const BYE_ID = "__MLPN_BYE__";
const EDITABLE_STATUSES = new Set(["scheduled", "postponed", "cancelled"]);

function pairKey(teamAId, teamBId) {
  return [String(teamAId), String(teamBId)].sort().join("::");
}

function createSeededRng(seed = 1) {
  let state = (Number(seed) || 1) >>> 0;
  return function next() {
    state = (state + 0x6d2b79f5) >>> 0;
    let value = Math.imul(state ^ (state >>> 15), 1 | state);
    value ^= value + Math.imul(value ^ (value >>> 7), 61 | value);
    return ((value ^ (value >>> 14)) >>> 0) / 4294967296;
  };
}

function shuffle(items, rng) {
  const copy = [...items];
  for (let index = copy.length - 1; index > 0; index -= 1) {
    const swapIndex = Math.floor(rng() * (index + 1));
    [copy[index], copy[swapIndex]] = [copy[swapIndex], copy[index]];
  }
  return copy;
}

function buildCircleRounds(participants) {
  if (participants.length < 2 || participants.length % 2 !== 0) {
    throw new Error("Generator kolowy wymaga parzystej liczby uczestnikow (z uwzglednieniem pauzy)." );
  }

  let rotation = [...participants];
  const roundCount = rotation.length - 1;
  const rounds = [];

  for (let roundIndex = 0; roundIndex < roundCount; roundIndex += 1) {
    const matches = [];
    let byeTeamId = null;

    for (let pairIndex = 0; pairIndex < rotation.length / 2; pairIndex += 1) {
      const left = rotation[pairIndex];
      const right = rotation[rotation.length - 1 - pairIndex];

      if (left === BYE_ID || right === BYE_ID) {
        byeTeamId = left === BYE_ID ? right : left;
        continue;
      }

      const flipAnchor = pairIndex === 0 && roundIndex % 2 === 1;
      matches.push({
        home_team_id: flipAnchor ? right : left,
        away_team_id: flipAnchor ? left : right,
      });
    }

    rounds.push({
      stage_round: roundIndex + 1,
      bye_team_id: byeTeamId,
      matches,
    });

    rotation = [rotation[0], rotation[rotation.length - 1], ...rotation.slice(1, -1)];
  }

  return rounds;
}

function hasMatch(round, teamAId, teamBId) {
  const expectedKey = pairKey(teamAId, teamBId);
  return round.matches.some(
    (match) => pairKey(match.home_team_id, match.away_team_id) === expectedKey
  );
}

function scheduleMeetsConstraints(rounds, fixedMatches, byeRounds) {
  for (const constraint of fixedMatches) {
    const round = rounds.find((entry) => entry.stage_round === Number(constraint.stageRound));
    if (!round || !hasMatch(round, constraint.teamAId, constraint.teamBId)) {
      return false;
    }
  }

  for (const constraint of byeRounds) {
    const round = rounds.find((entry) => entry.stage_round === Number(constraint.stageRound));
    if (!round || round.bye_team_id !== constraint.teamId) {
      return false;
    }
  }

  return true;
}

function validateConstraintInputs(teamIds, fixedMatches, byeRounds, roundCount) {
  const teamIdSet = new Set(teamIds);

  for (const constraint of fixedMatches) {
    if (!teamIdSet.has(constraint.teamAId) || !teamIdSet.has(constraint.teamBId)) {
      throw new Error("Wymagany mecz zawiera druzyne spoza planowanego skladu ligi.");
    }
    if (constraint.teamAId === constraint.teamBId) {
      throw new Error("Wymagany mecz nie moze wskazywac tej samej druzyny dwukrotnie.");
    }
    if (constraint.stageRound < 1 || constraint.stageRound > roundCount) {
      throw new Error("Wymagany mecz wskazuje kolejke spoza planowanego etapu.");
    }
  }

  for (const constraint of byeRounds) {
    if (!teamIdSet.has(constraint.teamId)) {
      throw new Error("Wymagana pauza zawiera druzyne spoza planowanego skladu ligi.");
    }
    if (constraint.stageRound < 1 || constraint.stageRound > roundCount) {
      throw new Error("Wymagana pauza wskazuje kolejke spoza planowanego etapu.");
    }
  }
}

