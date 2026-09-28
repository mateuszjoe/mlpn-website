import React from "react";
import { createRoot } from "react-dom/client";
import { act } from "react-dom/test-utils";
import AdminActiveMatch from "./AdminActiveMatch";
import { supabase } from "../../lib/supabase";

jest.mock("../../contexts/AuthContext", () => ({
  useAuth: () => ({ user: { id: "duty" }, isAdmin: false }),
}));
jest.mock("../../lib/supabase", () => ({ supabase: { from: jest.fn(), rpc: jest.fn() } }));
jest.mock("../../lib/matchDataEvents", () => ({ notifyMatchDataUpdated: jest.fn() }));

let host, root, db, failSave, releaseSave;
const player = (id, name) => ({ id, display_name: name, position: "POM" });

function query(table) {
  const filters = [];
  let single = false;
  let update;
  const builder = {
    select: () => builder,
    eq: (field, value) => { filters.push((row) => row[field] === value); return builder; },
    in: (field, values) => { filters.push((row) => values.includes(row[field])); return builder; },
    is: (field, value) => { filters.push((row) => row[field] === value); return builder; },
    order: () => builder,
    range: () => builder,
    single: () => { single = true; return builder; },
    update: (value) => { update = value; return builder; },
    then: (resolve, reject) => {
      const rows = (table === "matches" ? db.v_matches : db[table] || []).filter((row) => filters.every((filter) => filter(row)));
      if (update) rows.forEach((row) => Object.assign(row, update));
      return Promise.resolve({ data: single ? rows[0] : rows, error: null }).then(resolve, reject);
    },
  };
  return builder;
}

async function mount() {
  await act(async () => { root.render(<AdminActiveMatch darkMode={false} />); });
}

async function click(text, index = 0) {
  const button = [...host.querySelectorAll("button")].filter((item) => item.textContent.trim() === text)[index];
  expect(button).toBeDefined();
  expect(button.disabled).toBe(false);
  await act(async () => { button.click(); });
}

function checkbox(name) {
  return [...host.querySelectorAll("label")].find((label) => label.textContent.includes(name))?.querySelector("input[type=checkbox]");
}

beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  host = document.createElement("div");
  document.body.appendChild(host);
  root = createRoot(host);
  failSave = false;
  releaseSave = null;
  db = {
    seasons: [{ id: "season", name: "Sezon 2026", year: 2026, status: "active" }],
    v_matches: [{ id: "match", season_id: "season", league_id: "league", status: "scheduled", home_team_id: "home", away_team_id: "away", home_team_name: "Gospodarze", away_team_name: "Goście", home_goals: null, away_goals: null }],
    active_match_assignments: [],
    match_lineups: [],
    team_players: [
      { player_id: "p1", team_id: "home", season_id: "season", league_id: "league", left_date: null, players: player("p1", "Jan Kowalski") },
      { player_id: "p2", team_id: "home", season_id: "season", league_id: "league", left_date: null, players: player("p2", "Adam Nowak") },
      { player_id: "p3", team_id: "away", season_id: "season", league_id: "league", left_date: null, players: player("p3", "Piotr Wiśniewski") },
    ],
    match_events: [],
  };
  supabase.from.mockReset().mockImplementation(query);
  supabase.rpc.mockReset().mockImplementation(async (name, args) => {
    if (name === "list_active_match_duty_users") return { data: [{ id: "duty", label: "Dyżurny", role: "editor" }] };
    if (name === "ensure_active_match_assignment") {
      if (!db.active_match_assignments.length) db.active_match_assignments.push({ match_id: "match", assigned_to: "duty" });
      return { error: null };
    }
    if (name === "set_match_attendance") {
      if (releaseSave) await releaseSave;
      if (failSave) return { error: { message: "Brak połączenia" } };
      db.match_lineups = db.match_lineups.filter((row) => row.player_id !== args.p_player_id);
      const row = { id: args.p_player_id, match_id: args.p_match_id, team_id: args.p_team_id, player_id: args.p_player_id,
        players: db.team_players.find((item) => item.player_id === args.p_player_id).players };
      if (args.p_present) db.match_lineups.push(row);
      return { data: args.p_present ? [row] : [], error: null };
    }
    return { error: null };
  });
  jest.spyOn(window, "confirm").mockReturnValue(true);
});

afterEach(async () => {
  await act(async () => { root.unmount(); });
  host.remove();
  jest.restoreAllMocks();
});

test("opening and saving an upcoming attendance list does not start the match", async () => {
  await mount();
  await click("Lista obecności");
  await act(async () => { checkbox("Jan Kowalski").click(); });
  expect(checkbox("Jan Kowalski").checked).toBe(true);
  expect(db.v_matches[0].status).toBe("scheduled");
  expect(db.v_matches[0].home_goals).toBeNull();
  expect(supabase.from).not.toHaveBeenCalledWith("matches");
  expect(host.textContent).not.toContain("Dodaj zdarzenie");
});

