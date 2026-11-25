import React, { useEffect, useMemo, useRef, useState } from 'react';
import { ArrowDown, ArrowUp, Check, Plus, Save, Trash2, X } from 'lucide-react';
import { updateTournamentMatch, resolveTournamentMatches } from '../lib/tournamentEngine';
import {
  updateTournamentSettings, upsertTournamentTeam, removeTournamentTeam,
  upsertTournamentPlayer, removeTournamentPlayer, setTournamentGroups,
  generateTournamentSchedule, generateTournamentBracket,
} from '../lib/tournamentManagement';
import TournamentMatchEditor from './TournamentMatchEditor';
import './TournamentAdmin.css';

const TABS = [['settings', 'Ustawienia'], ['teams', 'Drużyny'], ['groups', 'Grupy'], ['matches', 'Mecze']];
const STAGES = { group: 'Grupy', playoff: 'Baraże', round16: '1/8 finału', quarterfinal: 'Ćwierćfinały', semifinal: 'Półfinały', third: 'O 3. miejsce', final: 'Finał' };
const CRITERIA = { points: 'Punkty', headToHead: 'Mecze bezpośrednie', goalDifference: 'Bilans bramek', goalsScored: 'Zdobyte bramki' };
const STATUSES = { upcoming: 'Nadchodzący', live: 'W trakcie', completed: 'Zakończony', archived: 'Archiwalny' };
const started = match => match.status === 'live' || match.status === 'finished' || match.homeScore != null || match.awayScore != null || !!match.events?.length;
const teamById = (tournament, id) => tournament.teams.find(team => team.id === id);
const courtsFrom = text => text.split(/[,;\n]/).map(value => value.trim()).filter(Boolean);

function useDraft(defaults) {
  const serialized = JSON.stringify(defaults);
  const [draft, setDraft] = useState(defaults);
  useEffect(() => { setDraft(JSON.parse(serialized)); }, [serialized]);
  const change = (key, value) => setDraft(current => ({ ...current, [key]: value }));
  return [draft, change, setDraft];
}

function localTime(value, timezone = 'Europe/Warsaw') {
  if (!value || Number.isNaN(new Date(value).getTime())) return '';
  const parts = new Intl.DateTimeFormat('sv-SE', { timeZone: timezone, year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hourCycle: 'h23' }).formatToParts(new Date(value));
  const part = name => parts.find(item => item.type === name)?.value;
  return part('year') + '-' + part('month') + '-' + part('day') + 'T' + part('hour') + ':' + part('minute');
}

function timestamp(value, timezone = 'Europe/Warsaw') {
  if (!/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(value)) throw new Error('Podaj datę i godzinę.');
  const wall = Date.parse(value + ':00Z');
  let result = wall;
  for (let iteration = 0; iteration < 3; iteration += 1) {
    const displayed = Date.parse(localTime(new Date(result).toISOString(), timezone) + ':00Z');
    result += wall - displayed;
  }
  const iso = new Date(result).toISOString();
  if (localTime(iso, timezone) !== value) throw new Error('Ta godzina nie występuje w wybranej strefie czasowej.');
  return iso;
}

function Submit({ children = 'Zapisz', busy = false }) {
  return <button className="ta-primary" type="submit" disabled={busy}><Save size={15} />{busy ? 'Zapisywanie…' : children}</button>;
}

function ConfirmDelete({ label, onConfirm, onCancel }) {
  return <span className="ta-confirm"><span>{label}</span><button type="button" className="ta-danger" onClick={onConfirm}>Usuń</button><button type="button" className="ta-secondary" onClick={onCancel}>Anuluj</button></span>;
}

