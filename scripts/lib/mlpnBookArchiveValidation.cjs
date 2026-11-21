const normalize = name => String(name || '').toLocaleLowerCase('pl').replace(/sulejówek/g, '').replace(/superparkiet[._]pl/g, '').replace(/[^a-z0-9ąćęłńóśźż]/g, '');
const isBye = name => /^(?:-?przerwa-?|pauza|wolne miejsce.*)$/i.test(String(name || '').trim());

function resolveWordPressMatch(match, independentImport) {
  const names = String(match.originalMatchTitle || '').split(/\s+vs\.?\s+/i);
  const home = names.length === 2 ? names[0].trim() : match.homeName;
  const away = names.length === 2 ? names[1].trim() : match.awayName;
  if (!home || !away || isBye(home) || isBye(away)) return { exclude: true, reason: 'Bye or missing participant' };
  const imported = independentImport.filter(row => row.season_year === match.year && row.league_code === match.leagueCode
    && normalize(row.home_team_name) === normalize(match.homeName || home)
    && normalize(row.away_team_name) === normalize(match.awayName || away));
  let status = match.status === 1 ? 'completed' : 'not_played';
  let reason;
  // A real 0:0 is valid. Only a second independent record with no score makes
  // this a known empty slot; do not infer "not played" merely from zero goals.
  if (status === 'completed' && match.scoreHome === 0 && match.scoreAway === 0 && imported.length === 1
    && imported[0].home_goals == null && imported[0].away_goals == null) {
    status = 'not_played';
    reason = 'Empty 0:0 slot; independent import has no result';
  }
  return { home, away, status, reason };
}

module.exports = { normalize, isBye, resolveWordPressMatch };
