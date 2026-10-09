import { drawGraphic, getBestEightHeaderLayout, getSponsorPanelLayout } from "./graphicsRenderer";

const CATEGORIES = ["round-typer", "round-preview", "round-results", "best-eight", "player-award", "player-vote", "table-summary"];
const FORMATS = [
  { format: "post", width: 1080, height: 1080, isStory: false, M: 76 },
  { format: "story", width: 1080, height: 1920, isStory: true, M: 81 },
];
const SPONSORS = Array.from({ length: 16 }, (_, index) => ({ id: `sponsor-${index}`, name: `Partner ${index + 1}` }));
const CASES = FORMATS.flatMap((layout) => CATEGORIES.flatMap((category) =>
  [1, 2, 3, 4].map((rows) => [layout.format, category, rows, layout])
));
const EPSILON = 0.01;

function rowChoice(category, rows) {
  return category === "best-eight" ? { bestEightSponsorRows: rows } : { sponsorRows: rows };
}

function assertInside(inner, outer) {
  expect(inner.x).toBeGreaterThanOrEqual(outer.x - EPSILON);
  expect(inner.y).toBeGreaterThanOrEqual(outer.y - EPSILON);
  expect(inner.x + inner.w).toBeLessThanOrEqual(outer.x + outer.w + EPSILON);
  expect(inner.y + inner.h).toBeLessThanOrEqual(outer.y + outer.h + EPSILON);
}

function recordingContext() {
  const stack = [];
  const gradient = { addColorStop: jest.fn() };
  const ctx = {
    font: "800 20px Arial", textAlign: "start", textBaseline: "alphabetic",
    tx: 0, ty: 0, text: [], images: [],
    measureText(value) {
      const size = Number(this.font.match(/([\d.]+)px/)[1]);
      return { width: Array.from(String(value)).reduce((sum, char) => sum + (/[MW]/u.test(char) ? 0.95 : 0.62) * size, 0) };
    },
    fillText(value, x, y) {
      const size = Number(this.font.match(/([\d.]+)px/)[1]);
      const { width } = this.measureText(value);
      const left = this.textAlign === "center" ? x - width / 2 : this.textAlign === "right" ? x - width : x;
      const top = this.textBaseline === "middle" ? y - size / 2 : this.textBaseline === "top" ? y : y - size;
      this.text.push({ value: String(value), x: left + this.tx, y: top + this.ty, w: width, h: size });
    },
    drawImage(image, ...args) {
      const [x, y, w, h] = args.length === 8 ? args.slice(4) : args;
      this.images.push({ image, x: x + this.tx, y: y + this.ty, w, h });
    },
    save() { stack.push({ font: this.font, textAlign: this.textAlign, textBaseline: this.textBaseline, tx: this.tx, ty: this.ty }); },
    restore() { Object.assign(this, stack.pop()); },
    translate(x, y) { this.tx += x; this.ty += y; },
    createLinearGradient: () => gradient,
    createRadialGradient: () => gradient,
  };
  ["beginPath", "closePath", "moveTo", "arcTo", "arc", "fill", "stroke", "fillRect", "strokeRect",
    "lineTo", "clip", "rect", "quadraticCurveTo", "bezierCurveTo", "setLineDash", "ellipse", "rotate", "scale"]
    .forEach((method) => { ctx[method] = jest.fn(); });
  return ctx;
}

function contentFixture(category, rows) {
  const matches = Array.from({ length: category === "round-typer" ? 3 : 34 }, (_, index) => ({
    id: index + 1, league_code: "1st", home_team_name: "ALM", away_team_name: "DTX",
    home_team_abbr: "ALM", away_team_abbr: "DTX", home_goals: index, away_goals: 0,
    match_date: "2026-09-11", match_time: "18:30:00", status: "completed",
  }));
  const standings = Array.from({ length: 16 }, (_, index) => ({
    position: index + 1, team_name: `Klub ${index + 1}`, played: 12,
    goals_for: index + 5, goals_against: 3, points: 30 - index,
  }));
  const form = {
    category, ...rowChoice(category, rows), theme: "stadium", leagueCode: "1st", seasonYear: 2026,
    round: 12, periodLabel: "Wrzesień", formation: "3-3-1",
    previewScope: "weekend", previewWeekendStart: "2026-09-11",
    resultsScope: "weekend", weekendStart: "2026-09-11",
    playerName: "Jan Lis", playerTeam: "Klub MLPN",
    lineup: Array.from({ length: 8 }, () => ({ name: "Jan Lis", logoUrl: "" })),
    candidates: ["Jan Lis", "Adam Kot", "Eryk Gil"].map((name) => ({ name, photoUrl: "" })),
  };
  const markers = category.startsWith("round") ? ["ALM", "DTX"]
    : category === "best-eight" ? ["J. Lis"]
      : category === "table-summary" ? standings.map(({ team_name }) => team_name)
        : category === "player-vote" ? ["Jan Lis", "Adam Kot", "Eryk Gil"]
          : ["Jan Lis", "Klub MLPN"];
  return { form, data: { matches, standings }, markers };
}

