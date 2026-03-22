const ROUND_WORDS = new Map([
  ["pierwszej", 1],
  ["pierwsza", 1],
  ["1", 1],
  ["drugiej", 2],
  ["druga", 2],
  ["2", 2],
  ["trzeciej", 3],
  ["trzecia", 3],
  ["3", 3],
  ["czwartej", 4],
  ["czwarta", 4],
  ["4", 4],
  ["piatej", 5],
  ["piata", 5],
  ["5", 5],
  ["szostej", 6],
  ["szosta", 6],
  ["6", 6],
  ["siodmej", 7],
  ["siodma", 7],
  ["7", 7],
  ["osmej", 8],
  ["osma", 8],
  ["8", 8],
  ["dziewiatej", 9],
  ["dziewiata", 9],
  ["9", 9],
  ["dziesiatej", 10],
  ["dziesiata", 10],
  ["10", 10],
  ["jedenastej", 11],
  ["jedenasta", 11],
  ["11", 11],
  ["dwunastej", 12],
  ["dwunasta", 12],
  ["12", 12],
  ["trzynastej", 13],
  ["trzynasta", 13],
  ["13", 13],
  ["czternastej", 14],
  ["czternasta", 14],
  ["14", 14],
  ["pietnastej", 15],
  ["pietnasta", 15],
  ["15", 15],
  ["szesnastej", 16],
  ["szesnasta", 16],
  ["16", 16],
  ["siedemnastej", 17],
  ["siedemnasta", 17],
  ["17", 17],
  ["osiemnastej", 18],
  ["osiemnasta", 18],
  ["18", 18],
  ["dziewietnastej", 19],
  ["dziewietnasta", 19],
  ["19", 19],
  ["dwudziestej", 20],
  ["dwudziesta", 20],
  ["20", 20],
  ["dwudziestej pierwszej", 21],
  ["dwudziesta pierwsza", 21],
  ["21", 21],
  ["dwudziestej drugiej", 22],
  ["dwudziesta druga", 22],
  ["22", 22],
  ["dwudziestej trzeciej", 23],
  ["dwudziesta trzecia", 23],
  ["23", 23],
  ["dwudziestej czwartej", 24],
  ["dwudziesta czwarta", 24],
  ["24", 24],
  ["dwudziestej piatej", 25],
  ["dwudziesta piata", 25],
  ["25", 25],
  ["dwudziestej szostej", 26],
  ["dwudziesta szosta", 26],
  ["26", 26],
]);

function normalizeText(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s]/gu, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function detectDayKey(text) {
  const normalized = normalizeText(text);
  if (normalized.includes("sobot")) return "sat";
  if (normalized.includes("niedziel")) return "sun";
  if (normalized.includes("poniedzial")) return "mon";
  return null;
}

function detectTimePreference(text) {
  const normalized = normalizeText(text);
  if (normalized.includes("najpozniejsza godzina") || normalized.includes("najpozniej")) {
    return "latest";
  }
  if (normalized.includes("najwczesniejsza godzina") || normalized.includes("najwczesniej")) {
    return "earliest";
  }
  return null;
}

function detectRound(text) {
  const normalized = normalizeText(text);
  const numberMatch = normalized.match(/(?:w|na)\s+(\d+)\s*kolej/);
  if (numberMatch) {
    return Number.parseInt(numberMatch[1], 10);
  }

  for (const [phrase, roundNumber] of ROUND_WORDS.entries()) {
    if (normalized.includes(`${phrase} kolej`)) {
      return roundNumber;
    }
  }

  return null;
}

function prepareTeamMatchers(teams) {
  return [...(teams || [])]
    .map((team) => ({
      id: team.id,
      name: team.name,
      normalized: normalizeText(team.name),
    }))
    .sort((a, b) => b.normalized.length - a.normalized.length);
}

function findMentionedTeams(text, teams) {
  const normalized = normalizeText(text);
  const found = [];

  for (const team of prepareTeamMatchers(teams)) {
    if (!team.normalized) continue;
    if (!normalized.includes(team.normalized)) continue;
    if (found.some((item) => item.id === team.id)) continue;
    found.push(team);
  }

  return found;
}

