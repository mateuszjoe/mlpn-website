import { updateTournamentMatch } from "./tournamentEngine";

const VERSION = 1;
const keyFor = tournament => `mlpn:tournament-preview:v${VERSION}:${tournament.id}`;
const clone = value => JSON.parse(JSON.stringify(value));

function dependencyOrder(tournament, drafts) {
  const definitions = new Map(tournament.matches.map(match => [match.id, match]));
  const byId = new Map(drafts.map(match => [match.id, match]));
  const finished = new Set();
  const visiting = new Set();
  const ordered = [];
  function visit(id) {
    if (finished.has(id)) return;
    if (visiting.has(id)) throw new Error("Cyclic tournament bracket");
    const match = definitions.get(id);
    if (!match) throw new Error("Unknown tournament match");
    visiting.add(id);
    for (const source of [match.homeSource, match.awaySource]) {
      if (source?.matchId) visit(source.matchId);
      if (source?.type === "group") tournament.matches.filter(item => item.stage === "group" && item.groupId === source.groupId).forEach(item => visit(item.id));
    }
    visiting.delete(id);
    finished.add(id);
    ordered.push(byId.get(id));
  }
  drafts.forEach(match => visit(match.id));
  return ordered;
}

export function loadTournamentDraft(tournament) {
  if (!tournament.isDemo && !tournament.isImported && !tournament.isLocalCopy) return clone(tournament);
  try {
    const saved = JSON.parse(localStorage.getItem(keyFor(tournament)) || "null");
    if (!saved || saved.version !== VERSION || saved.tournamentId !== tournament.id || !Array.isArray(saved.matches) ||
      (!tournament.isDemo && !saved.isLocalCopy)) return clone(tournament);
    const known = new Set(tournament.matches.map(match => match.id));
    if (saved.matches.length !== known.size || new Set(saved.matches.map(match => match.id)).size !== known.size || saved.matches.some(match => !known.has(match.id))) return clone(tournament);
    // Store editable values only. Never restore arbitrary team data, source
    // references or executable-looking metadata from an untrusted draft.
    let restored = { ...clone(tournament), ...(saved.isLocalCopy ? { isLocalCopy: true } : {}) };
    for (const match of dependencyOrder(tournament, saved.matches)) {
      const { status, homeScore, awayScore, homePenalties, awayPenalties, events, kickoff, court } = match;
      restored = updateTournamentMatch(restored, match.id, { status, homeScore, awayScore, homePenalties, awayPenalties, events, kickoff, court });
    }
    return restored;
  } catch {
    return clone(tournament);
  }
}

export function saveTournamentDraft(tournament) {
  if (!tournament.isDemo && !tournament.isLocalCopy) return false;
  try {
    localStorage.setItem(keyFor(tournament), JSON.stringify({ version: VERSION, tournamentId: tournament.id, isLocalCopy: !!tournament.isLocalCopy,
      matches: tournament.matches.map(({ id, status, homeScore, awayScore, homePenalties, awayPenalties, events, kickoff, court }) =>
        ({ id, status, homeScore, awayScore, homePenalties, awayPenalties, events, kickoff, court })) }));
    return true;
  } catch { return false; }
}

export function resetTournamentDraft(tournament) {
  if (tournament.isDemo || tournament.isImported || tournament.isLocalCopy) {
    try { localStorage.removeItem(keyFor(tournament)); } catch { /* The in-memory reset still works. */ }
  }
  return clone(tournament);
}
