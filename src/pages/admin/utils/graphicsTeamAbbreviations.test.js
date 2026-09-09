import { GRAPHIC_TEAM_ABBREVIATIONS, getGraphicTeamAbbreviation } from "./graphicsTeamAbbreviations";

describe("approved graphic team abbreviations", () => {
  test("contains exactly 34 current teams with unique three-character labels", () => {
    const abbreviations = Object.values(GRAPHIC_TEAM_ABBREVIATIONS);
    expect(abbreviations).toHaveLength(34);
    expect(new Set(abbreviations).size).toBe(34);
    abbreviations.forEach((abbreviation) => expect(abbreviation).toMatch(/^[A-Z0-9]{3}$/));
  });

  test.each(Object.entries(GRAPHIC_TEAM_ABBREVIATIONS))("uses the approved label for %s", (name, abbreviation) => {
    expect(getGraphicTeamAbbreviation(name, "OLD")).toBe(abbreviation);
  });

  test("uses the final ALM and DTX corrections ahead of older database abbreviations", () => {
    expect(getGraphicTeamAbbreviation("Al Mar Wołomin", "AMW")).toBe("ALM");
    expect(getGraphicTeamAbbreviation("Detox", "DET")).toBe("DTX");
  });

  test.each([
    ["  al  mar   wolomin  ", "ALM"],
    ["AL-MAR WOŁOMIN", "ALM"],
    ["  dEtOx  ", "DTX"],
    ["fc slimak halinow", "SLI"],
    ["FC S\u0301limak Halino\u0301w", "SLI"],
    ["al komat", "ALK"],
    ["Huragan\tPoręby\nNowe", "HPN"],
  ])("normalizes case, Polish accents and spacing in %s", (name, abbreviation) => {
    expect(getGraphicTeamAbbreviation(name)).toBe(abbreviation);
  });

  test("keeps both Pendrachy teams distinct", () => {
    expect(getGraphicTeamAbbreviation("RKS Pendrachy")).toBe("RKS");
    expect(getGraphicTeamAbbreviation("RKS Pendrachy II")).toBe("RK2");
  });

  test("uses a sanitized, at-most-three-character supplied fallback for unknown teams", () => {
    expect(getGraphicTeamAbbreviation("Nowa drużyna", "n.d.2-extra")).toBe("ND2");
    expect(getGraphicTeamAbbreviation("Nowa drużyna", "łódź")).toBe("LOD");
    expect(getGraphicTeamAbbreviation(null, "abcde")).toBe("ABC");
  });

  test("derives a compact label when neither approved name nor usable fallback exists", () => {
    expect(getGraphicTeamAbbreviation("Nowa Drużyna Testowa IV")).toBe("NDT");
    expect(getGraphicTeamAbbreviation("Nowa Drużyna")).toBe("ND");
    expect(getGraphicTeamAbbreviation("Żółwie", "---")).toBe("ZOL");
    expect(getGraphicTeamAbbreviation("A")).toBe("A");
  });

  test.each([undefined, null, "", "   ", "---", 123, {}])("handles an absent or invalid name: %s", (name) => {
    expect(getGraphicTeamAbbreviation(name)).toBe("???");
  });
});
