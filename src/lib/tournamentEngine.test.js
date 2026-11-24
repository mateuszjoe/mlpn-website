import { tournamentCatalog, demoTournamentSlug } from "../data/tournamentDemo";
import { getGroupStandings, resolveTournamentMatches, getTournamentStats, updateTournamentMatch, getMatchWinner } from "./tournamentEngine";
import { loadTournamentDraft, saveTournamentDraft, resetTournamentDraft } from "./tournamentStorage";
import archives from "../data/tournamentArchives.json";

const copy = value => JSON.parse(JSON.stringify(value));
const demo = () => copy(tournamentCatalog.find(tournament => tournament.slug === demoTournamentSlug));
const player = team => ({ id: `${team}-player`, name: `Zawodnik ${team}` });
const team = id => ({ id, name: id, players: [player(id)] });
const match = (id, homeTeamId, awayTeamId, homeScore, awayScore, extra = {}) => ({
  id, homeTeamId, awayTeamId, homeScore, awayScore, stage: "group", groupId: "A", status: "finished",
  homePenalties: null, awayPenalties: null, kickoff: "2025-12-14T09:00:00+01:00", court: "1", events: [], ...extra,
});
const groupFixture = matches => ({ id: "small-demo", isDemo: true, rules: { pointsWin: 3, pointsDraw: 1, advancing: 2 },
  groups: [{ id: "A", teamIds: ["A", "B", "C", "D"] }], teams: ["A", "B", "C", "D"].map(team), matches });

describe("tournament fixtures and group tables", () => {
  test("does not fabricate entries, rules or fixtures for the announced Halinów tournament", () => {
    const tournament = tournamentCatalog.find(item => item.slug === "halinow-2026");
    expect(tournament.date).toBe("2026-12-20");
    expect(tournament.location).toBe("Halinów");
    expect(tournament.isDemo).toBe(false);
    expect(tournament.groups).toEqual([]);
    expect(tournament.teams).toEqual([]);
    expect(tournament.matches).toEqual([]);
    expect(tournament.rules).toEqual({});
  });

  test("the demo has all single round-robin pairings and internally consistent player events", () => {
    const tournament = demo();
    expect(tournament.teams).toHaveLength(16);
    expect(tournament.groups).toHaveLength(4);
    expect(tournament.matches.filter(item => item.stage === "group")).toHaveLength(24);
    expect(tournament.matches).toHaveLength(32);
    for (const group of tournament.groups) {
      const groupMatches = tournament.matches.filter(item => item.groupId === group.id);
      expect(new Set(groupMatches.map(item => [item.homeTeamId, item.awayTeamId].sort().join("|"))).size).toBe(6);
      expect(getGroupStandings(tournament, group.id).map(row => row.played)).toEqual([3, 3, 3, 3]);
    }
    for (const item of tournament.matches.filter(item => ["finished", "live"].includes(item.status))) {
      expect(item.events.filter(event => event.type === "goal" && event.teamId === item.homeTeamId)).toHaveLength(item.homeScore);
      expect(item.events.filter(event => event.type === "goal" && event.teamId === item.awayTeamId)).toHaveLength(item.awayScore);
      expect(() => updateTournamentMatch(tournament, item.id, { events: item.events })).not.toThrow();
    }
  });

  test("direct games decide equal points before overall goal difference", () => {
    const tournament = groupFixture([
      match("ab", "A", "B", 1, 0), match("ac", "A", "C", 1, 0), match("ad", "A", "D", 0, 1),
      match("bc", "B", "C", 10, 0), match("bd", "B", "D", 10, 0), match("cd", "C", "D", 0, 0),
    ]);
    const table = getGroupStandings(tournament, "A");
    expect(table.map(row => row.teamId)).toEqual(["A", "B", "D", "C"]);
    expect(table[1].goalDifference).toBeGreaterThan(table[0].goalDifference);
  });

  test("all clubs tied on points share a transitive mini-table", () => {
    const tournament = groupFixture([
      match("ab", "A", "B", 4, 0), match("bc", "B", "C", 2, 0), match("ca", "C", "A", 1, 0),
      match("ad", "A", "D", 1, 0), match("bd", "B", "D", 20, 0), match("cd", "C", "D", 30, 0),
    ]);
    expect(getGroupStandings(tournament, "A").map(row => row.teamId)).toEqual(["A", "C", "B", "D"]);
    tournament.matches.reverse();
    tournament.groups[0].teamIds.reverse();
    expect(getGroupStandings(tournament, "A").map(row => row.teamId)).toEqual(["A", "C", "B", "D"]);
  });

  test("respects an archive's overall goal difference before head-to-head rule", () => {
    const tournament = groupFixture([
      match("ab", "A", "B", 1, 0), match("ac", "A", "C", 1, 0), match("ad", "A", "D", 0, 1),
      match("bc", "B", "C", 10, 0), match("bd", "B", "D", 10, 0), match("cd", "C", "D", 0, 0),
    ]);
    tournament.rules.tiebreakers = [{ id: "points" }, { id: "goalDifference" }, { id: "headToHead" }, { id: "goalsScored" }];
    expect(getGroupStandings(tournament, "A").map(row => row.teamId)).toEqual(["B", "A", "D", "C"]);
  });

  test("recursively reapplies head-to-head to a smaller tied subset only when configured", () => {
    const tournament = groupFixture([
      match("ab", "A", "B", 2, 1), match("bc", "B", "C", 1, 0), match("ca", "C", "A", 1, 0),
      match("ad", "A", "D", 1, 0), match("bd", "B", "D", 10, 0), match("cd", "C", "D", 1, 0),
    ]);
    expect(getGroupStandings(tournament, "A").map(row => row.teamId)).toEqual(["B", "A", "C", "D"]);
    tournament.rules.tiebreakers = [{ id: "points" }, { id: "headToHead", applyRecursively: true }, { id: "goalDifference" }, { id: "goalsScored" }];
    expect(getGroupStandings(tournament, "A").map(row => row.teamId)).toEqual(["A", "B", "C", "D"]);
  });

  test("scheduled, malformed or outside-group games do not produce standings; live scores are marked", () => {
    const tournament = groupFixture([
      match("ab", "A", "B", 3, 0, { status: "live" }),
      match("cd", "C", "D", 9, 0, { status: "scheduled" }),
      match("ac", "A", "C", null, 0), match("outside", "A", "other", 100, 0),
    ]);
    expect(getGroupStandings(tournament, "A")[0]).toMatchObject({ teamId: "A", played: 1, points: 3, live: true });
    expect(getGroupStandings(tournament, "A", { includeLive: false }).every(row => row.played === 0)).toBe(true);
    expect(getGroupStandings(tournament, "missing")).toEqual([]);
  });
});