function applyFixedHomeTeams(rounds, fixedMatches) {
  return rounds.map((round) => ({
    ...round,
    matches: round.matches.map((match) => {
      const constraint = fixedMatches.find(
        (entry) =>
          Number(entry.stageRound) === round.stage_round &&
          pairKey(entry.teamAId, entry.teamBId) ===
            pairKey(match.home_team_id, match.away_team_id)
      );

      if (!constraint?.homeTeamId || constraint.homeTeamId === match.home_team_id) {
        return { ...match };
      }
      if (constraint.homeTeamId !== match.away_team_id) {
        throw new Error("Gospodarz wymaganego meczu nie nalezy do wskazanej pary.");
      }

      return {
        home_team_id: match.away_team_id,
        away_team_id: match.home_team_id,
      };
    }),
  }));
}

function buildConstrainedSingleRoundRobin({
  teamIds,
  fixedMatches = [],
  byeRounds = [],
  seed = 20260822,
  maxAttempts = 50000,
}) {
  const uniqueTeamIds = [...new Set(teamIds || [])];
  if (uniqueTeamIds.length !== (teamIds || []).length) {
    throw new Error("Lista druzyn zawiera duplikaty.");
  }
  if (uniqueTeamIds.length < 2) {
    throw new Error("Do ulozenia etapu potrzeba co najmniej dwoch druzyn.");
  }

  const participants = uniqueTeamIds.length % 2 === 1
    ? [...uniqueTeamIds, BYE_ID]
    : [...uniqueTeamIds];
  const roundCount = participants.length - 1;
  validateConstraintInputs(uniqueTeamIds, fixedMatches, byeRounds, roundCount);

  const rng = createSeededRng(seed);
  for (let attempt = 1; attempt <= maxAttempts; attempt += 1) {
    const candidate = buildCircleRounds(shuffle(participants, rng));
    if (!scheduleMeetsConstraints(candidate, fixedMatches, byeRounds)) continue;

    const rounds = applyFixedHomeTeams(candidate, fixedMatches);
    return { rounds, attempt, seed };
  }

  throw new Error(
    `Nie znaleziono terminarza spelniajacego ograniczenia po ${maxAttempts} probach.`
  );
}

function verifySingleRoundRobin(teamIds, rounds) {
  const errors = [];
  const teamIdSet = new Set(teamIds || []);
  const oddTeamCount = teamIdSet.size % 2 === 1;
  const expectedRoundCount = oddTeamCount ? teamIdSet.size : teamIdSet.size - 1;
  const expectedMatchesPerRound = Math.floor(teamIdSet.size / 2);
  const expectedPairCount = (teamIdSet.size * (teamIdSet.size - 1)) / 2;
  const pairCounts = new Map();
  const teamMatchCounts = new Map([...teamIdSet].map((teamId) => [teamId, 0]));
  const byeCounts = new Map([...teamIdSet].map((teamId) => [teamId, 0]));

  if ((rounds || []).length !== expectedRoundCount) {
    errors.push(`Liczba kolejek: ${(rounds || []).length}, oczekiwano ${expectedRoundCount}.`);
  }

  for (const round of rounds || []) {
    if (round.matches.length !== expectedMatchesPerRound) {
      errors.push(
        `Kolejka ${round.stage_round}: ${round.matches.length} meczow, oczekiwano ${expectedMatchesPerRound}.`
      );
    }

    const usedTeams = new Set();
    for (const match of round.matches) {
      if (!teamIdSet.has(match.home_team_id) || !teamIdSet.has(match.away_team_id)) {
        errors.push(`Kolejka ${round.stage_round}: mecz zawiera druzyne spoza ligi.`);
        continue;
      }
      if (match.home_team_id === match.away_team_id) {
        errors.push(`Kolejka ${round.stage_round}: druzyna gra sama ze soba.`);
      }
      if (usedTeams.has(match.home_team_id) || usedTeams.has(match.away_team_id)) {
        errors.push(`Kolejka ${round.stage_round}: druzyna wystepuje wiecej niz raz.`);
      }
      usedTeams.add(match.home_team_id);
      usedTeams.add(match.away_team_id);

      const key = pairKey(match.home_team_id, match.away_team_id);
      pairCounts.set(key, (pairCounts.get(key) || 0) + 1);
      teamMatchCounts.set(match.home_team_id, (teamMatchCounts.get(match.home_team_id) || 0) + 1);
      teamMatchCounts.set(match.away_team_id, (teamMatchCounts.get(match.away_team_id) || 0) + 1);
    }

    if (oddTeamCount) {
      if (!round.bye_team_id || !teamIdSet.has(round.bye_team_id)) {
        errors.push(`Kolejka ${round.stage_round}: brak poprawnej pauzy.`);
      } else {
        if (usedTeams.has(round.bye_team_id)) {
          errors.push(`Kolejka ${round.stage_round}: pauzujaca druzyna ma rownoczesnie mecz.`);
        }
        byeCounts.set(round.bye_team_id, (byeCounts.get(round.bye_team_id) || 0) + 1);
      }
    } else if (round.bye_team_id) {
      errors.push(`Kolejka ${round.stage_round}: parzysta liga nie powinna miec pauzy.`);
    }
  }

  if (pairCounts.size !== expectedPairCount) {
    errors.push(`Liczba unikalnych par: ${pairCounts.size}, oczekiwano ${expectedPairCount}.`);
  }
  for (const [key, count] of pairCounts.entries()) {
    if (count !== 1) errors.push(`Para ${key} wystepuje ${count} razy.`);
  }
  for (const teamId of teamIdSet) {
    if ((teamMatchCounts.get(teamId) || 0) !== teamIdSet.size - 1) {
      errors.push(
        `Druzyna ${teamId} ma ${teamMatchCounts.get(teamId) || 0} meczow, oczekiwano ${teamIdSet.size - 1}.`
      );
    }
    if (oddTeamCount && (byeCounts.get(teamId) || 0) !== 1) {
      errors.push(`Druzyna ${teamId} ma ${(byeCounts.get(teamId) || 0)} pauz, oczekiwano 1.`);
    }
  }

  return {
    ok: errors.length === 0,
    errors,
    roundCount: (rounds || []).length,
    matchCount: [...pairCounts.values()].reduce((sum, count) => sum + count, 0),
    uniquePairCount: pairCounts.size,
    expectedPairCount,
    matchesPerTeam: Object.fromEntries(teamMatchCounts),
    byesPerTeam: oddTeamCount ? Object.fromEntries(byeCounts) : {},
  };
}

