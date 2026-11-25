import archives from './tournamentArchives.json';
import corrections from './tournamentCorrections.json';
import { tournamentCatalog } from './tournamentDemo';
import { applyTournamentCorrections } from './tournamentCorrections';
import { getMatchWinner, getTournamentStats, resolveTournamentMatches } from '../lib/tournamentEngine';
import { validateManagedTournament } from '../lib/tournamentManagement';

const clone = value => JSON.parse(JSON.stringify(value));
const archive = (slug = 'halinowcup2025') => clone(archives.find(item => item.slug === slug));
const corrected = slug => applyTournamentCorrections(archive(slug));
const championId = 'ztTh3SJ3gtam0zXHkG3f';
const correctedSlugs = ['halinowcup2024', 'halinowcup2025', 'mlpntest', 'pucharsulejowka2025'];
const allPlayers = tournament => tournament.teams.flatMap(team => team.players || []);

test.each(correctedSlugs)('%s corrections are pure, repeatable and preserve import provenance', slug => {
  const source = archive(slug);
  const untouched = clone(source);
  const result = applyTournamentCorrections(source);
  expect(applyTournamentCorrections(result)).toEqual(result);
  expect(source).toEqual(untouched);
  expect(result.importSummary).toEqual(source.importSummary);
  expect(result.sourceNotes).toEqual(source.sourceNotes);
  expect(result.teams.map(team => ({ id: team.id, name: team.name }))).toEqual(source.teams.map(team => ({ id: team.id, name: team.name })));
  expect(result.matches).toHaveLength(source.matches.length);
  expect(() => validateManagedTournament(result)).not.toThrow();
});

test('Halinów 2024 adds only the verified penalties, source-spelled champion squad and three awards', () => {
  const source = archive('halinowcup2024');
  const tournament = applyTournamentCorrections(source);
  const semi = tournament.matches.find(match => match.id === 'Igw3v3F4lg0JtgCKrcDc');
  const final = tournament.matches.find(match => match.stage === 'final');
  expect(semi).toMatchObject({ homeScore: 1, awayScore: 1, homePenalties: 3, awayPenalties: 1 });
  expect(final).toMatchObject({ homeScore: 0, awayScore: 0, homePenalties: 8, awayPenalties: 7 });
  expect(getMatchWinner(final)).toBe('mkG7VLbw1iznL1UgakAq');
  expect(tournament.championTeamId).toBe(source.championTeamId);
  expect(tournament.matches.filter(match => ![semi.id, final.id].includes(match.id)))
    .toEqual(source.matches.filter(match => ![semi.id, final.id].includes(match.id)));
  expect(tournament.teams.find(team => team.id === source.championTeamId).players.map(player => player.name)).toEqual([
    'Michał Durajczyk', 'Przemek Rasiński', 'Przemek Niski', 'Piotrek Szymański',
    'Mateusz Misztalewski', 'Wojtek Lisak', 'Janek Greloch', 'Eryk Kopczynski',
  ]);
  expect(tournament.awards.map(award => award.playerName)).toEqual(['Wojtek Lisak', 'Przemek Niski', 'Damian Bąk']);
  expect(tournament.awards.find(award => award.type === 'scorer')).not.toHaveProperty('value');
  expect(tournament.matches.flatMap(match => match.events)).toEqual(source.matches.flatMap(match => match.events));
});