describe("shared compact sponsor band", () => {
  test.each(CASES)("leaves room for content in %s %s with %i partner rows", (format, category, rows, layout) => {
    const form = { category, ...rowChoice(category, rows) };
    const panel = getSponsorPanelLayout(form, SPONSORS, layout);
    const reference = getSponsorPanelLayout({ category: "best-eight", bestEightSponsorRows: rows }, SPONSORS, layout);
    expect(panel).toEqual(reference);
    expect(panel.rowsCount).toBe(rows);
    expect(panel.rowH).toBeGreaterThan(40);
    expect(panel.panelH).toBeLessThanOrEqual(layout.height * (layout.isStory ? 0.20 : 0.22));
    assertInside({ x: panel.panelX, y: panel.panelY, w: panel.panelW, h: panel.panelH }, { x: 0, y: 0, w: layout.width, h: layout.height });
    const top = category === "best-eight" ? getBestEightHeaderLayout(layout).contentTop
      : Math.round(layout.height * (layout.isStory ? 0.045 : 0.05)) + (layout.isStory ? 134 : 106);
    const contentHeight = panel.panelY - (layout.isStory ? 30 : 22) - top;
    expect(contentHeight).toBeGreaterThanOrEqual(layout.height * 0.55);
    expect(layout.height - panel.panelY - panel.panelH).toBeGreaterThanOrEqual(layout.isStory ? 58 : 36);
  });

  test.each(FORMATS.flatMap((layout) => CATEGORIES.map((category) => [layout.format, category, layout])))
  ("chooses enough automatic rows for the partner count in %s %s", (format, category, layout) => {
    [[0, 1], [1, 1], [6, 1], [7, 2], [12, 2], [13, 3], [16, 3], [24, 4], [25, 4]]
      .forEach(([count, expected]) => {
        const partners = Array.from({ length: count }, (_, id) => ({ id }));
        [undefined, "auto"].forEach((choice) => {
          const panel = getSponsorPanelLayout({ category, ...rowChoice(category, choice) }, partners, layout);
          expect(panel.rowsCount).toBe(expected);
        });
      });
  });

  test("keeps the best-eight row setting separate from other saved graphic settings", () => {
    const saved = { sponsorRows: 4, bestEightSponsorRows: 2 };
    CATEGORIES.forEach((category) => {
      expect(getSponsorPanelLayout({ ...saved, category }, SPONSORS, FORMATS[0]).rowsCount)
        .toBe(category === "best-eight" ? 2 : 4);
    });
  });
});

describe("partner logos across complete graphic categories", () => {
  let canvasContext;
  beforeEach(() => {
    canvasContext = jest.spyOn(HTMLCanvasElement.prototype, "getContext").mockImplementation(() => recordingContext());
  });
  afterEach(() => canvasContext.mockRestore());

  test.each(CASES)("draws all sixteen partners once below the content in %s %s with %i rows", (format, category, rows, layout) => {
    const { form, data, markers } = contentFixture(category, rows);
    const ctx = recordingContext();
    const logos = SPONSORS.map(({ id }, index) => ({ id, naturalWidth: index % 2 ? 220 : 100, naturalHeight: index % 2 ? 100 : 160 }));
    const images = {
      brand: null, teamLogos: new Map(), sponsorList: SPONSORS,
      sponsors: new Map(logos.map((logo) => [logo.id, logo])),
    };
    drawGraphic(ctx, form, data, images, layout.width, layout.height);
    const panel = getSponsorPanelLayout(form, SPONSORS, layout);
    const sponsorRegion = {
      x: panel.panelX + panel.pad, y: panel.panelY + panel.pad + panel.labelH + panel.gapLabel,
      w: panel.panelW - panel.pad * 2, h: panel.rowH * panel.rowsCount,
    };
    const drawn = ctx.images.filter(({ image }) => logos.includes(image));
    expect(drawn).toHaveLength(16);
    logos.forEach((logo) => expect(drawn.filter(({ image }) => image === logo)).toHaveLength(1));
    drawn.forEach((image, index) => {
      assertInside(image, sponsorRegion);
      drawn.slice(index + 1).forEach((other) => {
        const clear = image.x + image.w <= other.x + EPSILON || other.x + other.w <= image.x + EPSILON
          || image.y + image.h <= other.y + EPSILON || other.y + other.h <= image.y + EPSILON;
        expect(clear).toBe(true);
      });
    });
    markers.forEach((marker) => {
      const labels = ctx.text.filter(({ value }) => value === marker);
      expect(labels.length).toBeGreaterThan(0);
      labels.forEach((label) => expect(label.y + label.h).toBeLessThan(panel.panelY));
    });
  });
});