function comparePriorMatches(left, right) {
  const roundDiff = Number(left.round || 0) - Number(right.round || 0);
  if (roundDiff !== 0) return roundDiff;
  const dateDiff = String(left.match_date || "").localeCompare(String(right.match_date || ""));
  if (dateDiff !== 0) return dateDiff;
  return String(left.match_time || "").localeCompare(String(right.match_time || ""));
}

function orientAsReturnFixtures(rounds, priorMatches, fixedMatches = []) {
  const priorByPair = new Map();
  for (const match of [...(priorMatches || [])].sort(comparePriorMatches)) {
    priorByPair.set(pairKey(match.home_team_id, match.away_team_id), match);
  }

  const oriented = (rounds || []).map((round) => ({
    ...round,
    matches: round.matches.map((match) => {
      const prior = priorByPair.get(pairKey(match.home_team_id, match.away_team_id));
      if (!prior) return { ...match };
      return {
        home_team_id: prior.away_team_id,
        away_team_id: prior.home_team_id,
      };
    }),
  }));

  return applyFixedHomeTeams(oriented, fixedMatches);
}

function parseDate(dateText) {
  const date = new Date(`${dateText}T12:00:00`);
  return Number.isNaN(date.getTime()) ? null : date;
}

function formatDate(date) {
  return [
    date.getFullYear(),
    String(date.getMonth() + 1).padStart(2, "0"),
    String(date.getDate()).padStart(2, "0"),
  ].join("-");
}

function addDays(dateText, dayCount) {
  const date = parseDate(dateText);
  if (!date) throw new Error(`Niepoprawna data terminarza: ${dateText}`);
  date.setDate(date.getDate() + Number(dayCount));
  return formatDate(date);
}

function diffDays(dateText, baseDateText) {
  const date = parseDate(dateText);
  const baseDate = parseDate(baseDateText);
  if (!date || !baseDate) return 0;
  return Math.round((date.getTime() - baseDate.getTime()) / 86400000);
}

function normalizeTime(timeText) {
  return String(timeText || "").slice(0, 5);
}

function sortSlots(slots) {
  return [...slots].sort((left, right) => {
    const dateDiff = String(left.match_date).localeCompare(String(right.match_date));
    if (dateDiff !== 0) return dateDiff;
    return normalizeTime(left.match_time).localeCompare(normalizeTime(right.match_time));
  });
}

function uniqueSlots(matches) {
  const seen = new Set();
  const slots = [];
  for (const match of sortSlots(matches || [])) {
    if (!match.match_date || !match.match_time) continue;
    const slot = {
      match_date: match.match_date,
      match_time: normalizeTime(match.match_time),
    };
    const key = `${slot.match_date}::${slot.match_time}`;
    if (seen.has(key)) continue;
    seen.add(key);
    slots.push(slot);
  }
  return slots;
}

