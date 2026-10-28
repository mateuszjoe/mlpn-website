import React from 'react';
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import { useMLPNData } from './useMLPNData';
import * as queries from '../services/supabaseQueries';
import { MATCH_DATA_UPDATED_EVENT } from '../lib/matchDataEvents';

jest.mock('../services/supabaseQueries', () => ({
  fetchSeasons: jest.fn(),
  fetchSeasonConfig: jest.fn(),
  fetchStandings: jest.fn(),
  fetchAllMatches: jest.fn(),
  fetchTeamsForSeason: jest.fn(),
  fetchTopScorers: jest.fn(),
  fetchTopAssists: jest.fn(),
  fetchTopYellow: jest.fn(),
  fetchTopRed: jest.fn(),
  fetchNews: jest.fn(),
  fetchPolls: jest.fn(),
  fetchSponsors: jest.fn(),
  fetchActiveTyperConfig: jest.fn(),
  fetchFreeAgents: jest.fn(),
  fetchTournaments: jest.fn(),
  fetchSeasonSummary: jest.fn(),
  fetchSeasonMatchGalleries: jest.fn(),
}));

let host, root, latest, seasons;
const copy = value => JSON.parse(JSON.stringify(value));
const rankingQueries = ['fetchTopScorers', 'fetchTopAssists', 'fetchTopYellow', 'fetchTopRed'];
const aggregateQueries = ['fetchSeasonConfig', 'fetchStandings', ...rankingQueries];

function deferred() {
  let resolve, reject;
  const promise = new Promise((resolvePromise, rejectPromise) => {
    resolve = resolvePromise;
    reject = rejectPromise;
  });
  return { promise, resolve, reject };
}

function season(year, active = false) {
  const fixture = (id, home, away, status) => ({
    id: `${year}-${id}`, home: `${home} ${year}`, away: `${away} ${year}`,
    league: '1', round: 2, date: `${year}-10-27`, status,
    homeGoals: status === 'completed' ? 1 : 0, awayGoals: 0,
  });
  return {
    version: 1,
    fixtures: [
      fixture('previous', 'Alpha', 'Beta', 'completed'),
      ...(active ? [fixture('first', 'Alpha', 'Beta', 'live'), fixture('second', 'Gamma', 'Delta', 'live')] : []),
    ],
  };
}

function matchData(year) {
  const fixtures = copy(seasons[year].fixtures);
  return {
    fixtures,
    matches: fixtures.filter(match => ['completed', 'walkover_home', 'walkover_away'].includes(match.status)),
  };
}

function tableData(year) {
  const rows = ['Alpha', 'Beta', 'Gamma', 'Delta'].map(team => ({
    team: `${team} ${year}`, league: '1', pts: seasons[year].version,
  }));
  return { tableByLeague: { '1': rows }, teamStats: Object.fromEntries(rows.map(row => [row.team, row])) };
}

function Harness() {
  latest = useMLPNData();
  return null;
}

async function mount() {
  await act(async () => { root.render(<Harness />); });
}

async function poll() {
  await act(async () => { document.dispatchEvent(new Event('visibilitychange')); });
}

async function selectSeason(year) {
  await act(async () => { latest.setCurrentSeason(year); });
}

beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  jest.useFakeTimers();
  jest.spyOn(document, 'visibilityState', 'get').mockReturnValue('visible');
  jest.spyOn(console, 'warn').mockImplementation(() => {});
  jest.spyOn(console, 'error').mockImplementation(() => {});
  Object.values(queries).filter(jest.isMockFunction).forEach(query => query.mockReset());
  seasons = { 2025: season(2025), 2026: season(2026, true) };
  queries.fetchSeasons.mockResolvedValue([
    { id: 'archive', year: 2025, status: 'completed', is_current: false },
    { id: 'current', year: 2026, status: 'active', is_current: true },
  ]);
  queries.fetchSeasonConfig.mockImplementation(async year => ({
    currentRound: seasons[year].version, playedRounds: seasons[year].version,
    totalRounds: 18, totalRoundsByLeague: { '1': 18 }, playedRoundsByLeague: { '1': seasons[year].version },
  }));
  queries.fetchStandings.mockImplementation(async year => tableData(year));
  queries.fetchAllMatches.mockImplementation(async year => matchData(year));
  queries.fetchTeamsForSeason.mockImplementation(async year => [{ year }]);
  rankingQueries.forEach(name => queries[name].mockImplementation(async year => [{ name, year, version: seasons[year].version }]));
  ['fetchNews', 'fetchPolls', 'fetchSponsors', 'fetchFreeAgents', 'fetchTournaments', 'fetchSeasonMatchGalleries']
    .forEach(name => queries[name].mockResolvedValue([]));
  queries.fetchActiveTyperConfig.mockResolvedValue(null);
  queries.fetchSeasonSummary.mockResolvedValue(null);
  host = document.createElement('div');
  document.body.appendChild(host);
  root = createRoot(host);
});

afterEach(async () => {
  await act(async () => { root.unmount(); });
  host.remove();
  jest.useRealTimers();
  jest.restoreAllMocks();
});

