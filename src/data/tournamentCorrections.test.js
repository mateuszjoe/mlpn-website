import archives from './tournamentArchives.json';
import { tournamentCatalog } from './tournamentDemo';
import { applyTournamentCorrections } from './tournamentCorrections';
import { getMatchWinner, getTournamentStats, resolveTournamentMatches } from '../lib/tournamentEngine';

const archive = () => JSON.parse(JSON.stringify(archives.find(item => item.slug === 'halinowcup2025')));
const corrected = () => applyTournamentCorrections(archive());
const championId = 'ztTh3SJ3gtam0zXHkG3f';

test('completes the documented final and champion without changing any other match or the original export', () => {
  const source = archive();
  const untouched = JSON.parse(JSON.stringify(source));
  const tournament = applyTournamentCorrections(source);
  const final = resolveTournamentMatches(tournament).find(match => match.stage === 'final');
  expect(final).toMatchObject({ homeScore: 2, awayScore: 0, status: 'finished', sourceScoreMissing: false });
  expect(getMatchWinner(final)).toBe(championId);
  expect(tournament.championTeamId).toBe(championId);
  expect(tournament.matches.filter(match => match.stage !== 'final')).toEqual(source.matches.filter(match => match.stage !== 'final'));
  expect(tournament.matches.find(match => match.stage === 'third')).toMatchObject({ status: 'scheduled', homeScore: null, awayScore: null, reportedWinnerId: null });
  expect(source).toEqual(untouched);
  expect(tournament.importSummary).toEqual(source.importSummary);
});

test('records only the identified first goal and keeps the ten-goal award separate from event statistics', () => {
  const tournament = corrected();
  const final = tournament.matches.find(match => match.stage === 'final');
  expect(final.events).toHaveLength(1);
  expect(final.events[0]).toMatchObject({ type: 'goal', minute: 2, teamId: championId, playerId: 'curated-halinowcup2025-konrad-sliwka' });
  const stats = getTournamentStats(tournament);
  expect(stats).toMatchObject({ played: 79, goals: 227, recordedGoals: 1, unassignedGoals: 226 });
  expect(stats.scorers).toHaveLength(1);
  expect(stats.scorers[0]).toMatchObject({ name: 'Konrad Śliwka', goals: 1 });
  expect(tournament.individualStatsComplete).toBe(false);
  expect(tournament.awards).toEqual(expect.arrayContaining([
    expect.objectContaining({ type: 'goalkeeper', playerName: 'Łukasz Trąbiński', teamId: '0z3ZCklhsSQSRQEJfyvU' }),
    expect.objectContaining({ type: 'scorer', playerName: 'Konrad Śliwka', teamId: championId, value: 10, unit: 'goli' }),
  ]));
  expect(tournament.corrections[0].source).toEqual({ type: 'user-supplied-screenshot', receivedAt: '2026-11-25', label: 'Zrzut ekranu przekazany przez organizatora' });
});

test('is repeatable and reuses a matching confirmed roster identity instead of creating duplicates', () => {
  const first = corrected();
  expect(applyTournamentCorrections(first)).toEqual(first);
  const source = archive();
  source.teams.find(team => team.id === championId).players.push({ id: 'existing-konrad', name: 'Konrad Śliwka' });
  const reused = applyTournamentCorrections(source);
  expect(reused.teams.find(team => team.id === championId).players).toHaveLength(1);
  expect(reused.matches.find(match => match.stage === 'final').events[0].playerId).toBe('existing-konrad');
  expect(reused.awards.find(award => award.type === 'scorer').playerId).toBe('existing-konrad');
});

test('rejects ambiguous roster identities or changed final participants rather than assigning a goal to someone else', () => {
  const duplicate = archive();
  duplicate.teams[0].players.push({ id: 'other-konrad', name: 'Konrad Śliwka' });
  expect(() => applyTournamentCorrections(duplicate)).toThrow(/Niejednoznaczny/);
  const changedFinal = archive();
  changedFinal.matches.find(match => match.stage === 'final').awayTeamId = 'other-team';
  expect(() => applyTournamentCorrections(changedFinal)).toThrow(/Uczestnicy finału/);
});

test('keeps the six visible tournaments, including the real 2024 archive, with no fictional demo', () => {
  expect(tournamentCatalog).toHaveLength(6);
  expect(tournamentCatalog.some(tournament => tournament.slug === 'mlpntest')).toBe(true);
  expect(tournamentCatalog.some(tournament => tournament.slug === 'turniej-testowy-2025')).toBe(false);
  expect(tournamentCatalog.find(tournament => tournament.slug === 'halinowcup2025').championTeamId).toBe(championId);
  for (const tournament of archives.filter(item => item.slug !== 'halinowcup2025')) {
    expect(applyTournamentCorrections(tournament)).toBe(tournament);
  }
});
