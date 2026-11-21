const test = require('node:test');
const assert = require('node:assert/strict');
const { topWithTies, isPlayed, verify2026Schedule, calculateStreaks } = require('./mlpnBookTeamRecords.cjs');

function game(id, date, homeGoals = 2, awayGoals = 1, extra = {}) {
  return { id, season_year: 2026, league_code: '1st', round: 1,
    match_date: date, match_time: '18:00:00', status: 'completed',
    home_team_id: 'a', home_team_name: 'A', away_team_id: 'b', away_team_name: 'B',
    home_goals: homeGoals, away_goals: awayGoals, ...extra };
}
const wins = matches => calculateStreaks(matches).wins.find(row => row.teamId === 'a')?.value || 0;

test('chronology uses date and time, not round, input order or id', () => {
  const rows = [game('z', '2026-04-01', 2, 1, { round: 8 }),
    game('a', '2026-04-03', 2, 1, { round: 2 }),
    game('c', '2026-04-02', 0, 2, { round: 1 }),
    game('b', '2026-04-03', 2, 1, { match_time: '19:00:00', round: 3 })];
  assert.equal(wins(rows), 2);
  assert.equal(wins([...rows].reverse()), 2);
});

test('walkovers and missing scores interrupt a run; zero remains a real score', () => {
  const rows = [game('1', '2026-04-01'), game('2', '2026-04-02', 3, 0, { status: 'walkover_home' }),
    game('3', '2026-04-03'), game('4', '2026-04-04', null, null), game('5', '2026-04-05')];
  assert.equal(wins(rows), 1);
  assert.equal(isPlayed(game('zero', '2026-04-06', 0, 0)), true);
  assert.equal(calculateStreaks([game('zero', '2026-04-06', 0, 0)]).draws[0].value, 1);
});

test('missing chronology, ambiguous simultaneous fixtures and explicit gaps do not join runs', () => {
  assert.equal(wins([game('1', '2026-04-01'), game('2', null), game('3', '2026-04-03')]), 0);
  assert.equal(wins([game('1', '2026-04-01'), game('2', '2026-04-01')]), 0);
  assert.equal(wins([game('1', '2026-04-01'), game('2', '2026-04-02', 2, 1, { gapBefore: true })]), 1);
});

test('seasons are separate and future results are excluded', () => {
  const rows = [game('1', '2025-10-01', 2, 1, { season_year: 2025 }),
    game('2', '2026-04-01'), game('3', '2026-12-01')];
  assert.equal(wins(rows), 1);
});

test('rank includes every fifth-place tie and assigns shared competition ranks', () => {
  const ranked = topWithTies([10, 9, 8, 7, 6, 6, 5].map((value, i) => ({ holder: `${i}`, value })));
  assert.deepEqual(ranked.map(row => row.rank), [1, 2, 3, 4, 5, 5]);
});

test('a missing fixture blocks the affected teams instead of fabricating a longer run', () => {
  const membership = ['a', 'b'].map(team_id => ({ team_id, season_year: 2026,
    league_code: '1st', joined_round: 1, left_round: null }));
  const fixtures = [game('1', '2026-04-01')];
  const gaps = verify2026Schedule(fixtures, membership);
  assert.equal(gaps.length, 1);
  const result = calculateStreaks(fixtures, { blockedTeamIds: gaps.flatMap(gap => gap.teamIds) });
  assert.equal(result.wins.length, 0);
  membership[1].joined_round = 10;
  assert.equal(verify2026Schedule(fixtures, membership).length, 0);
});

test('duplicate fixtures are rejected', () => {
  const match = game('same', '2026-04-01');
  assert.throws(() => calculateStreaks([match, match]), /Duplicate fixture/);
});
