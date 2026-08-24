export function getTablePositions(standings = []) {
  const seen = new Set();
  const positions = [];

  for (let index = 0; index < standings.length; index += 1) {
    const rawPosition = Number(standings[index]?.position);
    const position = Number.isFinite(rawPosition) && rawPosition > 0
      ? Math.trunc(rawPosition)
      : index + 1;
    if (seen.has(position)) continue;
    seen.add(position);
    positions.push(position);
  }

  return positions.sort((left, right) => left - right);
}

export function getTablePositionOptions(standings = []) {
  return getTablePositions(standings).map((position) => ({
    value: String(position),
    label: `Poz. ${position}`,
  }));
}

function snapPosition(rawValue, positions, fallback, direction) {
  const numericValue = Number(rawValue);
  if (!Number.isFinite(numericValue) || numericValue <= 0) return fallback;
  if (positions.includes(numericValue)) return numericValue;

  if (direction === "up") {
    return positions.find((position) => position >= numericValue) ?? positions[positions.length - 1];
  }

  return [...positions].reverse().find((position) => position <= numericValue) ?? positions[0];
}

export function resolveTableRange({ enabled = false, from, to } = {}, positions = []) {
  const normalizedPositions = [...new Set(
    positions
      .map(Number)
      .filter((position) => Number.isFinite(position) && position > 0)
      .map(Math.trunc)
  )].sort((left, right) => left - right);

  if (!normalizedPositions.length) {
    return {
      enabled: Boolean(enabled),
      active: false,
      from: null,
      to: null,
      positions: [],
    };
  }

  const minimum = normalizedPositions[0];
  const maximum = normalizedPositions[normalizedPositions.length - 1];
  const resolvedFrom = snapPosition(from, normalizedPositions, minimum, "up");
  let resolvedTo = snapPosition(to, normalizedPositions, maximum, "down");

  // A stale draft or a league switch can leave an inverted range. Keep the
  // selected starting position and collapse to one valid row instead of
  // silently disabling the feature.
  if (resolvedFrom > resolvedTo) resolvedTo = resolvedFrom;

  return {
    enabled: Boolean(enabled),
    active: Boolean(enabled) && (resolvedFrom > minimum || resolvedTo < maximum),
    from: resolvedFrom,
    to: resolvedTo,
    positions: normalizedPositions,
  };
}

export function isTableRowDimmed(range, position) {
  if (!range?.active) return false;
  const numericPosition = Number(position);
  if (!Number.isFinite(numericPosition)) return false;
  return numericPosition < range.from || numericPosition > range.to;
}
