const config = require('../../src/data/bookPreviewConfig.json');

function createBookPreviewHtml(html) {
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(config.slug)) throw new Error('Unsafe preview directory name');
  if (!/<head[\s>]/i.test(html)) throw new Error('Missing HTML head');
  return html.replace(/<head(\s[^>]*)?>/i, head => `${head}\n<meta id="mlpn-book-preview-robots" name="robots" content="${config.robots}">\n<meta id="mlpn-book-preview-referrer" name="referrer" content="no-referrer">`);
}

module.exports = { createBookPreviewHtml, config };
