import React, { createContext, useContext, useEffect, useMemo, useState } from 'react';
import { ArrowLeft, ArrowRight, CalendarDays, Check, ChevronRight, Clock3, Flag, MapPin, Radio, Search, Shield, Star, Target, Trophy, Users, X } from 'lucide-react';
import { tournamentCatalog } from '../data/tournamentDemo';
import { getGroupStandings, resolveTournamentMatches, getTournamentStats, getMatchWinner } from '../lib/tournamentEngine';
import TournamentAdmin from '../components/TournamentAdmin';
import { createManagedTournament } from '../lib/tournamentManagement';
import TournamentShareTools from '../components/TournamentShareTools';
import useTournamentScroll from '../lib/useTournamentScroll';
import './TournamentCenter.css';

const TABS = [['', 'Przegląd'], ['mecze', 'Mecze'], ['grupy', 'Grupy'], ['drabinka', 'Drabinka'], ['statystyki', 'Statystyki'], ['druzyny', 'Drużyny'], ['organizator', 'Organizator']];
const STAGES = { group: 'Faza grupowa', round16: '1/8 finału', quarterfinal: 'Ćwierćfinały', semifinal: 'Półfinały', third: 'O 3. miejsce', final: 'Finał', playoff: 'Baraż' };
const MATCH_STATUS = { scheduled: 'Nadchodzący', live: 'Na żywo', finished: 'Zakończony' };
const matchStatusLabel = (tournament, status) => tournament.isImported && !tournament.isLocalCopy && status === 'scheduled' ? 'Brak wyniku' : MATCH_STATUS[status];
const EVENT_TYPES = { goal: 'Gol', assist: 'Asysta', yellow: 'Żółta kartka', red: 'Czerwona kartka' };
const dateLabel = date => { const value = new Date(`${String(date).slice(0, 10)}T12:00:00+01:00`); return Number.isNaN(value.getTime()) ? 'Data do potwierdzenia' : new Intl.DateTimeFormat('pl-PL', { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'Europe/Warsaw' }).format(value); };
const tournamentDateLabel = tournament => tournament.date ? dateLabel(tournament.date) : tournament.year ? `${tournament.year} · data nieznana` : 'Data do potwierdzenia';
const participantCount = tournament => Math.max(tournament.teams.length, Number(tournament.participantCount) || 0);
const timeLabel = date => date && !Number.isNaN(new Date(date).getTime()) ? new Intl.DateTimeFormat('pl-PL', { hour: '2-digit', minute: '2-digit', timeZone: 'Europe/Warsaw' }).format(new Date(date)) : 'Brak godziny';
const normalize = value => String(value || '').toLocaleLowerCase('pl').normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/ł/g, 'l');
const teamFor = (tournament, id) => tournament.teams.find(team => team.id === id);
const sourceLabel = (source, tournament) => {
  if (!source) return 'Do ustalenia';
  if (source.type === 'group') return `${source.position}. miejsce · ${tournament?.groups?.find(group => group.id === source.groupId)?.name || 'grupa'}`;
  const matchIndex = tournament?.matches?.findIndex(match => match.id === source.matchId) ?? -1;
  return `${source.type === 'loser' ? 'Przegrany' : 'Zwycięzca'} meczu ${matchIndex >= 0 ? matchIndex + 1 : 'poprzedniej rundy'}`;
};
const matchGroupLabel = (tournament, match) => tournament.groups.find(group => group.id === match.groupId)?.name || 'Faza grupowa';
const favoriteKey = slug => `mlpn-tournament-favorite-v1:${slug}`;
const TournamentNavigation = createContext({ basePath: '/turnieje', slug: '', onNavigate: () => {} });

function TournamentLink({ section = '', children, className, title }) {
  const { basePath, slug, onNavigate } = useContext(TournamentNavigation);
  const route = [slug, section].filter(Boolean).join('/');
  return <a href={`${basePath.replace(/\/$/, '')}/${route}`} className={className} title={title} onClick={event => {
    if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    event.preventDefault(); onNavigate(route || 'home');
  }}>{children}</a>;
}

function PlayerLink({ playerId, children }) {
  return playerId ? <TournamentLink section={`zawodnik/${encodeURIComponent(playerId)}`} className="tc-player-link">{children}</TournamentLink> : children;
}

function TeamMark({ team, small = false }) {
  const [failed, setFailed] = useState(false);
  return <span className={`tc-team-mark${small ? ' is-small' : ''}`} aria-hidden="true">{team?.logo && !failed ? <img src={team.logo} alt="" onError={() => setFailed(true)} /> : team ? <b>{(team.shortName || team.name).split(' ').map(word => word[0]).slice(0, 3).join('')}</b> : <Shield size={small ? 15 : 21} />}</span>;
}

function TeamName({ tournament, teamId, source, small = false }) {
  const team = teamFor(tournament, teamId);
  const content = <><TeamMark team={team} small={small} /><span>{team?.name || sourceLabel(source, tournament)}</span></>;
  return team ? <TournamentLink section={`druzyna/${encodeURIComponent(team.id)}`} className="tc-team-name" title={`Profil drużyny ${team.name}`}>{content}</TournamentLink> : <span className="tc-team-name">{content}</span>;
}

