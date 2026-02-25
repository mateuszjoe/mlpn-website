import React, { useMemo, useState } from "react";

const SHIELD_PATH =
  "M256 34 C196 34 140 52 100 86 C100 190 116 304 256 470 C396 304 412 190 412 86 C372 52 316 34 256 34 Z";

const PATTERNS = [
  { id: "split_vertical", label: "Pionowy pol na pol" },
  { id: "split_horizontal", label: "Poziomy pol na pol" },
  { id: "diagonal", label: "Skos" },
  { id: "sash", label: "Pas skosny" },
  { id: "stripes_vertical", label: "Pasy pionowe" },
  { id: "stripes_horizontal", label: "Pasy poziome" },
  { id: "quarters", label: "Cwiartki" },
  { id: "cross", label: "Krzyz" },
];

function xmlEscape(value) {
  return String(value || "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&apos;");
}

function buildInitials(teamName, abbreviation) {
  const abbr = String(abbreviation || "").trim().toUpperCase();
  if (abbr) return abbr.slice(0, 4);
  const words = String(teamName || "")
    .trim()
    .split(/\s+/)
    .filter(Boolean);
  if (!words.length) return "FC";
  return words
    .slice(0, 3)
    .map((w) => w[0])
    .join("")
    .toUpperCase();
}

function patternSvg(patternId, colorA, colorB) {
  switch (patternId) {
    case "split_horizontal":
      return `
        <rect x="0" y="0" width="512" height="256" fill="${colorA}" />
        <rect x="0" y="256" width="512" height="256" fill="${colorB}" />
      `;
    case "diagonal":
      return `
        <rect x="0" y="0" width="512" height="512" fill="${colorA}" />
        <polygon points="512,0 512,512 0,512" fill="${colorB}" />
      `;
    case "sash":
      return `
        <rect x="0" y="0" width="512" height="512" fill="${colorA}" />
        <polygon points="-40,120 100,-20 552,432 412,572" fill="${colorB}" />
      `;
    case "stripes_vertical":
      return `
        <rect x="0" y="0" width="512" height="512" fill="${colorA}" />
        <rect x="64" y="0" width="64" height="512" fill="${colorB}" />
        <rect x="192" y="0" width="64" height="512" fill="${colorB}" />
        <rect x="320" y="0" width="64" height="512" fill="${colorB}" />
        <rect x="448" y="0" width="64" height="512" fill="${colorB}" />
      `;
    case "stripes_horizontal":
      return `
        <rect x="0" y="0" width="512" height="512" fill="${colorA}" />
        <rect x="0" y="64" width="512" height="64" fill="${colorB}" />
        <rect x="0" y="192" width="512" height="64" fill="${colorB}" />
        <rect x="0" y="320" width="512" height="64" fill="${colorB}" />
        <rect x="0" y="448" width="512" height="64" fill="${colorB}" />
      `;
    case "quarters":
      return `
        <rect x="0" y="0" width="512" height="512" fill="${colorA}" />
        <rect x="0" y="0" width="256" height="256" fill="${colorB}" />
        <rect x="256" y="256" width="256" height="256" fill="${colorB}" />
      `;
    case "cross":
      return `
        <rect x="0" y="0" width="512" height="512" fill="${colorA}" />
        <rect x="206" y="0" width="100" height="512" fill="${colorB}" />
        <rect x="0" y="206" width="512" height="100" fill="${colorB}" />
      `;
    case "split_vertical":
    default:
      return `
        <rect x="0" y="0" width="256" height="512" fill="${colorA}" />
        <rect x="256" y="0" width="256" height="512" fill="${colorB}" />
      `;
  }
}

function hexToRgb(hex) {
  const raw = String(hex || "").replace("#", "");
  const safe = raw.length === 3 ? raw.split("").map((c) => c + c).join("") : raw;
  if (!/^[0-9a-fA-F]{6}$/.test(safe)) return { r: 0, g: 0, b: 0 };
  return {
    r: parseInt(safe.slice(0, 2), 16),
    g: parseInt(safe.slice(2, 4), 16),
    b: parseInt(safe.slice(4, 6), 16),
  };
}

