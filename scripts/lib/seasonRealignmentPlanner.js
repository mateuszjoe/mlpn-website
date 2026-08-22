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

  const preservedRows = futureRows.filter((match) => preservedIdSet.has(String(match.id)));
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
  buildRowReusePlan,
};
