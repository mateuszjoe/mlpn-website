import { TOURNAMENT_PREVIEW_BASE, TOURNAMENT_PREVIEW_MANIFEST, normalizeTournamentPreviewRoute, tournamentPreviewPath, syncTournamentPreviewManifest } from "./tournamentPreview";

afterEach(() => { syncTournamentPreviewManifest(false); document.head.querySelectorAll('link[rel="manifest"]').forEach(link => link.remove()); });

test("builds catalogue, tab and profile links only under the private prefix", () => {
  expect(tournamentPreviewPath()).toBe(TOURNAMENT_PREVIEW_BASE);
  for (const suffix of ["halinow-2026", "archive/grupy", "archive/druzyna/123", "archive/zawodnik/p_12"]) {
    expect(tournamentPreviewPath(suffix)).toBe(`${TOURNAMENT_PREVIEW_BASE}/${suffix}`);
  }
  expect(TOURNAMENT_PREVIEW_BASE).toMatch(/^\/podglad-turniejow-[a-f0-9]{24}$/);
});

test.each(["../turnieje", "a/../../", "a/unknown", "a/druzyna", "a/druzyna/b/c", "https://other.example", "a?ctx=home", "a#b"])
("rejects malformed nested route %s", value => {
  expect(normalizeTournamentPreviewRoute(value)).toBe("home");
  expect(tournamentPreviewPath(value)).toBe(TOURNAMENT_PREVIEW_BASE);
});

test("normalizes harmless surrounding slashes without changing identifiers", () => {
  expect(normalizeTournamentPreviewRoute("/test-2025/statystyki/")).toBe("test-2025/statystyki");
});

test("uses one preview manifest and restores the exact previous link and attributes on exit", () => {
  document.head.innerHTML = '<link rel="manifest" href="/custom-manifest.json?version=7" crossorigin="use-credentials">';
  const link = document.querySelector('link[rel="manifest"]');
  syncTournamentPreviewManifest(true);
  syncTournamentPreviewManifest(true);
  expect(document.querySelectorAll('link[rel="manifest"]')).toHaveLength(1);
  expect(link.getAttribute('href')).toBe(TOURNAMENT_PREVIEW_MANIFEST);
  syncTournamentPreviewManifest(false);
  expect(link.getAttribute('href')).toBe('/custom-manifest.json?version=7');
  expect(link.getAttribute('crossorigin')).toBe('use-credentials');
});

test("adopts a static preview link and returns to the public manifest after leaving", () => {
  document.head.innerHTML = `<link rel="manifest" href="${TOURNAMENT_PREVIEW_MANIFEST}">`;
  syncTournamentPreviewManifest(true);
  syncTournamentPreviewManifest(false);
  expect(document.querySelector('link[rel="manifest"]').getAttribute('href')).toBe('/manifest.json');
});

test("creates and removes only its own manifest when none existed", () => {
  syncTournamentPreviewManifest(true);
  expect(document.querySelector('link[rel="manifest"]').getAttribute('href')).toBe(TOURNAMENT_PREVIEW_MANIFEST);
  syncTournamentPreviewManifest(false);
  expect(document.querySelector('link[rel="manifest"]')).toBeNull();
});

test("handles the initial public-state effect of a dedicated HTML entry without leaking its manifest", () => {
  document.head.innerHTML = `<link rel="manifest" href="${TOURNAMENT_PREVIEW_MANIFEST}">`;
  syncTournamentPreviewManifest(false);
  expect(document.querySelector('link[rel="manifest"]').getAttribute('href')).toBe('/manifest.json');
  syncTournamentPreviewManifest(true);
  expect(document.querySelector('link[rel="manifest"]').getAttribute('href')).toBe(TOURNAMENT_PREVIEW_MANIFEST);
});

test("ordinary public navigation leaves unrelated manifest links alone", () => {
  document.head.innerHTML = '<link rel="manifest" href="/other.json">';
  syncTournamentPreviewManifest(false);
  expect(document.querySelector('link[rel="manifest"]').getAttribute('href')).toBe('/other.json');
});
