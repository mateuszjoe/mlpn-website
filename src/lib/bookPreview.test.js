import { syncBookPreviewMetadata } from './bookPreview';

afterEach(() => document.head.querySelectorAll('meta').forEach(meta => meta.remove()));

test('adds noindex and no-referrer only while the preview is open', () => {
  syncBookPreviewMetadata(true);
  expect(document.querySelector('meta[name="robots"]').content).toBe('noindex, nofollow, noarchive');
  expect(document.querySelector('meta[name="referrer"]').content).toBe('no-referrer');
  syncBookPreviewMetadata(false);
  expect(document.querySelector('meta[name="robots"]')).toBeNull();
  expect(document.querySelector('meta[name="referrer"]')).toBeNull();
});

test('adopts the static metadata without duplication and removes it on departure', () => {
  document.head.innerHTML = '<meta id="mlpn-book-preview-robots" name="robots" content="noindex, nofollow, noarchive">';
  syncBookPreviewMetadata(true);
  syncBookPreviewMetadata(true);
  expect(document.querySelectorAll('meta[name="robots"]')).toHaveLength(1);
  syncBookPreviewMetadata(false);
  expect(document.querySelectorAll('meta')).toHaveLength(0);
});

test('does not alter metadata belonging to ordinary public pages', () => {
  document.head.innerHTML = '<meta name="robots" content="index, follow"><meta name="referrer" content="strict-origin-when-cross-origin">';
  syncBookPreviewMetadata(true);
  syncBookPreviewMetadata(false);
  expect(document.querySelector('meta[name="robots"]').content).toBe('index, follow');
  expect(document.querySelector('meta[name="referrer"]').content).toBe('strict-origin-when-cross-origin');
});
