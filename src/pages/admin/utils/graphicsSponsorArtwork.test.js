import { createSponsorContrastMaskPixels, getSponsorContrastMask } from "./graphicsSponsorArtwork";

const NAVY = [15, 42, 74];
const PAPER = [244, 246, 249];
const rgbaAt = (pixels, index) => [...pixels.slice(index * 4, index * 4 + 4)];

describe("selective sponsor contrast mask", () => {
  test("protects white artwork without a sponsor-name whitelist and leaves its source untouched", () => {
    const source = new Uint8ClampedArray([
      255, 255, 255, 0,
      255, 255, 255, 255,
      240, 244, 250, 110,
      0, 0, 0, 255,
      180, 20, 30, 255,
      20, 110, 40, 255,
    ]);
    const before = [...source];
    const result = createSponsorContrastMaskPixels(source);
    expect(result.changed).toBe(true);
    expect(result.pixels).not.toBe(source);
    expect(rgbaAt(result.pixels, 0)[3]).toBe(0);
    expect(rgbaAt(result.pixels, 1)).toEqual([...NAVY, 255]);
    expect(rgbaAt(result.pixels, 2)).toEqual([...NAVY, 110]);
    for (const index of [3, 4, 5]) expect(rgbaAt(result.pixels, index)[3]).toBe(0);
    expect([...source]).toEqual(before);
  });

  test("uses the visible colour after alpha composition and preserves qualifying alpha", () => {
    const source = new Uint8ClampedArray([
      0, 0, 0, 0,
      0, 0, 0, 255,
      0, 0, 0, 32,
      255, 255, 255, 31,
      255, 255, 255, 32,
    ]);
    const { pixels, changed } = createSponsorContrastMaskPixels(source, "light");
    expect(changed).toBe(true);
    expect(rgbaAt(pixels, 1)[3]).toBe(0);
    expect(rgbaAt(pixels, 2)).toEqual([...NAVY, 32]);
    expect(rgbaAt(pixels, 3)[3]).toBe(0);
    expect(rgbaAt(pixels, 4)).toEqual([...NAVY, 32]);
  });

  test("uses a light mask for dark artwork on a dark background, leaving white artwork clear", () => {
    const source = new Uint8ClampedArray([
      0, 0, 0, 0,
      15, 42, 74, 255,
      255, 255, 255, 255,
      255, 255, 255, 32,
    ]);
    const { pixels, changed } = createSponsorContrastMaskPixels(source, "dark");
    expect(changed).toBe(true);
    expect(rgbaAt(pixels, 1)).toEqual([...PAPER, 255]);
    expect(rgbaAt(pixels, 2)[3]).toBe(0);
    expect(rgbaAt(pixels, 3)).toEqual([...PAPER, 32]);
  });

  test("does not add a mask when transparent artwork already has sufficient contrast", () => {
    const source = new Uint8ClampedArray([0, 0, 0, 0, 20, 40, 60, 255]);
    expect(createSponsorContrastMaskPixels(source, "light").changed).toBe(false);
  });

  test("never outlines a fully opaque board or an isolated transparent encoding defect", () => {
    const opaque = new Uint8ClampedArray(400 * 4).fill(255);
    expect(createSponsorContrastMaskPixels(opaque).changed).toBe(false);
    const almostOpaque = opaque.slice();
    almostOpaque[3] = 0;
    const before = [...almostOpaque];
    expect(createSponsorContrastMaskPixels(almostOpaque).changed).toBe(false);
    expect([...almostOpaque]).toEqual(before);
  });

  test("requires at least one percent transparent background before treating an image as a cutout", () => {
    const source = new Uint8ClampedArray(400 * 4).fill(255);
    for (let index = 0; index < 3; index += 1) source[index * 4 + 3] = 0;
    expect(createSponsorContrastMaskPixels(source).changed).toBe(false);
    source[3 * 4 + 3] = 15;
    expect(createSponsorContrastMaskPixels(source).changed).toBe(true);
  });

  test("handles empty and fully transparent artwork without manufacturing a mark", () => {
    expect(createSponsorContrastMaskPixels(new Uint8ClampedArray()).changed).toBe(false);
    expect(createSponsorContrastMaskPixels(new Uint8ClampedArray([255, 255, 255, 0])).changed).toBe(false);
  });
});