function MatchScore({ match }) {
  const hasScore = match.homeScore !== null && match.homeScore !== undefined && match.awayScore !== null && match.awayScore !== undefined;
  return <span className="tc-score"><strong>{hasScore ? `${match.homeScore} : ${match.awayScore}` : '— : —'}</strong>{match.homePenalties != null && match.awayPenalties != null && <small>k. {match.homePenalties} : {match.awayPenalties}</small>}</span>;
}

function MatchRow({ tournament, match, featured = false }) {
  const winner = getMatchWinner(match);
  return <article className={`tc-match${match.status === 'live' ? ' is-live' : ''}${featured ? ' is-featured' : ''}`}>
    <div className="tc-match-meta"><span className={`tc-match-status is-${match.status}`}>{match.status === 'live' && <Radio size={12} />}{matchStatusLabel(tournament, match.status)}</span><span>{match.stage === 'group' ? matchGroupLabel(tournament, match) : match.stageLabel || STAGES[match.stage]} · {tournament.isImported && match.kickoff ? dateLabel(match.kickoff) + ' · ' : ''}{timeLabel(match.kickoff)}</span>{match.court && <span>{match.court}</span>}</div>
    <div className="tc-match-scoreline"><span className={winner === match.homeTeamId ? 'is-winner' : ''}><TeamName tournament={tournament} teamId={match.homeTeamId} source={match.homeSource} /></span><TournamentLink section={'mecz/' + encodeURIComponent(match.id)} className="tc-score-link" title="Otwórz szczegóły meczu"><MatchScore match={match} /></TournamentLink><span className={winner === match.awayTeamId ? 'is-winner' : ''}><TeamName tournament={tournament} teamId={match.awayTeamId} source={match.awaySource} /></span></div>
    {match.outcomeNote && <p className="tc-match-note">{getMatchWinner(match) ? 'Awans: ' + (teamFor(tournament, getMatchWinner(match))?.name || '—') + ' · brak wyniku karnych' : 'Brak rozstrzygnięcia'}</p>}
    {!!match.events?.length && <details className="tc-match-events"><summary>Protokół meczu <span>{match.events.length} zdarzeń</span></summary><ul>{[...match.events].sort((a, b) => Number(a.minute) - Number(b.minute)).map(event => {
      const team = teamFor(tournament, event.teamId); const player = team?.players?.find(person => person.id === event.playerId);
      return <li key={event.id}><time>{event.minute == null ? 'Brak minuty' : event.minute + '′'}</time><span className={`tc-event-dot is-${event.type}`} /><span><b><PlayerLink playerId={player?.id}>{player?.name || 'Zawodnik nieustalony'}</PlayerLink></b><small>{team?.name}</small></span><em>{EVENT_TYPES[event.type]}</em></li>;
    })}</ul></details>}
  </article>;
}

function EmptyState({ title, children, icon: Icon = CalendarDays }) {
  return <div className="tc-empty"><Icon size={24} aria-hidden="true" /><h3>{title}</h3>{children && <p>{children}</p>}</div>;
}
function SectionHeading({ title, children }) {
  return <div className="tc-section-heading"><h2>{title}</h2>{children}</div>;
}
function GroupTable({ tournament, group }) {
  if (group.standingsComplete === false) {
    const known = group.reportedStandings || [];
    const rows = [...known, ...group.teamIds.filter(id => !known.some(row => row.teamId === id)).map(teamId => ({ teamId }))];
    return <section className="tc-group tc-reported-group"><div className="tc-group-heading"><h3>{group.name}</h3><span>Niepełna tabela</span></div><div className="tc-table-scroll"><table><thead><tr><th scope="col">#</th><th scope="col">Drużyna</th><th scope="col"><abbr title="Punkty">PKT</abbr></th></tr></thead><tbody>{rows.map(row => <tr key={row.teamId} className={row.qualified ? 'is-qualified' : ''}><td>{row.position ?? '—'}</td><th scope="row"><TeamName tournament={tournament} teamId={row.teamId} small />{row.qualified && <span className="tc-confirmed-advance">Awans</span>}</th><td><b>{row.points ?? '—'}</b></td></tr>)}</tbody></table></div></section>;
  }
  const rows = getGroupStandings(tournament, group.id);
  const advancing = group.advancing ?? (tournament.isDemo ? tournament.rules?.advancing || 2 : 0);
  const qualified = new Set(group.qualifiedPositions || Array.from({ length: advancing }, (_, index) => index + 1));
  return <section className="tc-group"><div className="tc-group-heading"><h3>{group.name || `Grupa ${group.id}`}</h3><span>{advancing ? 'Awans bezpośredni: ' + advancing : 'Tabela grupy'}{group.playoffPositions?.length ? ' · dodatkowo baraż' : ''}</span></div><div className="tc-table-scroll"><table><thead><tr><th scope="col">#</th><th scope="col">Drużyna</th><th scope="col"><abbr title="Mecze">M</abbr></th><th scope="col"><abbr title="Bramki">B</abbr></th><th scope="col"><abbr title="Bilans bramek">+/−</abbr></th><th scope="col"><abbr title="Punkty">PKT</abbr></th></tr></thead><tbody>{rows.map(row => <tr key={row.teamId} className={qualified.has(row.position) ? 'is-qualified' : group.playoffPositions?.includes(row.position) ? 'is-playoff' : ''}><td>{row.position}</td><th scope="row"><TeamName tournament={tournament} teamId={row.teamId} small />{row.live && <span className="tc-table-live">LIVE</span>}{row.tied && <span className="tc-table-tied" title="Równość kryteriów sportowych — kolejność wymaga rozstrzygnięcia">ex aequo</span>}</th><td>{row.played}</td><td>{row.goalsFor}:{row.goalsAgainst}</td><td>{row.goalDifference > 0 ? '+' : ''}{row.goalDifference}</td><td><b>{row.points}</b></td></tr>)}</tbody></table></div></section>;
}

