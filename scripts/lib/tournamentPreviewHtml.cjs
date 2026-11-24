const config = require('../../src/data/tournamentPreviewConfig.json');
const { createBookPreviewHtml } = require('./bookPreviewHtml.cjs');
const TABS = ['mecze', 'grupy', 'drabinka', 'statystyki', 'druzyny', 'organizator'];
const safeSegment = value => {
  const segment = String(value ?? '');
  if (!/^[a-z0-9_-]+$/i.test(segment)) throw new Error(`Unsafe tournament preview path segment: ${segment.slice(0, 50)}`);
  return segment;
};

function createTournamentPreviewHtml(html) {
  if (!/^podglad-turniejow-[a-f0-9]{24}$/.test(config.slug)) throw new Error('Unsafe tournament preview directory name');
  // Share the owned robots/referrer meta IDs with the existing book preview.
  // One application effect removes them when navigating back to public pages.
  let manifests = 0;
  const result = createBookPreviewHtml(html).replace(/<link\b[^>]*>/gi, tag => {
    if (!/\brel\s*=\s*(['"])manifest\1/i.test(tag)) return tag;
    manifests += 1;
    if (!/\bhref\s*=\s*(['"])[^'"]*\1/i.test(tag)) throw new Error('Missing manifest href');
    return tag.replace(/(\bhref\s*=\s*)(['"])[^'"]*\2/i, `$1$2/${config.slug}/manifest.webmanifest$2`);
  });
  if (manifests !== 1) throw new Error('Expected one public manifest link');
  return result;
}

function createTournamentPreviewManifest() {
  const root = `/${config.slug}/`;
  return {
    id: root,
    name: 'Turnieje MLPN — podgląd', short_name: 'Turnieje MLPN', lang: 'pl',
    start_url: root, scope: root, display: 'standalone',
    theme_color: '#163c78', background_color: '#f4f7fb',
    icons: [
      { src: '/logo1.png', sizes: '500x500', type: 'image/png', purpose: 'any' },
      { src: '/logo1big.webp', sizes: '5000x5000', type: 'image/webp', purpose: 'any' },
    ],
  };
}

function getTournamentPreviewRoutes(tournaments = []) {
  const routes = new Set([config.slug]);
  const all = [...config.defaultTournamentSlugs.map(slug => ({ slug })), ...tournaments];
  for (const tournament of all) {
    const base = `${config.slug}/${safeSegment(tournament.slug)}`;
    routes.add(base);
    TABS.forEach(tab => routes.add(`${base}/${tab}`));
    for (const team of tournament.teams || []) {
      routes.add(`${base}/druzyna/${safeSegment(team.id)}`);
      for (const player of team.players || []) routes.add(`${base}/zawodnik/${safeSegment(player.id)}`);
    }
    for (const player of tournament.players || []) routes.add(`${base}/zawodnik/${safeSegment(player.id)}`);
    for (const player of tournament.unassignedPlayers || []) routes.add(`${base}/zawodnik/${safeSegment(player.id)}`);
    for (const match of tournament.matches || []) routes.add(`${base}/mecz/${safeSegment(match.id)}`);
  }
  return [...routes];
}

module.exports = { config, createTournamentPreviewHtml, createTournamentPreviewManifest, getTournamentPreviewRoutes };