describe("qualification and knockout progression", () => {
  test("a live group is not seeded before it has a final result", () => {
    const tournament = demo();
    const groupMatch = tournament.matches.find(item => item.groupId === "A");
    groupMatch.status = "live";
    const qf = resolveTournamentMatches(tournament).find(item => item.id === "demo-qf1");
    expect(qf.homeTeamId).toBeNull();
    expect(qf.awayTeamId).toBe("demo-detox");
  });

  test("a missing group pairing does not silently award qualification", () => {
    const tournament = demo();
    tournament.matches = tournament.matches.filter(item => item.id !== "demo-A-1");
    expect(resolveTournamentMatches(tournament).find(item => item.id === "demo-qf1").homeTeamId).toBeNull();
  });

  test("alphabetical display order cannot resolve a sporting tie for advancement", () => {
    const tournament = demo();
    tournament.matches = tournament.matches.map(item => item.groupId === "A" ? { ...item, homeScore: 0, awayScore: 0, events: [] } : item);
    expect(getGroupStandings(tournament, "A").every(row => row.tied)).toBe(true);
    expect(resolveTournamentMatches(tournament).find(item => item.id === "demo-qf1").homeTeamId).toBeNull();
  });

  test("penalty winners and loser references resolve in any input order", () => {
    const tournament = demo();
    tournament.matches.reverse();
    const resolved = resolveTournamentMatches(tournament);
    const shootout = resolved.find(item => item.id === "demo-qf2");
    expect(getMatchWinner(shootout)).toBe("demo-faludza");
    expect(resolved.find(item => item.id === "demo-sf1")).toMatchObject({ homeTeamId: "demo-almar", awayTeamId: "demo-faludza" });
    expect(resolved.find(item => item.id === "demo-final").homeTeamId).toBeNull();
    expect(getMatchWinner({ ...shootout, status: "live" })).toBeNull();
    expect(getMatchWinner({ ...shootout, homePenalties: 2 })).toBeNull();
  });

  test("cyclic or missing upstream references stay unresolved", () => {
    const tournament = groupFixture([
      match("a", "A", "B", 1, 0, { stage: "final", homeSource: { type: "winner", matchId: "b" } }),
      match("b", "C", "D", 1, 0, { stage: "semifinal", homeSource: { type: "winner", matchId: "a" }, awaySource: { type: "winner", matchId: "missing" } }),
    ]);
    expect(resolveTournamentMatches(tournament).every(item => item.homeTeamId == null)).toBe(true);
  });

  test("changing a qualified team clears downstream results and their player events", () => {
    let tournament = demo();
    tournament = updateTournamentMatch(tournament, "demo-sf1", { status: "finished", homeScore: 1, awayScore: 0 });
    expect(resolveTournamentMatches(tournament).find(item => item.id === "demo-final").homeTeamId).toBe("demo-almar");
    const before = JSON.stringify(tournament);
    const updated = updateTournamentMatch(tournament, "demo-A-1", { homeScore: 0, awayScore: 4, events: [] });
    const qf = updated.matches.find(item => item.id === "demo-qf1");
    expect(qf).toMatchObject({ homeTeamId: "demo-rebelianci", status: "scheduled", homeScore: null, awayScore: null, events: [] });
    expect(updated.matches.find(item => item.id === "demo-sf1")).toMatchObject({ status: "scheduled", homeTeamId: null, homeScore: null, events: [] });
    expect(updated.matches.find(item => item.id === "demo-final").homeTeamId).toBeNull();
    expect(JSON.stringify(tournament)).toBe(before);
  });

  test("changing a score without changing its winner preserves valid later results", () => {
    let tournament = demo();
    tournament = updateTournamentMatch(tournament, "demo-sf1", { status: "finished", homeScore: 1, awayScore: 0 });
    const updated = updateTournamentMatch(tournament, "demo-qf1", { homeScore: 4 });
    expect(updated.matches.find(item => item.id === "demo-sf1")).toMatchObject({ status: "finished", homeScore: 1 });
  });
});

