import React, { useState } from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import TournamentCenter from './TournamentCenter';
import { tournamentCatalog } from '../data/tournamentDemo';
import { demoTournament as demo } from '../lib/__fixtures__/tournamentDemo';
import { getTournamentStats } from '../lib/tournamentEngine';

jest.mock('../components/TournamentShareTools', () => function MockShare({ tournament, basePath }) {
  return <a data-share href={basePath + '/' + tournament.slug}>Link do turnieju</a>;
});
jest.mock('../components/TournamentAdmin', () => {
  const React = require('react');
  const { updateTournamentMatch } = require('../lib/tournamentEngine');
  return function MockAdmin({ tournament, onSave, saving }) {
    const [error, setError] = React.useState('');
    const [notice, setNotice] = React.useState('');
    return <div data-admin><output data-revision>{tournament._revision || 0}</output><button disabled={saving} onClick={async () => {
      const match = tournament.matches.find(item => item.status === 'live') || tournament.matches[0];
      try { await onSave(updateTournamentMatch(tournament, match.id, { homeScore: match.homeScore + 1 })); setError(''); setNotice('Zapisano zmiany.'); }
      catch (failure) { setError(failure.message); }
    }}>Zapisz wynik testowy</button>{error && <p role="alert">{error}</p>}{notice && <p role="status">{notice}</p>}</div>;
  };
});

const basePath = '/podglad-turniejow-test-secret';
let host;
let root;
let archive;

function Wrapper({ initialRoute = 'home', initialCatalog = tournamentCatalog, canManage = false, storageReady = true, save, create }) {
  const [route, setRoute] = useState(initialRoute);
  const [catalog, setCatalog] = useState(initialCatalog);
  return <TournamentCenter route={route} onNavigate={setRoute} basePath={basePath} catalog={catalog} canManage={canManage} storageReady={storageReady}
    onSave={async (next, revision) => { const saved = save ? await save(next, revision) : { ...next, _revision: revision + 1 }; setCatalog(current => current.map(item => item.id === saved.id ? saved : item)); return saved; }}
    onCreate={async next => { const saved = create ? await create(next) : next; setCatalog(current => [...current, saved]); return saved; }} />;
}

beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  window.scrollTo = jest.fn();
  localStorage.clear();
  host = document.createElement('div'); document.body.appendChild(host); root = createRoot(host);
  archive = { ...JSON.parse(JSON.stringify(demo)), id: 'archive-test', slug: 'archiwum-test', isDemo: false, isImported: true, _revision: 7,
    name: 'Archiwalny turniej testowy', status: 'live' };
  tournamentCatalog.push(demo, archive);
});
afterEach(async () => {
  await act(async () => root.unmount()); host.remove(); localStorage.clear();
  const index = tournamentCatalog.indexOf(archive); if (index >= 0) tournamentCatalog.splice(index, 1);
  const demoIndex = tournamentCatalog.indexOf(demo); if (demoIndex >= 0) tournamentCatalog.splice(demoIndex, 1);
});
const render = async (route, props = {}) => act(async () => root.render(<Wrapper initialRoute={route} {...props} />));
const button = text => [...host.querySelectorAll('button, a')].find(element => element.textContent.trim() === text);
const click = async element => act(async () => Simulate.click(element, { button: 0 }));
const change = async (element, value) => act(async () => Simulate.change(element, { target: { value } }));

test('catalog is a compact list of real tournaments with direct links', async () => {
  tournamentCatalog.splice(tournamentCatalog.indexOf(demo), 1);
  await render('home');
  expect(host.querySelector('h1').textContent).toBe('Turnieje');
  const links = [...host.querySelectorAll('.tc-catalog-item a')];
  expect(links).toHaveLength(tournamentCatalog.length);
  expect(links[0].textContent).toContain('Wkrótce');
  expect(host.textContent).not.toContain('Turniej testowy MLPN');
  expect(host.querySelector('.tc-catalog-hero')).toBeNull();
  const link = links.find(element => element.querySelector('h2').textContent === archive.name);
  expect(link.getAttribute('href')).toBe(basePath + '/' + archive.slug);
  expect(button('Dodaj turniej')).toBeUndefined();
});