function parseSingleGuideline(line, teams) {
  const text = String(line || "").trim();
  const normalized = normalizeText(text);
  if (!normalized) return { rule: null, warning: null };

  const teamsFound = findMentionedTeams(text, teams);
  const round = detectRound(text);
  const dayKey = detectDayKey(text);
  const timePreference = detectTimePreference(text);

  if (normalized.includes("nie moze grac z") || normalized.includes("nie moga grac z")) {
    if (teamsFound.length < 2 || !round) {
      return { rule: null, warning: `Nie udalo sie rozpoznac pary druzyn lub kolejki: "${text}"` };
    }
    return {
      rule: {
        type: "blocked_matchup",
        teamAId: teamsFound[0].id,
        teamBId: teamsFound[1].id,
        round,
        source: text,
      },
      warning: null,
    };
  }

  if (timePreference) {
    if (teamsFound.length < 1 || !dayKey) {
      return { rule: null, warning: `Nie udalo sie rozpoznac druzyny lub dnia przy preferencji godziny: "${text}"` };
    }
    return {
      rule: {
        type: "time_preference",
        teamId: teamsFound[0].id,
        dayKey,
        preference: timePreference,
        round,
        source: text,
      },
      warning: null,
    };
  }

  if (normalized.includes("tylko w")) {
    if (teamsFound.length < 1 || !dayKey) {
      return { rule: null, warning: `Nie udalo sie rozpoznac druzyny lub dnia: "${text}"` };
    }
    return {
      rule: {
        type: "day_rule",
        teamId: teamsFound[0].id,
        mode: "only",
        dayKey,
        round,
        source: text,
      },
      warning: null,
    };
  }

  if (normalized.includes("nie moze grac w") || normalized.includes("nie moga grac w")) {
    if (teamsFound.length < 1 || !dayKey) {
      return { rule: null, warning: `Nie udalo sie rozpoznac druzyny lub dnia: "${text}"` };
    }
    return {
      rule: {
        type: "day_rule",
        teamId: teamsFound[0].id,
        mode: "avoid",
        dayKey,
        round,
        source: text,
      },
      warning: null,
    };
  }

  return { rule: null, warning: `Nie rozpoznano wytycznej: "${text}"` };
}

export function parseScheduleGuidelines(notesText, teams) {
  const lines = String(notesText || "")
    .split(/\r?\n|;/)
    .map((line) => line.trim())
    .filter(Boolean);

  const rules = [];
  const warnings = [];

  for (const line of lines) {
    const { rule, warning } = parseSingleGuideline(line, teams);
    if (rule) rules.push(rule);
    if (warning) warnings.push(warning);
  }

  const blockedMatchups = rules.filter((rule) => rule.type === "blocked_matchup");
  const dayRules = rules.filter((rule) => rule.type === "day_rule");
  const timePreferences = rules.filter((rule) => rule.type === "time_preference");

  return {
    rules,
    warnings,
    blockedMatchups,
    dayRules,
    timePreferences,
    hasRules: rules.length > 0,
  };
}

export function filterScheduleGuidelinesForTeams(parsedGuidelines, teamIdsLike) {
  const teamIds = new Set(teamIdsLike || []);
  const rules = (parsedGuidelines?.rules || []).filter((rule) => {
    if (rule.type === "blocked_matchup") {
      return teamIds.has(rule.teamAId) && teamIds.has(rule.teamBId);
    }
    if (rule.type === "day_rule" || rule.type === "time_preference") {
      return teamIds.has(rule.teamId);
    }
    return false;
  });

  return {
    rules,
    warnings: parsedGuidelines?.warnings || [],
    blockedMatchups: rules.filter((rule) => rule.type === "blocked_matchup"),
    dayRules: rules.filter((rule) => rule.type === "day_rule"),
    timePreferences: rules.filter((rule) => rule.type === "time_preference"),
    hasRules: rules.length > 0,
  };
}

