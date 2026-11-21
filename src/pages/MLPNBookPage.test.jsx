import React from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import MLPNBookPage from './MLPNBookPage';

jest.mock('../data/mlpnBookData', () => ({
  mlpnBookData: {
    asOf: '2026-11-21',
    records: [
      { id: 'goals-2026', period: '2026', group: 'players', label: 'Najwięcej goli', value: 50, unit: 'goli', holder: 'Paweł Łukaszewicz', detail: 'Sezon ligowy', season: 2026, scope: 'Sezon 2026', status: 'verified', sourceLabel: 'Protokoły', sourceUrl: '/zawodnik/pawel', sourceNote: 'Gole z zakończonych meczów.', ranking: [{ rank: 1, holder: 'Paweł Łukaszewicz', value: 50, detail: 'III liga', sourceUrl: '/zawodnik/pawel' }] },
      { id: 'games-archive', period: 'history', group: 'teams', label: 'Najwięcej rozegranych meczów', value: 200, unit: 'meczów', holder: 'Długa nazwa klubu', season: 2020, scope: 'Archiwum 2003–2026', status: 'partial', sourceLabel: 'Archiwum MLPN', sourceNote: 'Nie wszystkie sezony mają komplet danych.', ranking: [] },
    ],
    medals: [{ team: 'Dziadki', gold: 4, silver: 2, bronze: 1, total: 7, years: [2005, 2006, 2009, 2014] }],
    champions: [{ year: 2005, gold: 'Dziadki', silver: 'Pętla Team', bronze: 'FC Faworyt' }],
    seasons: [{ year: 2026, description: 'Podsumowanie trzech lig', url: '/1-liga/tabela?sezon=2026' }],
    stories: [{ id: 'dziadki', title: 'Cztery mistrzostwa', kicker: 'Dziadki', text: 'Historia klubu.', sourceLabel: 'Audyt archiwum' }],
    methodology: [],
  },
}));

let host;
let root;
beforeEach(async () => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  host = document.createElement('div');
  document.body.appendChild(host);
  root = createRoot(host);
  await act(async () => root.render(<MLPNBookPage />));
});
afterEach(async () => { await act(async () => root.unmount()); host.remove(); });

test('filters scope and category without mixing archived records with a current season', async () => {
  await selectPeriod('Wszystkie');
  const selects = host.querySelectorAll('select');
  expect(host.querySelectorAll('.mlpn-book-record')).toHaveLength(2);
  await act(async () => Simulate.change(selects[1], { target: { value: 'Sezon 2026' } }));
  expect(host.querySelectorAll('.mlpn-book-record')).toHaveLength(1);
  expect(host.querySelector('.mlpn-book-scope').textContent).toBe('Sezon 2026');
  await act(async () => Simulate.change(selects[0], { target: { value: 'teams' } }));
  expect(host.querySelectorAll('.mlpn-book-record')).toHaveLength(0);
  expect(host.querySelector('.mlpn-book-empty').textContent).toContain('Brak pasujących rekordów');
  await act(async () => Simulate.click(host.querySelector('.mlpn-book-empty button')));
  expect(host.querySelectorAll('.mlpn-book-record')).toHaveLength(2);
});

test('finds Polish names without diacritics and displays source, scope and calculation details', async () => {
  await selectPeriod('Sezon 2026');
  await act(async () => Simulate.change(host.querySelector('input[type="search"]'), { target: { value: 'pawel lukaszewicz' } }));
  const records = host.querySelectorAll('.mlpn-book-record');
  expect(records).toHaveLength(1);
  expect(records[0].querySelector('summary').textContent).toContain('Potwierdzone');
  expect(records[0].querySelector('.mlpn-book-record-footnote').textContent).toContain('Gole z zakończonych meczów.');
  expect(records[0].querySelector('.mlpn-book-record-footnote a').getAttribute('href')).toBe('/zawodnik/pawel');
});

test('keeps incomplete archive status visible before expanding a record', () => {
  const record = host.querySelectorAll('.mlpn-book-record')[0];
  expect(record.open).toBe(false);
  expect(record.querySelector('summary .mlpn-book-status').textContent).toBe('Niepełne archiwum');
  expect(record.querySelector('summary .mlpn-book-scope').textContent).toBe('Archiwum 2003–2026');
});

test('supports keyboard navigation between tabs and provides all 2026 league summary links', async () => {
  const tabs = host.querySelectorAll('[role="tab"]');
  await act(async () => Simulate.keyDown(tabs[0], { key: 'ArrowRight', preventDefault: jest.fn() }));
  expect(tabs[1].getAttribute('aria-selected')).toBe('true');
  expect(document.activeElement).toBe(tabs[1]);
  expect(host.querySelector('.mlpn-book-section-heading h2').textContent).toBe('Tabela wszech czasów');
  await act(async () => Simulate.keyDown(tabs[1], { key: 'End', preventDefault: jest.fn() }));
  expect(tabs[4].getAttribute('aria-selected')).toBe('true');
  expect(Array.from(host.querySelectorAll('.mlpn-book-season-leagues a'), link => link.getAttribute('href'))).toEqual(['/1-liga?sezon=2026', '/2-liga?sezon=2026', '/3-liga?sezon=2026']);
});

test('does not invent a source URL when the history only has an offline reference', async () => {
  await act(async () => Simulate.click(host.querySelectorAll('[role="tab"]')[3]));
  const story = host.querySelector('.mlpn-book-story');
  expect(story.textContent).toContain('Audyt archiwum');
  expect(story.querySelector('a')).toBeNull();
});

async function selectPeriod(label) {
  const button = [...host.querySelectorAll('.mlpn-book-period button')].find(button => button.textContent === label);
  await act(async () => Simulate.click(button));
}

test('starts with the whole archive and keeps the 2026 subset separate', async () => {
  expect(host.querySelectorAll('.mlpn-book-record')).toHaveLength(1);
  expect(host.querySelector('.mlpn-book-record-label').textContent).toBe('Najwięcej rozegranych meczów');
  await selectPeriod('Sezon 2026');
  expect(host.querySelectorAll('.mlpn-book-record')).toHaveLength(1);
  expect(host.querySelector('.mlpn-book-record-label').textContent).toBe('Najwięcej goli');
});
