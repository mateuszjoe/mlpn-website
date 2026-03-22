const EDITABLE_STATUSES = new Set(["scheduled", "postponed", "cancelled"]);

export function roundsPerRunda(teamCount) {
  if (teamCount < 2) return 0;
  return teamCount % 2 === 0 ? teamCount - 1 : teamCount;
}

export function getMirrorRound(round, roundsInHalf) {
  if (!roundsInHalf || round < 1 || round > roundsInHalf * 2) return null;
  return round > roundsInHalf ? round - roundsInHalf : round + roundsInHalf;
}

export function formatLeagueRoundLabel(round, roundsInHalf) {
  if (!roundsInHalf) return `Kolejka ${round}`;
  return round <= roundsInHalf ? `R1 K${round}` : `R2 K${round - roundsInHalf}`;
}

export function formatLockedRounds(rounds, roundsInHalf) {
  return (rounds || [])
    .map((round) => formatLeagueRoundLabel(round, roundsInHalf))
    .join(", ");
}

function sortRoundMatches(matches) {
  return [...(matches || [])].sort((a, b) => {
    const dateCompare = String(a?.match_date || "").localeCompare(String(b?.match_date || ""));
    if (dateCompare !== 0) return dateCompare;

    const timeCompare = String(a?.match_time || "").localeCompare(String(b?.match_time || ""));
    if (timeCompare !== 0) return timeCompare;

    const homeCompare = String(a?.home_team_name || a?.home || "").localeCompare(
      String(b?.home_team_name || b?.home || ""),
      "pl"
    );
    if (homeCompare !== 0) return homeCompare;

    return String(a?.id || "").localeCompare(String(b?.id || ""));
  });
}

function shuffleArray(items, rng = Math.random) {
  const copy = [...items];
  for (let i = copy.length - 1; i > 0; i -= 1) {
    const j = Math.floor(rng() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function isLockedStatus(status) {
  return !EDITABLE_STATUSES.has(String(status || "scheduled"));
}

function buildRoundMap(matches) {
  const map = new Map();
  for (const match of matches || []) {
    if (!map.has(match.round)) {
      map.set(match.round, []);
    }
    map.get(match.round).push(match);
  }

  for (const [round, roundMatches] of map.entries()) {
    map.set(round, sortRoundMatches(roundMatches));
  }

  return map;
}

export function buildRegenerationPlan(matches, teamCount, rng = Math.random) {
  const roundsInHalf = roundsPerRunda(teamCount);
  if (roundsInHalf < 1) {
    throw new Error("Ta liga ma za mało drużyn do regeneracji terminarza.");
  }

  const roundMap = buildRoundMap(matches);
  const totalRounds = roundsInHalf * 2;
  const lockedRounds = new Set();

  for (let round = 1; round <= totalRounds; round += 1) {
    const roundMatches = roundMap.get(round) || [];
    if (roundMatches.some((match) => isLockedStatus(match.status))) {
      lockedRounds.add(round);
      const mirrorRound = getMirrorRound(round, roundsInHalf);
      if (mirrorRound) {
        lockedRounds.add(mirrorRound);
      }
    }
  }

  const editableFirstHalfRounds = [];
  for (let round = 1; round <= roundsInHalf; round += 1) {
    const mirrorRound = getMirrorRound(round, roundsInHalf);
    if (!roundMap.has(round) || !roundMap.has(mirrorRound)) continue;
    if (lockedRounds.has(round) || lockedRounds.has(mirrorRound)) continue;
    editableFirstHalfRounds.push(round);
  }

  const shuffledSourceRounds = shuffleArray(editableFirstHalfRounds, rng);
  const roundMappings = new Map();

  editableFirstHalfRounds.forEach((targetRound, idx) => {
    const sourceRound = shuffledSourceRounds[idx];
    roundMappings.set(targetRound, sourceRound);
    roundMappings.set(
      getMirrorRound(targetRound, roundsInHalf),
      getMirrorRound(sourceRound, roundsInHalf)
    );
  });

  const updates = [];
  const cleanupMatchIds = [];

  for (const [targetRound, sourceRound] of [...roundMappings.entries()].sort((a, b) => a[0] - b[0])) {
    const targetMatches = roundMap.get(targetRound) || [];
    const sourceMatches = shuffleArray(roundMap.get(sourceRound) || [], rng);

    if (targetMatches.length !== sourceMatches.length) {
      throw new Error(`Nie udało się przetasować kolejki ${targetRound}: liczba meczów nie zgadza się.`);
    }

    targetMatches.forEach((targetMatch, idx) => {
      const sourceMatch = sourceMatches[idx];
      cleanupMatchIds.push(targetMatch.id);
      updates.push({
        matchId: targetMatch.id,
        payload: {
          home_team_id: sourceMatch.home_team_id,
          away_team_id: sourceMatch.away_team_id,
          status: "scheduled",
          home_goals: null,
          away_goals: null,
          video_url: null,
          gallery_url: null,
          referee: null,
          referee_id: null,
          mvp_player_id: null,
          notes: null,
        },
      });
    });
  }

  return {
    roundsInHalf,
    totalRounds,
    lockedRounds: [...lockedRounds].sort((a, b) => a - b),
    editableFirstHalfRounds,
    editableRounds: [...roundMappings.keys()].sort((a, b) => a - b),
    cleanupMatchIds: [...new Set(cleanupMatchIds)],
    updates,
  };
}
