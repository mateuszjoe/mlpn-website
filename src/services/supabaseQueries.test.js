import { fetchSeasonConfig, fetchTopRed } from './supabaseQueries';
import { publicSupabase } from '../lib/supabase';

jest.mock('../lib/supabase', () => ({ publicSupabase: { from: jest.fn() } }));

let responses, requests;

beforeEach(() => {
  responses = {};
  requests = [];
  jest.spyOn(console, 'warn').mockImplementation(() => {});
  publicSupabase.from.mockReset().mockImplementation(table => {
    const request = { table, filters: [] };
    requests.push(request);
    const builder = {
      select: () => builder,
      eq: (column, value) => { request.filters.push([column, value]); return builder; },
      gt: () => builder,
      order: () => builder,
      single: () => builder,
      then: (resolve, reject) => Promise.resolve(responses[table]).then(resolve, reject),
    };
    return builder;
  });
});

afterEach(() => { jest.restoreAllMocks(); });

test('a failed season lookup is an error, not a fabricated 18-round season', async () => {
  const error = { message: 'connection failed' };
  responses.seasons = { data: null, error };
  await expect(fetchSeasonConfig(2026)).rejects.toBe(error);
  expect(requests.map(request => request.table)).toEqual(['seasons']);
});

test('a failed fixture query is an error, not a season with no matches', async () => {
  const error = { message: 'fixture request failed' };
  responses.seasons = { data: { id: 'season', status: 'active' }, error: null };
  responses.v_matches = { data: null, error };
  await expect(fetchSeasonConfig(2026)).rejects.toBe(error);
});

test('an actually empty season still returns a valid empty configuration', async () => {
  responses.seasons = { data: { id: 'season', status: 'active' }, error: null };
  responses.v_matches = { data: [], error: null };
  await expect(fetchSeasonConfig(2026)).resolves.toEqual({
    currentRound: 1, playedRounds: 0, totalRounds: 0, totalRoundsByLeague: {}, playedRoundsByLeague: {},
  });
});

test('red-card ranking falls back to player statistics for the requested season when the view is missing', async () => {
  responses.v_top_red_cards = { data: null, error: { message: 'missing view' } };
  responses.player_season_stats = { data: [{
    player_id: 'player', red_cards: 2, yellow_cards: 5,
    players: { display_name: 'Jan Kowalski' }, teams: { name: 'Zespół' }, leagues: { code: '1' },
  }], error: null };
  await expect(fetchTopRed(2025)).resolves.toEqual([{
    playerId: 'player', name: 'Jan Kowalski', team: 'Zespół', league: '1', red: 2, yellow: 5,
  }]);
  expect(requests[1].filters).toContainEqual(['seasons.year', 2025]);
});

test('a failed red-card fallback propagates the error instead of overwriting good cached rankings with an empty list', async () => {
  const error = { message: 'fallback connection failed' };
  responses.v_top_red_cards = { data: null, error: { message: 'missing view' } };
  responses.player_season_stats = { data: null, error };
  await expect(fetchTopRed(2026)).rejects.toBe(error);
});