test('team and player hyperlinks stay inside the unlisted preview and open useful profiles', async () => {
  await render(demo.slug + '/grupy');
  const link = host.querySelector('.tc-group tbody a');
  expect(link.getAttribute('href')).toContain(basePath + '/' + demo.slug + '/druzyna/');
  await click(link);
  expect(host.querySelector('.tc-profile-heading').textContent).toContain('Drużyna');
  const playerLink = host.querySelector('.tc-profile-roster .tc-player-link');
  expect(playerLink.getAttribute('href')).toContain(basePath + '/' + demo.slug + '/zawodnik/');
  await click(playerLink);
  expect(host.querySelector('.tc-profile-heading').textContent).toContain('Zawodnik');
  expect(host.textContent).toContain('meczów ze zdarzeniem');
  expect(host.querySelector('[data-share]').getAttribute('href')).toBe(basePath + '/' + demo.slug);
});

test('visitors cannot open management through a direct organizer URL', async () => {
  const save = jest.fn();
  await render(archive.slug + '/organizator', { save });
  expect(host.querySelector('[data-admin]')).toBeNull();
  expect(host.querySelector('.tc-tabs a[href$="/organizator"]')).toBeNull();
  expect(host.textContent).toContain('Zaloguj się na konto administratora');
  expect(button('Utwórz kopię do testów')).toBeUndefined();
  expect(save).not.toHaveBeenCalled();
});

test('management waits for shared storage and saves with the current revision', async () => {
  const save = jest.fn(async (next, revision) => ({ ...next, _revision: revision + 1 }));
  await render(archive.slug + '/organizator', { canManage: true, storageReady: false, save });
  expect(host.querySelector('[data-admin]')).toBeNull();
  expect(host.textContent).toContain('Ładowanie danych turnieju');
  await act(async () => root.render(<Wrapper key="ready" initialRoute={archive.slug + '/organizator'} canManage storageReady save={save} />));
  expect(host.querySelector('[data-revision]').textContent).toBe('7');
  const before = getTournamentStats(archive).goals;
  await click(button('Zapisz wynik testowy'));
  expect(save).toHaveBeenCalledTimes(1);
  expect(save.mock.calls[0][1]).toBe(7);
  expect(getTournamentStats(save.mock.calls[0][0]).goals).toBe(before + 1);
  expect(host.querySelector('[data-revision]').textContent).toBe('8');
  expect(host.querySelector('[role=status]').textContent).toContain('Zapisano zmiany');
  expect(localStorage.length).toBe(0);
  await click(button('Statystyki'));
  expect(host.querySelectorAll('.tc-stat-bar b')[1].textContent).toBe(String(before + 1));
});

test('a rejected shared save leaves visible results and revision unchanged', async () => {
  const save = jest.fn(async () => { throw new Error('Dane zostały zmienione przez innego organizatora.'); });
  await render(archive.slug + '/organizator', { canManage: true, save });
  await click(button('Zapisz wynik testowy'));
  expect(host.querySelector('[role=alert]').textContent).toContain('innego organizatora');
  expect(host.querySelector('[data-revision]').textContent).toBe('7');
  expect(host.querySelector('.tc-notice')).toBeNull();
  await click(button('Statystyki'));
  expect(host.querySelectorAll('.tc-stat-bar b')[1].textContent).toBe(String(getTournamentStats(archive).goals));
});

test('admin creation awaits persistence and opens the new tournament organizer', async () => {
  const create = jest.fn(async next => ({ ...next, _revision: 1 }));
  await render('home', { canManage: true, create });
  await click(button('Dodaj turniej'));
  host.querySelector('input[name=name]').value = 'Nowy Puchar';
  host.querySelector('input[name=date]').value = '2026-12-20';
  host.querySelector('input[name=location]').value = 'Halinów';
  await act(async () => Simulate.submit(host.querySelector('.tc-create-form')));
  expect(create).toHaveBeenCalledTimes(1);
  expect(create.mock.calls[0][0]).toMatchObject({ name: 'Nowy Puchar', date: '2026-12-20', location: 'Halinów', teams: [], matches: [] });
  expect(host.querySelector('.tc-detail-title h1').textContent).toBe('Nowy Puchar');
  expect(host.querySelector('[data-admin]')).not.toBeNull();
});

test('unknown tournaments and player IDs have a recoverable empty state', async () => {
  await render('missing-slug');
  expect(host.textContent).toContain('Nie znaleziono turnieju');
  await act(async () => root.render(<TournamentCenter route={demo.slug + '/zawodnik/missing-player'} basePath={basePath} />));
  expect(host.textContent).toContain('Nie znaleziono zawodnika');
});

