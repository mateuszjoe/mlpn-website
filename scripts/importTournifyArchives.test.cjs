const { test, before } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { importAll, SLUGS, positionInPoule, stageFor } = require('./importTournifyArchives.cjs');

const repo = path.resolve(__dirname, '..');
const sourceDir = process.env.TOURNIFY_SOURCE_DIR || path.resolve(repo, '..', '.local/tournify-source');
const snapshotPaths = SLUGS.map(slug => path.join(sourceDir, slug, 'public-export.json'));
const hasSnapshots = snapshotPaths.every(file => fs.existsSync(file));
const raw = hasSnapshots ? snapshotPaths.map(file => JSON.parse(fs.readFileSync(file, 'utf8'))) : [];
const committed = JSON.parse(fs.readFileSync(path.join(repo, 'src/data/tournamentArchives.json'), 'utf8'));
const sourceTest = (name, run) => test(name, { skip: hasSnapshots ? false :
  'Optional source audit: obtain all 5 public Tournify exports described in docs/tournament-preview.md and place them in ../.local/tournify-source/<slug>/public-export.json (or set TOURNIFY_SOURCE_DIR).' }, run);
const expected = [
  { matches: 80, teams: 30, groups: 10, missing: 2, goals: 225, champion: null },
  { matches: 52, teams: 16, groups: 5, missing: 0, goals: 149, champion: 'Zielona i Przyjaciele' },
  { matches: 42, teams: 14, groups: 5, missing: 4, goals: 109, champion: 'STARSZAKI' },
  { matches: 56, teams: 20, groups: 6, missing: 0, goals: 132, champion: 'Hazardziści' },
  { matches: 56, teams: 20, groups: 6, missing: 0, goals: 161, champion: 'Młode Wilki' },
];
let archives, engine;
before(async () => {
  archives = hasSnapshots ? await importAll(sourceDir) : committed;
  engine = await import(`data:text/javascript;base64,${Buffer.from(fs.readFileSync(path.join(repo, 'src/lib/tournamentEngine.js'))).toString('base64')}`);
});

test('committed JSON has complete fixture identities, valid results and coherent event references without local snapshots', () => {
  assert.equal(committed.length, 5);
  assert.equal(committed.reduce((sum, item) => sum + item.matches.length, 0), 286);
  assert.equal(committed.reduce((sum, item) => sum + item.teams.length, 0), 100);
  for (const tournament of committed) {
    const teamIds = new Set(tournament.teams.map(team => team.id));
    const matchIds = new Set(tournament.matches.map(match => match.id));
    assert.equal(teamIds.size, tournament.teams.length);
    assert.equal(matchIds.size, tournament.matches.length);
    for (const match of tournament.matches) {
      assert.ok(teamIds.has(match.homeTeamId) && teamIds.has(match.awayTeamId));
      assert.notEqual(match.homeTeamId, match.awayTeamId);
      for (const field of ['homeScore', 'awayScore', 'homePenalties', 'awayPenalties']) {
        assert.ok(match[field] === null || (Number.isInteger(match[field]) && match[field] >= 0));
      }
      if (match.status === 'finished') assert.ok(match.homeScore !== null && match.awayScore !== null);
      for (const source of [match.homeSource, match.awaySource].filter(Boolean)) {
        if (source.matchId) assert.ok(matchIds.has(source.matchId));
        if (source.groupId) assert.ok(tournament.groups.some(group => group.id === source.groupId));
      }
      for (const event of match.events) {
        assert.ok([match.homeTeamId, match.awayTeamId].includes(event.teamId));
        assert.ok(tournament.teams.find(team => team.id === event.teamId).players.some(player => player.id === event.playerId));
      }
    }
  }
});

test('all five public archives retain every team and fixture, with missing results explicit', () => {
  assert.equal(archives.length, 5);
  assert.equal(archives.reduce((sum, item) => sum + item.matches.length, 0), 286);
  assert.equal(archives.reduce((sum, item) => sum + item.teams.length, 0), 100);
  archives.forEach((item, index) => {
    const want = expected[index];
    assert.equal(item.matches.length, want.matches);
    assert.equal(item.teams.length, want.teams);
    assert.equal(item.groups.length, want.groups);
    assert.equal(item.matches.filter(match => match.sourceScoreMissing).length, want.missing);
    assert.equal(engine.getTournamentStats(item).goals, want.goals);
    assert.equal(item.teams.find(team => team.id === item.championTeamId)?.name || null, want.champion);
    assert.equal(item.sourceUrl, `https://tournifyapp.com/live/${SLUGS[index]}`);
    assert.equal(item.isDemo, false);
    assert.equal(item.isImported, true);
    assert.equal(item.isLocalCopy, false);
  });
});

