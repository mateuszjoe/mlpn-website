const DEFAULT_RULES = {
  "1st": { promotionPlaces: 0, relegationPlaces: 2 },
  "2nd": { promotionPlaces: 2, relegationPlaces: 2 },
  "3rd": { promotionPlaces: 2, relegationPlaces: 0 },
};

// These exceptions were agreed for 2026. Do not apply them retroactively to
// archived seasons or assume they remain valid for a future season.
const SEASON_RULES = {
  2026: {
    "1st": { promotionPlaces: 0, relegationPlaces: 1 },
    "3rd": { promotionPlaces: 3, relegationPlaces: 0 },
  },
};

export function getLeagueRules(leagueId, seasonYear) {
  return {
    ...(SEASON_RULES[Number(seasonYear)]?.[leagueId]
      || DEFAULT_RULES[leagueId]
      || { promotionPlaces: 0, relegationPlaces: 0 }),
  };
}

function activeRows(rows) {
  return (rows || []).filter((row) => row && !row.withdrawn);
}

export function getPromotionRowsForLeague(rows = [], leagueId = "", seasonYear) {
  const { promotionPlaces } = getLeagueRules(leagueId, seasonYear);
  return activeRows(rows).slice(0, promotionPlaces);
}

export function getRelegationRowsForLeague(rows = [], leagueId = "", seasonYear) {
  const { relegationPlaces } = getLeagueRules(leagueId, seasonYear);
  return relegationPlaces ? activeRows(rows).slice(-relegationPlaces) : [];
}