test("close, reopen and remount retain attendance for both teams", async () => {
  await mount();
  await click("Lista obecności");
  await act(async () => { checkbox("Jan Kowalski").click(); });
  await click("Zamknij listę");
  await click("Lista obecności", 1);
  await act(async () => { checkbox("Piotr Wiśniewski").click(); });
  await act(async () => { root.unmount(); });
  root = createRoot(host);
  await mount();
  await click("Lista obecności");
  expect(checkbox("Jan Kowalski").checked).toBe(true);
  expect(checkbox("Adam Nowak").checked).toBe(false);
  await click("Lista obecności", 1);
  expect(checkbox("Piotr Wiśniewski").checked).toBe(true);
});

test("a failed save retains the previous checkbox and permits retry", async () => {
  await mount();
  await click("Lista obecności");
  failSave = true;
  await act(async () => { checkbox("Jan Kowalski").click(); });
  expect(checkbox("Jan Kowalski").checked).toBe(false);
  expect(host.textContent).toContain("Nie zapisano zmiany obecności");
  failSave = false;
  await act(async () => { checkbox("Jan Kowalski").click(); });
  expect(checkbox("Jan Kowalski").checked).toBe(true);
  failSave = true;
  await act(async () => { checkbox("Jan Kowalski").click(); });
  expect(checkbox("Jan Kowalski").checked).toBe(true);
});

test("pending save disables closing and status switching until confirmed", async () => {
  await mount();
  await click("Lista obecności");
  let finish;
  releaseSave = new Promise((resolve) => { finish = resolve; });
  await act(async () => { checkbox("Jan Kowalski").click(); });
  expect(checkbox("Adam Nowak").disabled).toBe(true);
  const close = [...host.querySelectorAll("button")].find((button) => button.textContent === "Zamknij listę");
  expect(close.disabled).toBe(true);
  expect(host.querySelector("fieldset").disabled).toBe(true);
  expect(host.textContent).toContain("Zapisywanie…");
  await act(async () => { finish(); });
  expect(checkbox("Jan Kowalski").checked).toBe(true);
  expect(close.disabled).toBe(false);
});

test("presence can be added and removed after finishing without altering the final score", async () => {
  db.v_matches[0] = { ...db.v_matches[0], status: "completed", home_goals: 4, away_goals: 2 };
  db.active_match_assignments.push({ match_id: "match", assigned_to: "duty" });
  await mount();
  await click("Zakończone");
  expect(host.textContent).toContain("4 - 2");
  await click("Lista obecności");
  await act(async () => { checkbox("Jan Kowalski").click(); });
  await act(async () => { checkbox("Jan Kowalski").click(); });
  expect(checkbox("Jan Kowalski").checked).toBe(false);
  expect(db.v_matches[0]).toMatchObject({ status: "completed", home_goals: 4, away_goals: 2 });
  expect(host.textContent).not.toContain("Dodaj zdarzenie");
  expect(host.textContent).not.toContain("Zakończ mecz");
});

test("starting and finishing keep attendance and allow a late correction", async () => {
  await mount();
  await click("Lista obecności");
  await act(async () => { checkbox("Jan Kowalski").click(); });
  await click("Rozpocznij mecz");
  expect(db.v_matches[0].status).toBe("live");
  await click("Lista obecności");
  expect(checkbox("Jan Kowalski").checked).toBe(true);
  await act(async () => { checkbox("Adam Nowak").click(); });
  await click("Zakończ mecz");
  expect(db.v_matches[0].status).toBe("completed");
  await click("Lista obecności");
  expect(checkbox("Jan Kowalski").checked).toBe(true);
  expect(checkbox("Adam Nowak").checked).toBe(true);
  await act(async () => { checkbox("Jan Kowalski").click(); });
  expect(db.match_lineups.map((row) => row.player_id)).toEqual(["p2"]);
});

test("a different duty cannot open or change the assigned match", async () => {
  db.active_match_assignments.push({ match_id: "match", assigned_to: "someone-else" });
  await mount();
  const buttons = [...host.querySelectorAll("button")].filter((button) => button.textContent.trim() === "Lista obecności");
  expect(buttons).toHaveLength(2);
  expect(buttons.every((button) => button.disabled)).toBe(true);
  expect(host.textContent).not.toContain("Rozpocznij mecz");
});

test("reopening fetches the latest saved attendance from another session", async () => {
  await mount();
  await click("Lista obecności");
  await click("Zamknij listę");
  db.match_lineups.push({ match_id: "match", team_id: "home", player_id: "p2", players: player("p2", "Adam Nowak") });
  await click("Lista obecności");
  expect(checkbox("Adam Nowak").checked).toBe(true);
});