sourceTest('every score, participant, original group and tie-break order matches its source', () => {
  const nullable = value => value == null || value === '' ? null : Number(value);
  archives.forEach((item, index) => {
    const source = raw[index];
    assert.deepEqual(item.rules.tiebreakers.map(criterion => criterion.id), source.tournament.tiebreakers.map(criterion => criterion.id));
    item.groups.forEach(group => {
      const original = source.collections.poules.find(poule => poule.id === group.id);
      assert.equal(group.name, original.name.trim());
      assert.equal(group.phase, original.fase);
    });
    item.matches.forEach(match => {
      const original = source.collections.matches.find(row => row.id === match.id);
      const poule = source.collections.poules.find(row => row.id === original.poule);
      assert.equal(match.homeScore, nullable(original.score1));
      assert.equal(match.awayScore, nullable(original.score2));
      assert.equal(match.homePenalties, nullable(original.penalties1));
      assert.equal(match.awayPenalties, nullable(original.penalties2));
      assert.equal(match.stage, stageFor(poule));
      assert.equal(match.homeTeamId, source.collections.teams.find(team => positionInPoule(team, poule.id) === Number(original.team1)).id);
      assert.equal(match.awayTeamId, source.collections.teams.find(team => positionInPoule(team, poule.id) === Number(original.team2)).id);
      if (match.reportedWinnerId) {
        assert.equal(match.reportedWinnerId, original.winner === 0 ? match.homeTeamId : match.awayTeamId);
        assert.equal(engine.getMatchWinner(match), match.reportedWinnerId);
        assert.match(match.outcomeNote, /niepodany/);
      }
    });
  });
});

test('all proven bracket links reproduce recorded teams without guessing the ambiguous barrage', () => {
  archives.forEach(item => engine.resolveTournamentMatches(item).forEach((resolved, index) => {
    assert.equal(resolved.homeTeamId, item.matches[index].homeTeamId);
    assert.equal(resolved.awayTeamId, item.matches[index].awayTeamId);
  }));
  assert.equal(archives.reduce((sum, item) => sum + item.importSummary.resolvedDependencies, 0), 49);
  assert.equal(archives.reduce((sum, item) => sum + item.importSummary.preservedAssignments, 0), 1);
  const barrage = archives[1].matches.find(match => match.id === 'VqhE0t7Ezw8QcSHE7aWq');
  assert.equal(barrage.stage, 'playoff');
  assert.equal(barrage.awaySource, undefined);
  assert.ok(archives[1].importSummary.warnings.some(warning => warning.matchId === barrage.id));
});

test('individual records retain 78 source players without inventing teams, goals or minutes', () => {
  const item = archives[4];
  const players = item.teams.flatMap(team => team.players);
  assert.equal(players.length, 72);
  assert.equal(item.unassignedPlayers.length, 6);
  assert.equal(item.importSummary.players, 78);
  const stats = engine.getTournamentStats(item);
  assert.equal(stats.recordedGoals, 37);
  assert.equal(stats.unassignedGoals, 124);
  assert.equal(stats.scorers.reduce((sum, row) => sum + row.goals, 0), 37);
  assert.ok(item.matches.flatMap(match => match.events).every(event => event.minute === null && event.type === 'goal'));
  assert.ok(archives.slice(0, 4).every(item => !item.teams.some(team => team.players.length) && engine.getTournamentStats(item).scorers.length === 0));
});

sourceTest('all player identities from the public snapshot are retained exactly once', () => {
  const item = archives[4];
  const players = [...item.teams.flatMap(team => team.players), ...item.unassignedPlayers];
  assert.deepEqual(players.map(player => player.id).sort(), raw[4].collections.players.map(player => player.id).sort());
});

test('uses source match days and Warsaw DST while disclosing the Halinów date discrepancy', () => {
  assert.equal(archives[0].date, '2025-12-20');
  assert.deepEqual(archives[0].matchDates, ['2025-12-20', '2025-12-21']);
  assert.ok(archives[0].sourceNotes.some(note => note.includes('2025-12-21')));
  assert.ok(archives[0].matches.every(match => match.kickoff.endsWith('+01:00')));
  assert.ok(archives[1].matches.every(match => match.kickoff.endsWith('+02:00')));
});

test('shipped data uses a sport allowlist and never exposes admin identities, DOB or history', () => {
  const forbidden = new Set(['uid', 'admins', 'admin', 'email', 'age', 'birthdate', 'dob', 'history', 'fcmToken', 'accessToken']);
  function visit(value) {
    if (!value || typeof value !== 'object') return;
    Object.entries(value).forEach(([key, child]) => {
      assert.equal(forbidden.has(key), false, `Forbidden exported key: ${key}`);
      visit(child);
    });
  }
  visit(archives);
  const serialized = JSON.stringify(archives);
  assert.equal(serialized.includes('firebasestorage.googleapis.com'), false);
});

sourceTest('source administrator identities never enter shipped sports data', () => {
  const serialized = JSON.stringify(archives);
  raw.forEach(source => {
    if (source.tournament.uid) assert.equal(serialized.includes(source.tournament.uid), false);
  });
});

sourceTest('committed JSON is exactly reproducible from the five local public snapshots', () => {
  assert.deepEqual(committed, archives);
});
