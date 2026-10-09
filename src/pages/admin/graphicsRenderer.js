// MLPN social-media graphics renderer (HTML canvas).
// Draws clean, brand-consistent POST/STORY graphics for the admin "Kreator grafik".
// Pure module: receives pre-loaded images, no DOM/data fetching.

import {
  getTablePositions,
  isTableRowDimmed,
  resolveTableRange,
} from "./utils/graphicsTableRange";
import { formatWeekendRange, sortMatchesChronologically, sortMatchesForGraphic } from "./utils/graphicsWeekend";
import { getGraphicTeamAbbreviation } from "./utils/graphicsTeamAbbreviations";

// Full brand lockup (eagle + "MLPN SULEJÓWEK" + "isola RISTORANTE"), white version for dark art.
export const BRAND_LOGO_SRC = "/logo2big.webp";

/* ============================== PALETTE / THEMES ============================== */

const BRAND = {
  navy: "#0f2a4a",
  navyDeep: "#081a30",
  navyMid: "#123256",
  line: "#22456e",
  steel: "#5f8bb5",
  steelSoft: "#9cbcda",
  gold: "#e7b23c",
  goldSoft: "#f6d27a",
  paper: "#f4f6f9",
  paperEdge: "#e5eaf1",
  ink: "#0d1b2c",
  white: "#ffffff",
};

const LEAGUE_ACCENTS = {
  "1st": "#d9313a",
  "2nd": "#e7b23c",
  "3rd": "#4fb268",
};

function themeConfig(theme) {
  if (theme === "clean") {
    return {
      dark: false,
      bgTop: "#eef2f7",
      bgBottom: "#dbe4ef",
      glow: "rgba(255,255,255,0.65)",
      text: BRAND.ink,
      textSoft: "rgba(13,27,44,0.62)",
      panel: "rgba(15,42,74,0.05)",
      panelLine: "rgba(15,42,74,0.12)",
    };
  }
  if (theme === "blue-red") {
    return {
      dark: true,
      bgTop: "#16375d",
      bgBottom: "#0a1d33",
      glow: "rgba(231,178,60,0.16)",
      text: BRAND.white,
      textSoft: "rgba(255,255,255,0.66)",
      panel: "rgba(255,255,255,0.07)",
      panelLine: "rgba(255,255,255,0.14)",
    };
  }
  // stadium (default, dark)
  return {
    dark: true,
    bgTop: "#123256",
    bgBottom: "#081a30",
    glow: "rgba(95,139,181,0.22)",
    text: BRAND.white,
    textSoft: "rgba(255,255,255,0.66)",
    panel: "rgba(255,255,255,0.06)",
    panelLine: "rgba(255,255,255,0.13)",
  };
}

/* ============================== CONFIG DATA ============================== */

const LEAGUE_OPTIONS = [
  { value: "1st", label: "I Liga" },
  { value: "2nd", label: "II Liga" },
  { value: "3rd", label: "III Liga" },
];

// 8-a-side formations (GK + 7). Each has exactly 8 slots, mapped by lineup index.
const FORMATIONS = [
  {
    id: "3-3-1",
    label: "3-3-1",
    slots: [
      { label: "BR", x: 0.5, y: 0.9 },
      { label: "LO", x: 0.17, y: 0.68 },
      { label: "ŚO", x: 0.5, y: 0.68 },
      { label: "PO", x: 0.83, y: 0.68 },
      { label: "LP", x: 0.17, y: 0.43 },
      { label: "ŚP", x: 0.5, y: 0.43 },
      { label: "PP", x: 0.83, y: 0.43 },
      { label: "NAP", x: 0.5, y: 0.18 },
    ],
  },
  {
    id: "2-3-2",
    label: "2-3-2",
    slots: [
      { label: "BR", x: 0.5, y: 0.9 },
      { label: "LO", x: 0.3, y: 0.7 },
      { label: "PO", x: 0.7, y: 0.7 },
      { label: "LP", x: 0.2, y: 0.46 },
      { label: "ŚP", x: 0.5, y: 0.46 },
      { label: "PP", x: 0.8, y: 0.46 },
      { label: "LN", x: 0.34, y: 0.2 },
      { label: "PN", x: 0.66, y: 0.2 },
    ],
  },
  {
    id: "3-2-2",
    label: "3-2-2",
    slots: [
      { label: "BR", x: 0.5, y: 0.9 },
      { label: "LO", x: 0.2, y: 0.7 },
      { label: "ŚO", x: 0.5, y: 0.7 },
      { label: "PO", x: 0.8, y: 0.7 },
      { label: "LP", x: 0.3, y: 0.46 },
      { label: "PP", x: 0.7, y: 0.46 },
      { label: "LN", x: 0.34, y: 0.2 },
      { label: "PN", x: 0.66, y: 0.2 },
    ],
  },
  {
    id: "2-4-1",
    label: "2-4-1",
    slots: [
      { label: "BR", x: 0.5, y: 0.9 },
      { label: "LO", x: 0.3, y: 0.72 },
      { label: "PO", x: 0.7, y: 0.72 },
      { label: "LP", x: 0.16, y: 0.46 },
      { label: "LŚ", x: 0.39, y: 0.46 },
      { label: "PŚ", x: 0.61, y: 0.46 },
      { label: "PP", x: 0.84, y: 0.46 },
      { label: "NAP", x: 0.5, y: 0.2 },
    ],
  },
];

function getFormation(id) {
  return FORMATIONS.find((formation) => formation.id === id) || FORMATIONS[0];
}

// Row 1 = 7 partners, Row 2 = 5 partners (Isola featured, centre).
const SPONSORS_TOP = [
  { id: "lemaj", name: "LEMAJ", src: "/loading-sponsors/100-lemaj-pl.webp" },
  { id: "jadlostacja", name: "Jadłostacja", src: "/loading-sponsors/110-jad-ostacja-sulejowek.webp" },
  { id: "pobudka", name: "Pobudka", src: "/loading-sponsors/120-pobudka-catering.webp" },
  { id: "naszestroje", name: "naszestroje.pl", src: "/naszestroje.png" },
  { id: "oslony", name: "OsłonyDoOkien", src: "/loading-sponsors/130-os-onydookien-pl.webp" },
  { id: "amerpol", name: "AMER-POL", src: "/loading-sponsors/140-amer-pol.webp" },
  { id: "pael", name: "PA-EL", src: "/loading-sponsors/150-pa-el-fasady.webp" },
];

const SPONSORS_BOTTOM = [
  { id: "sidap", name: "SiDAP Energy", src: "/loading-sponsors/160-sidap-energy.webp" },
  { id: "szwagier", name: "Szwagier-Kop", src: "/loading-sponsors/170-szwagier-kop.webp" },
  { id: "isola", name: "Isola Ristorante", src: "/loading-sponsors/000-isola-ristorante.webp", title: true },
  { id: "robo", name: "RoboExpert", src: "/loading-sponsors/180-roboexpert.webp" },
  { id: "hamag", name: "HAMAG", src: "/loading-sponsors/190-hamag-fotowoltaika.webp" },
];

/* ============================== SMALL UTILS ============================== */

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function romanRound(value) {
  const number = Number(value || 0);
  const map = [[50, "L"], [40, "XL"], [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]];
  if (!Number.isFinite(number) || number <= 0) return "";
  let remaining = Math.min(number, 59);
  let output = "";
  for (const [arabic, roman] of map) {
    while (remaining >= arabic) {
      output += roman;
      remaining -= arabic;
    }
  }
  return output;
}

function getLeague(leagueCode) {
  return LEAGUE_OPTIONS.find((item) => item.value === leagueCode) || LEAGUE_OPTIONS[0];
}

function getImage(imageMap, url) {
  return imageMap.get(String(url || "")) || null;
}

function formatShortDate(value) {
  if (!value) return "";
  const date = new Date(`${value}T12:00:00`);
  if (Number.isNaN(date.getTime())) return value;
  return new Intl.DateTimeFormat("pl-PL", { day: "2-digit", month: "2-digit" }).format(date);
}

function isCompletedStatus(status) {
  return ["completed", "walkover_home", "walkover_away"].includes(String(status || ""));
}

function getPeriodLabel(form) {
  if (form.category === "table-summary") return "Sezon";
  if (form.periodLabel && form.periodLabel.trim()) return form.periodLabel.trim();
  if (form.periodType === "round") return "Runda";
  if (form.periodType === "season") return `Sezon ${form.seasonYear || ""}`.trim();
  return "Miesiąc";
}

function titleForForm(form) {
  if (form.title && form.title.trim()) return form.title.trim();
  const roundText = form.round ? `${romanRound(form.round)} kolejka` : "Kolejka";
  if (form.category === "round-typer") return "Typer weekendu";
  if (form.category === "round-preview") {
    return form.previewScope === "weekend"
      ? formatWeekendRange(form.previewWeekendStart, { includeYear: false }) || "Weekend"
      : roundText;
  }
  if (form.category === "round-results") {
    return form.resultsScope === "weekend"
      ? formatWeekendRange(form.weekendStart, { includeYear: false }) || "Weekend"
      : roundText;
  }
  if (form.category === "best-eight") return `Ósemka ${form.periodType === "season" ? "sezonu" : form.periodType === "round" ? "rundy" : "miesiąca"}`;
  if (form.category === "player-award") return "Zawodnik okresu";
  if (form.category === "player-vote") return "Głosowanie kibiców";
  if (form.category === "table-summary") return "Tabela ligi";
  return "MLPN";
}

function subtitleForForm(form) {
  if (form.subtitle && form.subtitle.trim()) return form.subtitle.trim();
  if (form.category === "round-typer") {
    return formatWeekendRange(form.typerWeekendStart, { includeYear: false }) || "Wybierz weekend";
  }
  if (form.category === "round-preview") {
    if (form.previewScope === "weekend") {
      return "Zapowiedź weekendu";
    }
    return "Zapowiedź";
  }
  if (form.category === "round-results") {
    if (form.resultsScope === "weekend") {
      return "Wyniki weekendu";
    }
    return "Wyniki";
  }
  if (["best-eight", "player-award", "player-vote", "table-summary"].includes(form.category)) {
    return `${getLeague(form.leagueCode).label} · ${getPeriodLabel(form)}`;
  }
  return "";
}

