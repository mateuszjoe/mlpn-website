import React from 'react';
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import { publicSupabase, supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { validateManagedTournament } from '../lib/tournamentManagement';
import { loadTournamentDocuments, saveTournamentDocument } from './tournamentRepository';
import TournamentLiveCenter from '../components/TournamentLiveCenter';

let mockCenterProps;
jest.mock('../lib/supabase', () => ({ publicSupabase: { from: jest.fn() }, supabase: { rpc: jest.fn(), from: jest.fn() } }));
jest.mock('../contexts/AuthContext', () => ({ useAuth: jest.fn() }));
jest.mock('../pages/TournamentCenter', () => function MockCenter(props) { mockCenterProps = props; return null; });

const documentFor = (extra = {}) => ({ id: 'remote-cup', slug: 'remote-cup', name: 'Puchar', date: '2026-12-20', location: 'Halinów', status: 'upcoming', rules: {}, teams: [], groups: [], matches: [], ...extra });
const record = (document = documentFor(), revision = 1) => ({ slug: document.slug, document, revision, updated_at: '2026-11-25T12:00:00Z' });
const chain = result => { const query = { select: jest.fn(), order: jest.fn(), abortSignal: jest.fn().mockImplementation(() => Promise.resolve(result)) }; query.select.mockReturnValue(query); query.order.mockReturnValue(query); return query; };
const deferred = () => { let resolve; const promise = new Promise(done => { resolve = done; }); return { promise, resolve }; };
beforeEach(() => {
  jest.clearAllMocks();
  publicSupabase.from.mockReturnValue(chain({ data: [record()], error: null }));
  supabase.rpc.mockReturnValue(chain({ data: [record()], error: null }));
});

describe('tournament repository', () => {
  test('reads through the public client and attaches only the confirmed revision', async () => {
    const query = chain({ data: [record()], error: null }); publicSupabase.from.mockReturnValue(query);
    const tournaments = await loadTournamentDocuments();
    expect(publicSupabase.from).toHaveBeenCalledWith('tournament_documents');
    expect(query.select).toHaveBeenCalledWith('slug,document,revision,updated_at');
    expect(tournaments).toEqual([{ ...validateManagedTournament(documentFor()), _revision: 1 }]);
    expect(supabase.rpc).not.toHaveBeenCalled();
  });

  test('validates and strips client revision before the authenticated compare-and-swap call', async () => {
    const next = documentFor({ name: 'Nowa nazwa', _revision: 4 });
    supabase.rpc.mockReturnValue(chain({ data: [record(documentFor({ name: 'Nowa nazwa' }), 5)], error: null }));
    await expect(saveTournamentDocument(next, 4)).resolves.toMatchObject({ name: 'Nowa nazwa', _revision: 5 });
    expect(supabase.rpc).toHaveBeenCalledWith('save_tournament_document', { p_document: validateManagedTournament(documentFor({ name: 'Nowa nazwa' })), p_expected_revision: 4 });
    expect(next._revision).toBe(4);
    expect(supabase.from).not.toHaveBeenCalled();
  });

  test('new records use expected revision zero and require a revision-one receipt', async () => {
    await expect(saveTournamentDocument(documentFor(), 0)).resolves.toMatchObject({ _revision: 1 });
    expect(supabase.rpc.mock.calls[0][1].p_expected_revision).toBe(0);
  });

  test.each([
    [null], [[]], [[record(documentFor(), 2)]], [[record(documentFor({ slug: 'another-cup' }))]], [[record(), record()]],
  ])('does not report success for an absent, stale or mismatched receipt %j', async data => {
    supabase.rpc.mockReturnValue(chain({ data, error: null }));
    await expect(saveTournamentDocument(documentFor(), 0)).rejects.toMatchObject({ code: 'SAVE_UNCONFIRMED' });
  });

  test.each([['40001', 'CONFLICT', 'Wczytaj aktualną wersję'], ['42501', 'FORBIDDEN', 'Brak uprawnień'], ['XX000', 'SAVE_UNCONFIRMED', 'Nie udało się potwierdzić']])
  ('maps server error %s to useful guidance without exposing internal details', async (code, expected, message) => {
    supabase.rpc.mockReturnValue(chain({ data: null, error: { code, message: 'private SQL internals' } }));
    await expect(saveTournamentDocument(documentFor(), 0)).rejects.toMatchObject({ code: expected, message: expect.stringContaining(message) });
  });

  test('shows trusted validation guidance instead of suggesting an uncertain save', async () => {
    supabase.rpc.mockReturnValue(chain({ data: null, error: { code: '22023', message: 'Liczba goli lub asyst w protokole przekracza wynik.', details: 'private trigger context' } }));
    await expect(saveTournamentDocument(documentFor(), 0)).rejects.toMatchObject({ code: 'INVALID_DOCUMENT', message: 'Liczba goli lub asyst w protokole przekracza wynik.' });
    supabase.rpc.mockReturnValue(chain({ data: null, error: { code: '22023', message: 'cannot extract elements from an object: private SQL internals' } }));
    await expect(saveTournamentDocument(documentFor(), 0)).rejects.toMatchObject({ code: 'INVALID_DOCUMENT', message: 'Sprawdź dane turnieju i popraw wskazane pola.' });
  });

  test('rejects invalid data and revision before making any write', async () => {
    await expect(saveTournamentDocument(documentFor({ name: '' }), 0)).rejects.toThrow();
    await expect(saveTournamentDocument(documentFor(), -1)).rejects.toMatchObject({ code: 'INVALID_REVISION' });
    await expect(saveTournamentDocument(documentFor({ _revision: 2 }), 3)).rejects.toMatchObject({ code: 'INVALID_REVISION' });
    expect(supabase.rpc).not.toHaveBeenCalled();
  });

  test('rejects malformed public documents instead of marking storage ready', async () => {
    publicSupabase.from.mockReturnValue(chain({ data: [record(documentFor({ teams: null }))], error: null }));
    await expect(loadTournamentDocuments()).rejects.toMatchObject({ code: 'LOAD_FAILED' });
  });
});

describe('live center access and updates', () => {
  let host, root;
  const admin = { user: { id: 'admin' }, isAdmin: true, isAccountActive: true };
  const render = async (route = 'home') => { await act(async () => { root.render(<TournamentLiveCenter route={route} basePath="/private-preview" />); }); };
  beforeEach(() => {
    global.IS_REACT_ACT_ENVIRONMENT = true;
    useAuth.mockReturnValue(admin);
    Object.defineProperty(document, 'visibilityState', { configurable: true, value: 'visible' });
    host = document.createElement('div'); document.body.appendChild(host); root = createRoot(host);
  });
  afterEach(async () => { await act(async () => root.unmount()); host.remove(); jest.useRealTimers(); delete document.visibilityState; });

  test.each([
    { user: null, isAdmin: false, isAccountActive: true },
    { user: { id: 'editor' }, isAdmin: false, isAccountActive: true },
    { user: { id: 'admin' }, isAdmin: true, isAccountActive: false },
  ])('blocks writes for viewers, editors and inactive administrators', async auth => {
    useAuth.mockReturnValue(auth); await render();
    expect(mockCenterProps.canManage).toBe(false);
    await expect(mockCenterProps.onSave(documentFor(), 1)).rejects.toMatchObject({ code: 'FORBIDDEN' });
    await expect(mockCenterProps.onCreate(documentFor())).rejects.toMatchObject({ code: 'FORBIDDEN' });
    expect(supabase.rpc).not.toHaveBeenCalled();
  });

  test('shows static data on load failure and does not permit saving until reload succeeds', async () => {
    publicSupabase.from.mockReturnValue(chain({ data: null, error: { message: 'private outage details' } }));
    await render();
    expect(mockCenterProps.catalog).toHaveLength(8);
    expect(mockCenterProps.catalog.every(tournament => tournament._revision === 0)).toBe(true);
    expect(mockCenterProps.storageReady).toBe(false);
    expect(mockCenterProps.loadError).not.toContain('private outage');
    await expect(mockCenterProps.onCreate(documentFor())).rejects.toMatchObject({ code: 'NOT_READY' });
    expect(supabase.rpc).not.toHaveBeenCalled();
    publicSupabase.from.mockReturnValue(chain({ data: [record()], error: null }));
    await act(async () => { await mockCenterProps.onReload(); });
    expect(mockCenterProps.storageReady).toBe(true);
    expect(mockCenterProps.loadError).toBe('');
  });

  test('waits for a confirmed save and keeps the current document on a later conflict', async () => {
    await render('remote-cup/organizator');
    const pending = deferred(); supabase.rpc.mockReturnValue(chain(pending.promise));
    let saving;
    await act(async () => { saving = mockCenterProps.onSave(documentFor({ name: 'Zmieniony puchar', _revision: 1 }), 1); });
    expect(mockCenterProps.catalog.find(tournament => tournament.slug === 'remote-cup').name).toBe('Puchar');
    await act(async () => { pending.resolve({ data: [record(documentFor({ name: 'Zmieniony puchar' }), 2)], error: null }); await saving; });
    expect(mockCenterProps.catalog.find(tournament => tournament.slug === 'remote-cup')).toMatchObject({ name: 'Zmieniony puchar', _revision: 2 });
    supabase.rpc.mockReturnValue(chain({ data: null, error: { code: '40001' } }));
    await expect(mockCenterProps.onSave(documentFor({ name: 'Nadpisanie', _revision: 2 }), 2)).rejects.toMatchObject({ code: 'CONFLICT' });
    expect(mockCenterProps.catalog.find(tournament => tournament.slug === 'remote-cup').name).toBe('Zmieniony puchar');
  });

  test('honors current authentication even when an older editor callback is retained', async () => {
    await render(); const previousSave = mockCenterProps.onSave;
    useAuth.mockReturnValue({ ...admin, user: null }); await render();
    await expect(previousSave(documentFor(), 1)).rejects.toMatchObject({ code: 'FORBIDDEN' });
    expect(supabase.rpc).not.toHaveBeenCalled();
  });

  test('refreshes viewers every twenty seconds and on focus but leaves editor drafts alone', async () => {
    jest.useFakeTimers(); await render();
    expect(publicSupabase.from).toHaveBeenCalledTimes(1);
    await act(async () => { jest.advanceTimersByTime(20000); });
    expect(publicSupabase.from).toHaveBeenCalledTimes(2);
    await render('remote-cup/organizator');
    await act(async () => { jest.advanceTimersByTime(40000); window.dispatchEvent(new Event('focus')); document.dispatchEvent(new Event('visibilitychange')); });
    expect(publicSupabase.from).toHaveBeenCalledTimes(2);
    await render('remote-cup/grupy');
    await act(async () => { window.dispatchEvent(new Event('focus')); });
    expect(publicSupabase.from).toHaveBeenCalledTimes(3);
  });
});