test('Halinów 2025 completes bronze, exact semifinal penalties and final without fabricating unknown penalties or goals', () => {
  const source = archive();
  const tournament = applyTournamentCorrections(source);
  const final = resolveTournamentMatches(tournament).find(match => match.stage === 'final');
  const semi = tournament.matches.find(match => match.id === 'ZlNwJRbEwzLjL2oFqpyD');
  const bronze = tournament.matches.find(match => match.stage === 'third');
  expect(final).toMatchObject({ homeScore: 2, awayScore: 0, status: 'finished', sourceScoreMissing: false });
  expect(getMatchWinner(final)).toBe(championId);
  expect(tournament.championTeamId).toBe(championId);
  expect(semi).toMatchObject({ homeScore: 1, awayScore: 1, homePenalties: 4, awayPenalties: 3 });
  expect(bronze).toMatchObject({
    homeScore: 0, awayScore: 0, status: 'finished', sourceScoreMissing: false,
    homePenalties: null, awayPenalties: null, reportedWinnerId: '0z3ZCklhsSQSRQEJfyvU',
  });
  expect(getMatchWinner(bronze)).toBe('0z3ZCklhsSQSRQEJfyvU');
  const changed = [semi.id, bronze.id, final.id];
  expect(tournament.matches.filter(match => !changed.includes(match.id))).toEqual(source.matches.filter(match => !changed.includes(match.id)));
  expect(tournament.teams).toHaveLength(30);
  const alo = tournament.teams.find(team => team.name === 'Alo Matcha');
  expect(tournament.matches.filter(match => [match.homeTeamId, match.awayTeamId].includes(alo.id))).toHaveLength(7);
  expect(final.events).toHaveLength(1);
  expect(final.events[0]).toMatchObject({ type: 'goal', minute: 2, teamId: championId, playerId: 'curated-halinowcup2025-konrad-sliwka' });
  expect(getTournamentStats(tournament)).toMatchObject({ played: 80, goals: 227, recordedGoals: 1, unassignedGoals: 226 });
  expect(tournament.individualStatsComplete).toBe(false);
  expect(tournament.awards).toEqual(expect.arrayContaining([
    expect.objectContaining({ type: 'goalkeeper', playerName: 'Łukasz Trąbiński', playerId: 'curated-halinowcup2025-lukasz-trabinski' }),
    expect.objectContaining({ type: 'scorer', playerName: 'Konrad Śliwka', value: 10, unit: 'goli' }),
    expect.objectContaining({ type: 'mvp', playerName: 'Jan Dźwigała' }),
    expect.objectContaining({ type: 'final-mvp', label: 'MVP finału', playerName: 'Damian Krzyżewski' }),
  ]));
  expect(tournament.corrections[0].source.type).toBe('user-supplied-screenshot');
  expect(tournament.corrections[1].source).toMatchObject({
    type: 'official-facebook-post-photo',
    url: 'https://www.facebook.com/photo/?fbid=1435909525206126&set=pcb.1435909735206105',
  });
});

test('Puchar Burmistrza changes all 56 calendar dates while preserving times, results and ambiguous Goliasz identity', () => {
  const source = archive('mlpntest');
  const tournament = applyTournamentCorrections(source);
  expect(tournament.date).toBe('2024-03-17');
  expect(tournament.matchDates).toEqual(['2024-03-17']);
  expect(tournament.matches).toHaveLength(56);
  tournament.matches.forEach((match, index) => {
    expect(match.kickoff).toBe('2024-03-17' + source.matches[index].kickoff.slice(10));
    expect({ ...match, kickoff: source.matches[index].kickoff }).toEqual(source.matches[index]);
  });
  const players = allPlayers(tournament);
  expect(players).toHaveLength(allPlayers(source).length);
  expect(players.find(player => player.id === 'WZIggc7N5YKBVmSVlfnL').name).toBe('Karol Bienias');
  expect(players.find(player => player.id === 'fIbF9gvNVBsm0lLU9xbh').name).toBe('Dawid Kubuj');
  expect(players.find(player => player.id === 'oMQczZX1t4Z2WxledgC9').name).toBe('P. Goliasz');
  expect(players.some(player => player.name === 'Piotr Goljasz')).toBe(false);
  const scorer = tournament.awards.find(award => award.type === 'scorer');
  expect(scorer.playerName).toBe('Piotr Goljasz');
  expect(scorer).not.toHaveProperty('playerId');
  expect(scorer).not.toHaveProperty('value');
  expect(tournament.unassignedPlayers).toEqual(source.unassignedPlayers);
});

test('Puchar Sulejówka adds three linked awards but preserves the disputed fourth place and every score', () => {
  const source = archive('pucharsulejowka2025');
  const tournament = applyTournamentCorrections(source);
  expect(tournament.matches).toEqual(source.matches);
  expect(tournament.matches.find(match => match.stage === 'third').awayTeamId).toBe('0CypYP0FZ7ftvBjYcsFh');
  expect(tournament.awards.map(award => award.playerName)).toEqual(['Yevhenii Kost', 'Filip Hryniewicz', 'Przemek Żelazowski']);
  for (const award of tournament.awards) {
    expect(tournament.teams.find(team => team.id === award.teamId).players)
      .toEqual(expect.arrayContaining([expect.objectContaining({ id: award.playerId, name: award.playerName })]));
    expect(award).not.toHaveProperty('value');
  }
});

