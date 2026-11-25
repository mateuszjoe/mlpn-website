import archives from '../data/tournamentArchives.json';
import { tournamentCatalog } from '../data/tournamentDemo';
import { getGroupStandings, getMatchWinner, resolveTournamentMatches, updateTournamentMatch } from './tournamentEngine';
import { createManagedTournament, validateManagedTournament, updateTournamentSettings, upsertTournamentTeam, removeTournamentTeam,
  upsertTournamentPlayer, removeTournamentPlayer, setTournamentGroups, generateTournamentSchedule, generateTournamentBracket } from './tournamentManagement';

const startTime = '2026-12-20T09:00:00+01:00';
const create = () => createManagedTournament({ name: 'Halinów Cup', date: '2026-12-20', location: 'Halinów' });
const populated = (count = 4, groupCount = 1) => {
  let tournament = create();
  for (let index = 1; index <= count; index += 1) tournament = upsertTournamentTeam(tournament, { id: `t${index}`, name: `Drużyna ${index}` });
  return setTournamentGroups(tournament, Array.from({ length: groupCount }, (_, index) => ({ id: `g${index + 1}`, name: `Grupa ${index + 1}`,
    teamIds: tournament.teams.filter((team, teamIndex) => teamIndex % groupCount === index).map(team => team.id) })));
};
const scheduled = (count = 4, groupCount = 1) => generateTournamentSchedule(populated(count, groupCount), { startTime, durationMinutes: 10, breakMinutes: 2, courts: ['A', 'B'] });
const finishGroups = tournament => tournament.matches.filter(match => match.stage === 'group').reduce((current, match) => updateTournamentMatch(current, match.id,
  { status: 'finished', homeScore: Number(match.homeTeamId.slice(1)) < Number(match.awayTeamId.slice(1)) ? 1 : 0,
    awayScore: Number(match.homeTeamId.slice(1)) < Number(match.awayTeamId.slice(1)) ? 0 : 1 }), tournament);