function buildStageSlots({ existingMatches, startRound, roundCount, matchesPerRound }) {
  const slotsByGlobalRound = new Map();
  for (let globalRound = startRound; globalRound < startRound + roundCount; globalRound += 1) {
    slotsByGlobalRound.set(
      globalRound,
      uniqueSlots((existingMatches || []).filter((match) => Number(match.round) === globalRound))
    );
  }

  const templateEntry = [...slotsByGlobalRound.entries()]
    .filter(([, slots]) => slots.length > 0)
    .sort((left, right) => right[1].length - left[1].length || left[0] - right[0])[0];
  if (!templateEntry) {
    throw new Error("Brak istniejacych slotow, z ktorych mozna zbudowac kalendarz etapu.");
  }

  const templateSlots = templateEntry[1];
  const templateBaseDate = templateSlots[0].match_date;
  const pattern = templateSlots.map((slot) => ({
    dayOffset: diffDays(slot.match_date, templateBaseDate),
    match_time: normalizeTime(slot.match_time),
  }));
  if (pattern.length < matchesPerRound) {
    throw new Error(
      `Najpelniejsza kolejka ma tylko ${pattern.length} slotow, potrzeba ${matchesPerRound}.`
    );
  }

  const result = [];
  let previousBaseDate = null;
  for (let stageRound = 1; stageRound <= roundCount; stageRound += 1) {
    const globalRound = startRound + stageRound - 1;
    const existingSlots = slotsByGlobalRound.get(globalRound) || [];
    const baseDate = existingSlots[0]?.match_date || addDays(previousBaseDate, 7);
    previousBaseDate = baseDate;

    const used = new Set(
      existingSlots.map((slot) => `${slot.match_date}::${normalizeTime(slot.match_time)}`)
    );
    const expanded = [...existingSlots];
    for (const patternEntry of pattern) {
      if (expanded.length >= matchesPerRound) break;
      const candidate = {
        match_date: addDays(baseDate, patternEntry.dayOffset),
        match_time: patternEntry.match_time,
      };
      const key = `${candidate.match_date}::${candidate.match_time}`;
      if (used.has(key)) continue;
      used.add(key);
      expanded.push(candidate);
    }

    if (expanded.length < matchesPerRound) {
      throw new Error(`Nie udalo sie uzupelnic slotow dla kolejki ${globalRound}.`);
    }

    result.push({
      stage_round: stageRound,
      global_round: globalRound,
      slots: sortSlots(expanded).slice(0, matchesPerRound),
    });
  }

  return result;
}

function assignRoundMatchesToSlots(matches, slots, blockedTeamDates) {
  const assignments = new Array(matches.length);
  const usedSlotIndexes = new Set();

  function isAllowed(match, slot) {
    const homeBlockedDates = blockedTeamDates.get(match.home_team_id) || new Set();
    const awayBlockedDates = blockedTeamDates.get(match.away_team_id) || new Set();
    return !homeBlockedDates.has(slot.match_date) && !awayBlockedDates.has(slot.match_date);
  }

  function backtrack(matchIndex) {
    if (matchIndex >= matches.length) return true;
    const match = matches[matchIndex];

    for (let slotIndex = 0; slotIndex < slots.length; slotIndex += 1) {
      if (usedSlotIndexes.has(slotIndex)) continue;
      if (!isAllowed(match, slots[slotIndex])) continue;

      assignments[matchIndex] = slots[slotIndex];
      usedSlotIndexes.add(slotIndex);
      if (backtrack(matchIndex + 1)) return true;
      usedSlotIndexes.delete(slotIndex);
      assignments[matchIndex] = null;
    }
    return false;
  }

  return backtrack(0) ? assignments : null;
}

