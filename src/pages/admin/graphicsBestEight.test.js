import {
  drawGraphic,
  FORMATIONS,
  getBestEightHeaderLayout,
  getBestEightLayout,
  getBestEightNameLayout,
  getSponsorPanelLayout,
} from "./graphicsRenderer";

const FORMATS = [
  { format: "post", width: 1080, height: 1080, isStory: false, M: 76 },
  { format: "story", width: 1080, height: 1920, isStory: true, M: 81 },
];
const SPONSORS = Array.from({ length: 16 }, (_, i) => ({ id: `partner-${i}`, name: `Partner ${i + 1}` }));
const NAME_SETS = {
  short: ["Jan Lis", "Adam Kot", "Eryk Gil", "Iwo Wilk", "Igor Król", "Leon Wójcik", "Oskar Nowak", "Filip Mazur"],
  long: [
    "Dariusz Pszczółkowski", "Aleksander Konstantynopolski", "Wawrzyniec Brzęczyszczykiewicz",
    "Maksymilian Kowalski-Wiśniewski", "Bartłomiej Grzegorzewski", "Przemysław Szczęsnowicz",
    "Stanisław Brzeziński-Szymański", "Krzysztof Wierzchołowski",
  ],
  mixed: [
    "Jan Lis", "D. Pszczółkowski", "Marek Błoński", "Cezary Kostrzewa",
    "Wojciech Kowalski-Wiśniewski", "Aleksander Banaszek", "Łukasz Żółkiewski", "Wawrzyniec Brzęczyszczykiewicz",
  ],
};
const CASES = FORMATS.flatMap((layout) => FORMATIONS.flatMap((formation) =>
  [1, 2, 3, 4].map((rows) => [layout.format, formation.id, rows, layout])
));
const EPSILON = 0.01;

function inside(inner, outer) {
  expect(inner.x).toBeGreaterThanOrEqual(outer.x - EPSILON);
  expect(inner.y).toBeGreaterThanOrEqual(outer.y - EPSILON);
  expect(inner.x + inner.w).toBeLessThanOrEqual(outer.x + outer.w + EPSILON);
  expect(inner.y + inner.h).toBeLessThanOrEqual(outer.y + outer.h + EPSILON);
}

function separated(a, b, gap = 0) {
  return a.x + a.w + gap <= b.x + EPSILON || b.x + b.w + gap <= a.x + EPSILON
    || a.y + a.h + gap <= b.y + EPSILON || b.y + b.h + gap <= a.y + EPSILON;
}

function boundsFor(form, layout) {
  const panel = getSponsorPanelLayout(form, SPONSORS, layout);
  const { contentTop: top } = getBestEightHeaderLayout(layout);
  return { top, bottom: panel.panelY - (layout.isStory ? 30 : 22), panel };
}

function makeForm(formation, rows, names = NAME_SETS.mixed) {
  return {
    category: "best-eight", formation, bestEightSponsorRows: rows,
    leagueCode: "1st", periodLabel: "Wrzesień", theme: "stadium",
    lineup: names.map((name, index) => ({ name, logoUrl: `crest-${index}` })),
  };
}

function normalizeName(value) {
  return String(value).replace(/\s+/gu, "").toLocaleUpperCase("pl-PL");
}