describe('managed tournament validation and settings', () => {
  test('creates a stable empty tournament with normalized rules and no invented fixtures', () => {
    const tournament = create();
    expect(tournament).toMatchObject({ id: 'tournament-halinow-cup', slug: 'halinow-cup', status: 'upcoming', isManaged: true, isDemo: false,
      rules: { pointsWin: 3, pointsDraw: 1, pointsLoss: 0 }, teams: [], groups: [], matches: [] });
    expect(validateManagedTournament(tournament)).toEqual(tournament);
  });

  test.each(['archived', 'completed'])('keeps an explicitly unknown historical date with a verified year: %s', status => {
    const historical = { ...create(), date: null, year: 2023, isPartialArchive: true, status };
    const before = JSON.stringify(historical);
    expect(validateManagedTournament(historical)).toMatchObject({ date: null, year: 2023, isPartialArchive: true, status });
    expect(updateTournamentSettings(historical, { description: 'Potwierdzono klasyfikację końcową.' }).date).toBeNull();
    expect(JSON.stringify(historical)).toBe(before);
  });

  test.each([
    { isPartialArchive: false }, { isPartialArchive: 'true' }, { status: 'upcoming' }, { status: 'live' },
    { year: undefined }, { year: null }, { year: '2023' }, { year: 2023.5 }, { year: 1899 }, { year: 2101 },
    { date: undefined }, { date: '' }, { date: '2023' }, { date: '2023-02-30' },
  ])('does not use the historical date exception for malformed or ordinary tournaments: %j', patch => {
    expect(() => validateManagedTournament({ ...create(), date: null, year: 2023, isPartialArchive: true, status: 'archived', ...patch })).toThrow();
  });

  test('still requires a real date when creating a new tournament', () => {
    expect(() => createManagedTournament({ name: 'Nowy turniej', date: null, year: 2023, isPartialArchive: true })).toThrow(/datę/);
  });

  test.each([
    { name: '' }, { name: 'x'.repeat(181) }, { date: '2026-02-30' }, { timezone: 'Not/AZone' }, { slug: '../admin' }, { rules: { pointsWin: -1 } },
    { rules: { pointsDraw: true } }, { rules: { tiebreakers: ['goalDifference', 'points'] } },
    { rules: { tiebreakers: ['points', 'points'] } }, { rules: { tiebreakers: ['points', 'random'] } },
  ])('rejects invalid settings %j without mutating input', patch => {
    const tournament = create(); const before = JSON.stringify(tournament);
    expect(() => updateTournamentSettings(tournament, patch)).toThrow();
    expect(JSON.stringify(tournament)).toBe(before);
  });

  test('editable loss points contribute to the standings and cannot change after activity', () => {
    let tournament = updateTournamentSettings(scheduled(3), { rules: { pointsWin: 4, pointsDraw: 2, pointsLoss: 1 } });
    const match = tournament.matches[0];
    tournament = updateTournamentMatch(tournament, match.id, { status: 'live', homeScore: 2, awayScore: 0 });
    expect(getGroupStandings(tournament, 'g1').find(row => row.teamId === match.awayTeamId).points).toBe(1);
    expect(() => updateTournamentSettings(tournament, { rules: { pointsWin: 3 } })).toThrow(/rozpoczęciu/);
    expect(updateTournamentSettings(tournament, { name: 'Nowa nazwa' }).matches).toEqual(tournament.matches);
  });

  test('does not mark an incomplete tournament completed or put played results back into upcoming', () => {
    expect(() => updateTournamentSettings(scheduled(), { status: 'completed' })).toThrow(/zakończ/);
    const tournament = finishGroups(scheduled());
    expect(updateTournamentSettings(tournament, { status: 'completed' }).status).toBe('completed');
    expect(() => updateTournamentSettings(tournament, { status: 'upcoming' })).toThrow(/rozpoczęte/);
  });

  test.each([-1, 1.5, '2', true, Infinity])('rejects malformed stored score %s', value => {
    const tournament = scheduled(); tournament.matches[0].homeScore = value;
    expect(() => validateManagedTournament(tournament)).toThrow();
  });

  test('rejects unresolved active knockout matches, cyclic sources and source participant mismatches', () => {
    const tournament = generateTournamentBracket(scheduled(), { qualifiers: 2 });
    const final = tournament.matches.find(match => match.stage === 'final');
    final.status = 'finished'; final.homeScore = 1; final.awayScore = 0;
    expect(() => validateManagedTournament(tournament)).toThrow();
    final.status = 'scheduled'; final.homeScore = null; final.awayScore = null;
    final.homeSource = { type: 'winner', matchId: final.id };
    expect(() => validateManagedTournament(tournament)).toThrow(/cykliczne/);
  });

  test.each(archives.map(archive => [archive.slug, archive]))('preserves imported phases and results during metadata edits: %s', (slug, archive) => {
    const updated = updateTournamentSettings(archive, { description: 'Opis po aktualizacji' });
    expect(updated.matches).toEqual(archive.matches);
    expect(updated.groups.map(group => [group.id, group.phase, group.teamIds])).toEqual(archive.groups.map(group => [group.id, group.phase, group.teamIds]));
  });

  test('validates all live catalog entries including partial archives and the curated final goal without losing data', () => {
    expect(tournamentCatalog).toHaveLength(8);
    for (const entry of tournamentCatalog) {
      const tournament = validateManagedTournament(entry);
      expect(tournament.matches).toEqual(entry.matches);
      expect(tournament.awards).toEqual(entry.awards);
      expect(tournament.corrections).toEqual(entry.corrections);
      expect(tournament.championTeamId).toBe(entry.championTeamId);
      expect(tournament.finalStandings).toEqual(entry.finalStandings);
      expect(tournament.participantCount).toBe(entry.participantCount);
      expect(tournament.date).toBe(entry.date);
      expect(tournament.year).toBe(entry.year);
      if (entry.matches.length) expect(setTournamentGroups(tournament, tournament.groups).matches).toEqual(entry.matches);
    }
    const corrected = tournamentCatalog.find(entry => entry.corrections?.length);
    expect(corrected).toBeDefined();
    expect(validateManagedTournament(corrected).matches.find(match => match.stage === 'final').events.filter(event => event.type === 'goal')).toHaveLength(1);
  });

  test('historical classifications link only known teams and never claim a complete fixture list', () => {
    const historical = tournamentCatalog.filter(entry => entry.isPartialArchive);
    expect(historical).toHaveLength(2);
    for (const entry of historical) {
      const teamIds = new Set(entry.teams.map(team => team.id));
      expect(entry.status).toBe('archived');
      expect(entry.scheduleComplete).toBe(false);
      expect(entry.individualStatsComplete).toBe(false);
      expect(entry.rulesConfirmed).toBe(false);
      expect(Number.isInteger(entry.participantCount)).toBe(true);
      expect(entry.participantCount).toBeGreaterThanOrEqual(teamIds.size);
      expect(new Set(entry.finalStandings.map(row => row.teamId)).size).toBe(entry.finalStandings.length);
      expect(new Set(entry.finalStandings.map(row => row.position)).size).toBe(entry.finalStandings.length);
      for (const row of entry.finalStandings) {
        expect(teamIds.has(row.teamId)).toBe(true);
        expect(Number.isInteger(row.position)).toBe(true);
        expect(row.position).toBeGreaterThan(0);
        expect(row.position).toBeLessThanOrEqual(entry.participantCount);
      }
      for (const group of entry.groups) {
        expect(group.standingsComplete).toBe(false);
        expect(new Set(group.reportedStandings.map(row => row.teamId)).size).toBe(group.reportedStandings.length);
        expect(new Set(group.reportedStandings.map(row => row.position)).size).toBe(group.reportedStandings.length);
        for (const row of group.reportedStandings) {
          expect(group.teamIds).toContain(row.teamId);
          expect(Number.isInteger(row.position)).toBe(true);
          expect(row.position).toBeGreaterThan(0);
          expect(row.position).toBeLessThanOrEqual(group.teamIds.length);
          expect(Number.isInteger(row.points)).toBe(true);
          expect(row.points).toBeGreaterThanOrEqual(0);
        }
      }
      const final = resolveTournamentMatches(entry).find(match => match.stage === 'final');
      if (final) expect(getMatchWinner(final)).toBe(entry.finalStandings.find(row => row.position === 1).teamId);
    }
  });
});