function Settings({ tournament, submit, busy }) {
  const initialCriteria = tournament.rules?.tiebreakers?.length ? tournament.rules.tiebreakers : [{ id: 'points' }, { id: 'headToHead' }, { id: 'goalDifference' }, { id: 'goalsScored' }];
  const [form, change] = useDraft({ name: tournament.name, date: tournament.date || '', location: tournament.location || '', status: tournament.status || 'upcoming', matchMinutes: tournament.matchMinutes || 10, pointsWin: tournament.rules?.pointsWin ?? 3, pointsDraw: tournament.rules?.pointsDraw ?? 1, pointsLoss: tournament.rules?.pointsLoss ?? 0, criteria: initialCriteria });
  const move = (index, direction) => { const next = [...form.criteria]; [next[index], next[index + direction]] = [next[index + direction], next[index]]; change('criteria', next); };
  return <form className="ta-form" onSubmit={event => submit(event, current => updateTournamentSettings(current, { name: form.name, date: form.date, location: form.location, ...(form.status !== current.status ? { status: form.status } : {}), matchMinutes: Number(form.matchMinutes), rules: { ...current.rules, pointsWin: Number(form.pointsWin), pointsDraw: Number(form.pointsDraw), pointsLoss: Number(form.pointsLoss), tiebreakers: form.criteria } }))}>
    <h3>Ustawienia turnieju</h3>
    <div className="ta-grid"><label className="ta-wide">Nazwa turnieju<input required maxLength={160} value={form.name} onChange={event => change('name', event.target.value)} /></label><label>Data<input type="date" required value={form.date} onChange={event => change('date', event.target.value)} /></label><label>Miejsce<input value={form.location} onChange={event => change('location', event.target.value)} maxLength={160} /></label><label>Status turnieju<select value={form.status} onChange={event => change('status', event.target.value)}>{Object.entries(STATUSES).map(([id, name]) => <option key={id} value={id}>{name}</option>)}</select></label><label>Czas meczu (min)<input type="number" min="1" max="180" required value={form.matchMinutes} onChange={event => change('matchMinutes', event.target.value)} /></label></div>
    <h4>Punktacja</h4><div className="ta-grid ta-three"><label>Zwycięstwo<input type="number" min="0" max="99" required value={form.pointsWin} onChange={event => change('pointsWin', event.target.value)} /></label><label>Remis<input type="number" min="0" max="99" required value={form.pointsDraw} onChange={event => change('pointsDraw', event.target.value)} /></label><label>Porażka<input type="number" min="0" max="99" required value={form.pointsLoss} onChange={event => change('pointsLoss', event.target.value)} /></label></div>
    <h4>Kolejność w tabeli</h4><ol className="ta-criteria">{form.criteria.map((criterion, index) => <li key={criterion.id}><span>{CRITERIA[criterion.id] || criterion.id}</span>{index > 0 && <span><button type="button" className="ta-icon" disabled={index === 1} aria-label={'Przesuń w górę: ' + CRITERIA[criterion.id]} onClick={() => move(index, -1)}><ArrowUp size={16} /></button><button type="button" className="ta-icon" disabled={index === form.criteria.length - 1} aria-label={'Przesuń w dół: ' + CRITERIA[criterion.id]} onClick={() => move(index, 1)}><ArrowDown size={16} /></button></span>}</li>)}</ol>
    <div className="ta-actions"><Submit busy={busy}>Zapisz ustawienia</Submit></div>
  </form>;
}

function TeamForm({ team, submit, onSaved, busy }) {
  const [form, change] = useDraft({ name: team?.name || '', shortName: team?.shortName || '', logo: team?.logo || '' });
  return <form className="ta-form" onSubmit={event => submit(event, current => upsertTournamentTeam(current, { ...(team ? { id: team.id } : {}), ...form, shortName: form.shortName.trim() || form.name.trim() }), onSaved)}><h3>{team ? 'Edytuj drużynę' : 'Dodaj drużynę'}</h3><div className="ta-grid"><label>Nazwa drużyny<input required value={form.name} maxLength={120} onChange={event => change('name', event.target.value)} /></label><label>Skrót<input value={form.shortName} maxLength={15} onChange={event => change('shortName', event.target.value)} /></label><label className="ta-wide">Logo (adres URL)<input value={form.logo} maxLength={2000} placeholder="https://…" onChange={event => change('logo', event.target.value)} /></label></div><div className="ta-actions"><Submit busy={busy}>{team ? 'Zapisz drużynę' : 'Dodaj drużynę'}</Submit></div></form>;
}