function assignRoundsToSlots(
  rounds,
  stageSlots,
  teamNameById = new Map(),
  options = {}
) {
  const slotsByStageRound = new Map(
    (stageSlots || []).map((entry) => [entry.stage_round, entry])
  );
  const blockedTeamDates = options.blockedTeamDates || new Map();
  const scheduledMatches = [];
  const scheduledRounds = [];

  for (const round of rounds || []) {
    const slotRound = slotsByStageRound.get(round.stage_round);
    if (!slotRound || slotRound.slots.length < round.matches.length) {
      throw new Error(`Brak slotow dla kolejki etapu ${round.stage_round}.`);
    }

    const orderedMatches = [...round.matches].sort((left, right) => {
      const leftLabel = `${teamNameById.get(left.home_team_id) || left.home_team_id}|${teamNameById.get(left.away_team_id) || left.away_team_id}`;
      const rightLabel = `${teamNameById.get(right.home_team_id) || right.home_team_id}|${teamNameById.get(right.away_team_id) || right.away_team_id}`;
      return leftLabel.localeCompare(rightLabel, "pl");
    });

    const assignedSlots = assignRoundMatchesToSlots(
      orderedMatches,
      slotRound.slots,
      blockedTeamDates
    );
    if (!assignedSlots) {
      throw new Error(
        `Nie udalo sie przydzielic godzin w kolejce ${slotRound.global_round} bez kolizji z zaleglymi meczami.`
      );
    }

    const roundMatches = orderedMatches.map((match, index) => ({
      ...match,
      stage_round: round.stage_round,
      round: slotRound.global_round,
      match_date: assignedSlots[index].match_date,
      match_time: assignedSlots[index].match_time,
      status: "scheduled",
    }));

    scheduledMatches.push(...roundMatches);
    scheduledRounds.push({
      stage_round: round.stage_round,
      global_round: slotRound.global_round,
      bye_team_id: round.bye_team_id,
      matches: roundMatches,
    });
  }

  return { rounds: scheduledRounds, matches: scheduledMatches };
}

function normalizeTeamIdRemap(teamIdRemap) {
  if (teamIdRemap instanceof Map) return new Map(teamIdRemap);
  return new Map(Object.entries(teamIdRemap || {}));
}

function orientLikeExistingPair(match, existingByPair) {
  const existing = existingByPair.get(pairKey(match.home_team_id, match.away_team_id));
  if (!existing) return { ...match };
  return {
    ...match,
    home_team_id: existing.home_team_id,
    away_team_id: existing.away_team_id,
  };
}

function buildExistingRoundRobinStage({ existingMatches, teamIds, startRound }) {
  const uniqueTeamIds = [...new Set(teamIds || [])];
  const teamIdSet = new Set(uniqueTeamIds);
  const roundCount = uniqueTeamIds.length % 2 === 1
    ? uniqueTeamIds.length
    : uniqueTeamIds.length - 1;
  const matchesPerRound = Math.floor(uniqueTeamIds.length / 2);
  const rounds = [];

  for (let stageRound = 1; stageRound <= roundCount; stageRound += 1) {
    const globalRound = Number(startRound) + stageRound - 1;
    const matches = sortRowsForReuse(existingMatches || [])
      .filter((match) => Number(match.round) === globalRound)
      .filter(
        (match) =>
          teamIdSet.has(match.home_team_id) && teamIdSet.has(match.away_team_id)
      );

    if (matches.length !== matchesPerRound) {
      throw new Error(
        `Kolejka ${globalRound} ma ${matches.length} aktywnych meczow, oczekiwano ${matchesPerRound}.`
      );
    }

    const usedTeamIds = new Set();
    for (const match of matches) {
      if (usedTeamIds.has(match.home_team_id) || usedTeamIds.has(match.away_team_id)) {
        throw new Error(`Kolejka ${globalRound} zawiera druzyne wiecej niz raz.`);
      }
      usedTeamIds.add(match.home_team_id);
      usedTeamIds.add(match.away_team_id);
    }

    const byeTeamIds = uniqueTeamIds.filter((teamId) => !usedTeamIds.has(teamId));
    const expectedByeCount = uniqueTeamIds.length % 2 === 1 ? 1 : 0;
    if (byeTeamIds.length !== expectedByeCount) {
      throw new Error(
        `Kolejka ${globalRound} ma ${byeTeamIds.length} pauz, oczekiwano ${expectedByeCount}.`
      );
    }

    rounds.push({
      stage_round: stageRound,
      global_round: globalRound,
      bye_team_id: byeTeamIds[0] || null,
      matches: matches.map((match) => ({
        home_team_id: match.home_team_id,
        away_team_id: match.away_team_id,
      })),
    });
  }

  const verification = verifySingleRoundRobin(uniqueTeamIds, rounds);
  if (!verification.ok) throw new Error(verification.errors.join("\n"));
  return rounds;
}

