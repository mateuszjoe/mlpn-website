import {
  getLightBackgroundSponsorArtwork, hasLightSponsorWordmark, recolorLightSponsorPixels,
} from "./graphicsSponsorArtwork";

describe("flat contrasting sponsor artwork", () => {
  test.each(["ISOLA Ristorante", "Isola", "JADŁOSTACJA", "Jadłostacja Sulejówek", "OsłonyDoOkien.pl", "OsłonyDoOkien.pl Grubek"])
  ("recognizes only an approved white wordmark: %s", (name) => {
    expect(hasLightSponsorWordmark(name)).toBe(true);
  });

  test.each(["TOTALbet", "Szwagier-Kop", "Superliga", "HAMAG Fotowoltaika", "Unknown sponsor", "", null])
  ("leaves other sponsor brands alone: %s", (name) => {
    expect(hasLightSponsorWordmark(name)).toBe(false);
  });

  test("recolours bright neutral text while preserving colour, alpha and the original data", () => {
    const source = new Uint8ClampedArray([
      255, 255, 255, 0, // transparent background: even its RGB stays untouched
      255, 255, 255, 255,
      240, 244, 250, 110, // antialiasing keeps its exact alpha
      255, 25, 40, 255, // Isola red
      10, 220, 65, 230, // Isola green
      190, 190, 190, 255, // darker grey is not classified as white text
      255, 235, 150, 255, // pale gold remains gold
    ]);
    const before = [...source];
    const { pixels, changed } = recolorLightSponsorPixels(source);
    expect(changed).toBe(true);
    expect([...pixels]).toEqual([
      255, 255, 255, 0,
      15, 42, 74, 255,
      15, 42, 74, 110,
      255, 25, 40, 255,
      10, 220, 65, 230,
      190, 190, 190, 255,
      255, 235, 150, 255,
    ]);
    expect([...source]).toEqual(before);
  });

  test("never recolours an opaque white board", () => {
    const source = new Uint8ClampedArray([255, 255, 255, 255, 235, 235, 235, 255, 0, 0, 0, 255]);
    const result = recolorLightSponsorPixels(source);
    expect(result.changed).toBe(false);
    expect(result.pixels).toEqual(source);
  });

  test("does not treat a single transparent encoding defect as transparent artwork", () => {
    const source = new Uint8ClampedArray(400 * 4).fill(255);
    source[3] = 0;
    expect(recolorLightSponsorPixels(source).changed).toBe(false);
  });

  test("reads pixels once per image, caps raster memory and reuses the flattened result", () => {
    const source = new Uint8ClampedArray([0, 0, 0, 0, 255, 255, 255, 255]);
    const ctx = { drawImage: jest.fn(), getImageData: jest.fn(() => ({ data: source })), putImageData: jest.fn() };
    const canvas = { getContext: jest.fn(() => ctx) };
    const create = jest.spyOn(document, "createElement").mockReturnValue(canvas);
    try {
      const image = { naturalWidth: 4000, naturalHeight: 2000 };
      const first = getLightBackgroundSponsorArtwork(image, "ISOLA Ristorante");
      expect(first).toBe(canvas);
      expect(canvas.width).toBe(1600);
      expect(canvas.height).toBe(800);
      expect(first.naturalWidth).toBe(1600);
      expect(first.naturalHeight).toBe(800);
      expect(getLightBackgroundSponsorArtwork(image, "Isola")).toBe(first);
      expect(ctx.getImageData).toHaveBeenCalledTimes(1);
      expect(ctx.putImageData).toHaveBeenCalledTimes(1);
      expect(getLightBackgroundSponsorArtwork(image, "TOTALbet")).toBe(image);
    } finally { create.mockRestore(); }
  });

  test("fails back to the original once when browser pixel access is blocked", () => {
    const ctx = { drawImage: jest.fn(), getImageData: jest.fn(() => { throw new Error("SecurityError"); }) };
    const create = jest.spyOn(document, "createElement").mockReturnValue({ getContext: () => ctx });
    try {
      const image = { naturalWidth: 200, naturalHeight: 100 };
      expect(getLightBackgroundSponsorArtwork(image, "Jadłostacja")).toBe(image);
      expect(getLightBackgroundSponsorArtwork(image, "Jadłostacja")).toBe(image);
      expect(ctx.getImageData).toHaveBeenCalledTimes(1);
    } finally { create.mockRestore(); }
  });
});