// Conservative, repeatable glyph metrics exercise the renderer's real fitting code.
// The browser preview separately verifies the actual Montserrat font and pixels.
function recordingContext() {
  const stack = [];
  const gradient = { addColorStop: jest.fn() };
  const ctx = {
    font: "800 20px Arial", textAlign: "start", textBaseline: "alphabetic",
    translation: { x: 0, y: 0 }, text: [], images: [],
    measureText(value) {
      const size = Number(this.font.match(/([\d.]+)px/)[1]);
      const width = Array.from(String(value)).reduce((sum, char) => {
        const factor = /[MWmw]/u.test(char) ? 0.98 : /[ilI.,\s-]/u.test(char) ? 0.34 : /\p{Lu}/u.test(char) ? 0.73 : 0.63;
        return sum + factor * size;
      }, 0);
      return { width, actualBoundingBoxAscent: size * 0.78, actualBoundingBoxDescent: size * 0.22 };
    },
    fillText(value, x, y) {
      const size = Number(this.font.match(/([\d.]+)px/)[1]);
      const metrics = this.measureText(value);
      const left = this.textAlign === "center" ? x - metrics.width / 2 : this.textAlign === "right" ? x - metrics.width : x;
      const top = this.textBaseline === "middle" ? y - size / 2 : this.textBaseline === "top" ? y : this.textBaseline === "bottom" ? y - size : y - metrics.actualBoundingBoxAscent;
      this.text.push({
        value: String(value), font: this.font, color: this.fillStyle, x: left + this.translation.x,
        y: top + this.translation.y, w: metrics.width, h: size,
      });
    },
    drawImage(image, ...args) {
      const [x, y, w, h] = args.length === 8 ? args.slice(4) : args;
      this.images.push({ image, x: x + this.translation.x, y: y + this.translation.y, w, h });
    },
    save() {
      stack.push({ font: this.font, textAlign: this.textAlign, textBaseline: this.textBaseline, translation: { ...this.translation } });
    },
    restore() { Object.assign(this, stack.pop()); },
    translate(x, y) { this.translation.x += x; this.translation.y += y; },
    createLinearGradient: () => gradient,
    createRadialGradient: () => gradient,
  };
  ["beginPath", "closePath", "moveTo", "arcTo", "arc", "fill", "stroke", "fillRect", "strokeRect",
    "lineTo", "clip", "rect", "quadraticCurveTo", "bezierCurveTo", "setLineDash", "ellipse", "rotate", "scale"]
    .forEach((method) => { ctx[method] = jest.fn(); });
  return ctx;
}