describe('teams, players and group assignments', () => {
  test('team and player editing preserves stable IDs and input is immutable', () => {
    const base = create(); const tournament = upsertTournamentTeam(base, { name: 'Drużyna' });
    expect(base.teams).toEqual([]);
    expect(tournament.teams[0].id).toBe('team-1');
    const roster = upsertTournamentPlayer(tournament, 'team-1', { name: 'Jan Kowalski', number: '7' });
    const edited = upsertTournamentPlayer(roster, 'team-1', { id: 'player-1', name: 'Jan K.' });
    expect(edited.teams[0].players[0]).toMatchObject({ id: 'player-1', name: 'Jan K.', number: 7 });
    expect(roster.teams[0].players[0].name).toBe('Jan Kowalski');
    expect(removeTournamentPlayer(edited, 'team-1', 'player-1').teams[0].players).toEqual([]);
    expect(removeTournamentTeam(tournament, 'team-1').teams).toEqual([]);
  });

  test('rejects duplicate shirt numbers, unsafe logos and cross-team player IDs', () => {
    let tournament = populated(2);
    tournament = upsertTournamentPlayer(tournament, 't1', { id: 'p1', name: 'Jan', number: 0 });
    expect(() => upsertTournamentPlayer(tournament, 't1', { name: 'Adam', number: 0 })).toThrow(/Numery/);
    expect(() => upsertTournamentPlayer(tournament, 't2', { id: 'p1', name: 'Jan' })).toThrow(/Identyfikatory/);
    expect(() => upsertTournamentTeam(tournament, { id: 't1', name: 'Test', logo: 'javascript:alert(1)' })).toThrow(/Logo/);
    expect(() => upsertTournamentTeam(tournament, { id: 't1', name: 'x'.repeat(121) })).toThrow(/nazwa drużyny/);
    expect(() => removeTournamentTeam(tournament, 't1')).toThrow(/Najpierw/);
  });

  test('a recorded player can be renamed but cannot be removed or silently replaced through the team', () => {
    let tournament = scheduled(2);
    tournament = upsertTournamentPlayer(tournament, 't1', { id: 'p1', name: 'Jan' });
    const match = tournament.matches[0];
    tournament = updateTournamentMatch(tournament, match.id, { status: 'finished', homeScore: 1, awayScore: 0,
      events: [{ id: 'e1', type: 'goal', teamId: 't1', playerId: 'p1', minute: 1 }] });
    expect(() => removeTournamentPlayer(tournament, 't1', 'p1')).toThrow(/historii/);
    expect(() => upsertTournamentTeam(tournament, { id: 't1', name: 'Drużyna', players: [] })).toThrow(/Skład/);
    expect(upsertTournamentPlayer(tournament, 't1', { id: 'p1', name: 'Jan K.' }).matches).toEqual(tournament.matches);
  });

  test('removes only unplayed fixtures affected by reassignment and protects active groups', () => {
    let tournament = scheduled(6, 2);
    const g2 = tournament.matches.find(match => match.groupId === 'g2');
    tournament = updateTournamentMatch(tournament, g2.id, { status: 'live', homeScore: 0, awayScore: 0 });
    const changed = setTournamentGroups(tournament, tournament.groups.map(group => group.id === 'g1' ? { ...group, teamIds: ['t1', 't3'] } : group));
    expect(changed.matches.filter(match => match.groupId === 'g1')).toEqual([]);
    expect(changed.matches.find(match => match.id === g2.id)).toEqual(tournament.matches.find(match => match.id === g2.id));
    expect(() => setTournamentGroups(tournament, tournament.groups.map(group => group.id === 'g2' ? { ...group, teamIds: ['t2', 't4'] } : group))).toThrow(/rozegrane/);
  });

  test('rejects assigning one team to multiple groups in a phase and preserves imported structures', () => {
    const tournament = populated(4, 2);
    expect(() => setTournamentGroups(tournament, [{ ...tournament.groups[0], teamIds: ['t1', 't2'] }, { ...tournament.groups[1], teamIds: ['t2', 't3'] }])).toThrow(/jednej grupy/);
    expect(() => setTournamentGroups(archives[0], [])).toThrow(/oryginalne fazy/);
  });

  test('new group IDs cannot collide after another group has been removed', () => {
    let tournament = upsertTournamentTeam(create(), { id: 't1', name: 'Test' });
    tournament = setTournamentGroups(tournament, [{ name: 'A', teamIds: ['t1'] }, { name: 'B', teamIds: [] }]);
    tournament = setTournamentGroups(tournament, [tournament.groups[1], { name: 'C', teamIds: ['t1'] }]);
    expect(tournament.groups.map(group => group.id)).toEqual(['group-2', 'group-3']);
  });
});

