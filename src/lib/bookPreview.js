import config from '../data/bookPreviewConfig.json';

export const BOOK_PREVIEW_SLUG = config.slug;
export const BOOK_PREVIEW_SECTION = config.section;

// These IDs are also used in the static preview HTML, so leaving the preview
// through client-side navigation removes its policy from ordinary pages.
export function syncBookPreviewMetadata(enabled, doc = document) {
  for (const [id, name, content] of [
    ['mlpn-book-preview-robots', 'robots', config.robots],
    ['mlpn-book-preview-referrer', 'referrer', 'no-referrer'],
  ]) {
    let meta = doc.getElementById(id);
    if (!enabled) { meta?.remove(); continue; }
    if (!meta) { meta = doc.createElement('meta'); meta.id = id; doc.head.appendChild(meta); }
    meta.name = name;
    meta.content = content;
  }
}