test('accepts the previously persisted final-only correction and preserves unrelated administrative fields', () => {
  const previous = archive();
  const legacy = corrections[0];
  previous._revision = 4;
  previous.adminNote = 'Dodatkowa informacja organizatora';
  previous.teams.find(team => team.id === championId).players.push({ id: legacy.players[0].id, name: legacy.players[0].name });
  const final = previous.matches.find(match => match.stage === 'final');
  Object.assign(final, {
    homeScore: 2, awayScore: 0, homePenalties: null, awayPenalties: null,
    reportedWinnerId: null, status: 'finished', sourceScoreMissing: false, events: clone(legacy.final.events),
  });
  previous.awards = clone(legacy.awards);
  previous.corrections = [{ id: legacy.id, source: clone(legacy.source) }];
  const savedCopy = clone(previous);
  const result = applyTournamentCorrections(previous);
  expect(result._revision).toBe(4);
  expect(result.adminNote).toBe(previous.adminNote);
  expect(result.matches.find(match => match.stage === 'final').events).toHaveLength(1);
  expect(allPlayers(result).filter(player => player.name === 'Konrad Śliwka')).toHaveLength(1);
  expect(result.awards).toHaveLength(4);
  expect(previous).toEqual(savedCopy);
});

test('reuses a uniquely matching roster player and links both goal and award to the existing identifier', () => {
  const source = archive();
  source.teams.find(team => team.id === championId).players.push({ id: 'existing-konrad', name: 'Konrad Śliwka' });
  const tournament = applyTournamentCorrections(source);
  expect(allPlayers(tournament).filter(player => player.name === 'Konrad Śliwka')).toHaveLength(1);
  expect(tournament.matches.find(match => match.stage === 'final').events[0].playerId).toBe('existing-konrad');
  expect(tournament.awards.find(award => award.type === 'scorer').playerId).toBe('existing-konrad');
  expect(applyTournamentCorrections(tournament)).toEqual(tournament);
});

test.each(['other-roster', 'unassigned', 'duplicate-roster'])('refuses ambiguous player identities (%s) without mutating the input', scenario => {
  const source = archive();
  if (scenario === 'unassigned') source.unassignedPlayers = [{ id: 'unassigned-konrad', name: 'Konrad Śliwka' }];
  else source.teams.find(team => team.id !== championId).players.push({ id: 'other-konrad', name: 'Konrad Śliwka' });
  if (scenario === 'duplicate-roster') source.teams.find(team => team.id === championId).players.push({ id: 'another-konrad', name: 'Konrad Śliwka' });
  const copy = clone(source);
  expect(() => applyTournamentCorrections(source)).toThrow(/Niejednoznaczny/);
  expect(source).toEqual(copy);
});

test.each([
  ['participants', source => { source.matches.find(match => match.stage === 'final').awayTeamId = 'other-team'; }, /Uczestnicy finału/],
  ['score', source => { source.matches.find(match => match.stage === 'final').homeScore = 3; }, /Bieżący wynik/],
  ['penalties', source => { source.matches.find(match => match.id === 'ZlNwJRbEwzLjL2oFqpyD').homePenalties = 5; }, /Bieżący wynik/],
  ['team name', source => { source.teams.find(team => team.id === championId).name = 'Inna drużyna'; }, /Nie można przypisać/],
  ['conflicting event', source => { source.matches.find(match => match.stage === 'final').events = [{ ...corrections[0].final.events[0], minute: 3 }]; }, /Zdarzenie meczu/],
])('refuses changed %s in a current document rather than silently overwriting it', (_, change, error) => {
  const source = archive();
  change(source);
  const copy = clone(source);
  expect(() => applyTournamentCorrections(source)).toThrow(error);
  expect(source).toEqual(copy);
});

test('requires the expected abbreviated name and expected date when updating existing 2024 identities', () => {
  const renamed = archive('mlpntest');
  allPlayers(renamed).find(player => player.id === 'WZIggc7N5YKBVmSVlfnL').name = 'Kamil Bienias';
  expect(() => applyTournamentCorrections(renamed)).toThrow(/Niejednoznaczny/);
  const rescheduled = archive('mlpntest');
  rescheduled.matches[0].kickoff = '2024-03-18T10:00:00+01:00';
  expect(() => applyTournamentCorrections(rescheduled)).toThrow(/Data turnieju/);
});

test('does not silently replace a changed award total in a saved document', () => {
  const source = corrected();
  source.awards.find(award => award.type === 'scorer').value = 11;
  const copy = clone(source);
  expect(() => applyTournamentCorrections(source)).toThrow(/Wyróżnienie różni/);
  expect(source).toEqual(copy);
});

test('leaves unrelated archives unchanged and the catalogue keeps verified archive identities', () => {
  for (const tournament of archives.filter(item => !correctedSlugs.includes(item.slug))) {
    expect(applyTournamentCorrections(tournament)).toBe(tournament);
  }
  expect(tournamentCatalog.some(tournament => tournament.slug === 'mlpntest')).toBe(true);
  expect(tournamentCatalog.some(tournament => tournament.slug === 'turniej-testowy-2025')).toBe(false);
  for (const slug of correctedSlugs) {
    expect(tournamentCatalog.find(tournament => tournament.slug === slug)).toEqual(corrected(slug));
  }
});