describe("cached contrast raster", () => {
  afterEach(() => jest.restoreAllMocks());

  function mockRaster(source) {
    const contexts = [];
    const canvases = [];
    const create = jest.spyOn(document, "createElement").mockImplementation(() => {
      const ctx = {
        drawImage: jest.fn(),
        getImageData: jest.fn(() => ({ data: new Uint8ClampedArray(source) })),
        putImageData: jest.fn(),
      };
      const canvas = { getContext: jest.fn(() => ctx) };
      contexts.push(ctx);
      canvases.push(canvas);
      return canvas;
    });
    return { create, contexts, canvases };
  }

  test.each([
    [4000, 2000, 1600, 800],
    [500, 3000, 267, 1600],
    [220, 100, 220, 100],
  ])("caps %i×%i without upscaling and caches its %i×%i mask", (width, height, expectedWidth, expectedHeight) => {
    const { create, contexts, canvases } = mockRaster([0, 0, 0, 0, 255, 255, 255, 255]);
    const image = { naturalWidth: width, naturalHeight: height, name: "Unlisted new sponsor" };
    const mask = getSponsorContrastMask(image);
    expect(mask).toBe(canvases[0]);
    expect(mask.width).toBe(expectedWidth);
    expect(mask.height).toBe(expectedHeight);
    expect(mask.naturalWidth).toBe(expectedWidth);
    expect(mask.naturalHeight).toBe(expectedHeight);
    expect(getSponsorContrastMask(image, "light")).toBe(mask);
    expect(create).toHaveBeenCalledTimes(1);
    expect(contexts[0].drawImage).toHaveBeenCalledWith(image, 0, 0, expectedWidth, expectedHeight);
    expect(contexts[0].getImageData).toHaveBeenCalledTimes(1);
    expect(contexts[0].putImageData).toHaveBeenCalledTimes(1);
  });

  test("keeps separate masks for light and dark backgrounds, keyed by image identity", () => {
    const { create, contexts } = mockRaster([0, 0, 0, 0, 255, 255, 255, 255, 15, 42, 74, 255]);
    const first = { naturalWidth: 220, naturalHeight: 100, src: "/sponsor.webp" };
    const second = { ...first };
    const light = getSponsorContrastMask(first, "light");
    const dark = getSponsorContrastMask(first, "dark");
    expect(light).not.toBeNull();
    expect(dark).not.toBeNull();
    expect(dark).not.toBe(light);
    expect(getSponsorContrastMask(first, "light")).toBe(light);
    expect(getSponsorContrastMask(first, "dark")).toBe(dark);
    expect(getSponsorContrastMask(second, "light")).not.toBe(light);
    expect(create).toHaveBeenCalledTimes(3);
    contexts.forEach(ctx => expect(ctx.getImageData).toHaveBeenCalledTimes(1));
  });

  test.each([
    ["opaque board", [255, 255, 255, 255, 0, 0, 0, 255]],
    ["already contrasting artwork", [0, 0, 0, 0, 20, 40, 60, 255]],
  ])("returns and caches no mask for %s", (label, source) => {
    const { create, contexts } = mockRaster(source);
    const image = { naturalWidth: 220, naturalHeight: 100 };
    expect(getSponsorContrastMask(image)).toBeNull();
    expect(getSponsorContrastMask(image)).toBeNull();
    expect(create).toHaveBeenCalledTimes(1);
    expect(contexts[0].getImageData).toHaveBeenCalledTimes(1);
    expect(contexts[0].putImageData).not.toHaveBeenCalled();
  });

  test("caches a blocked pixel read without retrying or throwing during later frames", () => {
    const ctx = { drawImage: jest.fn(), getImageData: jest.fn(() => { throw new Error("SecurityError"); }) };
    jest.spyOn(document, "createElement").mockReturnValue({ getContext: () => ctx });
    const image = { naturalWidth: 220, naturalHeight: 100 };
    expect(getSponsorContrastMask(image, "light")).toBeNull();
    expect(getSponsorContrastMask(image, "light")).toBeNull();
    expect(ctx.getImageData).toHaveBeenCalledTimes(1);
  });

  test("returns no mask when canvas drawing is unavailable", () => {
    const create = jest.spyOn(document, "createElement").mockReturnValue({ getContext: () => null });
    const image = { naturalWidth: 220, naturalHeight: 100 };
    expect(getSponsorContrastMask(image)).toBeNull();
    expect(getSponsorContrastMask(image)).toBeNull();
    expect(create).toHaveBeenCalledTimes(1);
  });

  test("does not allocate a canvas for missing or unloaded images", () => {
    const create = jest.spyOn(document, "createElement");
    [null, undefined, {}, { naturalWidth: 100, naturalHeight: 0 }].forEach(image => {
      expect(getSponsorContrastMask(image)).toBeNull();
    });
    expect(create).not.toHaveBeenCalled();
  });
});