test('section links support direct URLs and leave modified clicks to the browser', async () => {
  await render(demo.slug + '/mecze');
  const link = host.querySelector('.tc-tabs a[href="' + basePath + '/' + demo.slug + '/drabinka"]');
  expect(link).not.toBeNull();
  await act(async () => Simulate.click(link, { button: 0, ctrlKey: true }));
  expect(host.querySelector('.tc-tabs a[aria-current=page]').textContent).toBe('Mecze');
  await click(link);
  expect(host.querySelector('.tc-tabs a[aria-current=page]').textContent).toBe('Drabinka');
});

test('missing historical third-place score is described honestly in its profile', async () => {
  const historical = tournamentCatalog.find(item => item.slug === 'halinowcup2025');
  const match = historical.matches.find(item => item.stage === 'third');
  await render(historical.slug + '/mecz/' + match.id);
  expect(host.textContent).toContain('Brak wyniku i protokołu');
});

test('champion is shown for confirmed finals and absent for unresolved finals', async () => {
  await render('halinowcup2025');
  expect(host.querySelector('.tc-champion').textContent).toContain('Zwycięzca turnieju');
  expect(host.querySelector('.tc-champion .tc-team-name').getAttribute('href')).toContain('/druzyna/');
  await act(async () => root.render(<TournamentCenter route={demo.slug} basePath={basePath} />));
  expect(host.querySelector('.tc-champion')).toBeNull();
});

test('group phase selection shows only its groups and survives a team-profile visit', async () => {
  const historical = tournamentCatalog.find(item => item.slug === 'halinowcup2025');
  const phases = [...new Set(historical.groups.map(group => group.phaseName))];
  await render(historical.slug + '/grupy');
  const selector = host.querySelector('select[aria-label="Faza grupowa"]');
  expect(selector.value).toBe(phases[0]);
  await change(selector, phases[1]);
  const expected = historical.groups.filter(group => group.phaseName === phases[1]).map(group => group.name);
  expect([...host.querySelectorAll('.tc-group-heading h3')].map(el => el.textContent)).toEqual(expected);
  await click(host.querySelector('.tc-group tbody a'));
  await click(button('Grupy'));
  expect(host.querySelector('select[aria-label="Faza grupowa"]').value).toBe(phases[1]);
  expect([...host.querySelectorAll('.tc-group-heading h3')].map(el => el.textContent)).toEqual(expected);
});

test('tournament views omit source explanations and promotional slogans', async () => {
  await render('halinowcup2025');
  expect(host.querySelector('.tc-local-banner')).toBeNull();
  expect(host.querySelector('.tc-source')).toBeNull();
  expect(host.querySelector('.tc-source-notes')).toBeNull();
  expect(host.textContent).not.toMatch(/Tournify|import|Jeden puchar|Historia turniejów|źródł/);
  await click(button('Drabinka'));
  expect(host.textContent).not.toMatch(/Tournify|import|źródł/);
});

test('archival status filter uses the same missing-result label as the match card', async () => {
  await render('halinowcup2025/mecze');
  const status = host.querySelectorAll('.tc-filters select')[2];
  expect(status.querySelector('option[value=scheduled]').textContent).toBe('Brak wyniku');
  await change(status, 'scheduled');
  expect(host.querySelectorAll('.tc-match')).toHaveLength(1);
  expect([...host.querySelectorAll('.tc-match-status')].every(element => element.textContent === 'Brak wyniku')).toBe(true);
});

test('unknown rosters and missing team assignments are distinct from empty rosters', async () => {
  archive.teams[0].players = [];
  archive.unassignedPlayers = [{ id: 'unassigned-player', name: 'Jan Testowy' }];
  await render(archive.slug + '/druzyny');
  expect(host.querySelector('.tc-team-card-meta').textContent).toContain('Brak danych o kadrze');
  expect(host.textContent).not.toContain('0 zawodników w kadrze');
  expect(host.querySelector('.tc-unassigned h2').textContent).toBe('Drużyna nieustalona');
  await click(host.querySelector('.tc-unassigned a'));
  expect(host.querySelector('.tc-profile-heading p').textContent).toBe('Drużyna nieustalona');
});

test('round-of-16 appears before quarterfinals in the bracket and schedule filter', async () => {
  const tournament = { ...archive, id: 'round16-test', slug: 'round16-test', matches: [{ ...archive.matches[0], id: 'round16-first', stage: 'round16', groupId: null }, ...archive.matches] };
  await render(tournament.slug + '/drabinka', { initialCatalog: [tournament] });
  expect(host.querySelector('.tc-bracket-stage h3').textContent).toContain('1/8 finału');
  await click(button('Mecze'));
  expect(host.querySelector('.tc-filters option[value=round16]').textContent).toBe('1/8 finału');
});