describe("results and individual statistics", () => {
  test.each([-1, 0.5, "abc", Infinity, true])("rejects invalid score %s without altering data", score => {
    const tournament = demo();
    const before = JSON.stringify(tournament);
    expect(() => updateTournamentMatch(tournament, "demo-qf3", { homeScore: score })).toThrow(/liczbą/);
    expect(JSON.stringify(tournament)).toBe(before);
  });

  test("does not finish an unresolved fixture or accept an undecided knockout tie", () => {
    const tournament = demo();
    expect(() => updateTournamentMatch(tournament, "demo-final", { status: "finished", homeScore: 1, awayScore: 0 })).toThrow(/uczestnicy/);
    expect(() => updateTournamentMatch(tournament, "demo-qf3", { status: "finished", homeScore: 1, awayScore: 1 })).toThrow(/karnych/);
    expect(() => updateTournamentMatch(tournament, "demo-qf3", { status: "finished", homeScore: 1, awayScore: 1, homePenalties: 2, awayPenalties: 2 })).toThrow(/karnych/);
    expect(() => updateTournamentMatch(tournament, "demo-A-1", { homePenalties: 2, awayPenalties: 1 })).toThrow(/Karne/);
  });

  test("rejects impossible event totals and players belonging to another team", () => {
    const tournament = demo();
    const current = tournament.matches.find(item => item.id === "demo-qf3");
    expect(() => updateTournamentMatch(tournament, current.id, { homeScore: 0 })).toThrow(/strzelców/);
    expect(() => updateTournamentMatch(tournament, current.id, { events: [{ id: "bad", type: "goal", teamId: current.homeTeamId, playerId: "other" }] })).toThrow(/składu/);
    expect(() => updateTournamentMatch(tournament, current.id, { events: [current.events[0], current.events[0]] })).toThrow(/identyfikator/);
    expect(() => updateTournamentMatch(tournament, current.id, { homeTeamId: "other" })).toThrow(/pola/);
  });

  test("unassigned goals are explicit and penalties never become scorer statistics", () => {
    const tournament = demo();
    const stats = getTournamentStats(tournament);
    expect(stats.played).toBe(26);
    expect(stats.live).toBe(1);
    expect(stats.goals).toBe(64);
    expect(stats.recordedGoals).toBe(64);
    expect(stats.unassignedGoals).toBe(0);
    expect(stats.scorers.reduce((sum, entry) => sum + entry.goals, 0)).toBe(64);
    const updated = updateTournamentMatch(tournament, "demo-qf3", { homeScore: 3 });
    expect(getTournamentStats(updated)).toMatchObject({ goals: 66, recordedGoals: 64, unassignedGoals: 2 });
    expect(getTournamentStats(updated).scorers).toEqual(stats.scorers);
  });

  test("resetting a match to scheduled removes result and events from totals", () => {
    const updated = updateTournamentMatch(demo(), "demo-qf3", { status: "scheduled" });
    expect(updated.matches.find(item => item.id === "demo-qf3")).toMatchObject({ homeScore: null, awayScore: null, events: [] });
    expect(getTournamentStats(updated)).toMatchObject({ goals: 63, live: 0 });
  });

  test("historical shootout winner is kept without invented penalties, but cleared when correcting the result", () => {
    const tournament = groupFixture([match("final", "A", "B", 1, 1, { stage: "final", reportedWinnerId: "B", outcomeNote: "Archiwum" })]);
    expect(getMatchWinner(tournament.matches[0])).toBe("B");
    expect(updateTournamentMatch(tournament, "final", { court: "Hala" }).matches[0].reportedWinnerId).toBe("B");
    expect(() => updateTournamentMatch(tournament, "final", { homeScore: 2, awayScore: 2 })).toThrow(/karnych/);
    const changed = updateTournamentMatch(tournament, "final", { homeScore: 2 });
    expect(changed.matches[0].reportedWinnerId).toBeNull();
    expect(getMatchWinner(changed.matches[0])).toBe("A");
  });
});