describe("best-eight formation geometry", () => {
  test.each(CASES)("keeps every player clear of crests and neighbours: %s %s, %i sponsor rows", (format, formation, rows, layout) => {
    const form = makeForm(formation, rows);
    const { top, bottom, panel } = boundsFor(form, layout);
    const { pitch, players } = getBestEightLayout(form, layout, top, bottom);
    expect(players).toHaveLength(8);
    expect(players.map(({ index }) => index).sort()).toEqual([0, 1, 2, 3, 4, 5, 6, 7]);
    inside(pitch, { x: 0, y: top, w: layout.width, h: bottom - top });
    expect(pitch.y + pitch.h).toBeLessThan(panel.panelY);

    const regions = [];
    players.forEach((player) => {
      expect(player.label).toBe(FORMATIONS.find(({ id }) => id === formation).slots[player.index].label);
      ["position", "logo", "name"].forEach((kind) => {
        const box = player[kind];
        Object.values(box).forEach((value) => expect(Number.isFinite(value)).toBe(true));
        expect(box.w).toBeGreaterThan(0);
        expect(box.h).toBeGreaterThan(0);
        inside(box, pitch);
        regions.push({ ...box, index: player.index, kind });
      });
      expect(separated(player.position, player.logo, 4)).toBe(true);
      expect(separated(player.logo, player.name, 4)).toBe(true);
      expect(separated(player.position, player.name, 4)).toBe(true);
    });
    regions.forEach((a, index) => regions.slice(index + 1).forEach((b) => {
      expect({ pair: `${a.index}:${a.kind} / ${b.index}:${b.kind}`, clear: separated(a, b, 2) })
        .toEqual({ pair: `${a.index}:${a.kind} / ${b.index}:${b.kind}`, clear: true });
    }));

    // The keeper remains below all outfield players on the upright pitch.
    const keeper = players.find(({ label }) => label === "BR");
    players.filter(({ label }) => label !== "BR").forEach((player) => {
      expect(keeper.logo.y).toBeGreaterThan(player.logo.y);
    });
  });

  test.each(CASES)("fits short, long and hyphenated full names: %s %s, %i sponsor rows", (format, formation, rows, layout) => {
    const form = makeForm(formation, rows);
    const { top, bottom } = boundsFor(form, layout);
    const { players } = getBestEightLayout(form, layout, top, bottom);
    const ctx = recordingContext();
    players.forEach(({ name: box, nameSize }) => Object.values(NAME_SETS).flat().forEach((name) => {
      const plan = getBestEightNameLayout(ctx, name, box, nameSize);
      expect(normalizeName(plan.lines.join(" "))).toBe(normalizeName(name));
      expect(plan.lines.length).toBeGreaterThan(0);
      expect(plan.fontSize).toBeGreaterThan(0);
      expect(plan.fontSize).toBeLessThanOrEqual(nameSize);
      expect(plan.lineHeight).toBeGreaterThanOrEqual(plan.fontSize);
      expect(plan.lineHeight * plan.lines.length).toBeLessThanOrEqual(box.h + EPSILON);
      ctx.font = `800 ${plan.fontSize}px Arial`;
      plan.lines.forEach((line) => expect(ctx.measureText(line).width).toBeLessThanOrEqual(box.w + EPSILON));
    }));
  });

  test("contains an exceptionally long unbroken surname without spilling into a neighbouring player", () => {
    const ctx = recordingContext();
    const name = `Jan ${"Brzęczyszczykiewicz".repeat(8)}`;
    const box = { x: 0, y: 0, w: 150, h: 44 };
    const plan = getBestEightNameLayout(ctx, name, box, 22);
    expect(normalizeName(plan.lines.join(" "))).toBe(normalizeName(name));
    expect(plan.fontSize).toBeGreaterThan(0);
    expect(plan.lineHeight * plan.lines.length).toBeLessThanOrEqual(box.h + EPSILON);
    ctx.font = `800 ${plan.fontSize}px Arial`;
    plan.lines.forEach((line) => expect(ctx.measureText(line).width).toBeLessThanOrEqual(box.w + EPSILON));
  });
});

describe("best-eight sponsor band", () => {
  test.each(FORMATS)("uses at most the reserved footer share in $format for 1–4 rows", (layout) => {
    [1, 2, 3, 4].forEach((rows) => {
      const panel = getSponsorPanelLayout(makeForm("3-3-1", rows), SPONSORS, layout);
      expect(panel.rowsCount).toBe(rows);
      expect(panel.panelH).toBeLessThanOrEqual(layout.height * (layout.isStory ? 0.20 : 0.22));
      inside({ x: panel.panelX, y: panel.panelY, w: panel.panelW, h: panel.panelH }, { x: 0, y: 0, w: layout.width, h: layout.height });
    });
  });

  test.each(FORMATS)("defaults sixteen partners to three rows regardless of old saved row choice in $format", (layout) => {
    [undefined, 1, 2, 3, 4].forEach((sponsorRows) => {
      const panel = getSponsorPanelLayout({ category: "best-eight", sponsorRows }, SPONSORS, layout);
      expect(panel.rowsCount).toBe(3);
    });
    expect(getSponsorPanelLayout({ category: "round-typer", sponsorRows: 4 }, SPONSORS, layout).rowsCount).toBe(4);
  });
});