function Groups({ tournament, selectedPhase, setSelectedPhase }) {
  const phases = [...new Set(tournament.groups.map(group => group.phaseName || 'Faza grupowa'))];
  const phase = phases.includes(selectedPhase) ? selectedPhase : phases[0];
  if (!tournament.groups.length) return <EmptyState title="Brak grup" icon={Users} />;
  return <><SectionHeading title={tournament.isPartialArchive && phases.length === 1 ? phase : 'Grupy'}>{phases.length > 1 && <label className="tc-phase-select">Etap<select aria-label="Faza grupowa" value={phase} onChange={event => setSelectedPhase(event.target.value)}>{phases.map(name => <option key={name} value={name}>{name}</option>)}</select></label>}</SectionHeading><div className="tc-groups">{tournament.groups.filter(group => (group.phaseName || 'Faza grupowa') === phase).map(group => <GroupTable key={group.id} tournament={tournament} group={group} />)}</div></>;
}
function Bracket({ tournament, matches }) {
  const stages = ['round16', 'quarterfinal', 'semifinal', 'final'].filter(stage => matches.some(match => match.stage === stage));
  if (!matches.some(match => match.stage !== 'group')) return <EmptyState title="Brak drabinki" icon={Trophy} />;
  return <><SectionHeading title="Drabinka" /><div className="tc-bracket-scroll" role="region" aria-label="Drabinka turnieju — przewijaj w poziomie" tabIndex={0}><div className="tc-bracket" style={{ '--tc-round-count': Math.max(1, stages.length) }}>{stages.map((stage, index) => <section key={stage} className={`tc-bracket-stage stage-${index}`}><h3><span>0{index + 1}</span>{STAGES[stage]}</h3><div className="tc-bracket-matches">{matches.filter(match => match.stage === stage).map(match => <div className="tc-bracket-slot" key={match.id}><MatchRow tournament={tournament} match={match} /></div>)}</div>{stage === 'final' && matches.filter(match => match.stage === 'third').map(match => <div className="tc-bronze" key={match.id}><h3>O trzecie miejsce</h3><MatchRow tournament={tournament} match={match} /></div>)}</section>)}</div></div>{matches.some(match => match.stage === 'playoff') && <section className="tc-playoff-matches"><SectionHeading title="Baraże" /><div className="tc-match-list">{matches.filter(match => match.stage === 'playoff').map(match => <MatchRow key={match.id} tournament={tournament} match={match} />)}</div></section>}</>;
}

function Schedule({ tournament, matches, favorite }) {
  const [teamId, setTeamId] = useState('all'); const [stage, setStage] = useState('all'); const [status, setStatus] = useState('all');
  if (!matches.length) return <EmptyState title={tournament.isPartialArchive ? 'Brak danych o meczach' : 'Brak meczów'} icon={Clock3} />;
  const visible = matches.filter(match => (teamId === 'all' || match.homeTeamId === teamId || match.awayTeamId === teamId) && (stage === 'all' || match.stage === stage) && (status === 'all' || match.status === status));
  return <><SectionHeading title={tournament.isPartialArchive ? 'Znane mecze' : 'Mecze'} /><div className="tc-filters"><label>Drużyna<select value={teamId} onChange={event => setTeamId(event.target.value)}><option value="all">Wszystkie drużyny</option>{tournament.teams.map(team => <option key={team.id} value={team.id}>{team.name}</option>)}</select></label><label>Etap<select value={stage} onChange={event => setStage(event.target.value)}><option value="all">Wszystkie etapy</option>{Object.entries(STAGES).map(([id, label]) => <option key={id} value={id}>{label}</option>)}</select></label><label>Status<select value={status} onChange={event => setStatus(event.target.value)}><option value="all">Wszystkie mecze</option>{Object.keys(MATCH_STATUS).map(id => <option key={id} value={id}>{matchStatusLabel(tournament, id)}</option>)}</select></label>{favorite && <button className="tc-text-button" onClick={() => setTeamId(favorite)}><Star size={15} />Moja drużyna</button>}</div><div className="tc-result-count">{visible.length} {visible.length === 1 ? 'spotkanie' : 'spotkań'}</div><div className="tc-match-list">{visible.map(match => <MatchRow key={match.id} tournament={tournament} match={match} />)}</div>{!visible.length && <EmptyState title="Brak meczów" />}</>;
}

