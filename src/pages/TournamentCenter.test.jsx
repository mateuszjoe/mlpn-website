import React, { useState } from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import TournamentCenter from './TournamentCenter';
import { tournamentCatalog, demoTournamentSlug } from '../data/tournamentDemo';
import { loadTournamentDraft } from '../lib/tournamentStorage';
import { getTournamentStats } from '../lib/tournamentEngine';

jest.mock('../components/TournamentShareTools', () => function MockShare({ tournament, basePath }) {
  return <a data-share href={`${basePath}/${tournament.slug}`}>Link do turnieju</a>;
});

const basePath = '/podglad-turniejow-test-secret';
const demo = tournamentCatalog.find(item => item.slug === demoTournamentSlug);
let host;
let root;
let archive;

function Wrapper({ initialRoute = 'home' }) {
  const [route, setRoute] = useState(initialRoute);
  return <TournamentCenter route={route} onNavigate={setRoute} basePath={basePath} />;
}

beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  localStorage.clear();
  host = document.createElement('div'); document.body.appendChild(host); root = createRoot(host);
  archive = { ...JSON.parse(JSON.stringify(demo)), id: 'archive-test', slug: 'archiwum-test', isDemo: false, isImported: true,
    name: 'Rzeczywisty turniej archiwalny', status: 'completed', sourceUrl: 'https://www.tournify.pl/live/archive-test', sourceLabel: 'Tournify' };
  tournamentCatalog.push(archive);
});
afterEach(async () => {
  await act(async () => root.unmount()); host.remove(); localStorage.clear();
  const index = tournamentCatalog.indexOf(archive); if (index >= 0) tournamentCatalog.splice(index, 1);
});
const render = async route => act(async () => root.render(<Wrapper initialRoute={route} />));
const button = text => [...host.querySelectorAll('button, a')].find(element => element.textContent.trim() === text);
const click = async element => act(async () => Simulate.click(element, { button: 0 }));
const change = async (element, value) => act(async () => Simulate.change(element, { target: { value } }));

test('catalog separates confirmed upcoming event, imported archive and the simulation', async () => {
  await render('home');
  expect(host.querySelector('.tc-upcoming').textContent).toContain('Halinów');
  expect(host.querySelector('.tc-upcoming').textContent).toContain('Format, lista drużyn i godzina startu w przygotowaniu');
  expect(host.querySelector('.tc-demo-entry').textContent).toContain('PLAC TESTOWY');
  const link = [...host.querySelectorAll('.tc-archive-row a')].find(element => element.textContent === archive.name);
  expect(link.getAttribute('href')).toBe(`${basePath}/${archive.slug}`);
});

test('team and player hyperlinks stay inside the unlisted preview and open useful profiles', async () => {
  await render(`${demo.slug}/grupy`);
  const link = host.querySelector('.tc-group tbody a');
  expect(link.getAttribute('href')).toMatch(new RegExp(`^${basePath}/${demo.slug}/druzyna/`));
  await click(link);
  expect(host.querySelector('.tc-profile-heading').textContent).toContain('Profil drużyny');
  const playerLink = host.querySelector('.tc-profile-roster .tc-player-link');
  expect(playerLink.getAttribute('href')).toContain(`${basePath}/${demo.slug}/zawodnik/`);
  await click(playerLink);
  expect(host.querySelector('.tc-profile-heading').textContent).toContain('Profil zawodnika');
  expect(host.textContent).toContain('meczów ze zdarzeniem zawodnika');
  expect(host.querySelector('[data-share]').getAttribute('href')).toBe(`${basePath}/${demo.slug}`);
});

test('saving a local score updates statistics and survives a reload', async () => {
  await render(`${demo.slug}/organizator`);
  const selectedId = host.querySelector('.tc-match-picker select').value;
  const selected = demo.matches.find(match => match.id === selectedId);
  const before = getTournamentStats(demo).goals;
  await change(host.querySelector('.tc-editor-score select'), 'finished');
  await change(host.querySelectorAll('.tc-editor-score input')[0], String(selected.homeScore + 1));
  await act(async () => Simulate.submit(host.querySelector('.tc-editor')));
  expect(host.querySelector('[role=status]').textContent).toContain('Mecz zapisany lokalnie');
  const restored = loadTournamentDraft(demo);
  expect(restored.matches.find(match => match.id === selectedId).homeScore).toBe(selected.homeScore + 1);
  expect(getTournamentStats(restored).goals).toBe(before + 1);
  await click(button('Statystyki'));
  expect(host.querySelectorAll('.tc-stat-bar b')[1].textContent).toBe(String(before + 1));
});

test('a result smaller than recorded goals is rejected without changing the saved tournament', async () => {
  await render(`${demo.slug}/organizator`);
  await change(host.querySelectorAll('.tc-editor-score input')[0], '0');
  await act(async () => Simulate.submit(host.querySelector('.tc-editor')));
  expect(host.querySelector('[role=alert]').textContent).toContain('strzelców jest więcej');
  expect(loadTournamentDraft(demo)).toEqual(demo);
});