/* ============================== CANVAS PRIMITIVES ============================== */

const FONT = "Montserrat, 'Segoe UI', Arial, sans-serif";

function roundRect(ctx, x, y, w, h, r) {
  const radius = Math.min(r, w / 2, h / 2);
  ctx.beginPath();
  ctx.moveTo(x + radius, y);
  ctx.arcTo(x + w, y, x + w, y + h, radius);
  ctx.arcTo(x + w, y + h, x, y + h, radius);
  ctx.arcTo(x, y + h, x, y, radius);
  ctx.arcTo(x, y, x + w, y, radius);
  ctx.closePath();
}

function fillRoundRect(ctx, x, y, w, h, r, fill, stroke, lineWidth = 1) {
  roundRect(ctx, x, y, w, h, r);
  if (fill) {
    ctx.fillStyle = fill;
    ctx.fill();
  }
  if (stroke) {
    ctx.strokeStyle = stroke;
    ctx.lineWidth = lineWidth;
    ctx.stroke();
  }
}

function setFont(ctx, size, weight = 800) {
  ctx.font = `${weight} ${size}px ${FONT}`;
}

// Fit text into maxWidth (shrinking), then draw. Supports letter-spacing (tracking).
function drawText(ctx, text, x, y, opts = {}) {
  const {
    size = 40,
    minSize = 12,
    weight = 800,
    color = "#fff",
    align = "center",
    baseline = "middle",
    maxWidth = Infinity,
    tracking = 0,
    upper = false,
    shadow = null,
  } = opts;
  let str = String(text == null ? "" : text);
  if (upper) str = str.toUpperCase();

  const measure = (s) => {
    if (!tracking) return ctx.measureText(s).width;
    let w = 0;
    for (const ch of s) w += ctx.measureText(ch).width + tracking;
    return w - tracking;
  };

  let fontSize = size;
  setFont(ctx, fontSize, weight);
  while (fontSize > minSize && measure(str) > maxWidth) {
    fontSize -= 1;
    setFont(ctx, fontSize, weight);
  }
  if (Number.isFinite(maxWidth) && maxWidth > 0 && measure(str) > maxWidth) {
    const ellipsis = "...";
    let next = str;
    while (next.length > 1 && measure(`${next}${ellipsis}`) > maxWidth) {
      next = next.slice(0, -1);
    }
    str = next.length > 1 ? `${next}${ellipsis}` : ellipsis;
  }

  ctx.save();
  if (shadow) {
    ctx.shadowColor = shadow.color || "rgba(0,0,0,0.35)";
    ctx.shadowBlur = shadow.blur ?? 8;
    ctx.shadowOffsetY = shadow.offsetY ?? 3;
  }
  ctx.fillStyle = color;
  ctx.textBaseline = baseline;

  if (!tracking) {
    ctx.textAlign = align;
    ctx.fillText(str, x, y);
  } else {
    const total = measure(str);
    let cursor = align === "center" ? x - total / 2 : align === "right" ? x - total : x;
    ctx.textAlign = "left";
    for (const ch of str) {
      ctx.fillText(ch, cursor, y);
      cursor += ctx.measureText(ch).width + tracking;
    }
  }
  ctx.restore();
  return fontSize;
}

function wrapLines(ctx, text, maxWidth) {
  const words = String(text || "").replace(/\s+/g, " ").trim().split(" ").filter(Boolean);
  const lines = [];
  let current = "";
  words.forEach((word) => {
    const candidate = current ? `${current} ${word}` : word;
    if (!current || ctx.measureText(candidate).width <= maxWidth) current = candidate;
    else {
      lines.push(current);
      current = word;
    }
  });
  if (current) lines.push(current);
  return lines;
}

function drawWrapped(ctx, text, x, y, opts = {}) {
  const { size = 30, weight = 700, color = "#fff", align = "center", maxWidth = 400, lineHeight, maxLines = 3 } = opts;
  setFont(ctx, size, weight);
  ctx.fillStyle = color;
  ctx.textAlign = align;
  ctx.textBaseline = "top";
  const lh = lineHeight || size * 1.2;
  const lines = wrapLines(ctx, text, maxWidth).slice(0, maxLines);
  lines.forEach((line, i) => ctx.fillText(line, x, y + i * lh));
  return lines.length * lh;
}

function drawImageContain(ctx, image, x, y, w, h, pad = 0) {
  if (!image || !image.naturalWidth) return false;
  const bw = w - pad * 2;
  const bh = h - pad * 2;
  const ratio = image.naturalWidth / image.naturalHeight;
  let dw = bw;
  let dh = bh;
  if (ratio > bw / bh) dh = bw / ratio;
  else dw = bh * ratio;
  try {
    ctx.drawImage(image, x + pad + (bw - dw) / 2, y + pad + (bh - dh) / 2, dw, dh);
    return true;
  } catch {
    return false;
  }
}

function containDrawRect(image, x, y, w, h, pad = 0) {
  if (!image || !image.naturalWidth) return null;
  const bw = w - pad * 2;
  const bh = h - pad * 2;
  if (bw <= 0 || bh <= 0) return null;
  const ratio = image.naturalWidth / image.naturalHeight;
  let dw = bw;
  let dh = bh;
  if (ratio > bw / bh) dh = bw / ratio;
  else dw = bh * ratio;
  return { x: x + pad + (bw - dw) / 2, y: y + pad + (bh - dh) / 2, w: dw, h: dh };
}

function drawOutlinedLogo(ctx, image, x, y, w, h, fallback = "", pad = 0) {
  const rect = containDrawRect(image, x, y, w, h, pad);
  if (!rect) {
    drawText(ctx, fallback, x + w / 2, y + h / 2, {
      size: Math.min(w, h) * 0.28,
      minSize: 9,
      weight: 900,
      color: BRAND.navy,
      maxWidth: w * 0.82,
    });
    return false;
  }

  const mask = document.createElement("canvas");
  mask.width = Math.max(1, Math.ceil(w));
  mask.height = Math.max(1, Math.ceil(h));
  const maskCtx = mask.getContext("2d");
  maskCtx.drawImage(image, rect.x - x, rect.y - y, rect.w, rect.h);
  maskCtx.globalCompositeOperation = "source-in";
  maskCtx.fillStyle = "#858585";
  maskCtx.fillRect(0, 0, mask.width, mask.height);

  const outline = Math.max(0.5, Math.min(8, Math.min(w, h) * 0.016));
  ctx.save();
  ctx.globalAlpha = 1;
  Array.from({ length: 24 }).forEach((_, index) => {
    const angle = (Math.PI * 2 * index) / 24;
    ctx.drawImage(mask, x + Math.cos(angle) * outline, y + Math.sin(angle) * outline, w, h);
  });
  ctx.globalAlpha = 0.45;
  ctx.shadowColor = "#858585";
  ctx.shadowBlur = 12;
  ctx.drawImage(mask, x, y, w, h);
  ctx.restore();

  ctx.drawImage(image, rect.x, rect.y, rect.w, rect.h);
  return true;
}

function drawImageCover(ctx, image, x, y, w, h) {
  if (!image || !image.naturalWidth) return false;
  const ratio = image.naturalWidth / image.naturalHeight;
  let dw = w;
  let dh = h;
  if (ratio > w / h) dw = h * ratio;
  else dh = w / ratio;
  try {
    ctx.drawImage(image, x + (w - dw) / 2, y + (h - dh) / 2, dw, dh);
    return true;
  } catch {
    return false;
  }
}

/* ============================== SPONSOR FRAMES ============================== */
// Per-logo framing (zoom + offset + optional backing) so every partner logo fills its
// cell cleanly. Edited per sponsor in the Sponsors tab, saved to localStorage, keyed by id.
export const SPONSOR_FRAMES_KEY = "mlpn_graphics_sponsor_frames";

// Width:height of a partner cell — identical in the graphic and the crop preview (WYSIWYG).
export const SPONSOR_CELL_ASPECT = 2.2;

export function defaultFrame() {
  return {
    scale: 1,
    x: 0,
    y: 0,
    bg: "light",
    mode: "fit",
    glow: true,
    glowAutoColor: false,
    glowColor: "#858585",
    glowSize: 0.016,
    glowStrength: 1,
    glowDensity: 24,
    glowBlur: 12,
  };
}

function normalizeColor(value, fallback = "#000000") {
  const color = String(value || "").trim();
  return /^#[0-9a-f]{6}$/i.test(color) ? color : fallback;
}

export function normalizeSponsorFrame(frame) {
  const source = frame && typeof frame === "object" ? frame : {};
  const scale = Number(source.scale);
  const x = Number(source.x);
  const y = Number(source.y);
  const bg = ["auto", "none", "light", "dark"].includes(source.bg) ? source.bg : "auto";
  const mode = ["fit", "fill"].includes(source.mode) ? source.mode : "fit";
  const glowSize = Number(source.glowSize);
  const glowStrength = Number(source.glowStrength);
  const glowDensity = Number(source.glowDensity);
  const legacyGradient = Number(source.glowGradient);
  const glowBlur = Number(source.glowBlur ?? (Number.isFinite(legacyGradient) ? legacyGradient * 8 : undefined));

  return {
    scale: clamp(Number.isFinite(scale) ? scale : 1, 1, 3),
    x: clamp(Number.isFinite(x) ? x : 0, -0.6, 0.6),
    y: clamp(Number.isFinite(y) ? y : 0, -0.6, 0.6),
    bg,
    mode,
    glow: true,
    glowAutoColor: source.glowAutoColor === true,
    glowColor: normalizeColor(source.glowColor, "#858585"),
    glowSize: clamp(Number.isFinite(glowSize) ? glowSize : 0.016, 0.004, 0.09),
    glowStrength: clamp(Number.isFinite(glowStrength) ? glowStrength : 1, 0.05, 1),
    glowDensity: clamp(Number.isFinite(glowDensity) ? glowDensity : 24, 4, 24),
    glowBlur: clamp(Number.isFinite(glowBlur) ? glowBlur : 12, 0, 16),
  };
}