function remapRoundRobinStage({
  existingMatches,
  teamIds,
  startRound,
  teamIdRemap,
  fixedMatches = [],
  byeRounds = [],
}) {
  const baseRounds = buildExistingRoundRobinStage({
    existingMatches,
    teamIds,
    startRound,
  });
  const uniqueTeamIds = [...new Set(teamIds || [])];

  // Idempotency: after the target schedule has been applied, reconstruct it
  // directly instead of applying the swap for a second time.
  if (scheduleMeetsConstraints(baseRounds, fixedMatches, byeRounds)) {
    return {
      rounds: applyFixedHomeTeams(baseRounds, fixedMatches),
      remapped: false,
    };
  }

  const remap = normalizeTeamIdRemap(teamIdRemap);
  const remappedTeamIds = uniqueTeamIds.map((teamId) => remap.get(teamId) || teamId);
  if (
    new Set(remappedTeamIds).size !== uniqueTeamIds.length ||
    remappedTeamIds.some((teamId) => !uniqueTeamIds.includes(teamId))
  ) {
    throw new Error("Mapowanie druzyn musi byc bijekcja w obrebie skladu etapu.");
  }

  const stageRoundNumbers = new Set(baseRounds.map((round) => round.global_round));
  const existingByPair = new Map();
  for (const match of sortRowsForReuse(existingMatches || [])) {
    if (!stageRoundNumbers.has(Number(match.round))) continue;
    existingByPair.set(pairKey(match.home_team_id, match.away_team_id), match);
  }

  const remappedRounds = baseRounds.map((round) => ({
    ...round,
    bye_team_id: round.bye_team_id
      ? remap.get(round.bye_team_id) || round.bye_team_id
      : null,
    matches: round.matches.map((match) =>
      orientLikeExistingPair(
        {
          home_team_id: remap.get(match.home_team_id) || match.home_team_id,
          away_team_id: remap.get(match.away_team_id) || match.away_team_id,
        },
        existingByPair
      )
    ),
  }));
  const fixedRounds = applyFixedHomeTeams(remappedRounds, fixedMatches);

  if (!scheduleMeetsConstraints(fixedRounds, fixedMatches, byeRounds)) {
    throw new Error("Mapowanie druzyn nie spelnia wymaganych par lub pauz etapu.");
  }
  const verification = verifySingleRoundRobin(uniqueTeamIds, fixedRounds);
  if (!verification.ok) throw new Error(verification.errors.join("\n"));

  return { rounds: fixedRounds, remapped: true };
}