test.each([
  ['one of two live matches finishes', fixtures => { fixtures[1].status = 'completed'; fixtures[1].homeGoals = 3; }],
  ['a completed score is corrected', fixtures => { fixtures[0].homeGoals = 4; }],
  ['a completed match becomes a walkover', fixtures => { fixtures[0].status = 'walkover_home'; }],
  ['a result is reopened', fixtures => { fixtures[0].status = 'live'; }],
])('refreshes all aggregates when %s', async (_description, change) => {
  await mount();
  change(seasons[2026].fixtures);
  seasons[2026].version = 2;
  await poll();

  expect(latest.matches).toEqual(matchData(2026).matches);
  expect(latest.fixtures.some(match => match.status === 'live')).toBe(true);
  expect(latest.stats.tableByLeague['1'][0].pts).toBe(2);
  expect(latest.currentRound).toBe(2);
  expect(latest.playedRoundsByLeague).toEqual({ '1': 2 });
  aggregateQueries.forEach(name => expect(queries[name]).toHaveBeenCalledTimes(2));
  ['topScorers', 'topAssists', 'topYellow', 'topRed'].forEach(name => expect(latest.stats[name][0].version).toBe(2));
});

test('refreshes a scheduled match that finished between idle polls', async () => {
  seasons[2026].fixtures.forEach(match => { if (match.status === 'live') match.status = 'scheduled'; });
  await mount();
  seasons[2026].fixtures[1].status = 'completed';
  seasons[2026].version = 2;
  await act(async () => { jest.advanceTimersByTime(5 * 60 * 1000); });
  expect(latest.matches).toHaveLength(2);
  expect(latest.stats.topScorers[0].version).toBe(2);
  expect(queries.fetchStandings).toHaveBeenCalledTimes(2);
});

test('live score refresh keeps table and team detail in sync without reloading unchanged aggregates', async () => {
  await mount();
  const initialTable = latest.stats.tableByLeague['1'];
  seasons[2026].fixtures[1].homeGoals = 2;
  seasons[2026].fixtures[1].away = 'New opponent';
  await act(async () => { jest.advanceTimersByTime(12000); });
  expect(latest.fixtures[1].homeGoals).toBe(2);
  aggregateQueries.forEach(name => expect(queries[name]).toHaveBeenCalledTimes(1));
  const row = latest.stats.tableByLeague['1'][0];
  expect(latest.stats.teamStats['Alpha 2026']).toBe(row);
  expect(row.nextOpponent).toBe('New opponent');
  expect(initialTable[0].nextOpponent).toBe('Beta 2026');

  seasons[2026].fixtures.splice(1, 1);
  await poll();
  expect(latest.stats.teamStats['Alpha 2026'].nextOpponent).toBeNull();
});

test('ignores an old season response arriving after switching seasons', async () => {
  await mount();
  const pending = deferred();
  queries.fetchAllMatches.mockImplementationOnce(() => pending.promise);
  await poll();
  await selectSeason(2025);
  const archive = latest.fixtures;
  await act(async () => { pending.resolve(matchData(2026)); });
  expect(latest.currentSeason).toBe(2025);
  expect(latest.fixtures).toBe(archive);
  expect(latest.matches).toEqual(matchData(2025).matches);
  expect(latest.stats.topScorers[0].year).toBe(2025);
  expect(latest.refreshError).toBeNull();
});

test('ignores aggregates from an old season even if their match request finished before switching', async () => {
  await mount();
  seasons[2026].fixtures[1].status = 'completed';
  const pending = deferred();
  queries.fetchStandings.mockImplementationOnce(() => pending.promise);
  await poll();
  await selectSeason(2025);
  await act(async () => { pending.resolve(tableData(2026)); });
  expect(latest.currentSeason).toBe(2025);
  expect(latest.stats.tableByLeague['1'][0].team).toBe('Alpha 2025');
  expect(latest.stats.topRed[0].year).toBe(2025);
  expect(latest.matches).toEqual(matchData(2025).matches);
});

test('manual refresh wins over an older pending poll for the same season', async () => {
  await mount();
  const staleMatches = matchData(2026);
  const pending = deferred();
  queries.fetchAllMatches.mockImplementationOnce(() => pending.promise);
  await poll();
  seasons[2026].fixtures[1].status = 'completed';
  seasons[2026].version = 2;
  await act(async () => { latest.refreshData(); });
  const freshMatches = latest.matches;
  await act(async () => { pending.resolve(staleMatches); });
  expect(latest.matches).toBe(freshMatches);
  expect(latest.matches).toHaveLength(2);
  expect(latest.stats.topAssists[0].version).toBe(2);
});

test('deduplicates overlapping visibility and interval refreshes', async () => {
  await mount();
  const pending = deferred();
  queries.fetchAllMatches.mockImplementationOnce(() => pending.promise);
  await poll();
  await poll();
  await act(async () => { jest.advanceTimersByTime(24000); });
  expect(queries.fetchAllMatches).toHaveBeenCalledTimes(2);
  await act(async () => { pending.resolve(matchData(2026)); });
  await poll();
  expect(queries.fetchAllMatches).toHaveBeenCalledTimes(3);
});