function textColorForBackground(hex) {
  const { r, g, b } = hexToRgb(hex);
  const yiq = (r * 299 + g * 587 + b * 114) / 1000;
  return yiq >= 150 ? "#111827" : "#ffffff";
}

function estimateBannerFontSize(text) {
  const len = Math.max(1, String(text || "").trim().length);
  const avgGlyphWidthFactor = 0.58;
  const targetWidth = 250;
  const size = Math.floor(targetWidth / (len * avgGlyphWidthFactor));
  return Math.max(16, Math.min(36, size));
}

function buildShieldSvg({
  colorA,
  colorB,
  patternId,
  initials,
  showInitials,
  bannerText,
  showBannerText,
  bannerPosition,
}) {
  const safeInitials = xmlEscape(initials).slice(0, 5);
  const safeBannerText = xmlEscape(String(bannerText || "").trim()).slice(0, 42);
  const pattern = patternSvg(patternId, colorA, colorB);
  const bannerRect = bannerPosition === "top"
    ? { x: 110, y: 110, w: 292, h: 52, rx: 14 }
    : { x: 92, y: 338, w: 328, h: 56, rx: 14 };
  const bannerFill = bannerPosition === "top" ? colorA : colorB;
  const bannerTextColor = textColorForBackground(bannerFill);
  const bannerFontSize = estimateBannerFontSize(safeBannerText);
  const bannerTextLength = bannerPosition === "top" ? 252 : 286;
  const bannerY = bannerRect.y + Math.floor(bannerRect.h * 0.67);

  return `
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
      <defs>
        <clipPath id="shieldClip">
          <path d="${SHIELD_PATH}" />
        </clipPath>
        <filter id="softShadow" x="-20%" y="-20%" width="140%" height="140%">
          <feDropShadow dx="0" dy="8" stdDeviation="10" flood-color="#000000" flood-opacity="0.25"/>
        </filter>
      </defs>
      <g filter="url(#softShadow)">
        <g clip-path="url(#shieldClip)">
          ${pattern}
          <rect x="0" y="0" width="512" height="130" fill="#ffffff" opacity="0.08" />
          <rect x="0" y="420" width="512" height="92" fill="#000000" opacity="0.10" />
          ${showBannerText && safeBannerText ? `
            <g>
              <rect x="${bannerRect.x}" y="${bannerRect.y}" width="${bannerRect.w}" height="${bannerRect.h}" rx="${bannerRect.rx}" fill="${bannerFill}" opacity="0.92" />
              <rect x="${bannerRect.x}" y="${bannerRect.y}" width="${bannerRect.w}" height="${Math.max(10, Math.floor(bannerRect.h * 0.18))}" rx="${bannerRect.rx}" fill="#ffffff" opacity="0.12" />
              <text
                x="256"
                y="${bannerY}"
                text-anchor="middle"
                font-family="Montserrat, Arial, sans-serif"
                font-size="${bannerFontSize}"
                font-weight="800"
                letter-spacing="1"
                fill="${bannerTextColor}"
                textLength="${bannerTextLength}"
                lengthAdjust="spacingAndGlyphs"
              >${safeBannerText}</text>
            </g>
          ` : ""}
        </g>
        <path d="${SHIELD_PATH}" fill="none" stroke="#ffffff" stroke-opacity="0.88" stroke-width="12" />
        <path d="${SHIELD_PATH}" fill="none" stroke="#0f172a" stroke-opacity="0.30" stroke-width="20" />
        ${showInitials ? `
          <g>
            <text x="256" y="286"
              text-anchor="middle"
              font-family="Montserrat, Arial, sans-serif"
              font-size="118"
              font-weight="900"
              fill="#ffffff"
              stroke="#111827"
              stroke-width="12"
              paint-order="stroke fill"
              letter-spacing="4">${safeInitials}</text>
          </g>
        ` : ""}
      </g>
    </svg>
  `.trim();
}

function svgToDataUrl(svg) {
  return `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`;
}