function assignRoundsToStableSlots(
  rounds,
  stageSlots,
  existingMatches,
  teamNameById = new Map(),
  options = {}
) {
  const slotsByStageRound = new Map(
    (stageSlots || []).map((entry) => [entry.stage_round, entry])
  );
  const blockedTeamDates = options.blockedTeamDates || new Map();
  const fixedSlots = options.fixedSlots || [];
  const teamIdRemap = normalizeTeamIdRemap(options.teamIdRemap);
  const inverseTeamIdRemap = new Map();
  for (const [sourceTeamId, targetTeamId] of teamIdRemap) {
    if (inverseTeamIdRemap.has(targetTeamId)) {
      throw new Error("Mapowanie druzyn dla slotow musi byc bijekcja.");
    }
    inverseTeamIdRemap.set(targetTeamId, sourceTeamId);
  }
  const globalRoundNumbers = new Set(
    (stageSlots || []).map((entry) => Number(entry.global_round))
  );
  const existingByPair = new Map();
  for (const match of sortRowsForReuse(existingMatches || [])) {
    if (!globalRoundNumbers.has(Number(match.round))) continue;
    existingByPair.set(pairKey(match.home_team_id, match.away_team_id), match);
  }

  function slotKey(slot) {
    return `${slot.match_date}::${normalizeTime(slot.match_time)}`;
  }

  function isAllowed(match, slot) {
    const homeBlockedDates = blockedTeamDates.get(match.home_team_id) || new Set();
    const awayBlockedDates = blockedTeamDates.get(match.away_team_id) || new Set();
    return !homeBlockedDates.has(slot.match_date) && !awayBlockedDates.has(slot.match_date);
  }

  const scheduledMatches = [];
  const scheduledRounds = [];

  for (const round of rounds || []) {
    const slotRound = slotsByStageRound.get(round.stage_round);
    if (!slotRound) throw new Error(`Brak slotow dla kolejki etapu ${round.stage_round}.`);

    const roundFixedSlots = fixedSlots.filter(
      (entry) => Number(entry.stageRound) === Number(round.stage_round)
    );
    const candidateSlots = sortSlots([
      ...(slotRound.slots || []),
      ...roundFixedSlots.map((entry) => ({
        match_date: entry.match_date,
        match_time: normalizeTime(entry.match_time),
      })),
    ]).filter(
      (slot, index, slots) =>
        slots.findIndex((candidate) => slotKey(candidate) === slotKey(slot)) === index
    );
    const orderedMatches = [...round.matches].sort((left, right) => {
      const leftLabel = `${teamNameById.get(left.home_team_id) || left.home_team_id}|${teamNameById.get(left.away_team_id) || left.away_team_id}`;
      const rightLabel = `${teamNameById.get(right.home_team_id) || right.home_team_id}|${teamNameById.get(right.away_team_id) || right.away_team_id}`;
      return leftLabel.localeCompare(rightLabel, "pl");
    });
    const assignments = new Map();
    const usedSlotKeys = new Set();

    for (const fixedSlot of roundFixedSlots) {
      const match = orderedMatches.find(
        (candidate) =>
          pairKey(candidate.home_team_id, candidate.away_team_id) ===
          pairKey(fixedSlot.teamAId, fixedSlot.teamBId)
      );
      if (!match) {
        throw new Error(`Brak wymaganej pary dla stalego slotu w kolejce ${round.stage_round}.`);
      }
      const slot = {
        match_date: fixedSlot.match_date,
        match_time: normalizeTime(fixedSlot.match_time),
      };
      if (usedSlotKeys.has(slotKey(slot))) {
        throw new Error(`Staly slot ${slotKey(slot)} zostal wskazany wiecej niz raz.`);
      }
      if (!isAllowed(match, slot)) {
        throw new Error(`Staly slot ${slotKey(slot)} koliduje z zaleglym meczem druzyny.`);
      }
      assignments.set(match, slot);
      usedSlotKeys.add(slotKey(slot));
    }

    // Keep a pair on its current round/date/time whenever that slot is still
    // available. This is what makes the output stable across repeated runs.
    for (const match of orderedMatches) {
      if (assignments.has(match)) continue;
      const existing = existingByPair.get(pairKey(match.home_team_id, match.away_team_id));
      if (!existing || Number(existing.round) !== Number(slotRound.global_round)) continue;
      const slot = candidateSlots.find(
        (candidate) =>
          candidate.match_date === existing.match_date &&
          normalizeTime(candidate.match_time) === normalizeTime(existing.match_time)
      );
      if (!slot || usedSlotKeys.has(slotKey(slot)) || !isAllowed(match, slot)) continue;
      assignments.set(match, slot);
      usedSlotKeys.add(slotKey(slot));
    }

    // A remapped pair inherits the slot occupied by its source pair in this
    // round. For example, after Detox -> PJM, Tidy-PJM keeps the former
    // Detox-Tidy slot. Exact pairs above always win, which keeps a second run
    // idempotent after the remap has already been deployed.
    for (const match of orderedMatches) {
      if (assignments.has(match) || inverseTeamIdRemap.size === 0) continue;
      const sourceHomeTeamId =
        inverseTeamIdRemap.get(match.home_team_id) || match.home_team_id;
      const sourceAwayTeamId =
        inverseTeamIdRemap.get(match.away_team_id) || match.away_team_id;
      const source = existingByPair.get(pairKey(sourceHomeTeamId, sourceAwayTeamId));
      if (!source || Number(source.round) !== Number(slotRound.global_round)) continue;
      const slot = candidateSlots.find(
        (candidate) =>
          candidate.match_date === source.match_date &&
          normalizeTime(candidate.match_time) === normalizeTime(source.match_time)
      );
      if (!slot || usedSlotKeys.has(slotKey(slot)) || !isAllowed(match, slot)) continue;
      assignments.set(match, slot);
      usedSlotKeys.add(slotKey(slot));
    }

    const remainingMatches = orderedMatches.filter((match) => !assignments.has(match));
    const remainingSlots = candidateSlots.filter((slot) => !usedSlotKeys.has(slotKey(slot)));

    function backtrack(matchIndex) {
      if (matchIndex >= remainingMatches.length) return true;
      const match = remainingMatches[matchIndex];
      for (let slotIndex = 0; slotIndex < remainingSlots.length; slotIndex += 1) {
        const slot = remainingSlots[slotIndex];
        const key = slotKey(slot);
        if (usedSlotKeys.has(key) || !isAllowed(match, slot)) continue;
        assignments.set(match, slot);
        usedSlotKeys.add(key);
        if (backtrack(matchIndex + 1)) return true;
        assignments.delete(match);
        usedSlotKeys.delete(key);
      }
      return false;
    }

    if (!backtrack(0)) {
      throw new Error(
        `Nie udalo sie stabilnie przydzielic godzin w kolejce ${slotRound.global_round}.`
      );
    }

    const roundMatches = orderedMatches.map((match) => ({
      ...match,
      stage_round: round.stage_round,
      round: slotRound.global_round,
      match_date: assignments.get(match).match_date,
      match_time: normalizeTime(assignments.get(match).match_time),
      status: "scheduled",
    }));
    scheduledMatches.push(...roundMatches);
    scheduledRounds.push({
      stage_round: round.stage_round,
      global_round: slotRound.global_round,
      bye_team_id: round.bye_team_id,
      matches: roundMatches,
    });
  }

  return { rounds: scheduledRounds, matches: scheduledMatches };
}