describe("complete best-eight rendering", () => {
  let canvasContext;
  beforeEach(() => {
    canvasContext = jest.spyOn(HTMLCanvasElement.prototype, "getContext").mockImplementation(() => recordingContext());
  });
  afterEach(() => canvasContext.mockRestore());

  test.each(CASES)("renders all eight full names and crests without text collisions: %s %s, %i sponsor rows", (format, formation, rows, layout) => {
    [NAME_SETS.short, NAME_SETS.long].forEach((names) => {
      const form = makeForm(formation, rows, names);
      const ctx = recordingContext();
      const crests = names.map((_, index) => ({
        id: `crest-${index}`, naturalWidth: index % 2 ? 80 : 140, naturalHeight: index % 2 ? 140 : 80,
      }));
      const sponsorImages = SPONSORS.map(({ id }) => ({ id, naturalWidth: 220, naturalHeight: 100 }));
      const images = {
        brand: null, sponsorList: SPONSORS,
        teamLogos: new Map(crests.map((crest) => [crest.id, crest])),
        sponsors: new Map(sponsorImages.map((sponsor) => [sponsor.id, sponsor])),
      };
      drawGraphic(ctx, form, {}, images, layout.width, layout.height);

      const actualCrests = ctx.images.filter(({ image }) => crests.includes(image));
      expect(actualCrests).toHaveLength(8);
      crests.forEach((crest) => expect(actualCrests.filter(({ image }) => image === crest)).toHaveLength(1));
      sponsorImages.forEach((sponsor) => expect(ctx.images.filter(({ image }) => image === sponsor)).toHaveLength(1));

      const renderedNames = [];
      names.forEach((name) => {
        const normalized = normalizeName(name);
        const lines = ctx.text.filter(({ value }) => {
          const token = normalizeName(value);
          return token.length >= 3 && normalized.includes(token);
        }).sort((a, b) => a.y - b.y || a.x - b.x);
        expect(normalizeName(lines.map(({ value }) => value).join(" "))).toBe(normalized);
        expect(lines.some(({ value }) => value.includes("...") || value.includes("…"))).toBe(false);
        renderedNames.push(...lines);
      });
      renderedNames.forEach((text, index) => {
        actualCrests.forEach((crest) => expect(separated(text, crest, 2)).toBe(true));
        renderedNames.slice(index + 1).forEach((other) => expect(separated(text, other)).toBe(true));
      });

      const labels = FORMATIONS.find(({ id }) => id === formation).slots.map(({ label }) => label);
      labels.forEach((label) => expect(ctx.text.filter(({ value }) => value === label)).toHaveLength(1));
      const positionTexts = ctx.text.filter(({ value }) => labels.includes(value));
      positionTexts.forEach((text) => {
        actualCrests.forEach((crest) => expect(separated(text, crest, 2)).toBe(true));
        renderedNames.forEach((name) => expect(separated(text, name, 2)).toBe(true));
      });
      const panel = getSponsorPanelLayout(form, SPONSORS, layout);
      // A glow mask can cross the reserved gap even when the source crest fits.
      expect(ctx.images.filter(({ image, y }) => image instanceof HTMLCanvasElement && y < panel.panelY)).toHaveLength(0);
      [...actualCrests, ...renderedNames, ...positionTexts].forEach((box) => {
        inside(box, { x: 0, y: 0, w: layout.width, h: panel.panelY });
      });
      expect(ctx.text.map(({ value }) => value).join(" ")).not.toMatch(/pasj|emocj|jeden cel|jedna liga/iu);
    });
  });

  test.each(FORMATS)("keeps empty lineup and unavailable partner logos readable in $format", (layout) => {
    const ctx = recordingContext();
    const form = { ...makeForm("2-4-1", 3), lineup: [] };
    const images = { brand: null, teamLogos: new Map(), sponsors: new Map(), sponsorList: SPONSORS };
    expect(() => drawGraphic(ctx, form, {}, images, layout.width, layout.height)).not.toThrow();
    expect(ctx.text.filter(({ value }) => value === "Zawodnik")).toHaveLength(8);
    expect(ctx.text.filter(({ value }) => value === "MLPN")).toHaveLength(8);
    SPONSORS.forEach(({ name }) => {
      const labels = ctx.text.filter(({ value }) => value === name);
      expect(labels).toHaveLength(1);
      expect(labels[0].color).toBe("#0d1b2c");
    });
  });
});