export function loadAllFrames() {
  try {
    return JSON.parse((typeof localStorage !== "undefined" && localStorage.getItem(SPONSOR_FRAMES_KEY)) || "{}") || {};
  } catch {
    return {};
  }
}

export function getSponsorFrame(id) {
  const all = loadAllFrames();
  return normalizeSponsorFrame({ ...defaultFrame(), ...(all[id] || {}) });
}

export function setSponsorFrame(id, frame) {
  const all = loadAllFrames();
  all[id] = normalizeSponsorFrame(frame);
  try {
    localStorage.setItem(SPONSOR_FRAMES_KEY, JSON.stringify(all));
  } catch {
    /* storage unavailable — ignore */
  }
}

export function clearSponsorFrame(id) {
  const all = loadAllFrames();
  delete all[id];
  try {
    localStorage.setItem(SPONSOR_FRAMES_KEY, JSON.stringify(all));
  } catch {
    /* ignore */
  }
}

// Sponsor logos are a mix of white (for dark bg) and dark/colour art — detect brightness
// so an unset backing ("auto") can pick a light plate for dark logos on the dark band.
const lumCache = new Map();
function isLightLogo(image) {
  if (!image || !image.naturalWidth) return true;
  const key = image.src || image;
  if (lumCache.has(key)) return lumCache.get(key);
  try {
    const s = 34;
    const c = document.createElement("canvas");
    c.width = s;
    c.height = s;
    const cx = c.getContext("2d", { willReadFrequently: true });
    cx.drawImage(image, 0, 0, s, s);
    const data = cx.getImageData(0, 0, s, s).data;
    let sum = 0;
    let count = 0;
    for (let i = 0; i < data.length; i += 4) {
      if (data[i + 3] < 40) continue;
      sum += 0.2126 * data[i] + 0.7152 * data[i + 1] + 0.0722 * data[i + 2];
      count += 1;
    }
    const light = count ? sum / count > 140 : true;
    lumCache.set(key, light);
    return light;
  } catch {
    lumCache.set(key, false);
    return false;
  }
}

/* ============================== SHARED COMPONENTS ============================== */

// League crest on a soft white rounded tile.
function drawCrest(ctx, image, x, y, size, fallback, dark) {
  fillRoundRect(ctx, x, y, size, size, size * 0.24, dark ? "rgba(255,255,255,0.94)" : "#ffffff", "rgba(9,20,35,0.10)", 1.5);
  const drawn = drawImageContain(ctx, image, x, y, size, size, size * 0.14);
  if (!drawn) {
    drawText(ctx, fallback, x + size / 2, y + size / 2, {
      size: size * 0.3,
      minSize: 9,
      weight: 900,
      color: BRAND.navy,
      maxWidth: size * 0.82,
    });
  }
}

// Circular player photo.
function drawCirclePhoto(ctx, image, cx, cy, r, ringColor) {
  ctx.save();
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.closePath();
  ctx.clip();
  ctx.fillStyle = "#dfe6ee";
  ctx.fillRect(cx - r, cy - r, r * 2, r * 2);
  if (!drawImageCover(ctx, image, cx - r, cy - r, r * 2, r * 2)) {
    // silhouette
    ctx.fillStyle = "#b9c6d6";
    ctx.beginPath();
    ctx.arc(cx, cy - r * 0.22, r * 0.42, 0, Math.PI * 2);
    ctx.fill();
    ctx.beginPath();
    ctx.moveTo(cx - r * 0.62, cy + r);
    ctx.quadraticCurveTo(cx, cy + r * 0.1, cx + r * 0.62, cy + r);
    ctx.closePath();
    ctx.fill();
  }
  ctx.restore();
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.strokeStyle = ringColor || BRAND.gold;
  ctx.lineWidth = Math.max(3, r * 0.05);
  ctx.stroke();
}

/* ============================== BACKGROUND ============================== */

function drawBackground(ctx, width, height, form, layout) {
  const t = layout.t;
  const bg = ctx.createLinearGradient(0, 0, width * 0.35, height);
  bg.addColorStop(0, t.bgTop);
  bg.addColorStop(1, t.bgBottom);
  ctx.fillStyle = bg;
  ctx.fillRect(0, 0, width, height);

  // soft glow behind the header
  const glow = ctx.createRadialGradient(width * 0.5, height * 0.16, 0, width * 0.5, height * 0.16, width * 0.75);
  glow.addColorStop(0, t.glow);
  glow.addColorStop(1, "rgba(0,0,0,0)");
  ctx.fillStyle = glow;
  ctx.fillRect(0, 0, width, height);

  // Smooth depth instead of hard horizontal bands.
  const depth = ctx.createLinearGradient(0, height * 0.22, 0, height);
  if (t.dark) {
    depth.addColorStop(0, "rgba(255,255,255,0.035)");
    depth.addColorStop(0.38, "rgba(255,255,255,0)");
    depth.addColorStop(1, "rgba(0,0,0,0.3)");
  } else {
    depth.addColorStop(0, "rgba(255,255,255,0.2)");
    depth.addColorStop(0.45, "rgba(255,255,255,0)");
    depth.addColorStop(1, "rgba(15,42,74,0.12)");
  }
  ctx.fillStyle = depth;
  ctx.fillRect(0, 0, width, height);

  const vignette = ctx.createRadialGradient(width * 0.5, height * 0.46, width * 0.1, width * 0.5, height * 0.46, width * 0.86);
  vignette.addColorStop(0, "rgba(0,0,0,0)");
  vignette.addColorStop(1, t.dark ? "rgba(0,0,0,0.28)" : "rgba(15,42,74,0.08)");
  ctx.fillStyle = vignette;
  ctx.fillRect(0, 0, width, height);

  // thin accent hairline near top
  ctx.fillStyle = form.accentColor || BRAND.gold;
  ctx.globalAlpha = 0.9;
  ctx.fillRect(0, 0, width, Math.max(6, height * 0.006));
  ctx.globalAlpha = 1;
}

/* ============================== HEADER ============================== */

export function getBestEightHeaderLayout(layout) {
  const { width, isStory } = layout;
  const y = isStory ? 64 : 28;
  const h = isStory ? 166 : 126;
  return {
    logo: { x: width * 0.055, y, w: width * 0.15, h },
    title: { x: width * 0.23, y, w: width * 0.51, h },
    context: { x: width * 0.77, y, w: width * 0.18, h },
    contentTop: isStory ? 280 : 178,
  };
}

function drawBestEightHeader(ctx, form, images, layout) {
  const { logo, title, context, contentTop } = getBestEightHeaderLayout(layout);
  const dark = layout.t.dark;
  if (!dark) fillRoundRect(ctx, logo.x, logo.y, logo.w, logo.h, 12, BRAND.navy);
  drawImageContain(ctx, images.brand, logo.x + 8, logo.y + 4, logo.w - 16, logo.h - 8);
  const cx = title.x + title.w / 2;
  if (form.title?.trim()) {
    const plan = getBestEightNameLayout(ctx, form.title.trim().toUpperCase(), title, layout.isStory ? 64 : 52);
    drawBestEightName(ctx, plan, title, layout.t.text);
  } else {
    drawText(ctx, "ÓSEMKA", cx, title.y + title.h * 0.36, {
      size: layout.isStory ? 96 : 82, weight: 900, color: layout.t.text, maxWidth: title.w,
    });
    const period = form.periodType === "season" ? "SEZONU" : form.periodType === "round" ? "RUNDY" : "MIESIĄCA";
    drawText(ctx, period, cx, title.y + title.h * 0.81, {
      size: layout.isStory ? 54 : 43, weight: 800, color: dark ? BRAND.goldSoft : BRAND.navy,
      maxWidth: title.w, tracking: 3,
    });
  }
  const accent = LEAGUE_ACCENTS[form.leagueCode] || BRAND.gold;
  const badgeH = layout.isStory ? 54 : 42;
  const badgeY = context.y + context.h * 0.16;
  fillRoundRect(ctx, context.x, badgeY, context.w, badgeH, 6, accent);
  drawText(ctx, getLeague(form.leagueCode).label.toUpperCase(), context.x + context.w / 2, badgeY + badgeH / 2, {
    size: layout.isStory ? 32 : 27, weight: 900,
    color: form.leagueCode === "2nd" ? BRAND.ink : BRAND.white, maxWidth: context.w - 16,
  });
  const period = getPeriodLabel(form);
  const year = String(form.seasonYear || "").trim();
  const date = form.subtitle?.trim() || [period, year && !period.includes(year) ? year : ""].filter(Boolean).join(" ");
  const dateBox = { x: context.x, y: badgeY + badgeH + 12, w: context.w, h: context.h * 0.36 };
  drawBestEightName(ctx, getBestEightNameLayout(ctx, date.toUpperCase(), dateBox, layout.isStory ? 25 : 21), dateBox, layout.t.textSoft);
  return contentTop;
}