export default function AdminTeamLogoCreator({
  darkMode,
  teamName,
  abbreviation,
  onApply,
  currentUrl,
}) {
  const [colorA, setColorA] = useState("#0f172a");
  const [colorB, setColorB] = useState("#f97316");
  const [patternId, setPatternId] = useState("split_vertical");
  const [showInitials, setShowInitials] = useState(true);
  const [manualInitials, setManualInitials] = useState("");
  const [showBannerText, setShowBannerText] = useState(false);
  const [bannerTextPosition, setBannerTextPosition] = useState("bottom");
  const [manualBannerText, setManualBannerText] = useState("");

  const initials = useMemo(
    () => (manualInitials.trim() ? manualInitials.trim().toUpperCase().slice(0, 5) : buildInitials(teamName, abbreviation)),
    [manualInitials, teamName, abbreviation]
  );

  const svg = useMemo(
    () => buildShieldSvg({
      colorA,
      colorB,
      patternId,
      initials,
      showInitials,
      bannerText: manualBannerText.trim() || String(teamName || "").trim(),
      showBannerText,
      bannerPosition: bannerTextPosition,
    }),
    [colorA, colorB, patternId, initials, showInitials, manualBannerText, teamName, showBannerText, bannerTextPosition]
  );
  const dataUrl = useMemo(() => svgToDataUrl(svg), [svg]);

  const card = darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-gray-50";
  const buttonBase = darkMode
    ? "border-white/10 bg-white/5 text-gray-200 hover:bg-white/10"
    : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50";

  return (
    <div className={`rounded-2xl border p-4 space-y-4 ${card}`}>
      <div className="flex items-center justify-between gap-3">
        <div>
          <div className="font-semibold text-sm">Prosty kreator logo (SVG)</div>
          <div className={`text-xs ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
            1 ksztalt tarczy + 2 kolory + wzor. Generowane logo zapisze sie jako grafika SVG.
          </div>
        </div>
        <button
          type="button"
          onClick={() => onApply(dataUrl)}
          className="px-3 py-2 rounded-xl bg-orange-500 text-black text-sm font-medium hover:bg-orange-400"
        >
          Uzyj tego logo
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-[220px_1fr] gap-4">
        <div className="space-y-3">
          <div className={`rounded-2xl border p-3 flex items-center justify-center ${card}`}>
            <img src={dataUrl} alt="Podglad logo" className="w-40 h-40 object-contain" />
          </div>
          {currentUrl && currentUrl !== dataUrl && (
            <div className={`rounded-xl border p-2 ${card}`}>
              <div className={`text-xs mb-2 ${darkMode ? "text-gray-400" : "text-gray-500"}`}>Obecne logo</div>
              <img src={currentUrl} alt="Obecne logo" className="w-16 h-16 object-contain rounded-lg" />
            </div>
          )}
          <button
            type="button"
            onClick={() => {
              setColorA("#0f172a");
              setColorB("#f97316");
              setPatternId("split_vertical");
              setShowInitials(true);
              setManualInitials("");
              setShowBannerText(false);
              setBannerTextPosition("bottom");
              setManualBannerText("");
            }}
            className={`w-full px-3 py-2 rounded-xl border text-sm ${buttonBase}`}
          >
            Reset ustawien
          </button>
        </div>

        <div className="space-y-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div className="space-y-2">
              <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Kolor 1</label>
              <div className="flex items-center gap-3">
                <input type="color" value={colorA} onChange={(e) => setColorA(e.target.value)} className="w-12 h-10 rounded border-0 bg-transparent p-0" />
                <input
                  type="text"
                  value={colorA}
                  onChange={(e) => setColorA(e.target.value)}
                  className={`flex-1 px-3 py-2 rounded-xl border text-sm ${darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300 text-gray-900"}`}
                />
              </div>
            </div>
            <div className="space-y-2">
              <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Kolor 2</label>
              <div className="flex items-center gap-3">
                <input type="color" value={colorB} onChange={(e) => setColorB(e.target.value)} className="w-12 h-10 rounded border-0 bg-transparent p-0" />
                <input
                  type="text"
                  value={colorB}
                  onChange={(e) => setColorB(e.target.value)}
                  className={`flex-1 px-3 py-2 rounded-xl border text-sm ${darkMode ? "bg-white/5 border-white/10 text-white" : "bg-white border-gray-300 text-gray-900"}`}
                />
              </div>
            </div>
          </div>

          <div className="space-y-2">
            <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Wzor kolorow</label>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
              {PATTERNS.map((pattern) => {
                const selected = patternId === pattern.id;
                return (
                  <button
                    key={pattern.id}
                    type="button"
                    onClick={() => setPatternId(pattern.id)}
                    className={`text-left px-3 py-2 rounded-xl border text-sm ${
                      selected
                        ? (darkMode ? "border-orange-400/40 bg-orange-500/10 text-orange-200" : "border-orange-200 bg-orange-50 text-orange-700")
                        : buttonBase
                    }`}
                  >
                    {pattern.label}
                  </button>
                );
              })}
            </div>
          </div>

          <div className="space-y-2">
            <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Inicjaly na tarczy</label>
            <div className="flex items-center gap-2">
              <label className={`flex items-center gap-2 text-sm ${darkMode ? "text-gray-300" : "text-gray-700"}`}>
                <input
                  type="checkbox"
                  checked={showInitials}
                  onChange={(e) => setShowInitials(e.target.checked)}
                  className="w-4 h-4"
                />
                Pokaz inicjaly
              </label>
              <button
                type="button"
                onClick={() => { const tmp = colorA; setColorA(colorB); setColorB(tmp); }}
                className={`ml-auto px-3 py-1.5 rounded-lg border text-xs ${buttonBase}`}
              >
                Zamien kolory
              </button>
            </div>
            <input
              type="text"
              value={manualInitials}
              onChange={(e) => setManualInitials(e.target.value)}
              placeholder={`Auto: ${buildInitials(teamName, abbreviation)}`}
              disabled={!showInitials}
              className={`w-full px-3 py-2 rounded-xl border text-sm ${darkMode ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500" : "bg-white border-gray-300 text-gray-900 placeholder:text-gray-400"} ${!showInitials ? "opacity-60" : ""}`}
            />
            <div className={`text-xs ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
              Zostaw puste, aby uzyc skrotu druzyny lub inicjalow z nazwy.
            </div>
          </div>

          <div className="space-y-2">
            <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>Napis na logo (auto dopasowanie)</label>
            <div className="flex flex-wrap items-center gap-3">
              <label className={`flex items-center gap-2 text-sm ${darkMode ? "text-gray-300" : "text-gray-700"}`}>
                <input
                  type="checkbox"
                  checked={showBannerText}
                  onChange={(e) => setShowBannerText(e.target.checked)}
                  className="w-4 h-4"
                />
                Pokaz napis na belce
              </label>
              <div className="flex items-center gap-3">
                <label className={`flex items-center gap-1 text-xs ${darkMode ? "text-gray-400" : "text-gray-600"}`}>
                  <input
                    type="radio"
                    name="bannerTextPosition"
                    checked={bannerTextPosition === "bottom"}
                    onChange={() => setBannerTextPosition("bottom")}
                    className="w-3.5 h-3.5"
                    disabled={!showBannerText}
                  />
                  dol
                </label>
                <label className={`flex items-center gap-1 text-xs ${darkMode ? "text-gray-400" : "text-gray-600"}`}>
                  <input
                    type="radio"
                    name="bannerTextPosition"
                    checked={bannerTextPosition === "top"}
                    onChange={() => setBannerTextPosition("top")}
                    className="w-3.5 h-3.5"
                    disabled={!showBannerText}
                  />
                  gora
                </label>
              </div>
            </div>
            <input
              type="text"
              value={manualBannerText}
              onChange={(e) => setManualBannerText(e.target.value)}
              placeholder={`Auto: ${String(teamName || "").trim() || "Nazwa druzyny"}`}
              disabled={!showBannerText}
              className={`w-full px-3 py-2 rounded-xl border text-sm ${darkMode ? "bg-white/5 border-white/10 text-white placeholder:text-gray-500" : "bg-white border-gray-300 text-gray-900 placeholder:text-gray-400"} ${!showBannerText ? "opacity-60" : ""}`}
            />
            <div className={`text-xs ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
              Rozmiar czcionki dopasowuje sie automatycznie do dlugosci napisu.
            </div>
          </div>

          <div className={`rounded-xl border p-3 ${card}`}>
            <div className={`text-xs break-all ${darkMode ? "text-gray-400" : "text-gray-500"}`}>
              Format: SVG (lekki, skalowalny). Mozesz tez dalej uzyc zwyklego uploadu pliku.
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
