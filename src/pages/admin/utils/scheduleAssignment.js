function getDayKeyFromSlot(slot) {
  if (slot?.dayKey) return slot.dayKey;
  const dayOffset = Number(slot?.dayOffset);
  if (dayOffset === 0) return "sat";
  if (dayOffset === 1) return "sun";
  return "mon";
}

export function getDayKeyFromOffset(dayOffset) {
  if (dayOffset === 0) return "sat";
  if (dayOffset === 1) return "sun";
  return "mon";
}

export function getDayKeyFromDate(dateStr) {
  if (!dateStr) return null;
  const date = new Date(`${dateStr}T12:00:00`);
  const day = date.getDay();
  if (day === 6) return "sat";
  if (day === 0) return "sun";
  if (day === 1) return "mon";
  return null;
}

export function isRuleAllowedOnDay(rule = "any", dayKey) {
  switch (rule) {
    case "only_sat":
      return dayKey === "sat";
    case "only_sun":
      return dayKey === "sun";
    case "only_mon":
      return dayKey === "mon";
    case "no_sat":
      return dayKey !== "sat";
    case "no_sun":
      return dayKey !== "sun";
    case "no_mon":
      return dayKey !== "mon";
    default:
      return true;
  }
}

export function describeMatchTeams(match, teamNames) {
  const home = teamNames.get(match.home_team_id) || "Gospodarze";
  const away = teamNames.get(match.away_team_id) || "Goscie";
  return `${home} vs ${away}`;
}

export function assignMatchesToAllowedSlots(matches, slots, teamDayRules, teamNames, contextLabel, options = {}) {
  if (!matches.length) return [];
  if (matches.length > slots.length) {
    throw new Error(`Nie ma wystarczajacej liczby slotow dla ${contextLabel}.`);
  }

  const scoreMatchSlot = options.scoreMatchSlot || (() => 0);

  const normalizedSlots = slots.map((slot, index) => ({
    ...slot,
    slotIndex: index,
    dayKey: getDayKeyFromSlot(slot),
  }));
  const slotByIndex = new Map(normalizedSlots.map((slot) => [slot.slotIndex, slot]));

  const candidateEntries = matches.map((match, matchIndex) => {
    const candidates = normalizedSlots
      .filter((slot) => {
        const homeRule = teamDayRules[match.home_team_id] || "any";
        const awayRule = teamDayRules[match.away_team_id] || "any";
        return isRuleAllowedOnDay(homeRule, slot.dayKey) && isRuleAllowedOnDay(awayRule, slot.dayKey);
      })
      .map((slot) => ({
        slotIndex: slot.slotIndex,
        score: scoreMatchSlot(match, slot),
      }))
      .sort((a, b) => b.score - a.score);

    return { match, matchIndex, candidates };
  });

  const impossibleEntry = candidateEntries.find((entry) => entry.candidates.length === 0);
  if (impossibleEntry) {
    throw new Error(
      `Nie da sie ulozyc ${contextLabel}. Mecz ${describeMatchTeams(impossibleEntry.match, teamNames)} nie miesci sie w zadnym dostepnym dniu tej kolejki.`
    );
  }

  const orderedEntries = [...candidateEntries].sort((a, b) => a.candidates.length - b.candidates.length);
  const usedSlots = new Set();
  let bestAssignments = null;
  let bestScore = Number.NEGATIVE_INFINITY;
  const assignments = new Array(matches.length);

  const backtrack = (position, scoreSum) => {
    if (position >= orderedEntries.length) {
      if (scoreSum > bestScore) {
        bestScore = scoreSum;
        bestAssignments = [...assignments];
      }
      return;
    }

    const entry = orderedEntries[position];
    for (const candidate of entry.candidates) {
      const { slotIndex, score } = candidate;
      if (usedSlots.has(slotIndex)) continue;
      usedSlots.add(slotIndex);
      assignments[entry.matchIndex] = slotByIndex.get(slotIndex);
      backtrack(position + 1, scoreSum + score);
      usedSlots.delete(slotIndex);
      assignments[entry.matchIndex] = null;
    }
  };

  backtrack(0, 0);

  if (!bestAssignments) {
    throw new Error(
      `Nie da sie ulozyc ${contextLabel} zgodnie z ograniczeniami druzyn. Zmien ograniczenia albo rozklad slotow w kolejce.`
    );
  }

  return matches.map((match, index) => ({
    match,
    slot: bestAssignments[index],
  }));
}