function Roster({ tournament, team, submit, busy }) {
  const [editing, setEditing] = useState(''); const [deleting, setDeleting] = useState('');
  const player = team.players?.find(item => item.id === editing);
  const [form, change, setForm] = useDraft({ name: player?.name || '', number: player?.number ?? '' });
  const used = id => tournament.matches.some(match => match.events?.some(event => event.playerId === id));
  const clear = () => { setEditing(''); setForm({ name: '', number: '' }); };
  return <section className="ta-roster"><h3>Kadra · {team.name}</h3><form className="ta-form ta-player-form" onSubmit={event => submit(event, current => upsertTournamentPlayer(current, team.id, { ...(player ? { id: player.id } : {}), name: form.name, number: form.number === '' ? null : Number(form.number) }), clear)}><div className="ta-grid"><label>Imię i nazwisko<input value={form.name} maxLength={120} required onChange={event => change('name', event.target.value)} /></label><label>Numer<input type="number" min="0" max="999" value={form.number} onChange={event => change('number', event.target.value)} /></label></div><div className="ta-actions">{player && <button type="button" className="ta-secondary" onClick={clear}>Anuluj edycję</button>}<Submit busy={busy}>{player ? 'Zapisz zawodnika' : 'Dodaj zawodnika'}</Submit></div></form><ul className="ta-person-list">{(team.players || []).map(person => <li key={person.id}><span className="ta-number">{person.number ?? '—'}</span><span className="ta-person-name">{person.name}</span>{deleting === person.id ? <ConfirmDelete label="Usunąć zawodnika?" onCancel={() => setDeleting('')} onConfirm={() => submit(null, current => removeTournamentPlayer(current, team.id, person.id), () => { setDeleting(''); if (editing === person.id) clear(); })} /> : <span className="ta-row-actions"><button type="button" className="ta-link" onClick={() => { setEditing(person.id); setDeleting(''); }}>Edytuj</button><button type="button" className="ta-icon" aria-label={'Usuń zawodnika ' + person.name} disabled={used(person.id)} title={used(person.id) ? 'Zawodnik ma zapisane zdarzenia meczowe' : 'Usuń zawodnika'} onClick={() => setDeleting(person.id)}><Trash2 size={15} /></button></span>}</li>)}</ul>{!team.players?.length && <p className="ta-note">Brak zawodników</p>}{team.players?.some(person => used(person.id)) && <p className="ta-note">Zawodnika ze zdarzeniami meczowymi nie można usunąć.</p>}</section>;
}

function Teams({ tournament, submit, busy }) {
  const [selected, setSelected] = useState(''); const [deleting, setDeleting] = useState('');
  const team = teamById(tournament, selected);
  const used = id => tournament.groups.some(group => group.teamIds.includes(id)) || tournament.matches.some(match => match.homeTeamId === id || match.awayTeamId === id || match.events?.some(event => event.teamId === id));
  const afterSave = next => { if (!team) setSelected(next.teams.find(item => !tournament.teams.some(previous => previous.id === item.id))?.id || ''); };
  return <><div className="ta-heading"><h3>Drużyny <span>({tournament.teams.length})</span></h3><button type="button" className="ta-secondary" onClick={() => { setSelected(''); setDeleting(''); }}><Plus size={15} />Dodaj drużynę</button></div><ul className="ta-team-list">{tournament.teams.map(item => <li key={item.id} className={selected === item.id ? 'is-selected' : ''}><button type="button" className="ta-team-name" onClick={() => { setSelected(item.id); setDeleting(''); }}><strong>{item.name}</strong><small>{item.players?.length || 0} zawodników</small></button>{deleting === item.id ? <ConfirmDelete label="Usunąć drużynę?" onCancel={() => setDeleting('')} onConfirm={() => submit(null, current => removeTournamentTeam(current, item.id), () => { setDeleting(''); if (selected === item.id) setSelected(''); })} /> : <button type="button" className="ta-icon" aria-label={'Usuń drużynę ' + item.name} title={used(item.id) ? 'Drużyna jest przypisana do grupy lub meczu' : 'Usuń drużynę'} disabled={used(item.id)} onClick={() => setDeleting(item.id)}><Trash2 size={16} /></button>}</li>)}</ul>{tournament.teams.some(item => used(item.id)) && <p className="ta-note">Drużyn przypisanych do grup lub meczów nie można usunąć.</p>}<TeamForm key={'team-form-' + (selected || 'new')} team={team} submit={submit} onSaved={afterSave} busy={busy} />{team && <Roster key={'roster-' + team.id} tournament={tournament} team={team} submit={submit} busy={busy} />}</>;
}

