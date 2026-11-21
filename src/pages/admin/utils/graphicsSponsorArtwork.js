const BACKGROUNDS = { light: [244, 246, 249], dark: [10, 30, 55] };
const OUTLINES = { light: [15, 42, 74], dark: [244, 246, 249] };
const contrastMaskCache = new WeakMap();
const linear = Array.from({ length: 256 }, (_, value) => {
  const channel = value / 255;
  return channel <= 0.04045 ? channel / 12.92 : ((channel + 0.055) / 1.055) ** 2.4;
});
const luminance = ([r, g, b]) => 0.2126 * linear[r] + 0.7152 * linear[g] + 0.0722 * linear[b];

// Identify only the details that disappear into the actual backing. The mask is
// drawn underneath the original artwork, so brand colours are never replaced.
export function createSponsorContrastMaskPixels(source, background = "light") {
  const pixels = new Uint8ClampedArray(source.length);
  let transparent = 0;
  for (let i = 3; i < source.length; i += 4) if (source[i] < 16) transparent += 1;
  // An opaque rectangular logo already has its own backing. Do not outline its
  // white board or turn the entire rectangle into another sponsor tile.
  if (!source.length || transparent < Math.max(1, source.length / 4 * 0.01)) return { pixels, changed: false };
  const bg = BACKGROUNDS[background] || BACKGROUNDS.light;
  const ink = OUTLINES[background] || OUTLINES.light;
  const bgLuminance = luminance(bg);
  let changed = false;
  for (let i = 0; i < source.length; i += 4) {
    if (source[i + 3] < 32) continue;
    const alpha = source[i + 3] / 255;
    const composed = bg.map((channel, index) => Math.round(source[i + index] * alpha + channel * (1 - alpha)));
    const light = luminance(composed);
    const contrast = (Math.max(light, bgLuminance) + 0.05) / (Math.min(light, bgLuminance) + 0.05);
    if (contrast >= 2.5) continue;
    pixels.set(ink, i);
    pixels[i + 3] = source[i + 3];
    changed = true;
  }
  return { pixels, changed };
}

export function getSponsorContrastMask(image, background = "light") {
  if (!image?.naturalWidth || !image?.naturalHeight) return null;
  const key = background === "dark" ? "dark" : "light";
  if (!contrastMaskCache.has(image)) contrastMaskCache.set(image, new Map());
  const cache = contrastMaskCache.get(image);
  if (cache.has(key)) return cache.get(key);
  // Unsupported or CORS-blocked reads fall back to the original artwork; do not
  // retry expensive reads on every preview frame.
  cache.set(key, null);
  try {
    const canvas = document.createElement("canvas");
    const scale = Math.min(1, 1600 / Math.max(image.naturalWidth, image.naturalHeight));
    canvas.width = Math.max(1, Math.round(image.naturalWidth * scale));
    canvas.height = Math.max(1, Math.round(image.naturalHeight * scale));
    const ctx = canvas.getContext("2d", { willReadFrequently: true });
    if (!ctx) return null;
    ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
    const raster = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const { pixels, changed } = createSponsorContrastMaskPixels(raster.data, key);
    if (!changed) return null;
    raster.data.set(pixels);
    ctx.putImageData(raster, 0, 0);
    canvas.naturalWidth = canvas.width;
    canvas.naturalHeight = canvas.height;
    cache.set(key, canvas);
    return canvas;
  } catch {
    return null;
  }
}