function drawHeader(ctx, form, images, layout) {
  if (form.category === "best-eight") return drawBestEightHeader(ctx, form, images, layout);
  const { width, M, t } = layout;
  const top = layout.headerTop;
  const isStory = layout.isStory;

  // Compact lockup: logo and title sit side by side so the header stays a thin
  // strip and the table/content below gets the room.
  const logoH = isStory ? 108 : 86;
  const logoW = logoH; // square lockup
  const logoX = M;
  const logoY = top;
  ctx.save();
  ctx.shadowColor = "rgba(0,0,0,0.35)";
  ctx.shadowBlur = 18;
  ctx.shadowOffsetY = 5;
  drawImageContain(ctx, images.brand, logoX, logoY, logoW, logoH);
  ctx.restore();

  // Context pill (league / season), top-right, vertically centred on the logo.
  const pillText = form.category && form.category.startsWith("round")
    ? `SEZON ${form.seasonYear || ""}`.trim()
    : getLeague(form.leagueCode).label.toUpperCase();
  const pillAccent = form.category && form.category.startsWith("round")
    ? BRAND.gold
    : LEAGUE_ACCENTS[form.leagueCode] || BRAND.gold;
  const pillCy = logoY + logoH / 2;
  drawPill(ctx, pillText, width - M, pillCy, pillAccent, layout);

  setFont(ctx, isStory ? 30 : 26, 900);
  const pillPadX = isStory ? 30 : 26;
  const pillW = ctx.measureText(pillText.toUpperCase()).width + pillPadX * 2 + 4;

  // Title block to the right of the logo, reserving space for the pill on the right.
  const titleX = logoX + logoW + (isStory ? 26 : 20);
  const titleMaxW = Math.max(120, width - M - pillW - (isStory ? 24 : 18) - titleX);
  const cy = logoY + logoH / 2;
  const sub = subtitleForForm(form);
  const titleSize = isStory ? 48 : 39;
  const subSize = isStory ? 25 : 20;

  if (sub) {
    const titleY = cy - (isStory ? 16 : 13);
    const subY = titleY + (isStory ? 33 : 27);
    drawText(ctx, titleForForm(form), titleX, titleY, {
      size: titleSize,
      minSize: 18,
      weight: 900,
      color: t.text,
      align: "left",
      maxWidth: titleMaxW,
      shadow: t.dark ? { color: "rgba(0,0,0,0.35)", blur: 8, offsetY: 3 } : null,
    });
    drawText(ctx, sub, titleX, subY, {
      size: subSize,
      minSize: 12,
      weight: 800,
      color: t.textSoft,
      align: "left",
      maxWidth: titleMaxW,
      upper: true,
      tracking: 1.5,
    });
  } else {
    drawText(ctx, titleForForm(form), titleX, cy, {
      size: titleSize,
      minSize: 18,
      weight: 900,
      color: t.text,
      align: "left",
      maxWidth: titleMaxW,
      shadow: t.dark ? { color: "rgba(0,0,0,0.35)", blur: 8, offsetY: 3 } : null,
    });
  }

  return logoY + logoH + (isStory ? 26 : 20);
}

function drawSparkle(ctx, cx, cy, r, color) {
  ctx.save();
  ctx.fillStyle = color;
  ctx.beginPath();
  for (let i = 0; i < 4; i += 1) {
    const a = (Math.PI / 2) * i;
    ctx.lineTo(cx + Math.cos(a) * r, cy + Math.sin(a) * r);
    const a2 = a + Math.PI / 4;
    ctx.lineTo(cx + Math.cos(a2) * r * 0.32, cy + Math.sin(a2) * r * 0.32);
  }
  ctx.closePath();
  ctx.fill();
  ctx.restore();
}

function drawPill(ctx, text, rightX, cy, accent, layout) {
  setFont(ctx, layout.isStory ? 30 : 26, 900);
  const padX = layout.isStory ? 30 : 26;
  const w = ctx.measureText(text.toUpperCase()).width + padX * 2 + 4;
  const h = layout.isStory ? 58 : 50;
  const x = rightX - w;
  fillRoundRect(ctx, x, cy - h / 2, w, h, h / 2, accent);
  drawText(ctx, text, x + w / 2, cy, {
    size: layout.isStory ? 30 : 26,
    weight: 900,
    color: accent === BRAND.gold ? BRAND.ink : "#ffffff",
    upper: true,
    tracking: 1,
    maxWidth: w - padX,
  });
}

/* ============================== SPONSOR PANEL ============================== */