function Groups({ tournament, submit, busy }) {
  const [form, , setForm] = useDraft({ groups: tournament.groups });
  const [confirm, setConfirm] = useState(false);
  const locked = tournament.isImported || tournament.matches.some(match => started(match));
  const update = (index, key, value) => { setConfirm(false); setForm(current => ({ groups: current.groups.map((group, itemIndex) => itemIndex === index ? { ...group, [key]: value } : group) })); };
  const persist = event => { event?.preventDefault(); if (tournament.matches.length && !confirm) { setConfirm(true); return; } submit(null, current => setTournamentGroups(current, form.groups), () => setConfirm(false)); };
  if (locked) return <><h3>Grupy</h3><p className="ta-note">Podział na grupy jest zamknięty.</p><div className="ta-group-readonly">{tournament.groups.map(group => <section key={group.id}><h4>{group.phaseName ? group.phaseName + ' · ' : ''}{group.name}</h4><ul>{group.teamIds.map(id => <li key={id}>{teamById(tournament, id)?.name || 'Drużyna nieustalona'}</li>)}</ul></section>)}</div></>;
  return <form className="ta-form" onSubmit={persist}><div className="ta-heading"><h3>Podział na grupy</h3><button type="button" className="ta-secondary" onClick={() => { setConfirm(false); setForm(current => ({ groups: [...current.groups, { name: 'Grupa ' + String.fromCharCode(65 + current.groups.length), teamIds: [], advancing: 2 }] })); }}><Plus size={15} />Dodaj grupę</button></div>{!form.groups.length && <p className="ta-note">Dodaj grupy i przydziel drużyny.</p>}<div className="ta-group-editor">{form.groups.map((group, index) => <section key={group.id || 'new-' + index}><div className="ta-grid"><label>Nazwa grupy<input required value={group.name} maxLength={80} onChange={event => update(index, 'name', event.target.value)} /></label><label>Liczba awansujących<input type="number" min="0" max={Math.max(group.teamIds.length, 2)} required value={group.advancing ?? 2} onChange={event => update(index, 'advancing', Number(event.target.value))} /></label></div><div className="ta-team-choices">{tournament.teams.map(team => { const selected = group.teamIds.includes(team.id); const assignedElsewhere = form.groups.some((other, otherIndex) => otherIndex !== index && other.teamIds.includes(team.id)); return <label key={team.id}><input type="checkbox" checked={selected} disabled={!selected && assignedElsewhere} onChange={event => update(index, 'teamIds', event.target.checked ? [...group.teamIds, team.id] : group.teamIds.filter(id => id !== team.id))} /><span>{team.name}</span></label>; })}</div><button type="button" className="ta-link ta-delete-group" onClick={() => { setConfirm(false); setForm(current => ({ groups: current.groups.filter((_, itemIndex) => itemIndex !== index) })); }}><Trash2 size={14} />Usuń grupę</button></section>)}</div>{confirm && <div className="ta-warning">Zapisać nowy podział? Nierozpoczęte mecze zmienionych grup i zależna drabinka zostaną usunięte.<button type="button" className="ta-link" onClick={() => setConfirm(false)}>Anuluj</button></div>}<div className="ta-actions"><Submit busy={busy}>{confirm ? 'Potwierdź podział' : 'Zapisz grupy'}</Submit></div></form>;
}