function Statistics({ tournament, stats }) {
  const [category, setCategory] = useState(() => tournament.isImported && !stats.scorers?.length && !stats.assists?.length ? 'teams' : 'scorers');
  const choices = [['teams', 'Drużyny', 'goals', 'Bramki'], ['scorers', 'Strzelcy', 'goals', 'Gole'], ['assists', 'Asystenci', 'assists', 'Asysty'], ['cards', 'Kartki', 'cards', 'Kartki']];
  const resolved = resolveTournamentMatches(tournament);
  const teamTotals = tournament.teams.map(team => {
    const games = resolved.filter(match => ['finished', 'live'].includes(match.status) && Number.isFinite(match.homeScore) && Number.isFinite(match.awayScore) && [match.homeTeamId, match.awayTeamId].includes(team.id));
    return { teamId: team.id, name: team.name, played: games.length, goals: games.reduce((total, match) => total + (match.homeTeamId === team.id ? match.homeScore : match.awayScore), 0), against: games.reduce((total, match) => total + (match.homeTeamId === team.id ? match.awayScore : match.homeScore), 0) };
  }).filter(team => team.played).sort((a, b) => b.goals - a.goals || a.against - b.against || a.name.localeCompare(b.name, 'pl'));
  const selected = choices.find(choice => choice[0] === category);
  const rows = category === 'teams' ? teamTotals : stats[category] || [];
  if (tournament.isPartialArchive && !resolved.length) return <><SectionHeading title="Statystyki" /><EmptyState title="Brak danych o meczach" icon={Target} /></>;
  return <>
    <SectionHeading title="Statystyki" />
    <div className="tc-stat-bar"><div><b>{stats.played || 0}{stats.live > 0 && <small> + {stats.live} LIVE</small>}</b><span>{tournament.isPartialArchive ? 'znanych meczów' : 'meczów'}</span></div><div><b>{stats.goals || 0}</b><span>{tournament.isPartialArchive ? 'goli w znanych meczach' : 'bramek (w tym LIVE)'}</span></div><div><b>{Number(stats.averageGoals || 0).toLocaleString('pl-PL', { maximumFractionDigits: 2 })}</b><span>{tournament.isPartialArchive ? 'gola na znany mecz' : 'gola na mecz'}</span></div></div>
    <div className="tc-switch" aria-label="Rodzaj statystyki">{choices.map(([id, label]) => <button key={id} aria-pressed={category === id} onClick={() => setCategory(id)}>{label}</button>)}</div>
    {rows.length ? <div className="tc-ranking"><div className="tc-ranking-heading"><span>{category === 'teams' ? 'Drużyna' : 'Zawodnik / drużyna'}</span><span>{selected[3]}</span></div>{rows.map((row, index) => <div className="tc-ranking-row" key={String(row.playerId) + '-' + row.teamId}><span className="tc-rank-position">{row.rank || row.position || index + 1}</span><TeamMark team={teamFor(tournament, row.teamId)} small /><span><b>{category === 'teams' ? <TournamentLink section={'druzyna/' + encodeURIComponent(row.teamId)}>{row.name}</TournamentLink> : <PlayerLink playerId={row.playerId}>{row.name}</PlayerLink>}</b><small>{category === 'teams' ? row.played + ' meczów · ' + row.against + ' bramek straconych' : teamFor(tournament, row.teamId)?.name}</small></span><strong>{category === 'cards' ? <><span className="tc-yellow">{row.yellow ?? row.yellowCards ?? 0}</span><span className="tc-red">{row.red ?? row.redCards ?? 0}</span></> : row[selected[2]]}</strong></div>)}</div> : <EmptyState title="Brak danych" icon={Target} />}
    {category !== 'teams' && stats.unassignedGoals > 0 && <p className="tc-explanation">Niepełne dane · przypisane gole: {stats.recordedGoals || 0}/{stats.goals || 0}</p>}
  </>;
}

function Teams({ tournament, favorite, setFavorite }) {
  const [search, setSearch] = useState('');
  const visible = tournament.teams.filter(team => normalize(team.name).includes(normalize(search)));
  return <><SectionHeading title="Drużyny">{tournament.isPartialArchive && <span className="tc-note">Znane drużyny: {tournament.teams.length} z {participantCount(tournament)}</span>}</SectionHeading>{!tournament.teams.length ? <EmptyState title="Brak drużyn" icon={Users} /> : <><label className="tc-search"><Search size={17} /><input type="search" aria-label="Szukaj drużyny" placeholder="Szukaj drużyny…" value={search} onChange={event => setSearch(event.target.value)} /></label><div className="tc-team-list">{visible.map(team => <article key={team.id}><div className="tc-team-card-head"><TeamName tournament={tournament} teamId={team.id} /><button className={`tc-follow${favorite === team.id ? ' is-followed' : ''}`} aria-pressed={favorite === team.id} aria-label={`${favorite === team.id ? 'Usuń wybór drużyny' : 'Wybierz drużynę'} ${team.name}`} onClick={() => setFavorite(favorite === team.id ? '' : team.id)}><Star size={17} fill={favorite === team.id ? 'currentColor' : 'none'} /><span>{favorite === team.id ? 'Moja drużyna' : 'Wybierz'}</span></button></div><div className="tc-team-card-meta"><span>{tournament.groups.find(group => group.teamIds.includes(team.id))?.name || (tournament.isPartialArchive ? 'Grupa nieznana' : 'Bez grupy')}</span><span>{team.players?.length ? team.players.length + ' zawodników w kadrze' : 'Brak danych o kadrze'}</span></div>{!!team.players?.length && <details><summary>Kadra drużyny</summary><ul className="tc-roster">{team.players.map(player => <li key={player.id}><span>{player.number || '—'}</span><PlayerLink playerId={player.id}>{player.name}</PlayerLink></li>)}</ul></details>}</article>)}</div>{!visible.length && <p className="tc-explanation">Nie znaleziono drużyny o tej nazwie.</p>}{!!tournament.unassignedPlayers?.length && <section className="tc-unassigned"><SectionHeading title="Drużyna nieustalona" /><ul className="tc-roster">{tournament.unassignedPlayers.map(player => <li key={player.id}><span>—</span><PlayerLink playerId={player.id}>{player.name}</PlayerLink></li>)}</ul></section>}</>}</>;
}