test('does not start a poll while the initial season load is pending', async () => {
  const pending = deferred();
  queries.fetchStandings.mockImplementationOnce(() => pending.promise);
  await mount();
  await poll();
  expect(latest.loading).toBe(true);
  expect(queries.fetchAllMatches).toHaveBeenCalledTimes(1);
  await act(async () => { pending.resolve(tableData(2026)); });
  expect(latest.loading).toBe(false);
});

test.each(['resolve', 'reject'])('ignores a late full-season load that will %s after switching', async outcome => {
  const pending = deferred();
  queries.fetchStandings.mockImplementationOnce(() => pending.promise);
  await mount();
  await selectSeason(2025);
  expect(latest.loading).toBe(false);
  await act(async () => {
    if (outcome === 'resolve') pending.resolve(tableData(2026));
    else pending.reject(new Error('old load offline'));
  });
  expect(latest.currentSeason).toBe(2025);
  expect(latest.stats.tableByLeague['1'][0].team).toBe('Alpha 2025');
  expect(latest.error).toBeNull();
  expect(latest.loading).toBe(false);
});

test('a stale gallery refresh cannot overwrite galleries from a newer full refresh', async () => {
  await mount();
  const pending = deferred();
  queries.fetchSeasonMatchGalleries.mockImplementationOnce(() => pending.promise);
  await act(async () => { window.dispatchEvent(new Event('mlpn:match-galleries-updated')); });
  queries.fetchSeasonMatchGalleries.mockResolvedValue([{ id: 'new-gallery' }]);
  await act(async () => { latest.refreshData(); });
  await act(async () => { pending.resolve([{ id: 'old-gallery' }]); });
  expect(latest.matchGalleries).toEqual([{ id: 'new-gallery' }]);
});

test('keeps last good data and reports an aggregate failure, then retries that result change', async () => {
  await mount();
  const initialMatches = latest.matches;
  const initialTable = latest.stats.tableByLeague;
  seasons[2026].fixtures[1].status = 'completed';
  seasons[2026].version = 2;
  queries.fetchTopRed.mockRejectedValueOnce(new Error('offline'));
  await poll();
  expect(latest.matches).toBe(initialMatches);
  expect(latest.stats.tableByLeague).toBe(initialTable);
  expect(latest.stats.topRed[0].version).toBe(1);
  expect(latest.error).toBeNull();
  expect(latest.refreshError).toContain('Nie udało się odświeżyć');

  await poll();
  expect(latest.matches).toHaveLength(2);
  expect(latest.stats.topRed[0].version).toBe(2);
  expect(latest.refreshError).toBeNull();
  expect(queries.fetchStandings).toHaveBeenCalledTimes(3);
});

test('a late failed poll cannot show an error for the newly selected season', async () => {
  await mount();
  const pending = deferred();
  queries.fetchAllMatches.mockImplementationOnce(() => pending.promise);
  await poll();
  await selectSeason(2025);
  await act(async () => { pending.reject(new Error('old request offline')); });
  expect(latest.refreshError).toBeNull();
  expect(latest.error).toBeNull();
});

test('reuses archive data on navigation, but an admin update invalidates cached seasons', async () => {
  await mount();
  await selectSeason(2025);
  await selectSeason(2026);
  await selectSeason(2025);
  expect(queries.fetchAllMatches.mock.calls.filter(([year]) => year === 2025)).toHaveLength(1);
  expect(latest.stats.topScorers[0].year).toBe(2025);

  await selectSeason(2026);
  seasons[2025].version = 2;
  await act(async () => { window.dispatchEvent(new Event(MATCH_DATA_UPDATED_EVENT)); });
  await selectSeason(2025);
  expect(queries.fetchAllMatches.mock.calls.filter(([year]) => year === 2025)).toHaveLength(2);
  expect(latest.stats.topScorers[0].version).toBe(2);
});

test('a failed archive load is not cached and can be retried', async () => {
  await mount();
  queries.fetchTopAssists.mockRejectedValueOnce(new Error('offline'));
  await selectSeason(2025);
  expect(latest.error).toContain('2025');
  expect(latest.loading).toBe(false);
  await act(async () => { latest.refreshData(); });
  expect(latest.error).toBeNull();
  expect(latest.stats.topAssists[0].year).toBe(2025);
  expect(queries.fetchAllMatches.mock.calls.filter(([year]) => year === 2025)).toHaveLength(2);
});

test('retry also recovers a failure of the initial season list', async () => {
  queries.fetchSeasons.mockRejectedValueOnce(new Error('offline'));
  await mount();
  expect(latest.error).toContain('Nie udało się połączyć');
  expect(latest.currentSeason).toBeNull();
  expect(latest.loading).toBe(false);
  await act(async () => { latest.refreshData(); });
  expect(queries.fetchSeasons).toHaveBeenCalledTimes(2);
  expect(latest.error).toBeNull();
  expect(latest.currentSeason).toBe(2026);
  expect(latest.stats.tableByLeague['1'][0].team).toBe('Alpha 2026');
});
