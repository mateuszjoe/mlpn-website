const fs = require("fs");
const path = require("path");
const { createBookPreviewHtml, config } = require("./lib/bookPreviewHtml.cjs");
const { createTournamentPreviewHtml, createTournamentPreviewManifest, getTournamentPreviewRoutes, config: tournamentPreviewConfig } = require("./lib/tournamentPreviewHtml.cjs");

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

// Keep public /turnieje and the global SPA fallback unchanged. Each known
// preview deep link receives HTTP 200 + noindex without relying on JavaScript.
const demoRoutes = require("../src/data/tournamentDemoRoutes.json");
const archivePath = path.resolve(__dirname, "..", "src", "data", "tournamentArchives.json");
const archives = fs.existsSync(archivePath) ? JSON.parse(fs.readFileSync(archivePath, "utf8")) : [];
if (!Array.isArray(archives)) throw new Error("Tournament archives must be an array.");
const corrections = require('../src/data/tournamentCorrections.json');
for (const correction of corrections) {
  const archive = archives.find(item => item.slug === correction.tournamentSlug);
  if (archive) archive.unassignedPlayers = [...(archive.unassignedPlayers || []), ...(correction.players || [])];
}
const historical = require("../src/data/tournamentHistorical.json");
if (!Array.isArray(historical)) throw new Error("Historical tournaments must be an array.");
const tournamentRoutes = getTournamentPreviewRoutes([...demoRoutes, ...archives, ...historical]);
const tournamentHtml = createTournamentPreviewHtml(fs.readFileSync(indexPath, "utf8"));
for (const route of tournamentRoutes) {
  const directory = path.join(buildDir, route);
  fs.mkdirSync(directory, { recursive: true });
  fs.writeFileSync(path.join(directory, "index.html"), tournamentHtml);
}
fs.copyFileSync(
  path.resolve(__dirname, "..", "public", "turnieje", "tournament-notifications-sw.js"),
  path.join(buildDir, tournamentPreviewConfig.slug, "tournament-notifications-sw.js")
);
fs.writeFileSync(path.join(buildDir, tournamentPreviewConfig.slug, "manifest.webmanifest"), JSON.stringify(createTournamentPreviewManifest(), null, 2));
console.log(`Created ${tournamentRoutes.length} unlisted tournament entry points and a scoped notification worker.`);
