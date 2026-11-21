const test = require('node:test');
const assert = require('node:assert/strict');
const { createBookPreviewHtml, config } = require('./bookPreviewHtml.cjs');

test('preview HTML contains literal crawler policy before any script', () => {
  const publicHtml = '<html><head><meta charset="utf-8"><script src="app.js"></script></head><body></body></html>';
  const previewHtml = createBookPreviewHtml(publicHtml);
  assert.match(previewHtml, /name="robots" content="noindex, nofollow, noarchive"/);
  assert.match(previewHtml, /name="referrer" content="no-referrer"/);
  assert.ok(previewHtml.indexOf('noindex') < previewHtml.indexOf('<script'));
  assert.ok(!publicHtml.includes('noindex'));
});

test('preview directory has no path traversal and is distinct from public archive paths', () => {
  assert.match(config.slug, /^podglad-ksiegi-[a-f0-9]{24}$/);
  assert.notEqual(config.slug, 'ksiega-mlpn');
  assert.notEqual(config.slug, 'archiwum');
});

test('does not silently create indexable output when HTML is malformed', () => {
  assert.throws(() => createBookPreviewHtml('<html><body></body></html>'), /Missing HTML head/);
});