function sortRowsForReuse(rows) {
  return [...rows].sort((left, right) => {
    const roundDiff = Number(left.round || 0) - Number(right.round || 0);
    if (roundDiff !== 0) return roundDiff;
    const dateDiff = String(left.match_date || "").localeCompare(String(right.match_date || ""));
    if (dateDiff !== 0) return dateDiff;
    const timeDiff = normalizeTime(left.match_time).localeCompare(normalizeTime(right.match_time));
    if (timeDiff !== 0) return timeDiff;
    return String(left.id || "").localeCompare(String(right.id || ""));
  });
}

function buildRowReusePlan({
  existingMatches,
  desiredMatches,
  startRound,
  preserveMatchIds = [],
}) {
  const preservedIdSet = new Set((preserveMatchIds || []).map(String));
  const futureRows = sortRowsForReuse(
    (existingMatches || []).filter((match) => Number(match.round) >= Number(startRound))
  );
  const lockedFutureRows = futureRows.filter(
    (match) => !EDITABLE_STATUSES.has(String(match.status || "scheduled"))
  );
  if (lockedFutureRows.length > 0) {
    throw new Error(
      `Od kolejki ${startRound} znaleziono ${lockedFutureRows.length} rozegranych lub zablokowanych meczow.`
    );
  }

  // A preserved catch-up can already have been moved before startRound by a
  // previous successful run. Resolve protected IDs against the full league
  // snapshot so a second preview verifies the applied state instead of
  // treating the catch-up as missing.
  const preservedRows = sortRowsForReuse(
    (existingMatches || []).filter((match) => preservedIdSet.has(String(match.id)))
  );
  if (preservedRows.length !== preservedIdSet.size) {
    throw new Error("Nie znaleziono wszystkich wskazanych meczow zaleglych do zachowania.");
  }
  const reusableFutureRows = futureRows.filter(
    (match) => !preservedIdSet.has(String(match.id))
  );
  const plannedRows = sortRowsForReuse(desiredMatches || []);
  const existingByPair = new Map();
  for (const row of reusableFutureRows) {
    const key = pairKey(row.home_team_id, row.away_team_id);
    if (!existingByPair.has(key)) existingByPair.set(key, []);
    existingByPair.get(key).push(row);
  }

  const updates = [];
  const inserts = [];
  const reusedMatchIds = new Set();

  for (const desired of plannedRows) {
    const key = pairKey(desired.home_team_id, desired.away_team_id);
    const reusableRows = existingByPair.get(key) || [];
    const reusableRow = reusableRows.shift();

    if (!reusableRow) {
      inserts.push({
        round: desired.round,
        home_team_id: desired.home_team_id,
        away_team_id: desired.away_team_id,
        match_date: desired.match_date,
        match_time: desired.match_time,
        status: "scheduled",
        notes: "[MLPN_SCHEDULE_HIDDEN]",
      });
      continue;
    }

    reusedMatchIds.add(reusableRow.id);
    updates.push({
      matchId: reusableRow.id,
      payload: {
        round: desired.round,
        home_team_id: desired.home_team_id,
        away_team_id: desired.away_team_id,
        match_date: desired.match_date,
        match_time: desired.match_time,
        status: "scheduled",
        home_goals: null,
        away_goals: null,
        video_url: null,
        gallery_url: null,
        referee: null,
        referee_id: null,
        mvp_player_id: null,
        notes: "[MLPN_SCHEDULE_HIDDEN]",
      },
    });
  }

  return {
    updates,
    deleteMatchIds: futureRows
      .filter((match) => !preservedIdSet.has(String(match.id)))
      .filter((match) => !reusedMatchIds.has(match.id))
      .map((match) => match.id),
    inserts,
    preservedMatches: preservedRows,
    reusedPairCount: updates.length,
    existingFutureCount: futureRows.length,
    reusableFutureCount: reusableFutureRows.length,
    desiredFutureCount: plannedRows.length,
  };
}

module.exports = {
  BYE_ID,
  EDITABLE_STATUSES,
  pairKey,
  buildConstrainedSingleRoundRobin,
  verifySingleRoundRobin,
  orientAsReturnFixtures,
  buildStageSlots,
  assignRoundsToSlots,
  remapRoundRobinStage,
  assignRoundsToStableSlots,
  buildRowReusePlan,
};