describe('round-robin scheduling', () => {
  test.each([3, 4, 5])('%s teams play each pairing exactly once without a simultaneous team clash', count => {
    const tournament = scheduled(count);
    expect(tournament.matches).toHaveLength(count * (count - 1) / 2);
    expect(new Set(tournament.matches.map(match => [match.homeTeamId, match.awayTeamId].sort().join('|'))).size).toBe(tournament.matches.length);
    const slots = new Map();
    for (const match of tournament.matches) {
      const at = slots.get(match.kickoff) || [];
      expect(at).not.toContain(match.homeTeamId); expect(at).not.toContain(match.awayTeamId);
      slots.set(match.kickoff, [...at, match.homeTeamId, match.awayTeamId]);
    }
    for (const team of tournament.teams) expect(tournament.matches.filter(match => [match.homeTeamId, match.awayTeamId].includes(team.id))).toHaveLength(count - 1);
  });

  test('return legs reverse the venue and qualification waits for every required pairing', () => {
    let tournament = generateTournamentSchedule(populated(3), { startTime, numEncounters: 2 });
    expect(tournament.matches).toHaveLength(6);
    expect(tournament.groups[0].numEncounters).toBe(2);
    expect(new Set(tournament.matches.map(match => [match.homeTeamId, match.awayTeamId].join('|'))).size).toBe(6);
    tournament = generateTournamentBracket(tournament, { qualifiers: 2 });
    const firstLeg = tournament.matches.filter(match => match.stage === 'group').slice(0, 3);
    for (const match of firstLeg) tournament = updateTournamentMatch(tournament, match.id, { status: 'finished', homeScore: 1, awayScore: 0 });
    tournament.matches = tournament.matches.filter(match => match.stage !== 'group' || firstLeg.some(first => first.id === match.id));
    expect(resolveTournamentMatches(tournament).find(match => match.stage === 'final').homeTeamId).toBeNull();
  });

  test('rejects invalid schedule settings and refuses replacing live or finished fixtures', () => {
    expect(() => generateTournamentSchedule(populated(), { startTime: '2026-12-20T10:00' })).toThrow(/strefą/);
    expect(() => generateTournamentSchedule(populated(), { startTime, durationMinutes: 0 })).toThrow(/Długość/);
    expect(() => generateTournamentSchedule(populated(), { startTime, courts: ['A', 'A'] })).toThrow(/duplikaty/);
    let tournament = scheduled();
    tournament = updateTournamentMatch(tournament, tournament.matches[0].id, { status: 'live', homeScore: 0, awayScore: 0 });
    expect(() => generateTournamentSchedule(tournament, { startTime })).toThrow(/rozpoczęciu/);
  });

  test('regenerating one group cannot double-book another group on a preserved court', () => {
    const tournament = scheduled(6, 2);
    expect(() => generateTournamentSchedule(tournament, { groupIds: ['g1'], startTime, courts: ['B'] })).toThrow(/koliduje/);
  });
});

