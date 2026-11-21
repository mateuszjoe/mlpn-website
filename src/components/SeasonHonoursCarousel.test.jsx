import React from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import SeasonHonoursCarousel from './SeasonHonoursCarousel';

let host;
let root;
let goToLeague;
let openTeam;

function TestTeamLogo({ team, onClick }) {
  return <button type="button" aria-label={`Herb: ${team}`} onClick={onClick}>Herb</button>;
}

const leagueTabs = () => Array.from(host.querySelectorAll('.season-carousel__leagues [role="tab"]'));
const selectedLeague = () => host.querySelector('.season-carousel__leagues [aria-selected="true"]').textContent;
const click = async element => act(async () => Simulate.click(element));

beforeEach(async () => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  host = document.createElement('div');
  document.body.appendChild(host);
  root = createRoot(host);
  goToLeague = jest.fn();
  openTeam = jest.fn();
  await act(async () => root.render(<SeasonHonoursCarousel TeamLogo={TestTeamLogo} openTeam={openTeam} goToLeague={goToLeague} />));
});

afterEach(async () => {
  await act(async () => root.unmount());
  host.remove();
});

test('switches the single visible slide and opens the currently selected league', async () => {
  expect(selectedLeague()).toBe('I Liga');
  expect(host.textContent).toContain('Damian Zajdowski');
  expect(host.querySelectorAll('.season-carousel__panel')).toHaveLength(1);
  expect(host.querySelectorAll('.season-honours')).toHaveLength(1);

  await click(leagueTabs()[1]);
  expect(selectedLeague()).toBe('II Liga');
  expect(host.textContent).toContain('Maks Kardas');
  expect(host.textContent).not.toContain('Damian Zajdowski');
  await click(host.querySelector('.season-carousel__footer button'));
  expect(goToLeague).toHaveBeenLastCalledWith('2nd');

  await click(leagueTabs()[2]);
  expect(selectedLeague()).toBe('III Liga');
  expect(host.textContent).toContain('Sebastian Orzoł');
  expect(host.querySelectorAll('.season-honours__award')).toHaveLength(4);
  expect(host.querySelectorAll('.season-honours__player')).toHaveLength(8);
});

test('previous and next buttons wrap through all three leagues', async () => {
  await click(host.querySelector('[aria-label="Poprzednia liga"]'));
  expect(selectedLeague()).toBe('III Liga');
  await click(host.querySelector('[aria-label="Następna liga"]'));
  expect(selectedLeague()).toBe('I Liga');
  await click(host.querySelector('[aria-label="Następna liga"]'));
  expect(selectedLeague()).toBe('II Liga');
});

test.each([
  [0, 'I Liga', 'Al Mar Wołomin'],
  [1, 'II Liga', 'Faludża'],
  [2, 'III Liga', 'FC Faworyt'],
])('shows the correct champion of %s (%s) and opens the club profile', async (index, leagueName, champion) => {
  await click(leagueTabs()[index]);
  expect(selectedLeague()).toBe(leagueName);
  const banner = host.querySelector('.season-honours__champion');
  expect(banner).not.toBeNull();
  expect(banner.textContent).toMatch(/mistrz/i);
  expect(banner.textContent).toContain(champion);
  const clubLink = banner.querySelector('.season-honours__champion-team');
  expect(clubLink.textContent).toContain(champion);
  await click(clubLink);
  expect(openTeam).toHaveBeenLastCalledWith(champion);
});

test('keeps the mobile awards/eight selection while changing league and isolates its keyboard navigation', async () => {
  const detailTabs = () => Array.from(host.querySelectorAll('.season-honours__tabs [role="tab"]'));
  await click(detailTabs()[1]);
  expect(detailTabs()[1].getAttribute('aria-selected')).toBe('true');
  await click(leagueTabs()[2]);
  expect(selectedLeague()).toBe('III Liga');
  expect(detailTabs()[1].getAttribute('aria-selected')).toBe('true');
  expect(host.querySelector('.season-honours__eight').classList.contains('season-honours__panel--inactive')).toBe(false);

  await act(async () => Simulate.keyDown(detailTabs()[1], { key: 'ArrowLeft' }));
  expect(detailTabs()[0].getAttribute('aria-selected')).toBe('true');
  expect(selectedLeague()).toBe('III Liga');
});

test('arrow, Home and End keys change tabs and keep keyboard focus on the selected league', async () => {
  leagueTabs()[0].focus();
  await act(async () => Simulate.keyDown(leagueTabs()[0], { key: 'ArrowRight' }));
  expect(selectedLeague()).toBe('II Liga');
  expect(document.activeElement).toBe(leagueTabs()[1]);
  expect(leagueTabs().map(tab => tab.tabIndex)).toEqual([-1, 0, -1]);
  await act(async () => Simulate.keyDown(leagueTabs()[1], { key: 'End' }));
  expect(selectedLeague()).toBe('III Liga');
  await act(async () => Simulate.keyDown(leagueTabs()[2], { key: 'Home' }));
  expect(selectedLeague()).toBe('I Liga');
  await act(async () => Simulate.keyDown(leagueTabs()[0], { key: 'ArrowLeft' }));
  expect(selectedLeague()).toBe('III Liga');
  expect(document.activeElement).toBe(leagueTabs()[2]);
});

async function swipe(from, to) {
  const panel = host.querySelector('.season-carousel__panel');
  await act(async () => Simulate.touchStart(panel, { touches: [{ identifier: 3, clientX: from[0], clientY: from[1] }] }));
  await act(async () => Simulate.touchEnd(panel, { touches: [], changedTouches: [{ identifier: 3, clientX: to[0], clientY: to[1] }] }));
}

test('horizontal swipes change leagues without treating vertical scrolls or taps as navigation', async () => {
  await swipe([240, 200], [80, 210]);
  expect(selectedLeague()).toBe('II Liga');
  await swipe([80, 200], [240, 205]);
  expect(selectedLeague()).toBe('I Liga');
  await swipe([240, 300], [160, 100]);
  expect(selectedLeague()).toBe('I Liga');
  await swipe([200, 100], [210, 103]);
  expect(selectedLeague()).toBe('I Liga');
  await click(host.querySelector('.season-honours__club'));
  expect(openTeam).toHaveBeenCalledWith('Al Mar Wołomin');
});

test('cancelled and multi-finger gestures never change the league', async () => {
  const panel = host.querySelector('.season-carousel__panel');
  await act(async () => Simulate.touchStart(panel, { touches: [{ identifier: 1, clientX: 240, clientY: 100 }] }));
  await act(async () => Simulate.touchCancel(panel));
  await act(async () => Simulate.touchEnd(panel, { touches: [], changedTouches: [{ identifier: 1, clientX: 40, clientY: 100 }] }));
  expect(selectedLeague()).toBe('I Liga');
  await act(async () => Simulate.touchStart(panel, { touches: [{ identifier: 1, clientX: 240, clientY: 100 }, { identifier: 2, clientX: 300, clientY: 100 }] }));
  await act(async () => Simulate.touchEnd(panel, { touches: [], changedTouches: [{ identifier: 1, clientX: 40, clientY: 100 }] }));
  expect(selectedLeague()).toBe('I Liga');
});
