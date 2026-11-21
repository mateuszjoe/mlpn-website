const fs = require("fs");
const path = require("path");
const { createBookPreviewHtml, config } = require("./lib/bookPreviewHtml.cjs");

const buildDir = path.resolve(__dirname, "..", "build");
const indexPath = path.join(buildDir, "index.html");
const notFoundPath = path.join(buildDir, "404.html");

if (!fs.existsSync(indexPath)) {
  throw new Error("Cannot create GitHub Pages SPA fallback: build/index.html is missing.");
}

fs.copyFileSync(indexPath, notFoundPath);
console.log("Created build/404.html for GitHub Pages client-side routes.");

// Dedicated HTTP 200 entry point: crawlers receive noindex before running JS.
// Do not advertise this path in robots.txt, a sitemap, or the public navigation.
const previewDir = path.join(buildDir, config.slug);
fs.mkdirSync(previewDir, { recursive: true });
fs.writeFileSync(path.join(previewDir, "index.html"), createBookPreviewHtml(fs.readFileSync(indexPath, "utf8")));
console.log("Created the unlisted book preview with static noindex metadata.");