describe('knockout scheduling and progression', () => {
  test.each([2, 4, 8, 16])('creates a coherent %s-team bracket and advances actual group winners', qualifiers => {
    const groupCount = qualifiers === 2 ? 1 : qualifiers / 2;
    let tournament = finishGroups(scheduled(qualifiers, groupCount));
    tournament = generateTournamentBracket(tournament, { qualifiers, includeThirdPlace: true });
    const knockout = tournament.matches.filter(match => match.stage !== 'group');
    expect(knockout).toHaveLength(qualifiers - 1 + (qualifiers >= 4 ? 1 : 0));
    const firstRound = knockout.filter(match => match.homeSource?.type === 'group');
    expect(firstRound.every(match => match.homeTeamId && match.awayTeamId)).toBe(true);
    expect(new Set(firstRound.flatMap(match => [match.homeTeamId, match.awayTeamId])).size).toBe(qualifiers);
    for (const match of knockout.filter(match => match.stage !== 'third')) {
      tournament = updateTournamentMatch(tournament, match.id, { status: 'finished', homeScore: 1, awayScore: 0 });
    }
    const final = resolveTournamentMatches(tournament).find(match => match.stage === 'final');
    expect(getMatchWinner(final)).toBeTruthy();
    expect(() => generateTournamentBracket(tournament, { qualifiers })).toThrow(/rozpoczętej/);
  });

  test('cross-group seeding keeps qualifiers from one group in opposite halves', () => {
    const tournament = generateTournamentBracket(scheduled(8, 4), { qualifiers: 8 });
    const firstRound = tournament.matches.filter(match => match.stage === 'quarterfinal');
    const firstHalf = firstRound.slice(0, 2).flatMap(match => [match.homeSource.groupId, match.awaySource.groupId]);
    const secondHalf = firstRound.slice(2).flatMap(match => [match.homeSource.groupId, match.awaySource.groupId]);
    expect(new Set(firstHalf).size).toBe(4); expect(new Set(secondHalf).size).toBe(4);
  });

  test('does not invent a best-third qualifier for unsupported formats or overwrite imported brackets', () => {
    expect(() => generateTournamentBracket(scheduled(9, 3), { qualifiers: 8 })).toThrow(/układ/);
    expect(() => generateTournamentBracket(scheduled(), { qualifiers: 3 })).toThrow(/2, 4, 8 lub 16/);
    expect(() => generateTournamentBracket(archives[0], { qualifiers: 8 })).toThrow();
  });

  test('a shorter knockout match still waits for the full duration of the final group fixture', () => {
    const tournament = scheduled(4);
    const next = generateTournamentBracket(tournament, { qualifiers: 2, durationMinutes: 5, breakMinutes: 2 });
    const groupEnd = Math.max(...tournament.matches.map(match => Date.parse(match.kickoff) + 10 * 60000));
    expect(Date.parse(next.matches.find(match => match.stage === 'final').kickoff)).toBe(groupEnd + 2 * 60000);
    expect(() => generateTournamentBracket(tournament, { qualifiers: 2, startTime })).toThrow(/po meczach grupowych/);
  });
});