function TournamentAwards({ tournament }) {
  if (!tournament.awards?.length) return null;
  return <section className="tc-awards"><SectionHeading title="Wyróżnienia" /><div>{tournament.awards.map(award => <article key={award.id}><span>{award.label}</span><strong><PlayerLink playerId={award.playerId}>{award.playerName}</PlayerLink></strong><TeamName tournament={tournament} teamId={award.teamId} small />{award.value != null && <b>{award.value} {award.unit}</b>}</article>)}</div></section>;
}
function FinalStandings({ tournament, final }) {
  if (!tournament.finalStandings?.length) return null;
  if (final) {
    const winner = getMatchWinner(final);
    const runnerUp = winner && (winner === final.homeTeamId ? final.awayTeamId : final.homeTeamId);
    if (tournament.finalStandings.find(row => row.position === 1)?.teamId !== winner || tournament.finalStandings.find(row => row.position === 2)?.teamId !== runnerUp) return null;
  }
  return <section className="tc-final-standings"><SectionHeading title="Klasyfikacja końcowa" /><ol>{[...tournament.finalStandings].sort((a, b) => a.position - b.position).map(row => <li key={row.teamId} value={row.position}><b>{row.position}.</b><TeamName tournament={tournament} teamId={row.teamId} /></li>)}</ol></section>;
}
function Overview({ tournament, matches, stats, favorite }) {
  const current = matches.find(match => match.status === 'live') || (!tournament.isImported && matches.find(match => match.status === 'scheduled' && match.homeTeamId && match.awayTeamId)) || matches.find(match => match.stage === 'final' && match.status === 'finished') || [...matches].reverse().find(match => match.status === 'finished');
  const final = matches.find(match => match.stage === 'final');
  const championId = final ? getMatchWinner(final) : tournament.finalStandings?.find(row => row.position === 1)?.teamId;
  const favoriteMatches = favorite ? matches.filter(match => match.homeTeamId === favorite || match.awayTeamId === favorite).slice(0, 3) : [];
  return <>
    {championId && <div className="tc-champion"><Trophy size={23} /><div><span>Zwycięzca turnieju</span><TeamName tournament={tournament} teamId={championId} /></div></div>}
    {tournament.isPartialArchive && <p className="tc-archive-summary">Uczestnicy: {participantCount(tournament)} · znane drużyny: {tournament.teams.length}</p>}
    <FinalStandings tournament={tournament} final={final} />
    {!matches.length ? <EmptyState title={tournament.isPartialArchive || tournament.isImported ? 'Brak danych o meczach' : 'Turniej w przygotowaniu'} /> : <>
      <div className="tc-stat-bar"><div><b>{participantCount(tournament)}</b><span>drużyn</span></div><div><b>{stats.played || 0}{!tournament.isPartialArchive && <small> / {matches.length}</small>}</b><span>{tournament.isPartialArchive ? 'znanych meczów' : 'zakończonych meczów'}</span></div><div><b>{stats.goals || 0}</b><span>{tournament.isPartialArchive ? 'goli w znanych meczach' : 'bramek'}{stats.live > 0 ? ' (w tym LIVE)' : ''}</span></div></div>
      <SectionHeading title={current?.status === 'live' ? 'Na żywo' : current?.stage === 'final' ? 'Finał' : current?.status === 'finished' ? 'Ostatni wynik' : 'Najbliższy mecz'} />
      {current && <MatchRow tournament={tournament} match={current} featured />}
      <TournamentLink section="mecze" className="tc-text-button tc-all-matches">{tournament.isPartialArchive ? 'Znane mecze' : 'Wszystkie mecze'} <ArrowRight size={16} /></TournamentLink>
    </>}
    <TournamentAwards tournament={tournament} />
    {favoriteMatches.length > 0 && <section className="tc-favorite-matches"><SectionHeading title={teamFor(tournament, favorite)?.name} /><div className="tc-match-list">{favoriteMatches.map(match => <MatchRow key={match.id} tournament={tournament} match={match} />)}</div></section>}
  </>;
}
function TournamentProfile({ tournament, matches, type, id, navigate }) {
  if (type === 'mecz') return <MatchProfile tournament={tournament} match={matches.find(item => item.id === id)} navigate={navigate} />;
  const unassigned = tournament.unassignedPlayers?.find(player => player.id === id);
  if (type === 'zawodnik' && unassigned) return <><button className="tc-text-button" onClick={() => navigate('druzyny')}><ArrowLeft size={15} />Drużyny i kadry</button><header className="tc-profile-heading"><div className="tc-player-avatar"><Users size={30} /></div><div><h2>{unassigned.name}</h2><p>Drużyna nieustalona</p></div></header><EmptyState title="Brak statystyk" icon={Users} /></>;
  const isTeam = type === 'druzyna';
  const team = isTeam ? teamFor(tournament, id) : tournament.teams.find(item => item.players?.some(player => player.id === id));
  const player = !isTeam && team?.players?.find(item => item.id === id);
  if (!team || (!isTeam && !player)) return <><button className="tc-text-button tc-profile-jump" onClick={() => navigate(isTeam ? 'druzyny' : 'statystyki')}><ArrowLeft size={15} />Wróć do zestawienia</button><EmptyState title={isTeam ? 'Nie znaleziono drużyny' : 'Nie znaleziono zawodnika'} /></>;
  const teamMatches = matches.filter(match => match.homeTeamId === team.id || match.awayTeamId === team.id);
  const completed = teamMatches.filter(match => match.status === 'finished' && Number.isFinite(match.homeScore) && Number.isFinite(match.awayScore));
  const totals = completed.reduce((result, match) => {
    const home = match.homeTeamId === team.id; const goals = home ? match.homeScore : match.awayScore; const against = home ? match.awayScore : match.homeScore;
    return { goals: result.goals + goals, against: result.against + against, wins: result.wins + (getMatchWinner(match) === team.id ? 1 : 0) };
  }, { goals: 0, against: 0, wins: 0 });
  const playerMatches = teamMatches.filter(match => match.events?.some(event => event.playerId === player?.id));
  const playerEvents = teamMatches.filter(match => ['finished', 'live'].includes(match.status)).flatMap(match => match.events || []).filter(event => event.playerId === player?.id);
  const goals = playerEvents.filter(event => event.type === 'goal').length; const assists = playerEvents.filter(event => event.type === 'assist').length;
  const groups = tournament.groups.filter(group => group.teamIds.includes(team.id));
  return <>
    <button className="tc-text-button tc-profile-jump" onClick={() => navigate(isTeam ? 'druzyny' : 'statystyki')}><ArrowLeft size={15} />{isTeam ? 'Wszystkie drużyny' : 'Statystyki turnieju'}</button>
    <header className="tc-profile-heading">{isTeam ? <TeamMark team={team} /> : <div className="tc-player-avatar">{player.number || <Users size={30} />}</div>}<div><span className="tc-eyebrow">{isTeam ? 'Drużyna' : 'Zawodnik'}</span><h2>{isTeam ? team.name : player.name}</h2>{isTeam ? <p>{groups.map(group => [group.phaseName, group.name].filter(Boolean).join(' · ')).join(' / ') || 'Uczestnik turnieju'}</p> : <TeamName tournament={tournament} teamId={team.id} small />}</div></header>
    <div className="tc-stat-bar" hidden={tournament.isPartialArchive && isTeam && !completed.length}>{isTeam ? <><div><b>{completed.length}</b><span>meczów z wynikiem</span></div><div><b>{totals.goals}:{totals.against}</b><span>{tournament.isPartialArchive ? 'bramki w znanych meczach' : 'bramki zdobyte / stracone'}</span></div><div><b>{totals.wins}</b><span>{tournament.isPartialArchive ? 'zwycięstw w znanych meczach' : 'zwycięstw (w tym po karnych)'}</span></div></> : <><div><b>{goals}</b><span>zapisanych bramek</span></div><div><b>{assists}</b><span>zapisanych asyst</span></div><div><b>{playerMatches.length}</b><span>meczów ze zdarzeniem</span></div></>}</div>
    <div className="tc-profile-grid"><section><SectionHeading title={isTeam ? 'Mecze drużyny' : 'Zdarzenia w meczach'} />{(isTeam ? teamMatches : playerMatches).length ? <div className="tc-match-list">{(isTeam ? teamMatches : playerMatches).map(match => <MatchRow key={match.id} tournament={tournament} match={isTeam ? match : { ...match, events: match.events.filter(event => event.playerId === player.id) }} />)}</div> : <EmptyState title={isTeam ? 'Brak danych o meczach' : 'Brak zdarzeń'} />}</section><aside className="tc-profile-roster"><h3>{isTeam ? 'Kadra drużyny' : 'Zawodnicy drużyny'}</h3>{team.players?.length ? <ul className="tc-roster">{team.players.map(person => <li key={person.id}><span>{person.number || '—'}</span><PlayerLink playerId={person.id}>{person.name}</PlayerLink></li>)}</ul> : <p className="tc-explanation">Brak danych</p>}</aside></div>

  </>;
}