describe("local preview drafts", () => {
  beforeEach(() => localStorage.clear());
  afterEach(() => jest.restoreAllMocks());

  test("restores validated scores after reload and reset restores the original fixture", () => {
    const base = demo();
    const changed = updateTournamentMatch(base, "demo-qf3", { homeScore: 3, status: "finished" });
    expect(saveTournamentDraft(changed)).toBe(true);
    expect(loadTournamentDraft(base).matches.find(item => item.id === "demo-qf3")).toMatchObject({ homeScore: 3, status: "finished" });
    expect(resetTournamentDraft(base)).toEqual(base);
    expect(loadTournamentDraft(base)).toEqual(base);
  });

  test("does not persist the real upcoming tournament", () => {
    const upcoming = tournamentCatalog.find(item => !item.isDemo);
    expect(saveTournamentDraft(upcoming)).toBe(false);
    expect(loadTournamentDraft(upcoming)).toEqual(upcoming);
    expect(localStorage.length).toBe(0);
  });

  test("an imported archive can have an explicit local copy without modifying its source", () => {
    const archive = { ...demo(), isDemo: false, isImported: true };
    expect(saveTournamentDraft(archive)).toBe(false);
    const changed = updateTournamentMatch({ ...archive, isLocalCopy: true }, "demo-qf3", { homeScore: 3 });
    expect(saveTournamentDraft(changed)).toBe(true);
    const loaded = loadTournamentDraft(archive);
    expect(loaded.isLocalCopy).toBe(true);
    expect(loaded.matches.find(item => item.id === "demo-qf3").homeScore).toBe(3);
    expect(archive.matches.find(item => item.id === "demo-qf3").homeScore).toBe(1);
    expect(resetTournamentDraft(archive)).toEqual(archive);
    expect(loadTournamentDraft(archive)).toEqual(archive);
  });

  test.each(archives.map(archive => [archive.slug, archive]))("restores every result and event from an unchanged complete archive copy: %s", (slug, archive) => {
    const local = { ...copy(archive), isLocalCopy: true };
    expect(saveTournamentDraft(local)).toBe(true);
    const restored = loadTournamentDraft(archive);
    expect(restored.isLocalCopy).toBe(true);
    const sportingValues = tournament => tournament.matches.map(({ id, homeTeamId, awayTeamId, homeScore, awayScore, homePenalties, awayPenalties, status, events, reportedWinnerId }) =>
      ({ id, homeTeamId, awayTeamId, homeScore, awayScore, homePenalties, awayPenalties, status, events, reportedWinnerId }));
    expect(sportingValues(restored)).toEqual(sportingValues(local));
  });

  test.each(archives.map(archive => [archive.slug, archive]))("restores changed archive knockout winner and downstream invalidation: %s", (slug, archive) => {
    const fixture = archive.matches.find(item => item.stage !== "group" && item.status === "finished" &&
      archive.matches.some(next => next.homeSource?.matchId === item.id || next.awaySource?.matchId === item.id));
    const oldWinner = getMatchWinner(fixture);
    const homeWins = oldWinner !== fixture.homeTeamId;
    const changed = updateTournamentMatch({ ...copy(archive), isLocalCopy: true }, fixture.id,
      { homeScore: homeWins ? 2 : 0, awayScore: homeWins ? 0 : 2, homePenalties: null, awayPenalties: null, events: [] });
    expect(getMatchWinner(changed.matches.find(item => item.id === fixture.id))).not.toBe(oldWinner);
    const downstream = changed.matches.find(item => item.homeSource?.matchId === fixture.id || item.awaySource?.matchId === fixture.id);
    expect(downstream.status).toBe("scheduled");
    expect(downstream.events).toEqual([]);
    expect(saveTournamentDraft(changed)).toBe(true);
    const restored = loadTournamentDraft(archive);
    expect(restored.isLocalCopy).toBe(true);
    expect(restored.matches).toEqual(changed.matches);
  });

  test("replays saved corrections before downstream scores even when imported fixtures are reversed", () => {
    const base = demo();
    base.matches.reverse();
    let changed = updateTournamentMatch(base, "demo-A-1", { homeScore: 0, awayScore: 4, events: [] });
    changed = updateTournamentMatch(changed, "demo-qf1", { status: "finished", homeScore: 5, awayScore: 0 });
    changed = updateTournamentMatch(changed, "demo-qf2", { status: "finished", homeScore: 1, awayScore: 0 });
    changed = updateTournamentMatch(changed, "demo-sf1", { status: "finished", homeScore: 2, awayScore: 0 });
    expect(saveTournamentDraft(changed)).toBe(true);
    const restored = loadTournamentDraft(base);
    expect(restored.matches.find(item => item.id === "demo-qf1")).toMatchObject({ homeTeamId: "demo-rebelianci", homeScore: 5, status: "finished" });
    expect(restored.matches.find(item => item.id === "demo-sf1")).toMatchObject({ homeTeamId: "demo-rebelianci", homeScore: 2, status: "finished" });
    expect(restored.matches.find(item => item.id === "demo-final").homeTeamId).toBe("demo-rebelianci");
  });

  test("corrupted, unknown and inconsistent saved data falls back safely", () => {
    const base = demo();
    const key = `mlpn:tournament-preview:v1:${base.id}`;
    localStorage.setItem(key, "not-json");
    expect(loadTournamentDraft(base)).toEqual(base);
    saveTournamentDraft(base);
    const saved = JSON.parse(localStorage.getItem(key));
    saved.matches[0].homeScore = -10;
    localStorage.setItem(key, JSON.stringify(saved));
    expect(loadTournamentDraft(base)).toEqual(base);
    saved.matches[0].id = "unknown";
    localStorage.setItem(key, JSON.stringify(saved));
    expect(loadTournamentDraft(base)).toEqual(base);
  });

  test("storage-denied mode still provides an editable in-memory copy", () => {
    const base = demo();
    jest.spyOn(Storage.prototype, "getItem").mockImplementation(() => { throw new Error("Denied"); });
    jest.spyOn(Storage.prototype, "setItem").mockImplementation(() => { throw new Error("Denied"); });
    jest.spyOn(Storage.prototype, "removeItem").mockImplementation(() => { throw new Error("Denied"); });
    expect(loadTournamentDraft(base)).toEqual(base);
    expect(saveTournamentDraft(base)).toBe(false);
    expect(resetTournamentDraft(base)).toEqual(base);
  });
});
