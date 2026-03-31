import { isEditableScheduleStatus, isLockedScheduleStatus } from "./scheduleRegeneration";

const DEFAULT_SLOT_TIMES = ["14:30", "15:30", "16:30", "17:30", "18:30"];

function toRoundNumber(value) {
  const round = Number(value);
  return Number.isFinite(round) ? round : 0;
}

function matchSortValue(match) {
  return {
    date: String(match?.match_date || "9999-12-31"),
    time: String(match?.match_time || "99:99"),
    home: String(match?.home_team_name || match?.home_team_id || ""),
    id: String(match?.id || ""),
  };
}

function sortMatchesBySlot(matches) {
  return [...(matches || [])].sort((left, right) => {
    const a = matchSortValue(left);
    const b = matchSortValue(right);

    if (a.date !== b.date) return a.date.localeCompare(b.date);
    if (a.time !== b.time) return a.time.localeCompare(b.time);
    if (a.home !== b.home) return a.home.localeCompare(b.home, "pl");
    return a.id.localeCompare(b.id, undefined, { numeric: true });
  });
}

function createKey(parts) {
  return parts.join("::");
}

function parseDateSafe(dateStr) {
  if (!dateStr) return null;
  const date = new Date(`${dateStr}T12:00:00`);
  return Number.isNaN(date.getTime()) ? null : date;
}

function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function addDays(dateStr, days) {
  const parsed = parseDateSafe(dateStr) || new Date();
  parsed.setDate(parsed.getDate() + days);
  return formatDate(parsed);
}

function diffDays(dateStr, baseDateStr) {
  const date = parseDateSafe(dateStr);
  const base = parseDateSafe(baseDateStr);
  if (!date || !base) return 0;

  const diffMs = date.getTime() - base.getTime();
  return Math.round(diffMs / (24 * 60 * 60 * 1000));
}

function timeToMinutes(timeStr) {
  const [hours, minutes] = String(timeStr || "14:30").split(":").map(Number);
  return (hours || 0) * 60 + (minutes || 0);
}

function minutesToTime(minutesValue) {
  const hours = Math.floor(minutesValue / 60);
  const minutes = minutesValue % 60;
  return `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}`;
}

function nextTimeSlot(timeStr, offsetMinutes = 60) {
  return minutesToTime(timeToMinutes(timeStr) + offsetMinutes);
}