function MatchProfile({ tournament, match }) {
  if (!match) return <EmptyState title="Nie znaleziono meczu" />;
  const teams = [teamFor(tournament, match.homeTeamId), teamFor(tournament, match.awayTeamId)].filter(Boolean);
  return <><TournamentLink section="mecze" className="tc-text-button tc-profile-jump"><ArrowLeft size={15} />Wszystkie mecze</TournamentLink><MatchRow tournament={tournament} match={match} featured /><div className="tc-match-profile-teams">{teams.map(team => <section className="tc-profile-roster" key={team.id}><TeamName tournament={tournament} teamId={team.id} /><h3>Zgłoszona kadra</h3>{team.players?.length ? <ul className="tc-roster">{team.players.map(player => <li key={player.id}><span>{player.number || '—'}</span><PlayerLink playerId={player.id}>{player.name}</PlayerLink></li>)}</ul> : <p className="tc-explanation">Brak danych</p>}</section>)}</div>{!match.events?.length && <p className="tc-explanation">{Number.isFinite(match.homeScore) && Number.isFinite(match.awayScore) ? 'Brak protokołu' : 'Brak wyniku i protokołu'}</p>}</>;
}
function TournamentDetail({ initial, tab, darkMode, onNavigate, basePath, canManage, onSave, storageReady, onReload }) {
  const [tournament, setTournament] = useState(initial); const [revision, setRevision] = useState(0); const [notice, setNotice] = useState(''); const [saving, setSaving] = useState(false); const [reloadVersion, setReloadVersion] = useState(0);
  const [selectedPhase, setSelectedPhase] = useState(initial.groups[0]?.phaseName || 'Faza grupowa');
  const [favorite, setFavoriteState] = useState(() => { try { return localStorage.getItem(favoriteKey(initial.slug)) || ''; } catch { return ''; } });
  const matches = useMemo(() => resolveTournamentMatches(tournament), [tournament]); const stats = useMemo(() => getTournamentStats(tournament), [tournament]);
  useEffect(() => { setTournament(initial); }, [initial]);
  const setFavorite = id => { setFavoriteState(id); try { localStorage.setItem(favoriteKey(initial.slug), id); } catch { /* Preferences remain usable for this session. */ } };
  const navigate = section => onNavigate(`${tournament.slug}${section ? `/${section}` : ''}`);
  const save = async next => {
    if (!canManage || !storageReady || !onSave) throw new Error('Zaloguj się na konto administratora.');
    setSaving(true); setNotice('');
    try { const saved = await onSave(next, tournament._revision || 0); setTournament(saved); setRevision(value => value + 1); return saved; } finally { setSaving(false); }
  };
  const [profileType, encodedProfileId] = tab.split('/');
  let profileId = encodedProfileId || ''; try { profileId = decodeURIComponent(profileId); } catch { /* Invalid IDs resolve to an empty state. */ }
  const isProfile = ['druzyna', 'zawodnik', 'mecz'].includes(profileType) && profileId;
  const validTab = isProfile ? (profileType === 'druzyna' ? 'druzyny' : profileType === 'mecz' ? 'mecze' : 'statystyki') : TABS.some(([id]) => id === tab) ? tab : '';
  return <section className={'tournament-center' + (darkMode ? ' is-dark' : '')}>
    <header className="tc-detail-header">
      <a className="tc-back" href={basePath} onClick={event => { if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return; event.preventDefault(); onNavigate('home'); }}><ArrowLeft size={15} />Turnieje</a>
      <div className="tc-detail-title"><div><h1>{tournament.name}</h1><div className="tc-title-meta"><span><CalendarDays size={15} />{tournamentDateLabel(tournament)}</span>{tournament.location && <span><MapPin size={15} />{tournament.location}</span>}</div></div>{(tournament.isPartialArchive || tournament.isDemo || tournament.isLocalCopy) && <span className="tc-status-badge">{tournament.isPartialArchive ? 'Archiwum częściowe' : tournament.isLocalCopy ? 'Kopia' : 'Przykład'}</span>}</div>
    </header><nav className="tc-tabs" aria-label="Sekcje turnieju">{TABS.filter(([id]) => id !== 'organizator' || canManage).map(([id, label]) => <a href={basePath.replace(/\/$/, '') + '/' + tournament.slug + (id ? '/' + id : '')} aria-current={validTab === id ? 'page' : undefined} key={id} onClick={event => { if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return; event.preventDefault(); navigate(id); }}>{label}</a>)}</nav><div className="tc-content" role="region" aria-label={TABS.find(([id]) => id === validTab)?.[1]}>{notice && <div className="tc-notice" role="status"><Check size={16} /><span>{notice}</span><button aria-label="Zamknij komunikat" onClick={() => setNotice('')}><X size={15} /></button></div>}{isProfile && <TournamentProfile tournament={tournament} matches={matches} type={profileType} id={profileId} navigate={navigate} />}{!isProfile && validTab === '' && <Overview tournament={tournament} matches={matches} stats={stats} favorite={favorite} navigate={navigate} />}{!isProfile && validTab === 'mecze' && <Schedule tournament={tournament} matches={matches} favorite={favorite} />}{validTab === 'grupy' && <Groups tournament={tournament} selectedPhase={selectedPhase} setSelectedPhase={setSelectedPhase} />}{validTab === 'drabinka' && <Bracket tournament={tournament} matches={matches} />}{!isProfile && validTab === 'statystyki' && <Statistics tournament={tournament} stats={stats} />}{!isProfile && validTab === 'druzyny' && <Teams tournament={tournament} favorite={favorite} setFavorite={setFavorite} />}{validTab === 'organizator' && <>{canManage && storageReady ? <><TournamentAdmin key={reloadVersion} tournament={tournament} onSave={save} saving={saving} revision={revision} /><button type="button" className="tc-text-button tc-reload" disabled={saving} onClick={() => { if (window.confirm('Wczytać aktualne dane? Niezapisane zmiany w formularzu zostaną utracone.')) { Promise.resolve(onReload?.()).then(() => setReloadVersion(value => value + 1)).catch(() => {}); } }}>Wczytaj aktualne dane</button></> : <EmptyState title={canManage ? "Ładowanie danych turnieju…" : "Zaloguj się na konto administratora"} icon={Shield} />}</>}</div><div className="tc-share-area"><TournamentShareTools tournament={tournament} basePath={basePath} /></div></section>;
}

