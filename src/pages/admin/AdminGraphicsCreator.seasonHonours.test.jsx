import React from "react";
import { createRoot } from "react-dom/client";
import { act, Simulate } from "react-dom/test-utils";
import AdminGraphicsCreator from "./AdminGraphicsCreator";
import { supabase } from "../../lib/supabase";
import { season2026Honours } from "../../data/season2026Honours";
import { drawGraphic } from "./graphicsRenderer";

jest.mock("../../lib/supabase", () => ({ supabase: { from: jest.fn() } }));
jest.mock("./graphicsRenderer", () => ({
  ...jest.requireActual("./graphicsRenderer"),
  drawGraphic: jest.fn(),
}));

const DRAFT_KEY = "mlpn_admin_graphics_creator_form_draft_v1";
const matches = Object.entries(season2026Honours).flatMap(([league, honours]) => {
  const names = [...new Set([honours.champion, ...honours.bestEight.map((player) => player.teamRouteName || player.team)])];
  return names.map((name, index) => ({
    id: `${league}-${index}`,
    season_year: 2026,
    league_code: league,
    round: 19,
    home_team_id: `${league}-${name}`,
    home_team_name: name,
    home_team_logo: `/test-logos/${encodeURIComponent(name)}.png`,
    away_team_id: `${league}-opponent`,
    away_team_name: "Przeciwnik",
    status: "finished",
  }));
});

let host;
let root;
let originalImage;
let downloadedNames;

beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  jest.clearAllMocks();
  localStorage.clear();
  originalImage = global.Image;
  global.Image = class {
    set src(value) { this.url = value; Promise.resolve().then(() => this.onload?.()); }
  };
  jest.spyOn(HTMLCanvasElement.prototype, "getContext").mockReturnValue({ setTransform: jest.fn() });
  jest.spyOn(HTMLCanvasElement.prototype, "toBlob").mockImplementation((callback) => callback(new Blob(["png"], { type: "image/png" })));
  URL.createObjectURL = jest.fn(() => "blob:test-graphic");
  URL.revokeObjectURL = jest.fn();
  downloadedNames = [];
  jest.spyOn(HTMLAnchorElement.prototype, "click").mockImplementation(function () { downloadedNames.push(this.download); });

  supabase.from.mockImplementation((table) => {
    const filters = {};
    const query = {};
    ["select", "order", "or", "limit", "not", "is"].forEach((method) => { query[method] = () => query; });
    query.eq = (key, value) => { filters[key] = value; return query; };
    query.then = (resolve, reject) => {
      const data = table === "seasons"
        ? [{ id: "season-2026", year: 2026, is_current: true }, { id: "season-2025", year: 2025 }]
        : table === "v_matches" && filters.season_year === 2026 ? matches : [];
      return Promise.resolve({ data, error: null }).then(resolve, reject);
    };
    return query;
  });
  host = document.createElement("div");
  document.body.appendChild(host);
  root = createRoot(host);
});

afterEach(async () => {
  await act(async () => root.unmount());
  host.remove();
  global.Image = originalImage;
  jest.restoreAllMocks();
});

async function render(draft = {}) {
  localStorage.setItem(DRAFT_KEY, JSON.stringify({ category: "season-best-eight", seasonYear: "2026", round: "19", ...draft }));
  await act(async () => root.render(<AdminGraphicsCreator darkMode={false} />));
}
function button(label) { return [...host.querySelectorAll("button")].find((item) => item.textContent.trim() === label); }
async function category(label) {
  const target = [...host.querySelectorAll("button")].find((item) => item.textContent.startsWith(label));
  expect(target).toBeDefined();
  await act(async () => Simulate.click(target));
}
async function change(name, value) {
  const target = host.querySelector(`select[name="${name}"]`);
  expect(target).not.toBeNull();
  await act(async () => Simulate.change(target, { target: { name, value } }));
}
function renderedForm() { return drawGraphic.mock.calls[drawGraphic.mock.calls.length - 1]?.[1]; }

