const LIGHT_TEXT_NAVY = [15, 42, 74];
const contrastingArtworkCache = new WeakMap();

export function hasLightSponsorWordmark(name) {
  const key = String(name || "").toLocaleLowerCase("pl-PL").normalize("NFKD")
    .replace(/\p{M}/gu, "").replace(/ł/gu, "l").replace(/[^a-z0-9]/gu, "");
  return [
    "isola", "isolaristorante", "jadlostacja", "jadlostacjasulejowek",
    "oslonydookien", "oslonydookienpl", "oslonydookiengrubek", "oslonydookienplgrubek",
  ].includes(key);
}

// Return an independent raster, leaving both source artwork and its alpha intact.
// A fully opaque white board is artwork in its own right and must not be recoloured.
export function recolorLightSponsorPixels(source) {
  let transparent = 0;
  for (let i = 3; i < source.length; i += 4) {
    if (source[i] < 16) transparent += 1;
  }
  const pixels = new Uint8ClampedArray(source);
  if (!source.length || transparent < Math.max(1, source.length / 4 * 0.01)) {
    return { pixels, changed: false };
  }
  let changed = false;
  for (let i = 0; i < pixels.length; i += 4) {
    if (pixels[i + 3] === 0) continue;
    const min = Math.min(pixels[i], pixels[i + 1], pixels[i + 2]);
    const max = Math.max(pixels[i], pixels[i + 1], pixels[i + 2]);
    if (min >= 210 && max - min <= 20) {
      [pixels[i], pixels[i + 1], pixels[i + 2]] = LIGHT_TEXT_NAVY;
      changed = true;
    }
  }
  return { pixels, changed };
}

export function getLightBackgroundSponsorArtwork(image, name) {
  if (!image?.naturalWidth || !image?.naturalHeight || !hasLightSponsorWordmark(name)) return image;
  if (contrastingArtworkCache.has(image)) return contrastingArtworkCache.get(image);
  // Cache the original on any unsupported/tainted canvas too: never retry pixel
  // reads on every preview frame or compromise export when CORS blocks access.
  contrastingArtworkCache.set(image, image);
  try {
    const canvas = document.createElement("canvas");
    const scale = Math.min(1, 1600 / Math.max(image.naturalWidth, image.naturalHeight));
    canvas.width = Math.max(1, Math.round(image.naturalWidth * scale));
    canvas.height = Math.max(1, Math.round(image.naturalHeight * scale));
    const ctx = canvas.getContext("2d", { willReadFrequently: true });
    if (!ctx) return image;
    ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
    const raster = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const { pixels, changed } = recolorLightSponsorPixels(raster.data);
    if (!changed) return image;
    raster.data.set(pixels);
    ctx.putImageData(raster, 0, 0);
    // The shared crest fitter accepts images by their intrinsic dimensions.
    canvas.naturalWidth = canvas.width;
    canvas.naturalHeight = canvas.height;
    contrastingArtworkCache.set(image, canvas);
    return canvas;
  } catch {
    return image;
  }
}
