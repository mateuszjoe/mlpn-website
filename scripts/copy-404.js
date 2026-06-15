const fs = require("fs");
const path = require("path");

const buildDir = path.resolve(__dirname, "..", "build");
const indexPath = path.join(buildDir, "index.html");
const notFoundPath = path.join(buildDir, "404.html");

if (!fs.existsSync(indexPath)) {
  throw new Error("Cannot create GitHub Pages SPA fallback: build/index.html is missing.");
}

fs.copyFileSync(indexPath, notFoundPath);
console.log("Created build/404.html for GitHub Pages client-side routes.");
