import {
  drawGraphic, FORMATIONS, formatBestEightPlayerName, getBestEightHeaderLayout,
  getBestEightLayout, getSeasonAwardsLayout, getSeasonChampionLayout,
  getSponsorPanelLayout, titleForForm, subtitleForForm,
} from "./graphicsRenderer";

const FORMATS = [
  { format: "post", width: 1080, height: 1080, isStory: false, M: 76 },
  { format: "story", width: 1080, height: 1920, isStory: true, M: 81 },
];
const THEMES = ["stadium", "clean", "blue-red"];
const PARTNERS = Array.from({ length: 16 }, (_, index) => ({ id: `partner-${index}`, name: `Partner ${index}` }));
const NAMES = [
  "Jan Lis", "Łukasz Żółkiewski", "Maksymilian Kowalski-Wiśniewski", "Wawrzyniec Brzęczyszczykiewicz",
  "Krzysztof Wierzchołowski", "Dariusz Pszczółkowski", "Jan van der Meer", "Stanisław Brzeziński-Szymański",
];
const CATEGORIES = ["Najlepszy zawodnik", "Najlepszy strzelec", "Najlepszy asystent", "Najlepszy bramkarz"];
const EPSILON = 0.01;

function separated(a, b, gap = 0) {
  return a.x + a.w + gap <= b.x + EPSILON || b.x + b.w + gap <= a.x + EPSILON
    || a.y + a.h + gap <= b.y + EPSILON || b.y + b.h + gap <= a.y + EPSILON;
}

function inside(inner, outer) {
  expect(inner.x).toBeGreaterThanOrEqual(outer.x - EPSILON);
  expect(inner.y).toBeGreaterThanOrEqual(outer.y - EPSILON);
  expect(inner.x + inner.w).toBeLessThanOrEqual(outer.x + outer.w + EPSILON);
  expect(inner.y + inner.h).toBeLessThanOrEqual(outer.y + outer.h + EPSILON);
}

function normalized(value) {
  return String(value).replace(/\s+/gu, "").toLocaleUpperCase("pl-PL");
}

function textInBox(ctx, box) {
  return ctx.text.filter((item) => {
    const center = item.x + item.w / 2;
    return center >= box.x && center <= box.x + box.w
      && item.y >= box.y - EPSILON && item.y + item.h <= box.y + box.h + EPSILON;
  }).sort((a, b) => a.y - b.y || a.x - b.x);
}