function shuffleArray(items, rng = Math.random) {
  const copy = [...items];
  for (let i = copy.length - 1; i > 0; i -= 1) {
    const j = Math.floor(rng() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function buildRoundMap(matches) {
  const roundMap = new Map();

  for (const match of matches || []) {
    const round = toRoundNumber(match?.round);
    if (!roundMap.has(round)) {
      roundMap.set(round, []);
    }
    roundMap.get(round).push(match);
  }

  for (const [round, roundMatches] of roundMap.entries()) {
    roundMap.set(round, sortMatchesBySlot(roundMatches));
  }

  return roundMap;
}

function normalizeSlotPattern(slots, baseDate) {
  return (slots || []).map((slot) => ({
    dayOffset: diffDays(slot.match_date, baseDate),
    match_time: slot.match_time || DEFAULT_SLOT_TIMES[0],
  }));
}

function createDefaultPattern(slotCount) {
  const count = Math.max(1, slotCount || 1);
  return Array.from({ length: count }, (_, index) => ({
    dayOffset: 0,
    match_time: DEFAULT_SLOT_TIMES[index] || DEFAULT_SLOT_TIMES[DEFAULT_SLOT_TIMES.length - 1],
  }));
}

function getTemplateBaseDate(template) {
  const firstSlot = sortMatchesBySlot(template?.slots || [])[0];
  return firstSlot?.match_date || template?.baseDate || null;
}

function buildRoundTemplates(matches, startRound, roundCount, slotsPerRound) {
  const roundMap = buildRoundMap(matches);
  const rawTemplates = new Map();

  for (const [round, roundMatches] of roundMap.entries()) {
    const slots = roundMatches.map((match) => ({
      match_date: match.match_date,
      match_time: match.match_time || DEFAULT_SLOT_TIMES[0],
    }));
    const baseDate = slots[0]?.match_date || null;

    rawTemplates.set(round, {
      round,
      baseDate,
      slots,
      pattern: baseDate ? normalizeSlotPattern(slots, baseDate) : createDefaultPattern(slots.length || slotsPerRound),
    });
  }

  const futureTemplates = [...rawTemplates.values()]
    .filter((template) => template.round >= startRound && template.baseDate)
    .sort((left, right) => left.round - right.round);

  const bestPatternTemplate = futureTemplates
    .slice()
    .sort((left, right) => right.slots.length - left.slots.length)[0];

  const fallbackPattern = bestPatternTemplate?.pattern?.length
    ? bestPatternTemplate.pattern
    : createDefaultPattern(slotsPerRound);

  let anchorRound = futureTemplates[0]?.round || null;
  let anchorBaseDate = futureTemplates[0]?.baseDate || null;

  if (!anchorBaseDate) {
    const previousTemplates = [...rawTemplates.values()]
      .filter((template) => template.round < startRound && template.baseDate)
      .sort((left, right) => right.round - left.round);

    const previousTemplate = previousTemplates[0];
    if (previousTemplate) {
      anchorRound = previousTemplate.round + 1;
      anchorBaseDate = addDays(previousTemplate.baseDate, 7);
    } else {
      anchorRound = startRound;
      anchorBaseDate = formatDate(new Date());
    }
  }

  const templates = [];
  for (let offset = 0; offset < roundCount; offset += 1) {
    const round = startRound + offset;
    const existing = rawTemplates.get(round);

    if (existing?.baseDate) {
      templates.push(existing);
      continue;
    }

    const baseDate = addDays(anchorBaseDate, (round - anchorRound) * 7);
    const slots = fallbackPattern.map((patternEntry) => ({
      match_date: addDays(baseDate, patternEntry.dayOffset),
      match_time: patternEntry.match_time,
    }));

    templates.push({
      round,
      baseDate,
      slots,
      pattern: fallbackPattern,
    });
  }

  return { templates, fallbackPattern };
}

function expandTemplateSlots(template, neededCount, fallbackPattern) {
  const slots = sortMatchesBySlot(template?.slots || []);
  if (slots.length >= neededCount) {
    return slots.slice(0, neededCount);
  }

  const baseDate = getTemplateBaseDate(template) || formatDate(new Date());
  const normalizedUsed = new Set(
    slots.map((slot) => createKey([slot.match_date || baseDate, slot.match_time || DEFAULT_SLOT_TIMES[0]]))
  );

  const expanded = [...slots];
  for (const patternEntry of fallbackPattern || []) {
    if (expanded.length >= neededCount) break;

    const candidate = {
      match_date: addDays(baseDate, patternEntry.dayOffset),
      match_time: patternEntry.match_time,
    };
    const candidateKey = createKey([candidate.match_date, candidate.match_time]);
    if (normalizedUsed.has(candidateKey)) continue;

    normalizedUsed.add(candidateKey);
    expanded.push(candidate);
  }

  while (expanded.length < neededCount) {
    const lastSlot = expanded[expanded.length - 1] || {
      match_date: baseDate,
      match_time: DEFAULT_SLOT_TIMES[0],
    };
    const candidate = {
      match_date: lastSlot.match_date || baseDate,
      match_time: nextTimeSlot(lastSlot.match_time || DEFAULT_SLOT_TIMES[0]),
    };
    const candidateKey = createKey([candidate.match_date, candidate.match_time]);

    if (normalizedUsed.has(candidateKey)) {
      candidate.match_time = nextTimeSlot(candidate.match_time, 30);
    }

    normalizedUsed.add(createKey([candidate.match_date, candidate.match_time]));
    expanded.push(candidate);
  }

  return sortMatchesBySlot(expanded);
}

function teamRoundValue(value, fallbackValue) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallbackValue;
}

export function isSeasonTeamActiveOnRound(seasonTeam, roundNumber) {
  if (!seasonTeam) return false;

  const round = toRoundNumber(roundNumber);
  const joinedRound = teamRoundValue(seasonTeam.joined_round, 1);
  const leftRound = teamRoundValue(seasonTeam.left_round, null);

  return joinedRound <= round && (leftRound === null || round < leftRound);
}

function buildRemainingFixtures(activeTeamIds, lockedMatches) {
  const directedMatches = new Map();

  for (const match of lockedMatches || []) {
    const homeTeamId = match?.home_team_id;
    const awayTeamId = match?.away_team_id;

    if (!activeTeamIds.includes(homeTeamId) || !activeTeamIds.includes(awayTeamId)) {
      continue;
    }

    const directionKey = createKey([homeTeamId, awayTeamId]);
    directedMatches.set(directionKey, (directedMatches.get(directionKey) || 0) + 1);
  }

  const fixtures = [];
  for (let i = 0; i < activeTeamIds.length; i += 1) {
    for (let j = i + 1; j < activeTeamIds.length; j += 1) {
      const homeA = activeTeamIds[i];
      const homeB = activeTeamIds[j];

      const countAB = directedMatches.get(createKey([homeA, homeB])) || 0;
      const countBA = directedMatches.get(createKey([homeB, homeA])) || 0;
      const totalPlayed = countAB + countBA;

      if (totalPlayed >= 2) {
        continue;
      }

      if (totalPlayed === 1) {
        fixtures.push(
          countAB === 1
            ? { id: createKey([homeB, homeA, "return"]), home_team_id: homeB, away_team_id: homeA }
            : { id: createKey([homeA, homeB, "return"]), home_team_id: homeA, away_team_id: homeB }
        );
        continue;
      }

      fixtures.push(
        { id: createKey([homeA, homeB, "first"]), home_team_id: homeA, away_team_id: homeB },
        { id: createKey([homeB, homeA, "second"]), home_team_id: homeB, away_team_id: homeA }
      );
    }
  }

  return fixtures;
}

function countFixturesPerTeam(fixtures) {
  const counts = new Map();

  for (const fixture of fixtures || []) {
    counts.set(fixture.home_team_id, (counts.get(fixture.home_team_id) || 0) + 1);
    counts.set(fixture.away_team_id, (counts.get(fixture.away_team_id) || 0) + 1);
  }

  return counts;
}

function countFixturesPerPair(fixtures) {
  const counts = new Map();

  for (const fixture of fixtures || []) {
    const pairKey = [fixture.home_team_id, fixture.away_team_id].sort().join("::");
    counts.set(pairKey, (counts.get(pairKey) || 0) + 1);
  }

  return counts;
}

function fixtureScore(fixture, fixtureCountsByTeam, fixtureCountsByPair, roundsLeft, rng = Math.random) {
  const pairKey = [fixture.home_team_id, fixture.away_team_id].sort().join("::");
  const homeCount = fixtureCountsByTeam.get(fixture.home_team_id) || 0;
  const awayCount = fixtureCountsByTeam.get(fixture.away_team_id) || 0;
  const pairCount = fixtureCountsByPair.get(pairKey) || 0;

  let score = pairCount * 10 + homeCount + awayCount;
  if (homeCount >= roundsLeft) score += 5;
  if (awayCount >= roundsLeft) score += 5;
  score += rng();
  return score;
}

function chooseRoundFixtures(fixtures, teamIds, maxMatches, minMatches, roundsLeft, rng = Math.random) {
  const fixtureCountsByTeam = countFixturesPerTeam(fixtures);
  const fixtureCountsByPair = countFixturesPerPair(fixtures);

  const ordered = shuffleArray(fixtures, rng)
    .sort(
      (left, right) =>
        fixtureScore(right, fixtureCountsByTeam, fixtureCountsByPair, roundsLeft, rng) -
        fixtureScore(left, fixtureCountsByTeam, fixtureCountsByPair, roundsLeft, rng)
    )
    .slice(0, Math.max(18, maxMatches * 10));

  let best = [];

  function dfs(index, availableTeams, chosen) {
    if (chosen.length > best.length) {
      best = [...chosen];
    }

    if (best.length === maxMatches) return;

    const possibleAdditions = Math.min(Math.floor(availableTeams.size / 2), maxMatches - chosen.length);
    if (chosen.length + possibleAdditions <= best.length) {
      return;
    }

    for (let i = index; i < ordered.length; i += 1) {
      const fixture = ordered[i];
      if (!availableTeams.has(fixture.home_team_id) || !availableTeams.has(fixture.away_team_id)) {
        continue;
      }

      const nextTeams = new Set(availableTeams);
      nextTeams.delete(fixture.home_team_id);
      nextTeams.delete(fixture.away_team_id);

      chosen.push(fixture);
      dfs(i + 1, nextTeams, chosen);
      chosen.pop();

      if (best.length === maxMatches) return;
    }
  }

  dfs(0, new Set(teamIds), []);

  return best.length >= minMatches ? best : null;
}

function removeChosenFixtures(fixtures, chosenFixtures) {
  const chosenIds = new Set(chosenFixtures.map((fixture) => fixture.id));
  return fixtures.filter((fixture) => !chosenIds.has(fixture.id));
}

function attemptSchedule(fixtures, teamIds, roundNumbers, rng = Math.random) {
  const matchesPerRound = Math.floor(teamIds.length / 2);
  let remainingFixtures = [...fixtures];
  const scheduledRounds = [];

  for (let index = 0; index < roundNumbers.length; index += 1) {
    const roundNumber = roundNumbers[index];
    const roundsLeft = roundNumbers.length - index;

    if (remainingFixtures.length === 0) {
      scheduledRounds.push({ round: roundNumber, fixtures: [] });
      continue;
    }

    const minimumByVolume = Math.ceil(remainingFixtures.length / roundsLeft);
    const chosenFixtures = chooseRoundFixtures(
      remainingFixtures,
      teamIds,
      matchesPerRound,
      Math.min(matchesPerRound, minimumByVolume),
      roundsLeft,
      rng
    );

    if (!chosenFixtures) {
      return null;
    }

    remainingFixtures = removeChosenFixtures(remainingFixtures, chosenFixtures);
    scheduledRounds.push({
      round: roundNumber,
      fixtures: chosenFixtures,
    });
  }

  if (remainingFixtures.length > 0) {
    return null;
  }

  return scheduledRounds;
}

function scheduleFixturesIntoRounds(fixtures, teamIds, roundNumbers, maxAttempts = 400) {
  for (let attempt = 0; attempt < maxAttempts; attempt += 1) {
    const scheduled = attemptSchedule(fixtures, teamIds, roundNumbers, Math.random);
    if (scheduled) {
      return scheduled;
    }
  }

  return null;
}

export function getSuggestedStructureRound(matches) {
  const lockedRounds = (matches || [])
    .filter((match) => isLockedScheduleStatus(match.status))
    .map((match) => toRoundNumber(match.round));

  return Math.max(1, ...(lockedRounds.length ? [Math.max(...lockedRounds) + 1] : [1]));
}

export function buildMidSeasonSchedulePlan({
  matches,
  seasonTeams,
  startRound,
}) {
  const effectiveRound = toRoundNumber(startRound);
  if (effectiveRound < 1) {
    throw new Error("Podaj poprawna kolejke startowa.");
  }

  const futureLockedMatches = (matches || []).filter(
    (match) => toRoundNumber(match.round) >= effectiveRound && isLockedScheduleStatus(match.status)
  );

  if (futureLockedMatches.length > 0) {
    const firstLockedRound = Math.min(...futureLockedMatches.map((match) => toRoundNumber(match.round)));
    throw new Error(`Od kolejki ${effectiveRound} sa juz rozegrane lub zamkniete mecze. Najwczesniej mozesz zaczac od kolejki ${firstLockedRound + 1}.`);
  }

  const activeTeamIds = (seasonTeams || [])
    .filter((seasonTeam) => isSeasonTeamActiveOnRound(seasonTeam, effectiveRound))
    .map((seasonTeam) => seasonTeam.team_id);

  if (activeTeamIds.length < 2) {
    throw new Error("Po tej zmianie liga ma mniej niz 2 aktywne druzyny.");
  }

  const lockedMatches = (matches || []).filter((match) => toRoundNumber(match.round) < effectiveRound);
  const futureEditableMatches = (matches || []).filter(
    (match) => toRoundNumber(match.round) >= effectiveRound && isEditableScheduleStatus(match.status)
  );
  const fixtures = buildRemainingFixtures(activeTeamIds, lockedMatches);
  const matchesPerRound = Math.floor(activeTeamIds.length / 2);
  const existingMaxRound = Math.max(
    0,
    ...((matches || []).map((match) => toRoundNumber(match.round)))
  );
  const existingFutureRoundCount = Math.max(0, existingMaxRound - effectiveRound + 1);

  const fixtureCountsByTeam = countFixturesPerTeam(fixtures);
  const minimumRoundsNeeded = Math.max(
    Math.ceil(fixtures.length / Math.max(matchesPerRound, 1)),
    ...activeTeamIds.map((teamId) => fixtureCountsByTeam.get(teamId) || 0),
    0
  );
  const roundCount = Math.max(existingFutureRoundCount, minimumRoundsNeeded);
  const roundNumbers = Array.from({ length: roundCount }, (_, index) => effectiveRound + index);
  const scheduledRounds = scheduleFixturesIntoRounds(fixtures, activeTeamIds, roundNumbers);

  if (!scheduledRounds) {
    throw new Error("Nie udalo sie przebudowac przyszlego terminarza dla tej liczby druzyn.");
  }

  const { templates, fallbackPattern } = buildRoundTemplates(
    matches,
    effectiveRound,
    roundCount,
    matchesPerRound
  );

  const inserts = [];
  for (const scheduledRound of scheduledRounds) {
    const template = templates.find((entry) => entry.round === scheduledRound.round) || {
      round: scheduledRound.round,
      slots: [],
      baseDate: null,
    };
    const roundSlots = expandTemplateSlots(template, scheduledRound.fixtures.length, fallbackPattern);

    scheduledRound.fixtures.forEach((fixture, index) => {
      const slot = roundSlots[index];
      inserts.push({
        round: scheduledRound.round,
        home_team_id: fixture.home_team_id,
        away_team_id: fixture.away_team_id,
        match_date: slot?.match_date || template.baseDate || null,
        match_time: slot?.match_time || DEFAULT_SLOT_TIMES[index] || DEFAULT_SLOT_TIMES[0],
        status: "scheduled",
      });
    });
  }

  const finalRound = roundNumbers.length ? roundNumbers[roundNumbers.length - 1] : existingMaxRound;

  return {
    activeTeamIds,
    deletedMatchIds: futureEditableMatches.map((match) => match.id),
    inserts,
    startRound: effectiveRound,
    finalRound,
    roundCount,
    activeTeamCount: activeTeamIds.length,
    minimumRoundsNeeded,
  };
}

export function buildRoundSwapUpdates(matches, sourceRound, targetRound) {
  const source = toRoundNumber(sourceRound);
  const target = toRoundNumber(targetRound);

  if (source < 1 || target < 1 || source === target) {
    throw new Error("Wybierz dwie rozne kolejki.");
  }

  const sourceMatches = sortMatchesBySlot((matches || []).filter((match) => toRoundNumber(match.round) === source));
  const targetMatches = sortMatchesBySlot((matches || []).filter((match) => toRoundNumber(match.round) === target));

  if (sourceMatches.length === 0 || targetMatches.length === 0) {
    throw new Error("Jedna z wybranych kolejek nie ma meczow.");
  }

  if (sourceMatches.some((match) => isLockedScheduleStatus(match.status)) || targetMatches.some((match) => isLockedScheduleStatus(match.status))) {
    throw new Error("Nie mozna zamienic kolejki, ktora ma rozegrane lub zamkniete mecze.");
  }

  if (sourceMatches.length !== targetMatches.length) {
    throw new Error("Te kolejki maja rozna liczbe meczow, wiec nie da sie ich prosto zamienic terminami.");
  }

  const updates = [];
  for (let index = 0; index < sourceMatches.length; index += 1) {
    updates.push({
      matchId: sourceMatches[index].id,
      payload: {
        match_date: targetMatches[index].match_date,
        match_time: targetMatches[index].match_time,
      },
    });
    updates.push({
      matchId: targetMatches[index].id,
      payload: {
        match_date: sourceMatches[index].match_date,
        match_time: sourceMatches[index].match_time,
      },
    });
  }

  return {
    sourceRound: source,
    targetRound: target,
    updates,
    matchCount: sourceMatches.length + targetMatches.length,
  };
}
