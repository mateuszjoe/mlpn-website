const assert = require('node:assert/strict');
const { test } = require('node:test');
const data = require('../src/data/mlpnBookAllTimeTeams.json');

const club = name => data.clubs.find(row => row.team === name);
const season = (name, year, league) => data.seasonRows.find(row => row.team === name && row.year === year && row.league === league);

test('all 24 years and 68 league seasons have source rows', () => {
  assert.deepEqual([...new Set(data.seasonRows.map(row => row.year))].sort(), Array.from({ length: 24 }, (_, i) => 2003 + i));
  assert.equal(new Set(data.seasonRows.map(row => `${row.year}:${row.league}`)).size, 68);
  assert.equal(data.coverage.seasonRows, data.seasonRows.length);
  assert.equal(data.coverage.clubEntries, data.clubs.length);
  assert.equal(data.seasonRows.length, 814);
  assert.equal(data.coverage.l98Files, 41);
  assert.equal(data.coverage.wpTableRows, 277);
});

test('original 2003 and 2007 goals-conceded corrections are preserved', () => {
  assert.equal(season('Starszaki', 2003, 'I').goalsAgainst, 69);
  assert.equal(season('Zabraniec', 2003, 'I').goalsAgainst, 46);
  assert.equal(season('Legioholicy', 2003, 'I').goalsAgainst, 61);
  assert.equal(season('Legioholicy', 2007, 'I').goalsAgainst, 35);
  assert.equal(season('Pętla Team', 2007, 'I').goalsAgainst, 51);
});

test('reused WordPress team IDs do not overwrite historical identities', () => {
  for (const year of [2018, 2019, 2020, 2021]) assert.ok(season('Okinawa', year, 'III'));
  assert.ok(season('Ostre Grzyby', 2019, 'III'));
  for (const year of [2020, 2021, 2022]) assert.ok(season('Ostre Grzyby', year, 'II'));
  assert.equal(season('Al-Maj Car Marki', 2023, 'III').goalsFor, 93);
  assert.ok(season('La Repubblica', 2020, 'II'));
  assert.ok(!data.seasonRows.some(row => row.team === 'New Team FC' && row.year <= 2021));
  assert.ok(!data.seasonRows.some(row => row.team === 'KS ProBram24' && row.year <= 2022));
});

test('PKKL includes 2018–2020 without assuming continuity with PKKL Pierożek', () => {
  assert.equal(club('PKKL').seasons, 18);
  assert.equal(club('PKKL').lastYear, 2020);
  assert.equal(club('PKKL').goalsFor, 923);
  assert.equal(club('PKKL Pierożek').firstYear, 2021);
  assert.equal(club('Dziadki').goalsFor, 897);
  assert.equal(club('Dziadki').matchesConfirmed, 264);
});

test('all-time standings and gala adjustment are separate definitions', () => {
  assert.equal(club('Starszaki').goalsFor, 1835);
  assert.equal(club('Starszaki').goalsWithout2026Withdrawn, 1832);
  assert.equal(data.clubs.reduce((sum, row) => sum + row.goalsFor - row.goalsWithout2026Withdrawn, 0), 19 * 3);
  assert.deepEqual(data.clubs.slice(0, 5).map(row => row.team), ['Starszaki', 'Legioholicy', 'Fanatycy', 'FC Faworyt', 'Joga Finito']);
});

test('season records compare all leagues and retain tied winners', () => {
  const goals = data.records.find(row => row.id === 'all-time-team-season-goals');
  assert.equal(goals.value, 146);
  assert.deepEqual(goals.ranking.filter(row => row.rank === 1).map(row => row.holder), ['Legioholicy', 'Zabraniec']);
  const balance = data.records.find(row => row.id === 'all-time-team-season-balance');
  assert.equal(balance.value, 111);
  assert.equal(balance.holder, 'Pianka Kuflew');
  assert.equal(data.records.find(row => row.id === 'all-time-club-seasons').ranking.filter(row => row.rank === 1).length, 5);
});

test('mixed identities and administrative entries cannot become a club goal record', () => {
  const mixed = data.clubs.filter(row => row.mixedIdentity);
  assert.equal(mixed.length, 8);
  const goalRanking = data.records.find(row => row.id === 'all-time-club-goals').ranking;
  assert.ok(!goalRanking.some(row => mixed.some(entry => entry.team === row.holder)));
  assert.ok(!data.clubs.some(row => /^(?:-?przerwa-?|pauza|xxx|wolne miejsce(?: [IVX]+)?)$/i.test(row.team)));
});

test('all-time totals equal every source season without double counting', () => {
  for (const entry of data.clubs) {
    const rows = data.seasonRows.filter(row => row.team === entry.team);
    for (const key of ['goalsFor', 'goalsAgainst', 'matchesConfirmed']) {
      assert.equal(entry[key], rows.reduce((sum, row) => sum + row[key], 0), `${entry.team}: ${key}`);
      assert.ok(Number.isSafeInteger(entry[key]) && entry[key] >= 0);
    }
    assert.equal(entry.seasons, new Set(rows.map(row => row.year)).size);
    assert.equal(entry.seasonRows.length, rows.length);
    assert.ok(entry.seasonRows.every(row => row.sourceLabel));
  }
});

test('2026 is refreshed beyond the presentation snapshot', () => {
  assert.equal(season('FC Zieloni', 2026, 'I').goalsFor, 46);
  assert.equal(season('Gosuansa', 2026, 'II').goalsFor, 54);
  assert.equal(season('PJM', 2026, 'II').goalsFor, 72);
  assert.equal(season('FC Restart', 2026, 'III').goalsFor, 55);
  assert.equal(season('Sami Swoi FC', 2026, 'III').goalsFor, 60);
});