function Generators({ tournament, submit, busy }) {
  const [form, change] = useDraft({ start: tournament.date ? tournament.date + 'T09:00' : '', bracketStart: '', duration: tournament.matchMinutes || 10, interval: 2, courts: 'Boisko 1', encounters: 1, qualifiers: 8, bronze: true });
  const [confirmation, setConfirmation] = useState('');
  const scheduleLocked = tournament.isImported || tournament.matches.some(match => match.stage === 'group' && started(match));
  const bracketLocked = tournament.isImported || tournament.matches.some(match => match.stage !== 'group' && started(match));
  const generate = (event, kind) => { event.preventDefault(); const existing = tournament.matches.some(match => kind === 'schedule' ? true : match.stage !== 'group'); if (existing && confirmation !== kind) { setConfirmation(kind); return; } submit(null, current => { const options = { startTime: kind === 'bracket' && !form.bracketStart ? undefined : timestamp(kind === 'bracket' ? form.bracketStart : form.start, tournament.timezone), durationMinutes: Number(form.duration), breakMinutes: Number(form.interval), courts: courtsFrom(form.courts) }; return kind === 'schedule' ? generateTournamentSchedule(current, { ...options, numEncounters: Number(form.encounters) }) : generateTournamentBracket(current, { ...options, qualifiers: Number(form.qualifiers), includeThirdPlace: form.bronze }); }, () => setConfirmation('')); };
  const timing = kind => <div className="ta-grid"><label>{kind === 'bracket' ? 'Początek fazy pucharowej (opcjonalnie)' : 'Początek turnieju'}<input type="datetime-local" required={kind === 'schedule'} value={kind === 'bracket' ? form.bracketStart : form.start} onChange={event => { setConfirmation(''); change(kind === 'bracket' ? 'bracketStart' : 'start', event.target.value); }} />{kind === 'bracket' && <small>Domyślnie po zakończeniu grup.</small>}</label><label>Boiska (oddziel przecinkiem)<input required value={form.courts} onChange={event => { setConfirmation(''); change('courts', event.target.value); }} /></label><label>Czas meczu (min)<input type="number" min="1" max="180" required value={form.duration} onChange={event => { setConfirmation(''); change('duration', event.target.value); }} /></label><label>Przerwa między meczami (min)<input type="number" min="0" max="120" required value={form.interval} onChange={event => { setConfirmation(''); change('interval', event.target.value); }} /></label></div>;
  return <div className="ta-generators"><details><summary>Ułóż terminarz grup</summary>{scheduleLocked ? <p className="ta-note">Nie można zastąpić terminarza rozegranego turnieju.</p> : <form className="ta-form" onSubmit={event => generate(event, 'schedule')}>{timing('schedule')}<label>System rozgrywek<select value={form.encounters} onChange={event => { setConfirmation(''); change('encounters', event.target.value); }}><option value="1">Jeden mecz z każdym</option><option value="2">Mecz i rewanż</option></select></label>{confirmation === 'schedule' && <p className="ta-warning">Zastąpić nierozpoczęte mecze nowym terminarzem?</p>}<div className="ta-actions">{confirmation === 'schedule' && <button type="button" className="ta-secondary" onClick={() => setConfirmation('')}>Anuluj</button>}<Submit busy={busy}>{confirmation === 'schedule' ? 'Zastąp terminarz' : 'Ułóż terminarz'}</Submit></div></form>}</details><details><summary>Utwórz drabinkę</summary>{bracketLocked ? <p className="ta-note">Nie można zastąpić rozegranej drabinki.</p> : <form className="ta-form" onSubmit={event => generate(event, 'bracket')}>{timing('bracket')}<div className="ta-grid"><label>Liczba drużyn<select value={form.qualifiers} onChange={event => { setConfirmation(''); change('qualifiers', event.target.value); }}>{[2, 4, 8, 16].map(count => <option key={count} value={count}>{count}</option>)}</select></label><label className="ta-checkbox"><input type="checkbox" checked={form.bronze} onChange={event => { setConfirmation(''); change('bronze', event.target.checked); }} />Mecz o 3. miejsce</label></div>{confirmation === 'bracket' && <p className="ta-warning">Zastąpić nierozpoczęte mecze pucharowe nową drabinką?</p>}<div className="ta-actions">{confirmation === 'bracket' && <button type="button" className="ta-secondary" onClick={() => setConfirmation('')}>Anuluj</button>}<Submit busy={busy}>{confirmation === 'bracket' ? 'Zastąp drabinkę' : 'Utwórz drabinkę'}</Submit></div></form>}</details></div>;
}

function MatchTiming({ tournament, match, submit, busy }) {
  const [form, change] = useDraft({ kickoff: localTime(match.kickoff, tournament.timezone), court: match.court || '' });
  return <details className="ta-timing"><summary>Termin i boisko</summary><form className="ta-form" onSubmit={event => submit(event, current => updateTournamentMatch(current, match.id, { kickoff: timestamp(form.kickoff, tournament.timezone), court: form.court }))}><div className="ta-grid"><label>Termin meczu<input type="datetime-local" required value={form.kickoff} onChange={event => change('kickoff', event.target.value)} /></label><label>Boisko<input value={form.court} maxLength={80} onChange={event => change('court', event.target.value)} /></label></div><div className="ta-actions"><Submit busy={busy}>Zapisz termin</Submit></div></form></details>;
}

