const DATE_KEY_PATTERN = /^(\d{4})-(\d{2})-(\d{2})$/;

function parseDateKey(value) {
  const match = DATE_KEY_PATTERN.exec(String(value || ""));
  if (!match) return null;

  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const timestamp = Date.UTC(year, month - 1, day);
  const date = new Date(timestamp);

  // Date.UTC normalizes invalid dates (for example 31 February), so verify
  // every calendar component before accepting a database DATE value.
  if (
    !Number.isFinite(timestamp) ||
    date.getUTCFullYear() !== year ||
    date.getUTCMonth() !== month - 1 ||
    date.getUTCDate() !== day
  ) {
    return null;
  }

  return date;
}

function toDateKey(date) {
  return date.toISOString().slice(0, 10);
}

function addUtcDays(date, days) {
  return new Date(Date.UTC(
    date.getUTCFullYear(),
    date.getUTCMonth(),
    date.getUTCDate() + days
  ));
}

function completedPredicate(predicate) {
  if (typeof predicate === "function") return predicate;
  return (status) => ["completed", "walkover_home", "walkover_away"].includes(String(status || ""));
}

function compareNullableText(leftValue, rightValue) {
  const left = String(leftValue || "");
  const right = String(rightValue || "");
  if (!left && right) return 1;
  if (left && !right) return -1;
  return left.localeCompare(right);
}

export function dedupeMatchesById(matches = []) {
  const seenIds = new Set();

  return matches.filter((match) => {
    const id = match?.id;
    if (id == null || id === "") return true;

    const key = String(id);
    if (seenIds.has(key)) return false;
    seenIds.add(key);
    return true;
  });
}

export function getWeekendStart(value) {
  const date = parseDateKey(value);
  if (!date) return "";

  const dayOfWeek = date.getUTCDay();
  const offsetFromFriday = { 5: 0, 6: 1, 0: 2, 1: 3 }[dayOfWeek];
  if (offsetFromFriday == null) return "";

  return toDateKey(addUtcDays(date, -offsetFromFriday));
}

export function getWeekendEndExclusive(friday) {
  const start = parseDateKey(friday);
  if (!start || start.getUTCDay() !== 5) return "";
  return toDateKey(addUtcDays(start, 4));
}

export function isDateInWeekend(value, friday) {
  const date = parseDateKey(value);
  const start = parseDateKey(friday);
  const endExclusive = getWeekendEndExclusive(friday);
  if (!date || !start || !endExclusive) return false;

  const timestamp = date.getTime();
  return timestamp >= start.getTime() && timestamp < parseDateKey(endExclusive).getTime();
}

export function formatWeekendRange(friday, { includeYear = true } = {}) {
  const start = parseDateKey(friday);
  if (!start || start.getUTCDay() !== 5) return "";

  const end = addUtcDays(start, 3);
  const startDay = String(start.getUTCDate()).padStart(2, "0");
  const startMonth = String(start.getUTCMonth() + 1).padStart(2, "0");
  const startYear = start.getUTCFullYear();
  const endDay = String(end.getUTCDate()).padStart(2, "0");
  const endMonth = String(end.getUTCMonth() + 1).padStart(2, "0");
  const endYear = end.getUTCFullYear();

  if (startYear !== endYear) {
    const startPart = includeYear ? `${startDay}.${startMonth}.${startYear}` : `${startDay}.${startMonth}`;
    const endPart = includeYear ? `${endDay}.${endMonth}.${endYear}` : `${endDay}.${endMonth}`;
    return `${startPart}–${endPart}`;
  }

  if (startMonth !== endMonth) {
    return `${startDay}.${startMonth}–${endDay}.${endMonth}${includeYear ? `.${endYear}` : ""}`;
  }

  return `${startDay}–${endDay}.${endMonth}${includeYear ? `.${endYear}` : ""}`;
}

export function filterWeekendMatches(matches = [], friday, isCompletedStatus) {
  if (!getWeekendEndExclusive(friday)) return [];
  const isCompleted = completedPredicate(isCompletedStatus);

  return matches.filter(
    (match) => isCompleted(match?.status) && isDateInWeekend(match?.match_date, friday)
  );
}

export function buildWeekendOptions(matches = [], isCompletedStatus) {
  const isCompleted = completedPredicate(isCompletedStatus);
  const counts = new Map();

  matches.forEach((match) => {
    if (!isCompleted(match?.status)) return;
    const weekendStart = getWeekendStart(match?.match_date);
    if (!weekendStart) return;
    counts.set(weekendStart, (counts.get(weekendStart) || 0) + 1);
  });

  return [...counts.entries()]
    .sort(([left], [right]) => right.localeCompare(left))
    .map(([value, count]) => ({
      value,
      label: formatWeekendRange(value),
      count,
    }));
}

export function sortMatchesForGraphic(matches = []) {
  const leagueOrder = { "1st": 0, "2nd": 1, "3rd": 2 };
  return [...matches].sort(
    (left, right) =>
      (leagueOrder[left?.league_code] ?? 99) - (leagueOrder[right?.league_code] ?? 99) ||
      compareNullableText(left?.match_date, right?.match_date) ||
      compareNullableText(left?.match_time, right?.match_time) ||
      compareNullableText(left?.id, right?.id)
  );
}
