import {
  drawGraphic,
  getCompactMatchRowLayout,
  getRoundListLayout,
  getSponsorPanelLayout,
  subtitleForForm,
  titleForForm,
} from "./graphicsRenderer";

describe("graphics weekend headings", () => {
  const previewForm = {
    category: "round-preview",
    round: 12,
    previewScope: "weekend",
    previewWeekendStart: "2026-09-11",
    previewPage: 1,
    previewPageCount: 1,
  };

  test("labels a weekend preview by date rather than round", () => {
    expect(titleForForm(previewForm)).toBe("11–14.09");
    expect(subtitleForForm(previewForm)).toBe("Zapowiedź weekendu");
  });

  test("ignores legacy page numbers because a weekend now uses one graphic", () => {
    expect(subtitleForForm({ ...previewForm, previewPage: 2, previewPageCount: 3 }))
      .toBe("Zapowiedź weekendu");
    expect(subtitleForForm({ ...previewForm, previewPageCount: undefined }))
      .toBe("Zapowiedź weekendu");
  });

  test.each([
    ["2026-10-30", "30.10–02.11"],
    ["2027-12-31", "31.12–03.01"],
  ])("formats a weekend preview across a calendar boundary: %s", (friday, title) => {
    expect(titleForForm({ ...previewForm, previewWeekendStart: friday })).toBe(title);
  });

  test("shows a neutral weekend title until a valid Friday is selected", () => {
    expect(titleForForm({ ...previewForm, previewWeekendStart: "" })).toBe("Weekend");
    expect(titleForForm({ ...previewForm, previewWeekendStart: "2026-09-12" })).toBe("Weekend");
  });

  test.each(["round", undefined])("preserves round preview headings for scope %s", (previewScope) => {
    const form = { ...previewForm, previewScope, previewPage: 2, previewPageCount: 3 };
    expect(titleForForm(form)).toBe("XII kolejka");
    expect(subtitleForForm(form)).toBe("Zapowiedź");
  });

  test("preserves weekend and round result headings independently of preview state", () => {
    const form = {
      ...previewForm,
      category: "round-results",
      resultsScope: "weekend",
      weekendStart: "2026-09-04",
      resultsPage: 2,
      resultsPageCount: 4,
    };
    expect(titleForForm(form)).toBe("04–07.09");
    expect(subtitleForForm(form)).toBe("Wyniki weekendu");
    expect(titleForForm({ ...form, resultsScope: "round" })).toBe("XII kolejka");
    expect(subtitleForForm({ ...form, resultsScope: "round" })).toBe("Wyniki");
  });

  test("preserves explicit title and subtitle overrides", () => {
    const form = { ...previewForm, title: "  Mecze MLPN  ", subtitle: "  Gramy razem  " };
    expect(titleForForm(form)).toBe("Mecze MLPN");
    expect(subtitleForForm(form)).toBe("Gramy razem");
  });
});

const FORMATS = [
  { format: "post", width: 1080, height: 1080, isStory: false, M: 76 },
  { format: "story", width: 1080, height: 1920, isStory: true, M: 81 },
];
const SPONSORS = Array.from({ length: 12 }, (_, id) => ({ id, name: `Partner ${id + 1}` }));

function contentBounds(form, layout) {
  const top = Math.round(layout.height * (layout.isStory ? 0.045 : 0.05))
    + (layout.isStory ? 108 + 26 : 86 + 20);
  const panel = getSponsorPanelLayout(form, SPONSORS, layout);
  return { top, bottom: panel.panelY - (layout.isStory ? 30 : 22), panel };
}

describe("single-page fixture geometry", () => {
  const cases = FORMATS.flatMap((layout) => [17, 24, 34].flatMap((count) =>
    [1, 2, 3, 4].map((sponsorRows) => [layout.format, count, sponsorRows, layout])
  ));

  test.each(cases)("fits %s with %i matches and %i sponsor rows", (format, count, sponsorRows, layout) => {
    const form = { category: "round-preview", sponsorRows };
    const { top, bottom, panel } = contentBounds(form, layout);
    const grid = getRoundListLayout(count, layout, top, bottom);
    const row = getCompactMatchRowLayout(grid.colW, grid.rowH);
    expect(grid.cols * grid.rowsPerCol).toBeGreaterThanOrEqual(count);
    expect(grid.rowH).toBeGreaterThan(35);
    expect(row.nameSize).toBeGreaterThanOrEqual(15);
    expect(row.nameWidth).toBeGreaterThan(0);
    expect(row.nameSize * 2.9).toBeLessThanOrEqual(row.nameWidth + 0.01);
    expect(row.crest).toBeLessThan(grid.rowH);
    expect(row.chipH).toBeLessThan(grid.rowH);
    Array.from({ length: count }).forEach((_, i) => {
      const col = Math.floor(i / grid.rowsPerCol);
      const index = i % grid.rowsPerCol;
      const x = layout.M + col * (grid.colW + grid.colGap);
      const y = grid.y0 + index * (grid.rowH + grid.rowGap);
      expect(x).toBeGreaterThanOrEqual(layout.M);
      expect(x + grid.colW).toBeLessThanOrEqual(layout.width - layout.M + 0.01);
      expect(y).toBeGreaterThanOrEqual(top + grid.legendH);
      expect(y + grid.rowH).toBeLessThanOrEqual(bottom + 0.01);
      expect(y + grid.rowH).toBeLessThan(panel.panelY);
    });
  });

  test("keeps the existing sponsor dimensions for other graphic categories", () => {
    const normal = getSponsorPanelLayout({ category: "round-typer", sponsorRows: 4 }, SPONSORS, FORMATS[0]);
    const compact = getSponsorPanelLayout({ category: "round-results", sponsorRows: 4 }, SPONSORS, FORMATS[0]);
    expect(normal.rowH).toBe(80);
    expect(compact.rowsCount).toBe(4);
    expect(compact.rowH).toBe(56);
    expect(compact.panelY).toBeGreaterThan(normal.panelY);
  });
});