function Matches({ tournament, submit, commit, busy }) {
  const [selected, setSelected] = useState(''); const [team, setTeam] = useState('all'); const [stage, setStage] = useState('all');
  const matches = useMemo(() => resolveTournamentMatches(tournament), [tournament]);
  const visible = matches.filter(match => (team === 'all' || match.homeTeamId === team || match.awayTeamId === team) && (stage === 'all' || match.stage === stage));
  const current = visible.find(match => match.id === selected) || visible.find(match => match.status === 'live') || visible[0];
  const teamName = (id, source) => teamById(tournament, id)?.name || (source?.type === 'group' ? source.position + '. ' + (tournament.groups.find(group => group.id === source.groupId)?.name || 'grupa') : 'Do ustalenia');
  const resultKey = current ? JSON.stringify([current.id, current.status, current.homeScore, current.awayScore, current.homePenalties, current.awayPenalties, current.events]) : '';
  return <><h3>Mecze</h3><Generators tournament={tournament} submit={submit} busy={busy} />{!!matches.length && <><div className="ta-grid ta-match-filters"><label>Drużyna<select value={team} onChange={event => setTeam(event.target.value)}><option value="all">Wszystkie drużyny</option>{tournament.teams.map(item => <option value={item.id} key={item.id}>{item.name}</option>)}</select></label><label>Etap<select value={stage} onChange={event => setStage(event.target.value)}><option value="all">Wszystkie etapy</option>{Object.entries(STAGES).filter(([id]) => matches.some(match => match.stage === id)).map(([id, label]) => <option key={id} value={id}>{label}</option>)}</select></label></div><label className="ta-match-select">Mecz<select value={current?.id || ''} onChange={event => setSelected(event.target.value)}>{visible.map(match => <option key={match.id} value={match.id}>{localTime(match.kickoff, tournament.timezone).replace('T', ' ')} · {match.stageLabel || (match.stage === 'group' ? tournament.groups.find(group => group.id === match.groupId)?.name : STAGES[match.stage])} · {teamName(match.homeTeamId, match.homeSource)} — {teamName(match.awayTeamId, match.awaySource)}</option>)}{!visible.length && <option value="">Brak meczów</option>}</select></label></>}{current && <><MatchTiming key={current.id} tournament={tournament} match={current} submit={submit} busy={busy} /><TournamentMatchEditor key={resultKey} tournament={tournament} match={current} saving={busy} onSave={(id, patch) => commit(currentTournament => updateTournamentMatch(currentTournament, id, patch), { silentError: true, message: 'Zapisano mecz.' })} /></>}{!matches.length && <p className="ta-note">Brak meczów</p>}</>;
}

export default function TournamentAdmin({ tournament, onSave, saving = false }) {
  const [tab, setTab] = useState('settings'); const [working, setWorking] = useState(false);
  const [error, setError] = useState(''); const [notice, setNotice] = useState('');
  const lock = useRef(false); const activeTournament = useRef(tournament);
  activeTournament.current = tournament;
  const busy = saving || working;
  const commit = async (transform, { silentError = false, message = 'Zapisano zmiany.' } = {}) => {
    if (lock.current || saving) throw new Error('Poczekaj na zakończenie zapisu.');
    lock.current = true; setWorking(true); setError(''); setNotice('');
    try { const next = transform(activeTournament.current); await onSave(next); setNotice(message); return next; }
    catch (failure) { const issue = failure instanceof Error ? failure : new Error('Nie udało się zapisać zmian.'); if (!silentError) setError(issue.message); throw issue; }
    finally { lock.current = false; setWorking(false); }
  };
  const submit = (event, transform, afterSave) => { event?.preventDefault(); return commit(transform).then(next => { afterSave?.(next); }).catch(() => {}); };
  useEffect(() => { setError(''); setNotice(''); }, [tournament.id]);
  return <section className="tournament-admin" aria-label="Zarządzanie turniejem"><nav className="ta-tabs" aria-label="Zarządzanie turniejem">{TABS.map(([id, label]) => <button type="button" key={id} aria-pressed={tab === id} disabled={busy} onClick={() => { setTab(id); setError(''); setNotice(''); }}>{label}</button>)}</nav>{error && <div className="ta-feedback is-error" role="alert"><span>{error}</span><button type="button" aria-label="Zamknij błąd" onClick={() => setError('')}><X size={15} /></button></div>}{notice && <div className="ta-feedback" role="status"><Check size={16} /><span>{notice}</span></div>}<fieldset className="ta-body" disabled={busy}>{tab === 'settings' && <Settings tournament={tournament} submit={submit} busy={busy} />}{tab === 'teams' && <Teams tournament={tournament} submit={submit} busy={busy} />}{tab === 'groups' && <Groups tournament={tournament} submit={submit} busy={busy} />}{tab === 'matches' && <Matches tournament={tournament} submit={submit} commit={commit} busy={busy} />}</fieldset></section>;
}