// Deliberately conservative glyph widths exercise the actual font fitting and
// drawing paths, including multi-line Polish and hyphenated surnames.
function recordingContext() {
  const stack = [];
  const gradient = { addColorStop: jest.fn() };
  const ctx = {
    font: "800 20px Arial", textAlign: "start", textBaseline: "alphabetic",
    tx: 0, ty: 0, text: [], images: [],
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
      this.text.push({ value: String(value), x: left + this.tx, y: top + this.ty, w: metrics.width, h: size });
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

function fixture(category, formation, theme, rows) {
  const form = {
    category, formation, theme, leagueCode: "1st", seasonYear: 2026, periodType: "season",
    bestEightSponsorRows: rows, sponsorRows: rows,
    lineup: NAMES.map((name, index) => ({ name, logoUrl: `club-${index}`,
      positionLabel: FORMATIONS.find(({ id }) => id === formation).slots[index].label.replace("NAP", "ŚN") })),
    seasonHonours: {
      year: 2026, champion: "Towarzystwo Sportowe Brzęczyszczykiewicz-Sulejówek", championLogo: "champion",
      awards: CATEGORIES.map((category, index) => ({
        category, name: NAMES[index], team: "Stowarzyszenie Sportowe Konstantynopolitańczycy-Sulejówek",
        logoUrl: `club-${index}`, stat: ["MVP", "50 goli", "26 asyst", ""][index],
      })),
    },
  };
  const crests = ["champion", ...NAMES.map((_, index) => `club-${index}`)].map((id, index) => ({
    id, naturalWidth: index % 2 ? 80 : 140, naturalHeight: index % 2 ? 140 : 80,
  }));
  const sponsors = PARTNERS.map(({ id }) => ({ id, naturalWidth: 220, naturalHeight: 100 }));
  return { form, images: {
    brand: null, teamLogos: new Map(crests.map((crest) => [crest.id, crest])),
    sponsorList: PARTNERS, sponsors: new Map(sponsors.map((sponsor) => [sponsor.id, sponsor])),
  }, crests, sponsors };
}

function bounds(form, layout) {
  const headerBottom = form.category === "season-best-eight" ? getBestEightHeaderLayout(layout).contentTop
    : Math.round(layout.height * (layout.isStory ? 0.045 : 0.05)) + (layout.isStory ? 134 : 106);
  const champion = getSeasonChampionLayout(layout, headerBottom);
  const panel = getSponsorPanelLayout(form, PARTNERS, layout);
  return { champion, panel, top: champion.contentTop, bottom: panel.panelY - (layout.isStory ? 30 : 22) };
}

describe("official season graphics", () => {
  let canvasContext;
  beforeEach(() => {
    canvasContext = jest.spyOn(HTMLCanvasElement.prototype, "getContext").mockImplementation(() => recordingContext());
  });
  afterEach(() => canvasContext.mockRestore());

  test("uses season titles and the official year, unaffected by old period choices", () => {
    ["season-best-eight", "season-awards"].forEach((category) => {
      const form = { category, leagueCode: "3rd", seasonYear: 2025, periodLabel: "Wrzesień", seasonHonours: { year: 2026 } };
      expect(titleForForm(form)).toBe(category === "season-best-eight" ? "Ósemka sezonu" : "Wyróżnienia sezonu");
      expect(subtitleForForm(form)).toBe("III Liga · Sezon 2026");
    });
  });

  const CASES = FORMATS.flatMap((layout) => THEMES.flatMap((theme) => [1, 2, 3, 4].map((rows) =>
    [layout.format, theme, rows, layout])));

  test.each(CASES)("fits all four awards and champion without crest/text collisions: %s %s, %i partner rows", (format, theme, rows, layout) => {
    const { form, images, crests, sponsors } = fixture("season-awards", "3-3-1", theme, rows);
    const ctx = recordingContext();
    drawGraphic(ctx, form, {}, images, layout.width, layout.height);
    const { top, bottom, champion, panel } = bounds(form, layout);
    const { area, cards } = getSeasonAwardsLayout(layout, top, bottom);
    inside(area, { x: 0, y: top, w: layout.width, h: bottom - top });
    const contentText = [];
    cards.forEach(({ index, card, category, logo, name, team, stat }) => {
      const regions = [category, logo, name, team, stat];
      regions.forEach((box, i) => {
        inside(box, card);
        expect(box.w).toBeGreaterThan(0);
        expect(box.h).toBeGreaterThan(0);
        regions.slice(i + 1).forEach((other) => expect(separated(box, other, 4)).toBe(true));
      });
      [[category, CATEGORIES[index]], [name, formatBestEightPlayerName(NAMES[index])],
        [team, form.seasonHonours.awards[index].team], [stat, form.seasonHonours.awards[index].stat]]
        .forEach(([box, expected]) => {
          const rendered = textInBox(ctx, box);
          expect(normalized(rendered.map(({ value }) => value).join(" "))).toBe(normalized(expected));
          rendered.forEach((text) => inside(text, box));
          contentText.push(...rendered);
        });
      const crest = ctx.images.filter(({ image }) => image.id === `club-${index}`);
      expect(crest).toHaveLength(1);
      inside(crest[0], logo);
    });
    [champion.label, champion.name].forEach((box) => {
      const text = textInBox(ctx, box);
      expect(text.length).toBeGreaterThan(0);
      text.forEach((item) => inside(item, box));
      contentText.push(...text);
    });
    expect(normalized(textInBox(ctx, champion.name).map(({ value }) => value).join(" ")))
      .toBe(normalized(form.seasonHonours.champion));
    const drawnCrests = ctx.images.filter(({ image }) => crests.includes(image));
    expect(drawnCrests).toHaveLength(5);
    contentText.forEach((text, index) => {
      drawnCrests.forEach((crest) => expect(separated(text, crest, 2)).toBe(true));
      contentText.slice(index + 1).forEach((other) => expect(separated(text, other)).toBe(true));
      expect(text.y + text.h).toBeLessThan(panel.panelY);
    });
    sponsors.forEach((sponsor) => {
      const drawn = ctx.images.filter(({ image }) => image === sponsor);
      expect(drawn).toHaveLength(1);
      expect(drawn[0].y).toBeGreaterThan(panel.panelY);
    });
  });

  test.each(CASES)("fits official positions and initials in every formation: %s %s, %i partner rows", (format, theme, rows, layout) => {
    FORMATIONS.forEach(({ id: formation }) => {
      const { form, images, crests } = fixture("season-best-eight", formation, theme, rows);
      // Two central defenders may intentionally share the same official label.
      if (formation === "2-3-2") form.lineup[1].positionLabel = form.lineup[2].positionLabel = "ŚO";
      const ctx = recordingContext();
      drawGraphic(ctx, form, {}, images, layout.width, layout.height);
      const { top, bottom, champion, panel } = bounds(form, layout);
      const { pitch, players } = getBestEightLayout(form, layout, top, bottom);
      const actualCrests = ctx.images.filter(({ image }) => crests.includes(image));
      expect(actualCrests).toHaveLength(9);
      const regions = [];
      const renderedText = [];
      players.forEach((player) => {
        expect(player.label).toBe(form.lineup[player.index].positionLabel);
        [player.position, player.logo, player.name].forEach((box) => {
          inside(box, pitch);
          expect(box.w).toBeGreaterThan(0);
          expect(box.h).toBeGreaterThan(0);
          regions.push(box);
        });
        const name = textInBox(ctx, player.name);
        expect(normalized(name.map(({ value }) => value).join(" "))).toBe(normalized(formatBestEightPlayerName(NAMES[player.index])));
        const label = textInBox(ctx, player.position);
        expect(label.map(({ value }) => value)).toEqual([player.label]);
        renderedText.push(...name, ...label);
      });
      regions.forEach((box, i) => regions.slice(i + 1).forEach((other) => expect(separated(box, other, 2)).toBe(true)));
      renderedText.forEach((text, i) => {
        actualCrests.forEach((crest) => expect(separated(text, crest, 2)).toBe(true));
        renderedText.slice(i + 1).forEach((other) => expect(separated(text, other)).toBe(true));
        expect(text.y).toBeGreaterThan(champion.band.y + champion.band.h);
        expect(text.y + text.h).toBeLessThan(panel.panelY);
      });
      expect(ctx.text.some(({ value }) => value === "NAP" || value === "BP")).toBe(false);
    });
  });

  test.each(FORMATS)("shows missing selections clearly without inventing winners in $format", (layout) => {
    ["season-best-eight", "season-awards"].forEach((category) => {
      const { form, images } = fixture(category, "3-3-1", "stadium", 3);
      form.lineup = [];
      form.seasonHonours = null;
      const ctx = recordingContext();
      expect(() => drawGraphic(ctx, form, {}, images, layout.width, layout.height)).not.toThrow();
      const rendered = ctx.text.map(({ value }) => value).join(" ");
      expect(rendered).toContain(category === "season-best-eight" ? "Brak zatwierdzonej ósemki sezonu" : "Brak kompletu zatwierdzonych wyróżnień");
      expect(rendered).toContain("Nie wskazano mistrza");
      expect(rendered).not.toContain("Zawodnik");
      expect(rendered).not.toContain("MVP");
    });
  });

  test.each(FORMATS)("retains names and team labels when all club logos fail in $format", (layout) => {
    const { form, images } = fixture("season-awards", "3-3-1", "clean", 4);
    images.teamLogos = new Map();
    const ctx = recordingContext();
    drawGraphic(ctx, form, {}, images, layout.width, layout.height);
    expect(ctx.text.filter(({ value }) => value === "MLPN")).toHaveLength(4);
    const { top, bottom } = bounds(form, layout);
    getSeasonAwardsLayout(layout, top, bottom).cards.forEach(({ index, name }) => {
      expect(normalized(textInBox(ctx, name).map(({ value }) => value).join(" ")))
        .toBe(normalized(formatBestEightPlayerName(NAMES[index])));
    });
  });
});
