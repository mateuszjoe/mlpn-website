const test = require('node:test');
const assert = require('node:assert/strict');
const { config, createTournamentPreviewHtml, createTournamentPreviewManifest, getTournamentPreviewRoutes } = require('./tournamentPreviewHtml.cjs');

test('tournament HTML ships static noindex and no-referrer before scripts, preserving public HTML', () => {
  const source = '<html><head><link rel="manifest" href="/manifest.json" crossorigin="use-credentials"><link rel="icon" href="/logo1.png"><script src="/app.js"></script></head><body></body></html>';
  const result = createTournamentPreviewHtml(source);
  assert.ok(result.indexOf('noindex, nofollow, noarchive') < result.indexOf('<script'));
  assert.match(result, /name="referrer" content="no-referrer"/);
  assert.ok(!source.includes('noindex'));
  assert.ok(result.includes(`<link rel="manifest" href="/${config.slug}/manifest.webmanifest" crossorigin="use-credentials">`));
  assert.ok(result.includes('<link rel="icon" href="/logo1.png">'));
  assert.ok(source.includes('href="/manifest.json"'));
});

test('installed preview opens its own catalogue and stays within its scope', () => {
  const manifest = createTournamentPreviewManifest();
  assert.equal(manifest.start_url, `/${config.slug}/`);
  assert.equal(manifest.scope, manifest.start_url);
  assert.equal(manifest.id, manifest.start_url);
  assert.equal(manifest.display, 'standalone');
  assert.equal(manifest.name, 'Turnieje MLPN — podgląd');
  assert.ok(manifest.icons.every(icon => icon.src.startsWith('/') && !icon.src.startsWith('//')));
});

test('refuses a template missing its manifest rather than silently installing the public app', () => {
  assert.throws(() => createTournamentPreviewHtml('<html><head></head></html>'), /manifest/);
});

test('includes every catalogue, tournament, tab and linked profile beneath the unlisted prefix', () => {
  const tournament = { slug: 'cup-2025', teams: [{ id: 'team-1', players: [{ id: 'player_1' }] }], matches: [{ id: 'match-1' }] };
  const routes = getTournamentPreviewRoutes([tournament, tournament]);
  const base = `${config.slug}/cup-2025`;
  for (const route of [config.slug, base, `${base}/grupy`, `${base}/drabinka`, `${base}/druzyna/team-1`, `${base}/zawodnik/player_1`, `${base}/mecz/match-1`]) assert.ok(routes.includes(route), route);
  assert.equal(routes.length, new Set(routes).size);
  assert.ok(routes.every(route => route === config.slug || route.startsWith(`${config.slug}/`)));
  assert.ok(!routes.includes('turnieje'));
});

test('does not produce arbitrary directories for imported slugs or profile ids', () => {
  for (const entry of [{ slug: '../escape' }, { slug: 'cup', teams: [{ id: '../../escape' }] }, { slug: 'cup', players: [{ id: 'a/b' }] }, { slug: 'cup', unassignedPlayers: [{ id: '../escape' }] }]) {
    assert.throws(() => getTournamentPreviewRoutes([entry]), /Unsafe/);
  }
  assert.throws(() => createTournamentPreviewHtml('<body></body>'), /Missing HTML head/);
});

test('creates static noindex entry points for players preserved without an assigned team', () => {
  const routes = getTournamentPreviewRoutes([{ slug: 'archive', teams: [], unassignedPlayers: [{ id: 'orphan-1' }, { id: 'orphan-1' }] }]);
  assert.equal(routes.filter(route => route === `${config.slug}/archive/zawodnik/orphan-1`).length, 1);
});

test('new partial historical archives have direct tournament, team and confirmed-match routes', () => {
  const archives = require('../../src/data/tournamentHistorical.json');
  const routes = getTournamentPreviewRoutes(archives);
  for (const tournament of archives) {
    const base = `${config.slug}/${tournament.slug}`;
    assert.ok(routes.includes(base));
    assert.ok(routes.includes(`${base}/grupy`));
    for (const team of tournament.teams) assert.ok(routes.includes(`${base}/druzyna/${team.id}`));
    for (const match of tournament.matches) assert.ok(routes.includes(`${base}/mecz/${match.id}`));
  }
});
