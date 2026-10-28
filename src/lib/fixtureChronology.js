export function fixtureDateSortValue(item, fallback = "9999-12-31") {
  return item?.date || item?.scheduleDate || fallback;
}

export function fixtureTimeSortValue(item, fallback = "23:59") {
  return item?.time || item?.scheduleTime || fallback;
}

function fixtureSortSignature(item, dateFallback = "9999-12-31", timeFallback = "23:59") {
  return {
    date: fixtureDateSortValue(item, dateFallback),
    time: fixtureTimeSortValue(item, timeFallback),
    round: Number(item?.round || 0),
    league: String(item?.league || ""),
    home: String(item?.home || ""),
    away: String(item?.away || ""),
    id: String(item?.id || ""),
  };
}

export function compareFixturesChronologically(a, b) {
  const left = fixtureSortSignature(a);
  const right = fixtureSortSignature(b);
  return (
    left.date.localeCompare(right.date) ||
    left.time.localeCompare(right.time) ||
    left.round - right.round ||
    left.league.localeCompare(right.league) ||
    left.home.localeCompare(right.home, "pl") ||
    left.away.localeCompare(right.away, "pl") ||
    left.id.localeCompare(right.id)
  );
}

export function compareMatchesNewestFirst(a, b) {
  const left = fixtureSortSignature(a, "0000-00-00", "00:00");
  const right = fixtureSortSignature(b, "0000-00-00", "00:00");
  return (
    right.date.localeCompare(left.date) ||
    right.time.localeCompare(left.time) ||
    right.round - left.round ||
    right.league.localeCompare(left.league) ||
    right.home.localeCompare(left.home, "pl") ||
    right.away.localeCompare(left.away, "pl") ||
    right.id.localeCompare(left.id)
  );
}