function TournamentCatalog({ darkMode, onNavigate, basePath, catalog, canManage, onCreate, storageReady }) {
  const [creating, setCreating] = useState(false); const [busy, setBusy] = useState(false); const [error, setError] = useState('');
  const submit = async event => { event.preventDefault(); if (busy || !storageReady) return; const fields = Object.fromEntries(new FormData(event.currentTarget)); setBusy(true); setError(''); try { const saved = await onCreate(createManagedTournament(fields)); setCreating(false); onNavigate(saved.slug + '/organizator'); } catch (e) { setError(e.message); } finally { setBusy(false); } };
  const tournaments = [...catalog].sort((a, b) => Number(a.isDemo) - Number(b.isDemo) || String(b.date || b.year || '').localeCompare(String(a.date || a.year || '')));
  return <section className={'tournament-center' + (darkMode ? ' is-dark' : '')}><header className="tc-catalog-heading"><h1>Turnieje</h1>{canManage && <button className="tc-primary" disabled={!storageReady} onClick={() => setCreating(value => !value)}>Dodaj turniej</button>}</header>{creating && <form className="tc-create-form" onSubmit={submit}><fieldset disabled={busy}><legend>Nowy turniej</legend><label>Nazwa<input name="name" required maxLength="180" /></label><label>Data<input name="date" type="date" required /></label><label>Miejsce<input name="location" required maxLength="180" /></label>{error && <p className="tc-error" role="alert">{error}</p>}<div><button type="submit" className="tc-primary">{busy ? "Zapisywanie…" : "Utwórz turniej"}</button><button type="button" className="tc-secondary" onClick={() => setCreating(false)}>Anuluj</button></div></fieldset></form>}<div className="tc-catalog-list">{tournaments.map(tournament => <article className="tc-catalog-item" key={tournament.id}><a href={basePath.replace(/\/$/, '') + '/' + tournament.slug} onClick={event => { if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return; event.preventDefault(); onNavigate(tournament.slug); }}><div><h2>{tournament.name}</h2><div className="tc-catalog-meta"><span>{tournamentDateLabel(tournament)}</span>{tournament.location && <span>{tournament.location}</span>}{!!participantCount(tournament) && <span>{participantCount(tournament)} drużyn</span>}{!!tournament.matches.length && <span>{tournament.matches.length} {tournament.isPartialArchive ? 'znane mecze' : 'meczów'}</span>}</div></div><span className={'tc-catalog-status' + (tournament.status === 'upcoming' ? ' is-upcoming' : '')}>{tournament.isPartialArchive ? 'Archiwum częściowe' : tournament.isDemo ? 'Przykład' : tournament.status === 'upcoming' ? 'Wkrótce' : tournament.status === 'live' ? 'Trwa' : 'Archiwum'}</span><ChevronRight size={18} /></a></article>)}</div></section>;
}
export default function TournamentCenter({ darkMode = false, route = 'home', onNavigate = () => {}, basePath = '/turnieje', catalog = tournamentCatalog, canManage = false, onSave, onCreate, storageReady = false, loadError = '', onReload }) {
  useTournamentScroll(route);
  const [slug, ...rest] = String(route || 'home').split('/').filter(Boolean); const tab = rest.join('/');
  if (!slug || slug === 'home') return <><TournamentCatalog darkMode={darkMode} onNavigate={onNavigate} basePath={basePath} catalog={catalog} canManage={canManage} onCreate={onCreate} storageReady={storageReady} />{loadError && <p className="tc-error" role="alert">{loadError} <button onClick={() => Promise.resolve(onReload?.()).catch(() => {})}>Spróbuj ponownie</button></p>}</>;
  const tournament = catalog.find(item => item.slug === slug);
  if (!tournament) return <section className={`tournament-center${darkMode ? ' is-dark' : ''}`}><div className="tc-content"><EmptyState title="Nie znaleziono turnieju" /><button className="tc-secondary" onClick={() => onNavigate('home')}><ArrowLeft size={16} />Wróć do turniejów</button></div></section>;
  return <TournamentNavigation.Provider value={{ basePath, slug: tournament.slug, onNavigate }}><TournamentDetail key={tournament.slug} initial={tournament} tab={tab} darkMode={darkMode} onNavigate={onNavigate} basePath={basePath} canManage={canManage} onSave={onSave} storageReady={storageReady} onReload={onReload} />{loadError && <p className="tc-error" role="alert">{loadError} <button onClick={() => Promise.resolve(onReload?.()).catch(() => {})}>Spróbuj ponownie</button></p>}</TournamentNavigation.Provider>;
}
