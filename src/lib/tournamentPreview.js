import config from "../data/tournamentPreviewConfig.json";

export const TOURNAMENT_PREVIEW_SLUG = config.slug;
export const TOURNAMENT_PREVIEW_CONTEXT = config.context;
export const TOURNAMENT_PREVIEW_BASE = `/${config.slug}`;
export const TOURNAMENT_PREVIEW_MANIFEST = `${TOURNAMENT_PREVIEW_BASE}/manifest.webmanifest`;
const manifestStates = new WeakMap();
const TABS = new Set(["mecze", "grupy", "drabinka", "statystyki", "druzyny", "organizator"]);
const PROFILES = new Set(["druzyna", "zawodnik", "mecz"]);

export function normalizeTournamentPreviewRoute(route) {
  const value = String(route || "home").replace(/^\/+|\/+$/g, "");
  if (!value || value === "home") return "home";
  const segments = value.split("/");
  if (segments.some(segment => !/^[a-z0-9_-]+$/i.test(segment))) return "home";
  if (segments.length === 1 || (segments.length === 2 && TABS.has(segments[1])) ||
      (segments.length === 3 && PROFILES.has(segments[1]))) return segments.join("/");
  return "home";
}

export function tournamentPreviewPath(route = "home") {
  const section = normalizeTournamentPreviewRoute(route);
  return section === "home" ? TOURNAMENT_PREVIEW_BASE : `${TOURNAMENT_PREVIEW_BASE}/${section}`;
}

function isPreviewManifest(link, doc) {
  if (!link?.getAttribute("href")) return false;
  try { return new URL(link.getAttribute("href"), doc.baseURI).pathname === TOURNAMENT_PREVIEW_MANIFEST; }
  catch { return false; }
}

// Installed previews must reopen the hidden catalogue rather than public home.
// Preserve a pre-existing manifest exactly, including custom hrefs/attributes.
export function syncTournamentPreviewManifest(enabled, doc = document) {
  let state = manifestStates.get(doc);
  if (!enabled) {
    if (state) {
      if (state.created) state.link.remove();
      else if (state.previousHref == null) state.link.removeAttribute("href");
      else state.link.setAttribute("href", state.previousHref);
      manifestStates.delete(doc);
    } else {
      // A dedicated HTML entry already has the preview href before React starts.
      // The initial home-state effect can run once before routing is restored.
      const link = doc.querySelector('link[rel="manifest"]');
      if (isPreviewManifest(link, doc)) link.setAttribute("href", "/manifest.json");
    }
    return;
  }
  if (!state) {
    let link = doc.querySelector('link[rel="manifest"]');
    const created = !link;
    if (!link) {
      link = doc.createElement("link"); link.rel = "manifest"; doc.head.appendChild(link);
    }
    state = { link, created, previousHref: isPreviewManifest(link, doc) ? "/manifest.json" : link.getAttribute("href") };
    manifestStates.set(doc, state);
  }
  state.link.setAttribute("href", TOURNAMENT_PREVIEW_MANIFEST);
}
