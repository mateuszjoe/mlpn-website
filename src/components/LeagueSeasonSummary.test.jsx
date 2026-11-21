import React from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import LeagueSeasonSummary from './LeagueSeasonSummary';
import { season2026Honours } from '../data/season2026Honours';

let host;
let root;
let openTeam;

function TestTeamLogo({ team, onClick }) {
  return <button type="button" aria-label={`Herb: ${team}`} onClick={onClick} data-team-logo={team}>Herb</button>;
}

async function renderSummary(summary, leagueName = 'I Liga', darkMode = false) {
  await act(async () => root.render(
    <LeagueSeasonSummary summary={summary} leagueName={leagueName} darkMode={darkMode} TeamLogo={TestTeamLogo} openTeam={openTeam} />
  ));
}

function playerRows() {
  return Array.from(host.querySelectorAll('.season-honours__pitch-row'), row =>
    Array.from(row.querySelectorAll('.season-honours__player-name'), player => player.textContent)
  );
}

beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  host = document.createElement('div');
  document.body.appendChild(host);
  root = createRoot(host);
  openTeam = jest.fn();
});

afterEach(async () => {
  await act(async () => root.unmount());
  host.remove();
});

test.each([
  ['1st', 'I Liga', [
    ['K. Sochocki', 'M. Trąbiński'],
    ['D. Bąk', 'A. Wosiek', 'D. Zajdowski'],
    ['R. Tkaczyk', 'P. Wódkowski'],
    ['M. Wronka'],
  ]],
  ['2nd', 'II Liga', [
    ['O. Orełko'],
    ['M. Kardas', 'M. Skowroński', 'M. Boguszewski'],
    ['D. Juszyński', 'D. Turlej', 'R. Charkiewicz'],
    ['M. Komorowski'],
  ]],
  ['3rd', 'III Liga', [
    ['S. Orzoł'],
    ['S. Tomaszewski', 'P. Wąsowski', 'K. Kucharek'],
    ['P. Halaburda', 'A. Jakubowicz', 'M. Zimolużyński'],
    ['T. Bajur'],
  ]],
])('renders four official awards and the complete %s formation facing upwards', async (leagueId, leagueName, expectedRows) => {
  const summary = season2026Honours[leagueId];
  await renderSummary(summary, leagueName);

  const awardCards = host.querySelectorAll('.season-honours__award');
  expect(awardCards).toHaveLength(4);
  summary.awards.forEach((award, index) => {
    expect(awardCards[index].querySelector('h3').textContent).toBe(award.category);
    expect(awardCards[index].querySelector('.season-honours__winner').textContent).toBe(award.name);
    expect(awardCards[index].querySelector('.season-honours__club').textContent).toBe(award.team);
  });
  expect(host.querySelectorAll('.season-honours__player')).toHaveLength(8);
  expect(playerRows()).toEqual(expectedRows);
  expect(host.querySelector('.season-honours__eyebrow').textContent).toBe(`${leagueName} · sezon 2026`);

  const pitchRows = Array.from(host.querySelectorAll('.season-honours__pitch-row'));
  pitchRows.forEach((row, index) => {
    expect(row.style.gridTemplateColumns).toBe(`repeat(${expectedRows[index].length}, minmax(0, 1fr))`);
  });
  expect(pitchRows[pitchRows.length - 1].querySelector('abbr').title).toBe('Bramkarz');
});

test('keeps Kucharek on the right midfield and Orzoł in attack after the final gala correction', async () => {
  await renderSummary(season2026Honours['3rd'], 'III Liga');

  const rows = host.querySelectorAll('.season-honours__pitch-row');
  const attacker = rows[0].querySelector('.season-honours__player');
  expect(attacker.querySelector('.season-honours__player-name').textContent).toBe('S. Orzoł');
  expect(attacker.querySelector('abbr').title).toBe('Napastnik');
  expect(attacker.querySelector('abbr').textContent).toBe('NAP');
  expect(attacker.querySelector('[data-team-logo]').dataset.teamLogo).toBe('FC Faworyt');

  const rightMidfielder = rows[1].querySelectorAll('.season-honours__player')[2];
  expect(rightMidfielder.querySelector('.season-honours__player-name').textContent).toBe('K. Kucharek');
  expect(rightMidfielder.querySelector('abbr').title).toBe('Prawy pomocnik');
  expect(rightMidfielder.querySelector('abbr').textContent).toBe('PP');
  expect(rightMidfielder.querySelector('[data-team-logo]').dataset.teamLogo).toBe('RMB Bulls');
});

test('abbreviates only the first name and preserves long or compound surnames and the full tooltip', async () => {
  const summary = {
    ...season2026Honours['1st'],
    bestEight: season2026Honours['1st'].bestEight.map(player => ({ ...player })),
  };
  summary.bestEight[0].name = '  Łukasz   Zimolużyński-Kowalczyk  ';
  summary.bestEight[1].name = 'Jan van der Kowalski';
  summary.bestEight[2].name = 'Ronaldo';
  await renderSummary(summary);

  const names = Array.from(host.querySelectorAll('.season-honours__player-name'));
  const longName = names.find(name => name.textContent === 'Ł. Zimolużyński-Kowalczyk');
  expect(longName).toBeDefined();
  expect(longName.title).toContain('Łukasz   Zimolużyński-Kowalczyk');
  expect(names.map(name => name.textContent)).toEqual(expect.arrayContaining(['J. van der Kowalski', 'Ronaldo']));
});

test('opens the right club from an award name, award crest and pitch crest', async () => {
  await renderSummary(season2026Honours['3rd'], 'III Liga');
  const award = host.querySelector('.season-honours__award');
  await act(async () => Simulate.click(award.querySelector('.season-honours__club')));
  await act(async () => Simulate.click(award.querySelector('[data-team-logo]')));
  const pitchCrest = host.querySelector('.season-honours__pitch [data-team-logo="RMB Bulls"]');
  await act(async () => Simulate.click(pitchCrest));
  expect(openTeam.mock.calls).toEqual([['FC Faworyt'], ['FC Faworyt'], ['RMB Bulls']]);
});

test('updates all honours on league changes without mutating the shared season selections', async () => {
  const before = JSON.stringify(season2026Honours);
  await renderSummary(season2026Honours['1st'], 'I Liga');
  await renderSummary(season2026Honours['2nd'], 'II Liga', true);

  expect(host.querySelector('.season-honours').classList.contains('season-honours--dark')).toBe(true);
  expect(host.textContent).toContain('II Liga · sezon 2026');
  expect(host.textContent).toContain('Maks Kardas');
  expect(host.textContent).not.toContain('Damian Zajdowski');
  expect(host.querySelectorAll('.season-honours__award')).toHaveLength(4);
  expect(host.querySelectorAll('.season-honours__player')).toHaveLength(8);
  expect(JSON.stringify(season2026Honours)).toBe(before);
});
