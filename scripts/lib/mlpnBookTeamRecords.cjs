// Offline calculations for the local Księga MLPN preview. This module never connects
// to Supabase. Feed it a read-only export of v_matches and season_teams for 2026.
const OUTCOMES = {
  wins: (a, b) => a > b,
  draws: (a, b) => a === b,
  losses: (a, b) => a < b,
  winless: (a, b) => a <= b,
  unbeaten: (a, b) => a >= b,
};

function topWithTies(rows, metric = 'value', limit = 5) {
  const sorted = [...rows].sort((a, b) => b[metric] - a[metric]
    || String(a.holder || a.name || '').localeCompare(String(b.holder || b.name || ''), 'pl'));
  const threshold = sorted[Math.min(limit, sorted.length) - 1]?.[metric];
  let rank = 0;
  let previous;
  return sorted.filter(row => row[metric] >= threshold).map((row, index) => {
    if (row[metric] !== previous) rank = index + 1;
    previous = row[metric];
    return { ...row, rank };
  });
}

function isPlayed(match) {
  return match.status === 'completed'
    && Number.isInteger(match.home_goals) && match.home_goals >= 0
    && Number.isInteger(match.away_goals) && match.away_goals >= 0;
}

// 2026 format: two meetings between original participants, one if a team joined
// for the second half. Matches involving withdrawn teams are excluded entirely.
// A missing fixture cannot safely be placed on the timeline, so affected teams
// are omitted from streak comparisons instead of silently joining both sides.
function verify2026Schedule(fixtures, membership) {
  const members = membership.filter(member => member.season_year === 2026 && member.left_round == null);
  const gaps = [];
  for (let a = 0; a < members.length; a += 1) {
    for (let b = a + 1; b < members.length; b += 1) {
      const left = members[a];
      const right = members[b];
      if (left.league_code !== right.league_code) continue;
      const expected = left.joined_round > 1 || right.joined_round > 1 ? 1 : 2;
      const actual = fixtures.filter(match => match.season_year === 2026
        && match.league_code === left.league_code
        && ((match.home_team_id === left.team_id && match.away_team_id === right.team_id)
          || (match.away_team_id === left.team_id && match.home_team_id === right.team_id))).length;
      if (actual !== expected) gaps.push({ teamIds: [left.team_id, right.team_id], expected, actual });
    }
  }
  return gaps;
}

function calculateStreaks(fixtures, { blockedTeamIds = [], asOf = '2026-11-21' } = {}) {
  const blocked = new Set(blockedTeamIds);
  const byTeamSeason = new Map();
  const seen = new Set();
  for (const match of fixtures) {
    if (seen.has(match.id)) throw new Error(`Duplicate fixture ${match.id}`);
    seen.add(match.id);
    if (match.match_date && match.match_date > asOf) continue;
    for (const side of ['home', 'away']) {
      const opposite = side === 'home' ? 'away' : 'home';
      const teamId = match[`${side}_team_id`];
      if (blocked.has(teamId)) continue;
      const key = `${match.season_year}:${match.league_code}:${teamId}`;
      if (!byTeamSeason.has(key)) byTeamSeason.set(key, []);
      byTeamSeason.get(key).push({ ...match, teamId, holder: match[`${side}_team_name`],
        goalsFor: match[`${side}_goals`], goalsAgainst: match[`${opposite}_goals`] });
    }
  }
  const result = Object.fromEntries(Object.keys(OUTCOMES).map(key => [key, []]));
  for (const matches of byTeamSeason.values()) {
    // Unknown dates/times could hide an interruption anywhere in this season.
    if (matches.some(match => !/^\d{4}-\d{2}-\d{2}$/.test(match.match_date || '')
      || !/^\d{2}:\d{2}(:\d{2})?$/.test(match.match_time || ''))) continue;
    matches.sort((a, b) => a.match_date.localeCompare(b.match_date)
      || a.match_time.localeCompare(b.match_time));
    // A club cannot play two ordered games at exactly the same time.
    if (matches.some((match, index) => index > 0
      && match.match_date === matches[index - 1].match_date
      && match.match_time === matches[index - 1].match_time)) continue;
    for (const [kind, predicate] of Object.entries(OUTCOMES)) {
      let current = [];
      let best = [];
      for (const match of matches) {
        if (match.gapBefore) current = [];
        if (isPlayed(match) && predicate(match.goalsFor, match.goalsAgainst)) {
          current.push(match);
          if (current.length > best.length) best = [...current];
        } else current = [];
      }
      if (best.length) result[kind].push({
        teamId: best[0].teamId, holder: best[0].holder,
        leagueCode: best[0].league_code, season: best[0].season_year,
        value: best.length, start: best[0].match_date, end: best.at(-1).match_date,
        matchIds: best.map(match => match.id),
        results: best.map(match => `${match.goalsFor}:${match.goalsAgainst}`),
      });
    }
  }
  return Object.fromEntries(Object.entries(result).map(([key, values]) => [key, topWithTies(values)]));
}

module.exports = { topWithTies, isPlayed, verify2026Schedule, calculateStreaks };