test('reset requires a second explicit action and restores the original draft', async () => {
  await render(`${demo.slug}/organizator`);
  const matchId = host.querySelector('.tc-match-picker select').value;
  const original = demo.matches.find(match => match.id === matchId).homeScore;
  await change(host.querySelectorAll('.tc-editor-score input')[0], String(original + 2));
  await act(async () => Simulate.submit(host.querySelector('.tc-editor')));
  await click(button('Przywróć przykład'));
  expect(loadTournamentDraft(demo).matches.find(match => match.id === matchId).homeScore).toBe(original + 2);
  await click(button('Tak, przywróć dane'));
  expect(loadTournamentDraft(demo).matches.find(match => match.id === matchId).homeScore).toBe(original);
});

test('archive remains read-only until a separate local copy is created', async () => {
  await render(`${archive.slug}/organizator`);
  expect(host.querySelector('.tc-editor')).toBeNull();
  expect(host.querySelector('.tc-source a').getAttribute('href')).toBe(archive.sourceUrl);
  await click(button('Utwórz kopię do testów'));
  expect(host.querySelector('.tc-editor')).not.toBeNull();
  expect(host.querySelector('.tc-local-banner').textContent).toContain('KOPIA TESTOWA');
  expect(loadTournamentDraft(archive).isLocalCopy).toBe(true);
  expect(archive.isLocalCopy).toBeUndefined();
});

test('unknown tournaments and player IDs have a recoverable empty state', async () => {
  await render('missing-slug');
  expect(host.textContent).toContain('Nie znaleziono turnieju');
  await act(async () => root.render(<TournamentCenter route={`${demo.slug}/zawodnik/missing-player`} basePath={basePath} />));
  expect(host.textContent).toContain('Nie znaleziono zawodnika');
});

test('section links support direct URLs and leave modified clicks to the browser', async () => {
  await render(`${demo.slug}/mecze`);
  const link = host.querySelector(`.tc-tabs a[href="${basePath}/${demo.slug}/drabinka"]`);
  expect(link).not.toBeNull();
  await act(async () => Simulate.click(link, { button: 0, ctrlKey: true }));
  expect(host.querySelector('.tc-tabs a[aria-current=page]').textContent).toBe('Mecze');
  await click(link);
  expect(host.querySelector('.tc-tabs a[aria-current=page]').textContent).toBe('Drabinka');
});

test('a score entered while scheduled is rejected instead of silently disappearing', async () => {
  await render(`${demo.slug}/organizator`);
  await change(host.querySelector('.tc-match-picker select'), 'demo-qf4');
  expect(host.querySelector('.tc-editor-score select').value).toBe('scheduled');
  await change(host.querySelectorAll('.tc-editor-score input')[0], '2');
  await change(host.querySelectorAll('.tc-editor-score input')[1], '1');
  await act(async () => Simulate.submit(host.querySelector('.tc-editor')));
  expect(host.querySelector('[role=alert]').textContent).toContain('Zmień status na Na żywo lub Zakończony');
  expect(host.querySelector('[role=status]')).toBeNull();
  expect(loadTournamentDraft(demo)).toEqual(demo);
  await change(host.querySelector('.tc-editor-score select'), 'finished');
  await act(async () => Simulate.submit(host.querySelector('.tc-editor')));
  expect(loadTournamentDraft(demo).matches.find(match => match.id === 'demo-qf4').homeScore).toBe(2);
});

test('reverting a played match requires clearing its score and protocol before saving', async () => {
  await render(`${demo.slug}/organizator`);
  const matchId = host.querySelector('.tc-match-picker select').value;
  await change(host.querySelector('.tc-editor-score select'), 'scheduled');
  await act(async () => Simulate.submit(host.querySelector('.tc-editor')));
  expect(host.querySelector('[role=alert]')).not.toBeNull();
  expect(loadTournamentDraft(demo)).toEqual(demo);
  await click(button('Wyczyść wynik i protokół'));
  expect(host.querySelectorAll('.tc-editor-score input')[0].value).toBe('');
  expect(host.querySelectorAll('.tc-editor-event-list li')).toHaveLength(0);
  expect(loadTournamentDraft(demo)).toEqual(demo);
  await act(async () => Simulate.submit(host.querySelector('.tc-editor')));
  const restored = loadTournamentDraft(demo).matches.find(match => match.id === matchId);
  expect(restored.status).toBe('scheduled');
  expect(restored.homeScore).toBeNull();
  expect(restored.events).toEqual([]);
});

test('missing historical match score is described honestly in the match profile', async () => {
  const historical = tournamentCatalog.find(item => item.slug === 'halinowcup2025');
  const final = historical.matches.find(match => match.stage === 'final');
  await render(`${historical.slug}/mecz/${final.id}`);
  expect(host.textContent).toContain('W archiwum brakuje wyniku i szczegółowego protokołu tego meczu');
  expect(host.textContent).not.toContain('Dostępny jest wynik meczu');
});

test('champion is shown only when the source confirms the final winner', async () => {
  const confirmed = tournamentCatalog.find(item => item.slug === 'halinowcup2024');
  await render(confirmed.slug);
  expect(host.querySelector('.tc-champion').textContent).toContain('Zwycięzca turnieju');
  expect(host.querySelector('.tc-champion .tc-team-name').getAttribute('href')).toContain('/druzyna/');
  await act(async () => root.render(<TournamentCenter route="halinowcup2025" basePath={basePath} />));
  expect(host.querySelector('.tc-champion')).toBeNull();
});