export function ruleToLabel(rule, teamNameById) {
  if (!rule) return "";
  if (rule.type === "blocked_matchup") {
    const teamA = teamNameById.get(rule.teamAId) || "Druzyna A";
    const teamB = teamNameById.get(rule.teamBId) || "Druzyna B";
    return `${teamA} nie moze grac z ${teamB} w kolejce ${rule.round}`;
  }

  if (rule.type === "day_rule") {
    const team = teamNameById.get(rule.teamId) || "Druzyna";
    const dayLabel = rule.dayKey === "sat" ? "sobota" : rule.dayKey === "sun" ? "niedziela" : "poniedzialek";
    const scope = rule.round ? ` w kolejce ${rule.round}` : "";
    if (rule.mode === "only") {
      return `${team}${scope}: tylko ${dayLabel}`;
    }
    return `${team}${scope}: bez ${dayLabel}`;
  }

  if (rule.type === "time_preference") {
    const team = teamNameById.get(rule.teamId) || "Druzyna";
    const dayLabel = rule.dayKey === "sat" ? "sobota" : rule.dayKey === "sun" ? "niedziela" : "poniedzialek";
    const pref = rule.preference === "latest" ? "jak najpozniej" : "jak najwczesniej";
    const scope = rule.round ? ` w kolejce ${rule.round}` : "";
    return `${team}${scope}: ${dayLabel} ${pref}`;
  }

  return rule.source || "";
}

export function buildEffectiveDayRuleMap(baseRules, parsedGuidelines, roundNumber) {
  const effective = { ...(baseRules || {}) };

  for (const rule of parsedGuidelines?.dayRules || []) {
    if (rule.round && rule.round !== roundNumber) continue;

    const mappedValue = rule.mode === "only"
      ? `only_${rule.dayKey}`
      : `no_${rule.dayKey}`;
    effective[rule.teamId] = mappedValue;
  }

  return effective;
}

export function getRoundBlockedMatchups(parsedGuidelines, roundNumber) {
  return (parsedGuidelines?.blockedMatchups || []).filter((rule) => rule.round === roundNumber);
}

export function validateRoundPairingsForGuidelines(roundPairs, roundNumber, parsedGuidelines) {
  const blocked = getRoundBlockedMatchups(parsedGuidelines, roundNumber);
  if (!blocked.length) return true;

  return !blocked.some((rule) =>
    roundPairs.some((pair) => {
      const homeId = pair.home_team_id;
      const awayId = pair.away_team_id;
      return (
        (homeId === rule.teamAId && awayId === rule.teamBId) ||
        (homeId === rule.teamBId && awayId === rule.teamAId)
      );
    })
  );
}

export function validatePlanAgainstGuidelines(plan, parsedGuidelines) {
  if (!parsedGuidelines?.blockedMatchups?.length) return true;

  const roundPairs = new Map();
  for (const update of plan?.updates || []) {
    if (!roundPairs.has(update.targetRound)) {
      roundPairs.set(update.targetRound, []);
    }
    roundPairs.get(update.targetRound).push({
      home_team_id: update.payload.home_team_id,
      away_team_id: update.payload.away_team_id,
    });
  }

  for (const [roundNumber, pairs] of roundPairs.entries()) {
    if (!validateRoundPairingsForGuidelines(pairs, roundNumber, parsedGuidelines)) {
      return false;
    }
  }

  return true;
}

export function scoreGuidelineSlotPreference(matchLike, slotLike, parsedGuidelines, roundNumber) {
  const slotDayKey = slotLike.dayKey || null;
  if (!slotDayKey) return 0;

  const timeText = String(slotLike.time || slotLike.match_time || "");
  const [hours, minutes] = timeText.split(":").map((value) => Number.parseInt(value, 10) || 0);
  const totalMinutes = hours * 60 + minutes;
  let score = 0;

  for (const rule of parsedGuidelines?.timePreferences || []) {
    if (rule.round && rule.round !== roundNumber) continue;
    if (rule.dayKey !== slotDayKey) continue;
    if (matchLike.home_team_id !== rule.teamId && matchLike.away_team_id !== rule.teamId) continue;

    if (rule.preference === "latest") {
      score += totalMinutes;
    } else if (rule.preference === "earliest") {
      score += 2000 - totalMinutes;
    }
  }

  return score;
}

export function getGuidelineRounds(parsedGuidelines) {
  return [...new Set(
    (parsedGuidelines?.rules || [])
      .map((rule) => rule.round)
      .filter(Boolean)
  )].sort((a, b) => a - b);
}
