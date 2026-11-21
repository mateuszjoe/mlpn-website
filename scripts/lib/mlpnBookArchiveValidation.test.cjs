const test = require('node:test');
const assert = require('node:assert/strict');
const { resolveWordPressMatch } = require('./mlpnBookArchiveValidation.cjs');
const match = { year:2023, leagueCode:'3rd', status:1, homeName:'FC KSS', awayName:'ES Chobot Meat', scoreHome:0, scoreAway:0, originalMatchTitle:'FC KSS vs ES Chobot Meat' };
const imported = { season_year:2023, league_code:'3rd', home_team_name:'FC KSS', away_team_name:'ES Chobot Meat', home_goals:null, away_goals:null };
test('does not turn a vacant first-half slot into a 0:0 draw', () => {
  assert.equal(resolveWordPressMatch(match, [imported]).status, 'not_played');
});
test('keeps a genuine goalless draw when both sources contain its score', () => {
  assert.equal(resolveWordPressMatch(match, [{ ...imported, home_goals:0, away_goals:0 }]).status, 'completed');
});
test('ignores byes even when their old team ID now belongs to an active club', () => {
  assert.equal(resolveWordPressMatch({ ...match, originalMatchTitle:'FC KSS vs Pauza' }, []).exclude, true);
});
test('preserves the historical match title instead of a subsequently overwritten club name', () => {
  const result = resolveWordPressMatch({ ...match, homeName:'KS ProBram24', originalMatchTitle:'Ostre Grzyby vs Nankatsu', scoreHome:2, scoreAway:1 }, []);
  assert.equal(result.home, 'Ostre Grzyby');
  assert.equal(result.status, 'completed');
});
