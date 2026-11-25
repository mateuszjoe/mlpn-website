import React, { useState } from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import TournamentCenter from './TournamentCenter';
import { tournamentCatalog } from '../data/tournamentDemo';
import { demoTournament as demo } from '../lib/__fixtures__/tournamentDemo';
import { getTournamentStats, updateTournamentMatch } from '../lib/tournamentEngine';

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

test('missing historical score is described honestly in its profile', async () => {
  const match = archive.matches.find(item => item.status === 'scheduled');
  await render(archive.slug + '/mecz/' + match.id);
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
  const missing = archive.matches.filter(match => match.status === 'scheduled');
  expect(missing.length).toBeGreaterThan(0);
  await render(archive.slug + '/mecze');
  const status = host.querySelectorAll('.tc-filters select')[2];
  expect(status.querySelector('option[value=scheduled]').textContent).toBe('Brak wyniku');
  await change(status, 'scheduled');
  expect(host.querySelectorAll('.tc-match')).toHaveLength(missing.length);
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

test('partial catalogue uses verified participant totals and sorts unknown dates by known year', async () => {
  await render('home');
  const items = [...host.querySelectorAll('.tc-catalog-item')];
  const old = items.find(item => item.textContent.includes('Puchar Ligi MLPN 2023'));
  const recent = items.find(item => item.textContent.includes('Puchar Ligi MLPN 2026'));
  expect(old.textContent).toContain('2023 · data nieznana');
  expect(old.textContent).toContain('12 drużyn');
  expect(old.textContent).toContain('Archiwum częściowe');
  expect(old.textContent).not.toMatch(/4 drużyn|0 meczów|Wkrótce/);
  expect(recent.textContent).toContain('13 drużyn');
  expect(recent.textContent).toContain('2 znane mecze');
  expect(items.indexOf(old)).toBeGreaterThan(items.indexOf(recent));
});

test('historical podium remains useful without inventing a schedule or exact date', async () => {
  await render('puchar-ligi-mlpn-2023');
  expect(host.querySelector('.tc-status-badge').textContent).toBe('Archiwum częściowe');
  expect(host.querySelector('.tc-title-meta').textContent).toBe('2023 · data nieznana');
  expect(host.querySelector('.tc-champion').textContent).toContain('GREEN Team');
  expect(host.querySelectorAll('.tc-final-standings li')).toHaveLength(4);
  expect([...host.querySelectorAll('.tc-final-standings li .tc-team-name > span:last-child')].map(item => item.textContent)).toEqual(['GREEN Team', 'Netservis Dobczyn', 'Rebelianci', 'Joga Finito']);
  expect(host.textContent).toContain('Uczestnicy: 12 · znane drużyny: 4');
  expect(host.textContent).toContain('Brak danych o meczach');
  expect(host.textContent).not.toMatch(/Turniej w przygotowaniu|Najbliższy mecz|października/);
  await click(host.querySelector('.tc-final-standings a'));
  expect(host.querySelector('.tc-profile-heading h2').textContent).toBe('GREEN Team');
  expect(host.querySelector('.tc-stat-bar').hidden).toBe(true);
  await click(button('Drużyny'));
  expect(host.querySelector('.tc-section-heading').textContent).toContain('Znane drużyny: 4 z 12');
  await click(button('Statystyki'));
  expect(host.querySelector('.tc-stat-bar')).toBeNull();
  expect(host.textContent).toContain('Brak danych o meczach');
});

test('partial group tables show reported points and leave unknown results empty', async () => {
  await render('puchar-ligi-mlpn-2026/grupy');
  expect(host.querySelector('.tc-section-heading h2').textContent).toBe('II faza grupowa');
  const tables = [...host.querySelectorAll('.tc-reported-group table')];
  expect(tables).toHaveLength(2);
  expect(tables.map(table => [...table.querySelectorAll('tbody tr')].map(row => row.querySelector('td:last-child').textContent))).toEqual([['7', '4', '—', '—'], ['9', '6', '—', '—']]);
  expect(host.querySelectorAll('.tc-confirmed-advance')).toHaveLength(4);
  expect([...host.querySelectorAll('thead th')].map(item => item.textContent)).toEqual(['#', 'Drużyna', 'PKT', '#', 'Drużyna', 'PKT']);
  expect(host.textContent).not.toContain('0:0');
});

test('partial 2026 bracket contains only confirmed games and preserves final penalties', async () => {
  await render('puchar-ligi-mlpn-2026/drabinka');
  expect(host.querySelectorAll('.tc-match')).toHaveLength(2);
  expect([...host.querySelectorAll('.tc-score strong')].map(item => item.textContent)).toEqual(['2 : 4', '0 : 0']);
  expect(host.querySelector('.tc-score small').textContent).toBe('k. 4 : 3');
  expect(host.querySelectorAll('.tc-bracket-stage')).toHaveLength(2);
  expect(host.querySelector('.tc-bronze')).toBeNull();
  await click(button('Przegląd'));
  expect(host.querySelector('.tc-champion').textContent).toContain('Rebelianci');
  expect(host.querySelectorAll('.tc-final-standings li')).toHaveLength(2);
  expect([...host.querySelectorAll('.tc-stat-bar b')].map(item => item.textContent)).toEqual(['13', '2', '6']);
  expect(host.querySelector('.tc-stat-bar').textContent).toContain('goli w znanych meczach');
  await click(button('Statystyki'));
  expect(host.querySelector('.tc-stat-bar').textContent).toContain('znanych meczów');
});

test('a changed semifinal does not retain the archived champion when its final is unresolved', async () => {
  const original = tournamentCatalog.find(item => item.slug === 'puchar-ligi-mlpn-2026');
  const changed = updateTournamentMatch(original, 'puchar-ligi-2026-semifinal-1', { homeScore: 4, awayScore: 2 });
  await render(changed.slug, { initialCatalog: [changed] });
  expect(host.querySelector('.tc-champion')).toBeNull();
  expect(host.querySelector('.tc-final-standings')).toBeNull();
});