function recordingContext() {
  const text = [];
  const images = [];
  const gradient = { addColorStop: jest.fn() };
  const ctx = {
    font: "800 20px Arial",
    text,
    images,
    measureText(value) {
      const size = Number(this.font.match(/([\d.]+)px/)[1]);
      return { width: Array.from(String(value)).reduce((sum, char) => sum + (/[MW]/.test(char) ? 0.95 : 0.62) * size, 0) };
    },
    fillText(value, x, y) { text.push({ value: String(value), x, y, font: this.font }); },
    drawImage(image, ...bounds) { images.push({ image, bounds }); },
    createLinearGradient: () => gradient,
    createRadialGradient: () => gradient,
  };
  ["save", "restore", "beginPath", "closePath", "moveTo", "arcTo", "arc", "fill", "stroke",
    "fillRect", "strokeRect", "lineTo", "clip", "translate", "rect", "quadraticCurveTo"]
    .forEach((method) => { ctx[method] = jest.fn(); });
  return ctx;
}

describe("complete weekend rendering", () => {
  const matches = Array.from({ length: 34 }, (_, i) => ({
    id: i + 1,
    league_code: ["1st", "2nd", "3rd"][i % 3],
    home_team_name: "Al Mar Wołomin",
    away_team_name: "Detox",
    home_team_logo: "home-logo",
    away_team_logo: "away-logo",
    // Stale database abbreviations must not override the accepted names.
    home_team_abbr: "AMW",
    away_team_abbr: "DET",
    home_goals: i,
    away_goals: 0,
    match_date: `2026-09-${11 + i % 4}`,
    match_time: "18:30:00",
    status: "completed",
  }));
  const crest = { naturalWidth: 100, naturalHeight: 100 };
  const images = {
    brand: null,
    teamLogos: new Map([["home-logo", crest], ["away-logo", crest]]),
    sponsors: new Map(),
    sponsorList: SPONSORS,
  };

  test.each(FORMATS.flatMap((layout) => ["round-preview", "round-results"].map((category) => [layout.format, category, layout])))
  ("renders all 34 matches once in %s %s without truncating labels", (format, category, layout) => {
    const ctx = recordingContext();
    const form = {
      category, sponsorRows: 4, seasonYear: 2026, theme: "stadium",
      previewScope: "weekend", previewWeekendStart: "2026-09-11",
      resultsScope: "weekend", weekendStart: "2026-09-11",
      previewPage: 2, previewPageCount: 3, resultsPage: 2, resultsPageCount: 3,
      hitMatchId: 1,
    };
    drawGraphic(ctx, form, { matches }, images, layout.width, layout.height);
    const strings = ctx.text.map(({ value }) => value);
    expect(strings.filter((value) => value === "ALM")).toHaveLength(34);
    expect(strings.filter((value) => value === "DTX")).toHaveLength(34);
    expect(strings).not.toContain("AMW");
    expect(strings).not.toContain("DET");
    expect(strings).not.toContain("Al Mar Wołomin");
    expect(strings).not.toContain("Detox");
    expect(strings.some((value) => value.includes("..."))).toBe(false);
    expect(strings).toContain("HIT WEEKENDU");
    expect(ctx.images).toHaveLength(68);
    if (category === "round-results") {
      matches.forEach((match) => expect(strings.filter((value) => value === `${match.home_goals} : 0`)).toHaveLength(1));
    } else {
      expect(strings.filter((value) => value === "18:30")).toHaveLength(34);
      expect(strings.filter((value) => /^1[1-4]\.09$/.test(value))).toHaveLength(34);
    }
  });
});
