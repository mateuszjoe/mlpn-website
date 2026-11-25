import React, { useState } from 'react';
import { Save, X } from 'lucide-react';
import { updateTournamentMatch } from '../lib/tournamentEngine';
const STAGES = { group:'Faza grupowa',round16:'1/8 finału',quarterfinal:'Ćwierćfinały',semifinal:'Półfinały',third:'O 3. miejsce',final:'Finał',playoff:'Baraż' };
const MATCH_STATUS = {scheduled:'Nadchodzący',live:'Na żywo',finished:'Zakończony'};
const EVENT_TYPES = {goal:'Gol',assist:'Asysta',yellow:'Żółta kartka',red:'Czerwona kartka'};
const teamFor=(t,id)=>t.teams.find(team=>team.id===id);
const timeLabel=date=>date&&!Number.isNaN(new Date(date).getTime())?new Intl.DateTimeFormat('pl-PL',{hour:'2-digit',minute:'2-digit',timeZone:'Europe/Warsaw'}).format(new Date(date)):'Brak godziny';
export default function TournamentMatchEditor({ tournament, match, onSave, saving = false }) {
  const [form, setForm] = useState({ status: match.status, homeScore: match.homeScore ?? '', awayScore: match.awayScore ?? '', homePenalties: match.homePenalties ?? '', awayPenalties: match.awayPenalties ?? '' });
  const [busy, setBusy] = useState(false); const [pending, setPending] = useState(null);
  const [events, setEvents] = useState(match.events || []); const [error, setError] = useState('');
  const teams = [teamFor(tournament, match.homeTeamId), teamFor(tournament, match.awayTeamId)].filter(Boolean);
  const [eventDraft, setEventDraft] = useState({ type: 'goal', teamId: teams[0]?.id || '', playerId: teams[0]?.players?.[0]?.id || '', minute: '1' });
  const change = (key, value) => setForm(current => ({ ...current, [key]: value }));
  const draftTeam = teams.find(team => team.id === eventDraft.teamId);
  const addEvent = () => {
    if (!eventDraft.teamId || !eventDraft.playerId || !Number.isInteger(Number(eventDraft.minute)) || Number(eventDraft.minute) < 0 || eventDraft.minute === '') { setError('Wybierz zawodnika i podaj prawidłową minutę zdarzenia.'); return; }
    setPending(null); setEvents(current => [...current, { ...eventDraft, minute: Number(eventDraft.minute), id: `event-${Date.now()}-${Math.random().toString(36).slice(2, 8)}` }]); setError('');
  };
  const persist = async patch => {
    if (busy || saving) return;
    setBusy(true);
    try { await onSave(match.id, patch); setError(''); setPending(null); }
    catch (saveError) { setError(saveError.message || 'Nie udało się zapisać meczu.'); }
    finally { setBusy(false); }
  };
  const submit = async event => {
    event.preventDefault();
    if (busy || saving) return;
    const hasRecordedData = ['homeScore', 'awayScore', 'homePenalties', 'awayPenalties'].some(key => form[key] !== '') || events.length > 0;
    if (form.status === 'scheduled' && hasRecordedData) {
      setError('Zmień status na Na żywo lub Zakończony. Cofając mecz, najpierw wyczyść wynik i protokół.');
      return;
    }
    const numberOrNull = value => value === '' ? null : Number(value);
    const patch = { ...form, homeScore: numberOrNull(form.homeScore), awayScore: numberOrNull(form.awayScore), homePenalties: numberOrNull(form.homePenalties), awayPenalties: numberOrNull(form.awayPenalties), events };
    try {
      const next = updateTournamentMatch(tournament, match.id, patch);
      const affected = tournament.matches.filter(previous => previous.id !== match.id && previous.status !== 'scheduled' && next.matches.find(item => item.id === previous.id)?.status === 'scheduled');
      if (affected.length) { setPending({ patch, count: affected.length }); setError(''); return; }
      await persist(patch);
    } catch (saveError) { setError(saveError.message); }
  };
  if (teams.length !== 2) return <p role="status">Oczekiwanie na poprzedni etap</p>;
  return <form className="tc-editor" onSubmit={submit} onChangeCapture={() => setPending(null)}><fieldset disabled={busy || saving} style={{border:0,padding:0,margin:0,minWidth:0}}><div className="tc-editor-title"><span className="tc-eyebrow">{STAGES[match.stage]} · {timeLabel(match.kickoff)}</span><h3>{teams[0].name} <span>—</span> {teams[1].name}</h3></div><div className="tc-editor-score"><label>Status meczu<select value={form.status} onChange={event => change('status', event.target.value)}>{Object.entries(MATCH_STATUS).map(([id, label]) => <option key={id} value={id}>{label}</option>)}</select></label><label>Gole: {teams[0].name}<input type="number" min="0" step="1" inputMode="numeric" value={form.homeScore} onChange={event => change('homeScore', event.target.value)} /></label><label>Gole: {teams[1].name}<input type="number" min="0" step="1" inputMode="numeric" value={form.awayScore} onChange={event => change('awayScore', event.target.value)} /></label></div>{match.stage !== 'group' && <div className="tc-editor-penalties"><p>Rzuty karne — uzupełnij tylko przy remisie.</p><label>Karne: {teams[0].name}<input type="number" min="0" step="1" value={form.homePenalties} onChange={event => change('homePenalties', event.target.value)} /></label><label>Karne: {teams[1].name}<input type="number" min="0" step="1" value={form.awayPenalties} onChange={event => change('awayPenalties', event.target.value)} /></label></div>}{form.status === 'scheduled' && (form.homeScore !== '' || form.awayScore !== '' || form.homePenalties !== '' || form.awayPenalties !== '' || events.length > 0) && <div className="tc-scheduled-warning"><p>Cofnięcie do Nadchodzący wymaga usunięcia wyniku i protokołu. Może też usunąć wyniki zależnych meczów.</p><button type="button" className="tc-danger" onClick={() => { setForm(current => ({ ...current, homeScore: '', awayScore: '', homePenalties: '', awayPenalties: '' })); setEvents([]); setPending(null); setError(''); }}>Wyczyść wynik i protokół</button><small>Potwierdź przyciskiem „Zapisz mecz”.</small></div>}<div className="tc-editor-events"><h4>Zdarzenia</h4><div className="tc-event-form"><label>Zdarzenie<select value={eventDraft.type} onChange={event => setEventDraft(current => ({ ...current, type: event.target.value }))}>{Object.entries(EVENT_TYPES).map(([id, label]) => <option key={id} value={id}>{label}</option>)}</select></label><label>Drużyna zdarzenia<select value={eventDraft.teamId} onChange={event => setEventDraft(current => ({ ...current, teamId: event.target.value, playerId: teams.find(team => team.id === event.target.value)?.players?.[0]?.id || '' }))}>{teams.map(team => <option key={team.id} value={team.id}>{team.name}</option>)}</select></label><label>Zawodnik<select value={eventDraft.playerId} onChange={event => setEventDraft(current => ({ ...current, playerId: event.target.value }))}>{!draftTeam?.players?.length && <option value="">Brak zawodników</option>}{draftTeam?.players?.map(player => <option key={player.id} value={player.id}>{player.name}</option>)}</select></label><label>Minuta<input type="number" min="0" step="1" value={eventDraft.minute} onChange={event => setEventDraft(current => ({ ...current, minute: event.target.value }))} /></label><button type="button" className="tc-secondary" onClick={addEvent}>Dodaj zdarzenie</button></div><ul className="tc-editor-event-list">{events.map(event => <li key={event.id}><span>{event.minute == null ? 'Brak minuty' : event.minute + '′'}</span><b>{EVENT_TYPES[event.type]}</b><span>{teamFor(tournament, event.teamId)?.players?.find(player => player.id === event.playerId)?.name || 'Zawodnik nieustalony'}</span><button type="button" aria-label={`Usuń zdarzenie ${event.minute} minuta ${EVENT_TYPES[event.type]}`} onClick={() => { setPending(null); setEvents(current => current.filter(item => item.id !== event.id)); }}><X size={15} /></button></li>)}</ul></div>{pending && <div className="tc-scheduled-warning" role="alert"><p>Zmiana awansu wyczyści wyniki kolejnych meczów: {pending.count}. Potwierdź zmianę.</p><button className="tc-danger" type="button" onClick={() => persist(pending.patch)}>Zmień wynik i wyczyść kolejne mecze</button><button className="tc-secondary" type="button" onClick={() => setPending(null)}>Anuluj</button></div>}{error && <div className="tc-error" role="alert">{error}</div>}<div className="tc-editor-actions"><button className="tc-primary" type="submit"><Save size={17} />Zapisz mecz</button></div></fieldset></form>;
}