test("renders the official eight, positions and club crests for each selected league", async () => {
  await render();
  expect(renderedForm()).toMatchObject({ category: "season-best-eight", formation: "2-3-2", periodType: "season", periodLabel: "2026" });
  expect(renderedForm().lineup.slice(-2).map((player) => [player.name, player.positionLabel])).toEqual([
    ["Karol Sochocki", "LN"], ["Mateusz Trąbiński", "PN"],
  ]);
  expect(renderedForm().lineup.every((player) => player.logoUrl.startsWith("/test-logos/"))).toBe(true);
  expect(button("Pobierz PNG").disabled).toBe(false);

  await change("leagueCode", "2nd");
  expect(renderedForm().lineup[7]).toMatchObject({ name: "Olaf Orełko", positionLabel: "ŚN" });
  expect(renderedForm().seasonHonours.champion).toBe("Faludża");
  await change("leagueCode", "3rd");
  expect(renderedForm().lineup[7]).toMatchObject({ name: "Sebastian Orzoł", positionLabel: "ŚN" });
  expect(renderedForm().lineup.find((player) => player.name === "Patryk Halaburda").logoUrl).toContain("Fc%20KSS");
});

test("switches to the four official awards and exports the chosen league instead of the stale round", async () => {
  await render({ leagueCode: "2nd" });
  await category("Wyróżnienia sezonu");
  expect(renderedForm().category).toBe("season-awards");
  expect(renderedForm().seasonHonours.awards).toHaveLength(4);
  expect(renderedForm().seasonHonours.awards[2]).toMatchObject({ name: "Karol Bujalski", stat: "14 asyst" });
  expect(host.querySelector('select[name="periodType"]')).toBeNull();
  await act(async () => Simulate.click(button("Pobierz PNG")));
  expect(downloadedNames).toEqual(["mlpn-season-awards-post-2nd-2026.png"]);
  expect(HTMLCanvasElement.prototype.toBlob).toHaveBeenCalledWith(expect.any(Function), "image/png", 1);
});

test("an unsupported year hides the old canvas and disables downloading until a supported season returns", async () => {
  await render();
  await change("seasonYear", "2025");
  expect(host.textContent).toContain("Brak zatwierdzonego podsumowania dla tego sezonu");
  expect(host.querySelector("canvas").style.display).toBe("none");
  expect(button("Pobierz PNG").disabled).toBe(true);
  expect(button("Pobierz").disabled).toBe(true);
  await change("seasonYear", "2026");
  expect(host.querySelector("canvas").style.display).not.toBe("none");
  expect(button("Pobierz PNG").disabled).toBe(false);
  expect(renderedForm().seasonHonours.year).toBe(2026);
});

test("returning from official graphics keeps the manually edited lineup and formation", async () => {
  const manual = { name: "Jan Ręcznie Wybrany", team: "Moja drużyna", logoUrl: "/manual.png" };
  await render({ category: "best-eight", formation: "3-2-2", lineup: [manual] });
  expect(renderedForm().lineup[0]).toMatchObject(manual);
  await category("Ósemka sezonu");
  expect(renderedForm().lineup[0].name).toBe("Maciej Wronka");
  await category("Najlepsza ósemka");
  expect(renderedForm()).toMatchObject({ category: "best-eight", formation: "3-2-2" });
  expect(renderedForm().lineup[0]).toMatchObject(manual);
  expect(JSON.parse(localStorage.getItem(DRAFT_KEY)).lineup[0]).toMatchObject(manual);
});

test("story selection updates the real PNG canvas size and download name", async () => {
  await render({ category: "season-awards", leagueCode: "3rd", format: "story" });
  expect(host.querySelector("canvas").width).toBe(2160);
  expect(host.querySelector("canvas").height).toBe(3840);
  expect(drawGraphic).toHaveBeenLastCalledWith(expect.anything(), expect.objectContaining({ format: "story" }), expect.anything(), expect.anything(), 1080, 1920);
  await act(async () => Simulate.click(button("Pobierz PNG")));
  expect(downloadedNames).toEqual(["mlpn-season-awards-story-3rd-2026.png"]);
});