// Opaque bounding box of a logo (fraction of the image) so we can auto-trim the
// transparent margin the source files carry. Cached per image.
const bboxCache = new Map();
function opaqueBBox(image) {
  const key = (image && image.src) || image;
  if (bboxCache.has(key)) return bboxCache.get(key);
  const full = { x: 0, y: 0, w: 1, h: 1 };
  try {
    const maxS = 220;
    const s = Math.min(1, maxS / Math.max(image.naturalWidth, image.naturalHeight));
    const cw = Math.max(1, Math.round(image.naturalWidth * s));
    const ch = Math.max(1, Math.round(image.naturalHeight * s));
    const c = document.createElement("canvas");
    c.width = cw;
    c.height = ch;
    const cx = c.getContext("2d", { willReadFrequently: true });
    cx.drawImage(image, 0, 0, cw, ch);
    const data = cx.getImageData(0, 0, cw, ch).data;
    let minX = cw;
    let minY = ch;
    let maxX = -1;
    let maxY = -1;
    for (let y = 0; y < ch; y += 1) {
      for (let x = 0; x < cw; x += 1) {
        if (data[(y * cw + x) * 4 + 3] > 16) {
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }
    if (maxX < minX) {
      bboxCache.set(key, full);
      return full;
    }
    const mx = (maxX - minX + 1) * 0.03;
    const my = (maxY - minY + 1) * 0.03;
    const box = {
      x: Math.max(0, minX - mx) / cw,
      y: Math.max(0, minY - my) / ch,
      w: (Math.min(cw, maxX + 1 + mx) - Math.max(0, minX - mx)) / cw,
      h: (Math.min(ch, maxY + 1 + my) - Math.max(0, minY - my)) / ch,
    };
    bboxCache.set(key, box);
    return box;
  } catch {
    bboxCache.set(key, full);
    return full;
  }
}

// Auto-trim the transparent margin, then let the frame zoom/pan within that content,
// and CONTAIN-fit the result into the cell — so a logo always fills its cell nicely
// and never spills past the edges, whatever the cell size.
function drawImageFramed(ctx, image, x, y, w, h, frame, pad, cellBg = "dark") {
  if (!image || !image.naturalWidth) return false;
  const iw = image.naturalWidth;
  const ih = image.naturalHeight;
  const box = opaqueBBox(image);
  const bw = w - pad * 2;
  const bh = h - pad * 2;
  if (bw <= 0 || bh <= 0) return false;

  const f = normalizeSponsorFrame(frame);
  const contentX = box.x * iw;
  const contentY = box.y * ih;
  const contentW = box.w * iw;
  const contentH = box.h * ih;
  const contentRatio = contentW / contentH;

  const fillMode = f.mode === "fill";
  let baseW = bw;
  let baseH = bh;
  if (fillMode) {
    if (contentRatio > bw / bh) baseW = bh * contentRatio;
    else baseH = bw / contentRatio;
  } else if (contentRatio > bw / bh) {
    baseH = bw / contentRatio;
  } else {
    baseW = bh * contentRatio;
  }

  const appliedScale = fillMode ? f.scale : 1;
  const dw = baseW * appliedScale;
  const dh = baseH * appliedScale;
  const overflowX = Math.max(0, dw - bw);
  const overflowY = Math.max(0, dh - bh);
  const panX = fillMode ? clamp(f.x / 0.6, -1, 1) : 0;
  const panY = fillMode ? clamp(f.y / 0.6, -1, 1) : 0;
  const dx = x + pad + (bw - dw) / 2 - (overflowX / 2) * panX;
  const dy = y + pad + (bh - dh) / 2 - (overflowY / 2) * panY;

  try {
    if (f.glow && frame?.glow !== false) {
      const glowColor = f.glowAutoColor ? (cellBg === "light" ? "#000000" : "#ffffff") : f.glowColor;
      const outline = Math.max(0.5, Math.min(8, Math.min(w, h) * f.glowSize));
      const density = Math.round(f.glowDensity);
      const mask = document.createElement("canvas");
      mask.width = Math.max(1, Math.ceil(w));
      mask.height = Math.max(1, Math.ceil(h));
      const maskCtx = mask.getContext("2d");
      maskCtx.drawImage(image, contentX, contentY, contentW, contentH, dx - x, dy - y, dw, dh);
      maskCtx.globalCompositeOperation = "source-in";
      maskCtx.fillStyle = glowColor;
      maskCtx.fillRect(0, 0, mask.width, mask.height);

      ctx.save();
      ctx.globalAlpha = f.glowStrength;
      Array.from({ length: density }).forEach((_, index) => {
        const angle = (Math.PI * 2 * index) / density;
        const ox = Math.cos(angle) * outline;
        const oy = Math.sin(angle) * outline;
        ctx.drawImage(mask, x + ox, y + oy, w, h);
      });
      if (f.glowBlur > 0) {
        ctx.globalAlpha = f.glowStrength * 0.45;
        ctx.shadowColor = glowColor;
        ctx.shadowBlur = f.glowBlur;
        ctx.drawImage(mask, x, y, w, h);
      }
      ctx.restore();
    }
    ctx.drawImage(image, contentX, contentY, contentW, contentH, dx, dy, dw, dh);
    return true;
  } catch {
    return false;
  }
}

// One sponsor logo inside its cell — shared by the graphic and the cropping preview.
export function drawSponsorCell(ctx, image, frame, w, h, opts = {}) {
  const f = normalizeSponsorFrame(frame);
  const r = Math.min(h * 0.2, 16);
  if (opts.drawBand) {
    ctx.fillStyle = opts.forceBg === "light" ? "#f4f6f9" : "#0a1e37";
    ctx.fillRect(0, 0, w, h);
  }
  let bg = opts.forceBg || f.bg;
  if (!bg || bg === "auto") bg = isLightLogo(image) ? "none" : "light";
  ctx.save();
  roundRect(ctx, 0, 0, w, h, r);
  ctx.clip();
  if (bg === "light") {
    ctx.fillStyle = "#f4f6f9";
    ctx.fillRect(0, 0, w, h);
  } else if (bg === "dark") {
    ctx.fillStyle = "#0a1e37";
    ctx.fillRect(0, 0, w, h);
  } else if (opts.showCell !== false) {
    ctx.fillStyle = "rgba(255,255,255,0.045)";
    ctx.fillRect(0, 0, w, h);
  }
  const drawn = drawImageFramed(ctx, image, 0, 0, w, h, f, Math.min(w, h) * 0.06, bg === "light" ? "light" : "dark");
  ctx.restore();
  if (opts.outline !== false || opts.guide) {
    const outline = opts.guide
      ? "rgba(255,255,255,0.32)"
      : bg === "light"
      ? "rgba(10,30,55,0.12)"
      : "rgba(255,255,255,0.10)";
    fillRoundRect(ctx, 0.5, 0.5, w - 1, h - 1, r, null, outline, opts.guide ? 1.25 : 1);
  }
  return drawn;
}

// Fallback list when no partners come from the database.
function fallbackSponsorList() {
  return [...SPONSORS_TOP, ...SPONSORS_BOTTOM].map((s) => ({ id: s.id, name: s.name, frame: null }));
}

function sponsorRowsForForm(form, list) {
  if (form.category === "best-eight") {
    const automatic = Math.ceil(list.length / 6) || 1;
    const requested = Number(form.bestEightSponsorRows);
    return clamp(Math.round(requested > 0 ? requested : automatic), 1, Math.min(4, Math.max(1, list.length)));
  }
  const fallback = list.length > 6 ? 2 : 1;
  const requested = Number(form?.sponsorRows || fallback);
  const maxRows = Math.min(4, Math.max(1, list.length || 1));
  return clamp(Math.round(Number.isFinite(requested) ? requested : fallback), 1, maxRows);
}

function sponsorItemsForRow(list, rowIndex, rowsCount) {
  const base = Math.floor(list.length / rowsCount);
  const extra = list.length % rowsCount;
  const start = rowIndex * base + Math.min(rowIndex, extra);
  const count = base + (rowIndex < extra ? 1 : 0);
  return list.slice(start, start + count);
}

export function getSponsorPanelLayout(form, list, layout) {
  const { width, height, M } = layout;
  const rowsCount = sponsorRowsForForm(form, list);
  if (form.category === "best-eight") {
    const pad = layout.isStory ? 20 : 12;
    const labelH = layout.isStory ? 28 : 22;
    const gapLabel = 4;
    const rowH = Math.min(layout.isStory ? 88 : 60, (height * (layout.isStory ? 0.20 : 0.22) - pad * 2 - labelH - gapLabel) / rowsCount);
    const panelH = pad * 2 + labelH + gapLabel + rowH * rowsCount;
    return { rowsCount, rowH, labelH, pad, gapLabel, panelH,
      panelY: height - panelH - (layout.isStory ? 58 : 36), panelX: M * 0.5, panelW: width - M };
  }
  const isRoundList = ["round-preview", "round-results"].includes(form.category);
  // Four full-height sponsor rows otherwise consume almost half a square post.
  // Keep all logos, but use a denser band for multi-row fixture graphics.
  const rowH = layout.isStory ? 106 : isRoundList ? Math.min(80, Math.max(56, 160 / rowsCount)) : 80;
  const labelH = layout.isStory ? 34 : 28;
  const pad = layout.isStory ? 24 : 18;
  const gapLabel = layout.isStory ? 10 : 6;
  const footerSpace = layout.isStory ? 58 : 40;
  const panelH = pad * 2 + labelH + gapLabel + rowH * rowsCount;
  const panelY = height - panelH - footerSpace;
  const panelX = M * 0.5;
  const panelW = width - M;
  return { rowsCount, rowH, labelH, pad, gapLabel, panelH, panelY, panelX, panelW };
}

function drawSponsorPanel(ctx, form, images, layout) {
  const list = Array.isArray(images.sponsorList) ? images.sponsorList : fallbackSponsorList();
  const { rowsCount, rowH, labelH, pad, gapLabel, panelH, panelY, panelX, panelW } = getSponsorPanelLayout(form, list, layout);

  // One uniform dark band. No tiles, no shadows — logos are framed to fill their cells.
  fillRoundRect(ctx, panelX, panelY, panelW, panelH, 24, "#f4f6f9", "rgba(10,30,55,0.10)", 1.5);
  ctx.save();
  ctx.globalAlpha = 0.5;
  fillRoundRect(ctx, panelX, panelY, panelW, Math.max(3, panelH * 0.02), 24, BRAND.gold);
  ctx.restore();

  drawText(ctx, "PARTNERZY LIGI", panelX + panelW / 2, panelY + pad + labelH * 0.4, {
    size: layout.isStory ? 24 : 20,
    weight: 900,
    color: "rgba(10,30,55,0.58)",
    upper: true,
    tracking: 5,
  });

  const contentY = panelY + pad + labelH + gapLabel;
  for (let r = 0; r < rowsCount; r += 1) {
    const rowItems = sponsorItemsForRow(list, r, rowsCount);
    drawSponsorRow(ctx, rowItems, images.sponsors, panelX + pad, contentY + r * rowH, panelW - pad * 2, rowH);
  }
  return panelY;
}

function drawSponsorRow(ctx, items, sponsorImages, x, y, w, h) {
  if (!items.length) return;
  const slot = w / items.length;
  // Fixed cell aspect so the crop preview in the Sponsors tab matches the graphic 1:1.
  const maxCellW = slot * 0.94;
  const maxCellH = h * 0.92;
  let cellW = Math.min(maxCellW, maxCellH * SPONSOR_CELL_ASPECT);
  let cellH = cellW / SPONSOR_CELL_ASPECT;
  if (cellH > maxCellH) {
    cellH = maxCellH;
    cellW = cellH * SPONSOR_CELL_ASPECT;
  }
  const cellY = y + (h - cellH) / 2;
  items.forEach((item, i) => {
    const cellX = x + slot * i + (slot - cellW) / 2;
    const img = getImage(sponsorImages, item.id);
    ctx.save();
    ctx.translate(cellX, cellY);
    const drawn = drawSponsorCell(ctx, img, item.frame, cellW, cellH, { forceBg: "light", outline: false });
    ctx.restore();
    if (!drawn) {
      drawText(ctx, item.name, cellX + cellW / 2, cellY + cellH / 2, {
        size: cellH * 0.22,
        minSize: 9,
        weight: 800,
        color: BRAND.ink,
        maxWidth: cellW * 0.9,
      });
    }
  });
}

/* ============================== FOOTER ============================== */

function drawFooter(ctx, form, layout) {
  const { width, height, t } = layout;
  drawText(ctx, form.footerText || "mlpn.pl", width / 2, height - (layout.isStory ? 22 : 15), {
    size: layout.isStory ? 22 : 18,
    weight: 800,
    color: t.dark ? "rgba(255,255,255,0.5)" : "rgba(13,27,44,0.45)",
    baseline: "bottom",
    tracking: 2,
    upper: true,
  });
}

/* ============================== MATCH ROW (typer/preview/results) ============================== */

// "Jan Kowalski" -> "J. Kowalski"


function drawMatchRow(ctx, match, images, x, y, w, h, opts, layout) {
  if (opts.compact) {
    drawCompactMatchRow(ctx, match, images, x, y, w, h, opts, layout);
    return;
  }
  const { center = "VS", hit = false, accent = null, hitLabel = "HIT KOLEJKI" } = opts;
  const t = layout.t;
  const bg = hit ? "rgba(231,178,60,0.2)" : t.panel;
  const line = hit ? "rgba(231,178,60,0.7)" : t.panelLine;
  fillRoundRect(ctx, x, y, w, h, h * 0.2, bg, line, hit ? 3 : 1.5);

  // league accent stripe (left)
  let leftPad = h * 0.16;
  if (accent) {
    fillRoundRect(ctx, x + h * 0.1, y + h * 0.22, h * 0.1, h * 0.56, h * 0.05, accent);
    leftPad = h * 0.34;
  }

  const crest = h * 0.74;
  const gapC = h * 0.12;
  const chipW = w * 0.2;
  const chipH = h * 0.64;
  const cx = x + w / 2;

  const homeCrestX = x + leftPad;
  const awayCrestX = x + w - leftPad - crest;
  drawCrest(ctx, getImage(images.teamLogos, match.home_team_logo), homeCrestX, y + (h - crest) / 2, crest, match.home_team_abbr || "H", t.dark);
  drawCrest(ctx, getImage(images.teamLogos, match.away_team_logo), awayCrestX, y + (h - crest) / 2, crest, match.away_team_abbr || "A", t.dark);

  // names
  const nameSize = h * 0.3;
  const homeNameX = homeCrestX + crest + gapC;
  const homeNameMax = cx - chipW / 2 - gapC - homeNameX;
  const awayNameX = awayCrestX - gapC;
  const awayNameMax = awayNameX - (cx + chipW / 2 + gapC);
  drawText(ctx, match.home_team_name, homeNameX, y + h / 2, {
    size: nameSize,
    minSize: nameSize,
    weight: 800,
    color: t.text,
    align: "left",
    maxWidth: homeNameMax,
  });
  drawText(ctx, match.away_team_name, awayNameX, y + h / 2, {
    size: nameSize,
    minSize: nameSize,
    weight: 800,
    color: t.text,
    align: "right",
    maxWidth: awayNameMax,
  });

  // centre chip (score / VS / date+time)
  fillRoundRect(ctx, cx - chipW / 2, y + (h - chipH) / 2, chipW, chipH, chipH * 0.26, hit ? BRAND.gold : "rgba(8,16,28,0.6)", "rgba(255,255,255,0.14)", 1.5);
  const lines = Array.isArray(center) ? center.filter(Boolean) : [center];
  if (lines.length > 1) {
    const ls = h * 0.24;
    lines.slice(0, 2).forEach((textLine, i) => {
      drawText(ctx, textLine, cx, y + h / 2 + (i === 0 ? -ls * 0.5 : ls * 0.5), {
        size: ls,
        minSize: 11,
        weight: i === 0 ? 800 : 900,
        color: hit ? BRAND.ink : "#ffffff",
        maxWidth: chipW * 0.88,
      });
    });
  } else {
    drawText(ctx, lines[0] || "VS", cx, y + h / 2, {
      size: h * 0.34,
      minSize: 13,
      weight: 900,
      color: hit ? BRAND.ink : "#ffffff",
      maxWidth: chipW * 0.88,
    });
  }

  // Optional "hit" ribbon on the top edge.
  if (hit) {
    const tag = hitLabel;
    const tagSize = Math.min(h * 0.24, 22);
    setFont(ctx, tagSize, 900);
    const starW = tagSize * 1.2;
    const tagW = ctx.measureText(tag).width + tagSize * 1.4 + starW;
    const tagH = tagSize + h * 0.12;
    const tagX = x + w * 0.06;
    const tagY = y - tagH / 2;
    fillRoundRect(ctx, tagX, tagY, tagW, tagH, tagH / 2, BRAND.gold, "rgba(0,0,0,0.15)", 1);
    drawSparkle(ctx, tagX + tagH * 0.55, tagY + tagH / 2, tagSize * 0.42, BRAND.ink);
    drawText(ctx, tag, tagX + starW + tagSize * 0.4, tagY + tagH / 2, {
      size: tagSize,
      weight: 900,
      color: BRAND.ink,
      align: "left",
      tracking: 1,
    });
  }
}

// Width-safe geometry for three-character labels. Crests, names and centre chip
// each get their own space, even in a three-column square graphic.
export function getCompactMatchRowLayout(w, h) {
  const pad = Math.min(12, h * 0.2);
  const gap = Math.min(8, h * 0.12);
  const crest = Math.min(h * 0.72, w * 0.115);
  const chipW = w * 0.24;
  const chipH = h * 0.76;
  const nameWidth = (w - chipW) / 2 - pad - crest - gap * 2;
  // Reserve enough room even for three wide letters (e.g. WBP).
  const nameSize = Math.min(30, h * 0.4, nameWidth / 2.9);
  return { pad, gap, crest, chipW, chipH, nameWidth, nameSize };
}

function drawCompactMatchRow(ctx, match, images, x, y, w, h, opts, layout) {
  const { center, hit, accent } = opts;
  const t = layout.t;
  const { pad, gap, crest, chipW, chipH, nameWidth, nameSize } = getCompactMatchRowLayout(w, h);
  const cx = x + w / 2;
  const cy = y + h / 2;
  const homeAbbr = getGraphicTeamAbbreviation(match.home_team_name, match.home_team_abbr);
  const awayAbbr = getGraphicTeamAbbreviation(match.away_team_name, match.away_team_abbr);
  fillRoundRect(ctx, x, y, w, h, h * 0.18, hit ? "rgba(231,178,60,0.2)" : t.panel,
    hit ? BRAND.gold : t.panelLine, hit ? 2.5 : 1.25);
  if (accent) {
    fillRoundRect(ctx, x + 2, y + h * 0.25, Math.max(2, pad * 0.28), h * 0.5, 2, accent);
  }
  const homeCrestX = x + pad;
  const awayCrestX = x + w - pad - crest;
  drawCrest(ctx, getImage(images.teamLogos, match.home_team_logo), homeCrestX, cy - crest / 2, crest, homeAbbr, t.dark);
  drawCrest(ctx, getImage(images.teamLogos, match.away_team_logo), awayCrestX, cy - crest / 2, crest, awayAbbr, t.dark);
  const nameOptions = { size: nameSize, minSize: Math.min(8, nameSize), weight: 900, color: t.text, maxWidth: nameWidth };
  drawText(ctx, homeAbbr, homeCrestX + crest + gap, cy, { ...nameOptions, align: "left" });
  drawText(ctx, awayAbbr, awayCrestX - gap, cy, { ...nameOptions, align: "right" });

  fillRoundRect(ctx, cx - chipW / 2, cy - chipH / 2, chipW, chipH, chipH * 0.22,
    hit ? BRAND.gold : "rgba(8,16,28,0.7)", "rgba(255,255,255,0.14)", 1);
  const lines = Array.isArray(center) ? center.filter(Boolean) : [center];
  if (lines.length > 1) {
    const size = Math.min(24, h * 0.34, chipW / 3.7);
    lines.slice(0, 2).forEach((line, index) => {
      drawText(ctx, line, cx, cy + (index === 0 ? -1 : 1) * h * 0.17, {
        size, minSize: Math.min(8, size), weight: index === 0 ? 800 : 900,
        color: hit ? BRAND.ink : BRAND.white, maxWidth: chipW * 0.9,
      });
    });
  } else {
    drawText(ctx, lines[0] || "VS", cx, cy, {
      size: Math.min(34, h * 0.44, chipW / 3.7), minSize: 8, weight: 900,
      color: hit ? BRAND.ink : BRAND.white, maxWidth: chipW * 0.9,
    });
  }
  // Keep the highlight inside the card's own gap; a full ribbon would overlap
  // the previous fixture when all weekend matches share one image.
  if (hit) {
    const tagSize = Math.min(13, h * 0.22);
    const tagH = tagSize * 1.25;
    const tagW = Math.min(w - pad * 2, tagSize * 10);
    fillRoundRect(ctx, cx - tagW / 2, y - tagH * 0.3, tagW, tagH, tagH / 2, BRAND.gold);
    drawText(ctx, opts.hitLabel, cx, y + tagH * 0.2, {
      size: tagSize, minSize: 6, weight: 900, color: BRAND.ink, maxWidth: tagW * 0.9,
    });
  }
}

/* ============================== TEMPLATES ============================== */

function drawTyper(ctx, form, matches, images, layout, top, bottom) {
  const list = matches.slice(0, 5);
  if (!list.length) {
    drawEmpty(ctx, "Wybierz mecze do typera", layout, top, bottom);
    return;
  }
  const gap = layout.isStory ? 22 : 16;
  const areaH = bottom - top;
  const rowH = clamp((areaH - gap * (list.length - 1)) / list.length, layout.isStory ? 96 : 74, layout.isStory ? 150 : 112);
  const totalH = rowH * list.length + gap * (list.length - 1);
  let y = top + (areaH - totalH) / 2;
  const x = layout.M;
  const w = layout.width - layout.M * 2;
  list.forEach((match) => {
    const hit = form.hitMatchId != null && String(match.id) === String(form.hitMatchId);
    drawMatchRow(ctx, match, images, x, y, w, rowH, { center: "1 X 2", hit, hitLabel: "HIT WEEKENDU" }, layout);
    y += rowH + gap;
  });
}

export function getRoundListLayout(matchCount, layout, top, bottom) {
  const legendH = layout.isStory ? 40 : 32;
  const areaTop = top + legendH;
  const areaH = Math.max(1, bottom - areaTop);
  const width = layout.width - layout.M * 2;
  const colGap = layout.isStory ? 20 : 16;
  const maxCols = Math.min(layout.isStory ? 2 : 3, Math.max(1, matchCount));
  const candidates = Array.from({ length: maxCols }, (_, index) => {
    const cols = index + 1;
    const rowsPerCol = Math.max(1, Math.ceil(matchCount / cols));
    const colW = (width - colGap * (cols - 1)) / cols;
    const rowGap = Math.min(layout.isStory ? 14 : 10, areaH / (rowsPerCol * 10));
    const rowH = Math.min(layout.isStory ? 118 : 100, (areaH - rowGap * (rowsPerCol - 1)) / rowsPerCol);
    const contentH = rowsPerCol * rowH + (rowsPerCol - 1) * rowGap;
    const y0 = areaTop + Math.max(0, (areaH - contentH) / 2);
    const readableSize = getCompactMatchRowLayout(colW, rowH).nameSize;
    return { cols, rowsPerCol, colW, colGap, rowH, rowGap, y0, legendH, areaTop, readableSize };
  });
  // Choose columns by actual usable label size, not a fixed match-count limit.
  // Ties favour fewer columns for easier reading in chronological order.
  return candidates.reduce((best, candidate) => candidate.readableSize > best.readableSize + 0.5 ? candidate : best);
}

function drawRoundList(ctx, form, matches, images, layout, top, bottom, mode) {
  const isWeekendMode = mode === "results"
    ? form.resultsScope === "weekend"
    : form.previewScope === "weekend";
  // Weekend previews already contain the selected date range across all
  // rounds and leagues. Keep their chronological order instead of regrouping by league.
  const sortMatches = mode === "preview" && isWeekendMode
    ? sortMatchesChronologically
    : sortMatchesForGraphic;
  const clean = sortMatches(matches.filter(Boolean));
  if (!clean.length) {
    const emptyText = mode === "results"
      ? isWeekendMode
        ? "Brak wyników w wybranym weekendzie"
        : "Brak wyników w tej kolejce"
      : isWeekendMode
        ? "Brak spotkań w wybranym weekendzie"
        : "Brak spotkań w tej kolejce";
    drawEmpty(ctx, emptyText, layout, top, bottom);
    return;
  }
  // Legend of leagues present (small colour dots) so the accent stripes are readable.
  const present = [...new Set(clean.map((m) => m.league_code))];
  const { legendH, rowsPerCol, colW, colGap, rowGap, rowH, y0 } = getRoundListLayout(clean.length, layout, top, bottom);
  drawLeagueLegend(ctx, present, layout.width / 2, top + legendH * 0.4, layout);

  clean.forEach((match, i) => {
    const col = Math.floor(i / rowsPerCol);
    const row = i % rowsPerCol;
    const x = layout.M + col * (colW + colGap);
    const y = y0 + row * (rowH + rowGap);
    const accent = LEAGUE_ACCENTS[match.league_code] || BRAND.gold;
    const hit = form.hitMatchId != null && String(match.id) === String(form.hitMatchId);
    const time = match.match_time ? match.match_time.slice(0, 5) : "";
    const center =
      mode === "results"
        ? `${match.home_goals ?? 0} : ${match.away_goals ?? 0}`
        : [formatShortDate(match.match_date), time];
    const hitLabel = isWeekendMode ? "HIT WEEKENDU" : "HIT KOLEJKI";
    drawMatchRow(ctx, match, images, x, y, colW, rowH, { center, hit, accent, hitLabel, compact: true }, layout);
  });
}

function drawLeagueLegend(ctx, codes, cx, cy, layout) {
  const items = codes.map((code) => ({ code, label: getLeague(code).label }));
  const size = layout.isStory ? 24 : 20;
  const dot = size * 0.5;
  setFont(ctx, size, 800);
  const widths = items.map((it) => dot + 8 + ctx.measureText(it.label).width);
  const gap = size * 1.2;
  const total = widths.reduce((a, b) => a + b, 0) + gap * (items.length - 1);
  let x = cx - total / 2;
  items.forEach((it, i) => {
    ctx.beginPath();
    ctx.arc(x + dot / 2, cy, dot / 2, 0, Math.PI * 2);
    ctx.fillStyle = LEAGUE_ACCENTS[it.code] || BRAND.gold;
    ctx.fill();
    drawText(ctx, it.label, x + dot + 8, cy, {
      size,
      weight: 800,
      color: layout.t.textSoft,
      align: "left",
      upper: true,
      tracking: 1,
    });
    x += widths[i] + gap;
  });
}

// Each formation row gets the same vertical budget. Text and crests have disjoint
// rectangles, independent of the selected formation and the entered name length.
export function getBestEightLayout(form, layout, top, bottom) {
  const pitch = { x: layout.width * 0.045, y: top, w: layout.width * 0.91, h: bottom - top };
  const formation = getFormation(form.formation);
  const rows = [...new Set(formation.slots.map((slot) => slot.y))].sort((a, b) => a - b);
  const inset = layout.isStory ? 24 : 8;
  const rowH = (pitch.h - inset * 2) / rows.length;
  const positionH = layout.isStory ? 28 : 20;
  const nameH = layout.isStory ? 76 : 46;
  const gap = layout.isStory ? 12 : 5;
  const logoSize = Math.min(layout.isStory ? 150 : 82, rowH - positionH - nameH - gap * 3 - 4);
  const groupH = positionH + logoSize + nameH + gap * 2;
  const players = [];
  rows.forEach((row, rowIndex) => {
    const slots = formation.slots.map((slot, index) => ({ ...slot, index }))
      .filter((slot) => slot.y === row).sort((a, b) => a.x - b.x);
    const usableW = pitch.w - 24;
    const cellW = usableW / Math.max(3, slots.length);
    const rowW = cellW * slots.length;
    slots.forEach((slot, column) => {
      const cx = pitch.x + pitch.w / 2 - rowW / 2 + cellW * (column + 0.5);
      const y = pitch.y + inset + rowIndex * rowH + (rowH - groupH) / 2;
      const nameW = Math.min(layout.isStory ? 310 : 292, cellW - 14);
      players.push({
        index: slot.index, label: slot.label,
        position: { x: cx - 36, y, w: 72, h: positionH },
        logo: { x: cx - logoSize / 2, y: y + positionH + gap, w: logoSize, h: logoSize },
        name: { x: cx - nameW / 2, y: y + positionH + gap + logoSize + gap, w: nameW, h: nameH },
        nameSize: layout.isStory ? 33 : 25,
      });
    });
  });
  return { pitch, players };
}

export function formatBestEightPlayerName(name) {
  const parts = String(name || "").trim().split(/\s+/u).filter(Boolean);
  if (parts.length <= 1) return parts[0] || "";
  return `${Array.from(parts[0])[0].toLocaleUpperCase("pl-PL")}. ${parts.slice(1).join(" ")}`;
}

// Measure the actual canvas font before choosing one or two lines. Keep the full
// supplied text, including initials and hyphens; arbitrary long tokens can wrap.
export function getBestEightNameLayout(ctx, name, box, maxSize) {
  const text = String(name || "Zawodnik").replace(/\s+/gu, " ").trim() || "Zawodnik";
  const chars = Array.from(text);
  const candidates = [[text]];
  chars.forEach((char, index) => {
    if ((char === " " || char === "-") && index > 0 && index < chars.length - 1) {
      const cut = char === "-" ? index + 1 : index;
      candidates.push([chars.slice(0, cut).join("").trim(), chars.slice(cut).join("").trim()]);
    }
  });
  setFont(ctx, maxSize, 800);
  const fit = (lines) => {
    const widest = Math.max(...lines.map((line) => ctx.measureText(line).width), 1);
    const fontSize = Math.max(0.01, Math.floor(maxSize * Math.min(1, box.w / widest, box.h / (lines.length * maxSize * 1.12)) * 100) / 100);
    return { lines, fontSize, lineHeight: fontSize * 1.12 };
  };
  let best = fit(candidates[0]);
  candidates.slice(1).forEach((lines) => {
    const candidate = fit(lines);
    if (candidate.fontSize > best.fontSize * (best.lines.length === 1 ? 1.12 : 1)) best = candidate;
  });
  if (best.fontSize < Math.min(14, maxSize * 0.6) && chars.length > 1) {
    // Emergency wrapping is preferable to truncating or overflowing the card.
    for (let cut = 1; cut < chars.length; cut += 1) {
      const candidate = fit([chars.slice(0, cut).join("").trim(), chars.slice(cut).join("").trim()]);
      if (candidate.fontSize > best.fontSize) best = candidate;
    }
  }
  return best;
}

function drawBestEightName(ctx, plan, box, color) {
  ctx.save();
  setFont(ctx, plan.fontSize, 800);
  ctx.fillStyle = color;
  ctx.textAlign = "center";
  ctx.textBaseline = "middle";
  const firstY = box.y + box.h / 2 - (plan.lines.length - 1) * plan.lineHeight / 2;
  plan.lines.forEach((line, index) => ctx.fillText(line, box.x + box.w / 2, firstY + index * plan.lineHeight));
  ctx.restore();
}

function drawBestEightPitch(ctx, pitch, layout) {
  const { x, y, w, h } = pitch;
  const inset = w * 0.085;
  const line = layout.t.dark ? "rgba(156,188,218,0.25)" : "rgba(15,42,74,0.25)";
  ctx.save();
  ctx.beginPath();
  ctx.moveTo(x + inset, y);
  ctx.lineTo(x + w - inset, y);
  ctx.lineTo(x + w, y + h);
  ctx.lineTo(x, y + h);
  ctx.closePath();
  ctx.fillStyle = layout.t.dark ? "rgba(38,75,111,0.15)" : "rgba(255,255,255,0.15)";
  ctx.fill();
  ctx.strokeStyle = line;
  ctx.lineWidth = 2;
  ctx.stroke();
  ctx.beginPath();
  ctx.moveTo(x + inset / 2, y + h / 2);
  ctx.lineTo(x + w - inset / 2, y + h / 2);
  ctx.stroke();
  ctx.beginPath();
  ctx.ellipse(x + w / 2, y + h / 2, w * 0.105, h * 0.095, 0, 0, Math.PI * 2);
  ctx.stroke();
  [0, 1].forEach((end) => {
    const edgeY = end ? y + h : y;
    const depth = (end ? -1 : 1) * h * 0.13;
    ctx.beginPath();
    ctx.moveTo(x + w * 0.3, edgeY);
    ctx.lineTo(x + w * 0.3, edgeY + depth);
    ctx.lineTo(x + w * 0.7, edgeY + depth);
    ctx.lineTo(x + w * 0.7, edgeY);
    ctx.stroke();
  });
  ctx.restore();
}

function drawBestEight(ctx, form, images, layout, top, bottom) {
  const { pitch, players } = getBestEightLayout(form, layout, top, bottom);
  drawBestEightPitch(ctx, pitch, layout);
  players.forEach((player) => {
    const slot = form.lineup?.[player.index] || {};
    const { position, logo, name } = player;
    drawText(ctx, player.label, position.x + position.w / 2, position.y + position.h / 2, {
      size: position.h * 0.9, minSize: 12, weight: 800,
      color: layout.t.dark ? BRAND.goldSoft : BRAND.navy, maxWidth: position.w,
    });
    const image = getImage(images.teamLogos, slot.logoUrl);
    const drawn = drawImageFramed(ctx, image, logo.x, logo.y, logo.w, logo.h, { mode: "fit", glow: false }, 0);
    if (!drawn) {
      fillRoundRect(ctx, logo.x + logo.w * 0.15, logo.y, logo.w * 0.7, logo.h, 8, layout.t.panel, layout.t.panelLine);
      drawText(ctx, "MLPN", logo.x + logo.w / 2, logo.y + logo.h / 2, {
        size: logo.w * 0.2, color: layout.t.textSoft, maxWidth: logo.w * 0.6,
      });
    }
    fillRoundRect(ctx, name.x, name.y, name.w, name.h, 5,
      layout.t.dark ? "rgba(5,18,33,0.94)" : "rgba(255,255,255,0.96)", layout.t.panelLine);
    const textBox = { x: name.x + 8, y: name.y + 3, w: name.w - 16, h: name.h - 6 };
    const displayName = formatBestEightPlayerName(slot.name);
    drawBestEightName(ctx, getBestEightNameLayout(ctx, displayName, textBox, player.nameSize), textBox, layout.t.text);
  });
}

// Large, faint team crest woven into the background.
function drawTeamWatermark(ctx, image, cx, cy, size) {
  if (!image || !image.naturalWidth) return;
  ctx.save();
  ctx.globalAlpha = 0.12;
  drawImageContain(ctx, image, cx - size / 2, cy - size / 2, size, size);
  ctx.restore();
}

function drawPlayerAward(ctx, form, images, layout, top, bottom) {
  const t = layout.t;
  const areaH = bottom - top;
  const photo = getImage(images.teamLogos, form.playerPhotoUrl);
  const teamLogo = getImage(images.teamLogos, form.playerLogoUrl);

  if (layout.isStory) {
    drawTeamWatermark(ctx, teamLogo, layout.width / 2, top + areaH * 0.6, areaH * 0.8);
    const r = Math.min(layout.width * 0.33, areaH * 0.3);
    const cx = layout.width / 2;
    const cy = top + r + areaH * 0.03;
    drawCirclePhoto(ctx, photo, cx, cy, r, BRAND.gold);
    let ty = cy + r + areaH * 0.09;
    drawText(ctx, form.playerName || "Imię i nazwisko", cx, ty, { size: 66, minSize: 24, weight: 900, color: t.text, maxWidth: layout.width - layout.M * 2 });
    drawText(ctx, form.playerTeam || "Drużyna", cx, ty + 64, { size: 38, minSize: 16, weight: 800, color: BRAND.gold, maxWidth: layout.width - layout.M * 2 });
    if (form.playerCaption) {
      drawWrapped(ctx, form.playerCaption, cx, ty + 116, { size: 30, weight: 700, color: t.textSoft, align: "center", maxWidth: layout.width * 0.82, maxLines: 3 });
    }
  } else {
    const r = Math.min(layout.width * 0.23, areaH * 0.46);
    const cx = layout.M + r + layout.width * 0.02;
    const cy = top + areaH / 2;
    // watermark filling the right half where the text sits
    drawTeamWatermark(ctx, teamLogo, layout.width * 0.72, cy, areaH * 0.98);
    drawCirclePhoto(ctx, photo, cx, cy, r, BRAND.gold);
    const textX = cx + r + layout.width * 0.05;
    const textMax = layout.width - layout.M - textX;
    let ty = cy - areaH * 0.18;
    drawText(ctx, form.playerName || "Imię i nazwisko", textX, ty, { size: 62, minSize: 24, weight: 900, color: t.text, align: "left", maxWidth: textMax, shadow: t.dark ? { color: "rgba(0,0,0,0.4)", blur: 8, offsetY: 3 } : null });
    drawText(ctx, form.playerTeam || "Drużyna", textX, ty + 62, { size: 36, minSize: 16, weight: 800, color: BRAND.gold, align: "left", maxWidth: textMax });
    if (form.playerCaption) {
      drawWrapped(ctx, form.playerCaption, textX, ty + 116, { size: 27, weight: 700, color: t.textSoft, align: "left", maxWidth: textMax, maxLines: 4 });
    }
  }
}

function drawPlayerVote(ctx, form, images, layout, top, bottom) {
  const t = layout.t;
  const cands = form.candidates.slice(0, 3);
  const areaH = bottom - top;
  const n = cands.length || 1;
  const gapFactor = layout.isStory ? 1 : 0.8;
  // Width actually used by n circles + (n-1) gaps is n*2r + (n-1)*gapFactor*r —
  // size r against that exact figure so the last candidate never spills past the card.
  const r = Math.min((layout.width - layout.M * 2) / (n * 2 + (n - 1) * gapFactor), areaH * 0.3);
  const gap = r * gapFactor;
  const totalW = n * r * 2 + (n - 1) * gap;
  let x = layout.width / 2 - totalW / 2 + r;
  const cy = top + areaH * 0.4;

  cands.forEach((cand, i) => {
    drawCirclePhoto(ctx, getImage(images.teamLogos, cand.photoUrl), x, cy, r, BRAND.gold);
    if (cand.logoUrl) {
      const ls = r * 0.68;
      drawCrest(ctx, getImage(images.teamLogos, cand.logoUrl), x - ls / 2, cy + r * 0.6, ls, "", true);
    }
    if (cand.reaction) {
      setFont(ctx, r * 0.62, 400);
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      ctx.fillStyle = "#fff";
      ctx.fillText(cand.reaction, x + r * 0.74, cy - r * 0.74);
    }
    drawWrapped(ctx, cand.name || `Kandydat ${i + 1}`, x, cy + r + (layout.isStory ? 64 : 52), {
      size: layout.isStory ? 34 : 28,
      weight: 800,
      color: t.text,
      align: "center",
      maxWidth: r * 2.3,
      maxLines: 2,
    });
    x += r * 2 + gap;
  });
}

function tableRowStatus(leagueCode, position, totalRows) {
  const pos = Number(position || 0);
  const total = Number(totalRows || 0);
  if (!pos || !total) return null;
  if (leagueCode === "1st" && pos === 1) return "promoted";
  if ((leagueCode === "2nd" || leagueCode === "3rd") && pos <= 2) return "promoted";
  if ((leagueCode === "1st" || leagueCode === "2nd") && pos > total - 2) return "relegated";
  return null;
}

function drawTable(ctx, form, standings, images, layout, top, bottom) {
  const t = layout.t;
  if (!standings.length) {
    drawEmpty(ctx, "Brak danych tabeli", layout, top, bottom);
    return;
  }
  const x = layout.M;
  const w = layout.width - layout.M * 2;
  const areaH = bottom - top;
  // Never drop a team — shrink row height to fit the whole table instead of truncating.
  const rows = standings;
  const headH = layout.isStory ? 52 : 42;
  const rowH = Math.min(layout.isStory ? 84 : 60, (areaH - headH) / rows.length);
  const contentH = headH + rowH * rows.length;
  let y = top + Math.max(0, (areaH - contentH) / 2);

  // Optional split view: dim + blur positions outside the chosen range instead of hiding them,
  // so a post can focus on e.g. places 5-9 while keeping the rest of the table for context.
  const tableRange = resolveTableRange(
    {
      enabled: form.tableRangeEnabled,
      from: form.tableRangeFrom,
      to: form.tableRangeTo,
    },
    getTablePositions(rows)
  );

  ctx.save();
  ctx.beginPath();
  ctx.rect(0, top - 4, layout.width, areaH + 8);
  ctx.clip();

  // columns
  const cPos = x + w * 0.06;
  const cCrest = x + w * 0.13;
  const cName = x + w * 0.22;
  const cM = x + w * 0.74;
  const cGoals = x + w * 0.84;
  const cPts = x + w * 0.95;

  // header
  drawText(ctx, "#", cPos, y + headH / 2, { size: headH * 0.34, weight: 900, color: t.textSoft, upper: true });
  drawText(ctx, "Drużyna", cName, y + headH / 2, { size: headH * 0.34, weight: 900, color: t.textSoft, align: "left", upper: true, tracking: 1 });
  drawText(ctx, "M", cM, y + headH / 2, { size: headH * 0.34, weight: 900, color: t.textSoft });
  drawText(ctx, "BR", cGoals, y + headH / 2, { size: headH * 0.34, weight: 900, color: t.textSoft });
  drawText(ctx, "PKT", cPts, y + headH / 2, { size: headH * 0.34, weight: 900, color: BRAND.gold });
  y += headH;

  rows.forEach((row, i) => {
    const position = row.position || i + 1;
    const dimmed = isTableRowDimmed(tableRange, position);
    const status = dimmed ? null : tableRowStatus(form.leagueCode, position, standings.length);
    const rowFill = status === "promoted"
      ? (t.dark ? "rgba(34,197,94,0.24)" : "rgba(187,247,208,0.82)")
      : status === "relegated"
      ? (t.dark ? "rgba(239,68,68,0.24)" : "rgba(254,202,202,0.82)")
      : i % 2 === 0
      ? t.panel
      : null;
    const rowStroke = status === "promoted"
      ? "rgba(34,197,94,0.55)"
      : status === "relegated"
      ? "rgba(239,68,68,0.55)"
      : null;
    ctx.save();
    if (dimmed) {
      ctx.filter = "blur(3px) grayscale(90%)";
      ctx.globalAlpha = 0.4;
    }
    if (rowFill) fillRoundRect(ctx, x, y, w, rowH, rowH * 0.2, rowFill, rowStroke, status ? 1.5 : 1);
    const cy = y + rowH / 2;
    drawText(ctx, `${position}`, cPos, cy, { size: rowH * 0.36, weight: 900, color: t.text });
    const crest = rowH * 0.66;
    drawCrest(ctx, getImage(images.teamLogos, row.team_logo_url), cCrest - crest / 2, cy - crest / 2, crest, (row.team_name || "").slice(0, 2), t.dark);
    drawText(ctx, row.team_name, cName + rowH * 0.5, cy, { size: rowH * 0.34, minSize: 13, weight: 800, color: t.text, align: "left", maxWidth: cM - cName - rowH });
    drawText(ctx, row.played ?? 0, cM, cy, { size: rowH * 0.32, weight: 700, color: t.textSoft });
    drawText(ctx, `${row.goals_for ?? 0}:${row.goals_against ?? 0}`, cGoals, cy, { size: rowH * 0.3, weight: 700, color: t.textSoft });
    drawText(ctx, row.points ?? 0, cPts, cy, { size: rowH * 0.4, weight: 900, color: BRAND.gold });
    ctx.restore();
    y += rowH;
  });
  ctx.restore();
}

function drawEmpty(ctx, text, layout, top, bottom) {
  drawText(ctx, text, layout.width / 2, (top + bottom) / 2, {
    size: layout.isStory ? 40 : 32,
    weight: 800,
    color: layout.t.textSoft,
    maxWidth: layout.width - layout.M * 2,
  });
}

/* ============================== ENTRY ============================== */

export function drawGraphic(ctx, form, data, images, width, height) {
  ctx.imageSmoothingEnabled = true;
  ctx.imageSmoothingQuality = "high";

  const isStory = height / width > 1.3;
  const M = Math.round(width * (isStory ? 0.075 : 0.07));
  const layout = {
    width,
    height,
    isStory,
    M,
    headerTop: Math.round(height * (isStory ? 0.045 : 0.05)),
    t: themeConfig(form.theme),
  };

  drawBackground(ctx, width, height, form, layout);
  const contentTop = drawHeader(ctx, form, images, layout);
  const contentBottom = drawSponsorPanel(ctx, form, images, layout) - (isStory ? 30 : 22);
  drawFooter(ctx, form, layout);

  const c = form.category;
  if (c === "round-typer") drawTyper(ctx, form, data.matches, images, layout, contentTop, contentBottom);
  else if (c === "round-preview") drawRoundList(ctx, form, data.matches, images, layout, contentTop, contentBottom, "preview");
  else if (c === "round-results") drawRoundList(ctx, form, data.matches, images, layout, contentTop, contentBottom, "results");
  else if (c === "best-eight") drawBestEight(ctx, form, images, layout, contentTop, contentBottom);
  else if (c === "player-award") drawPlayerAward(ctx, form, images, layout, contentTop, contentBottom);
  else if (c === "player-vote") drawPlayerVote(ctx, form, images, layout, contentTop, contentBottom);
  else if (c === "table-summary") drawTable(ctx, form, data.standings, images, layout, contentTop, contentBottom);
}

export { SPONSORS_TOP, SPONSORS_BOTTOM, FORMATIONS, getFormation, titleForForm, subtitleForForm };
