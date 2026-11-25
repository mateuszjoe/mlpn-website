import React from 'react';
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import useTournamentScroll from './useTournamentScroll';

global.IS_REACT_ACT_ENVIRONMENT = true;
let host, root, scroll, restoration;
function View({ route, score = 0 }) {
  useTournamentScroll(route);
  return <div>{score}</div>;
}
beforeEach(() => {
  host = document.createElement('div'); document.body.appendChild(host);
  root = createRoot(host);
  restoration = window.history.scrollRestoration;
  window.history.scrollRestoration = 'auto';
  scroll = jest.spyOn(window, 'scrollTo').mockImplementation(() => {});
});
afterEach(() => {
  act(() => root.unmount()); host.remove(); scroll.mockRestore();
  window.history.scrollRestoration = restoration;
});

test('a newly opened tournament view starts at the top, also on back navigation', () => {
  act(() => root.render(<View route="halinow/grupy" />));
  expect(scroll).toHaveBeenLastCalledWith({ top: 0, left: 0, behavior: 'instant' });
  act(() => root.render(<View route="halinow/druzyna/team" />));
  act(() => root.render(<View route="halinow/grupy" />));
  expect(scroll).toHaveBeenCalledTimes(3);
});

test('score changes and ordinary re-renders do not interrupt reading or editing', () => {
  act(() => root.render(<View route="halinow/organizator" score={1} />));
  scroll.mockClear();
  act(() => root.render(<View route="halinow/organizator" score={2} />));
  expect(scroll).not.toHaveBeenCalled();
});

test('native scroll restoration and anchoring are isolated to the tournament preview', () => {
  act(() => root.render(<View route="halinow/grupy" />));
  expect(window.history.scrollRestoration).toBe('manual');
  expect(document.documentElement).toHaveProperty('className', 'mlpn-tournament-navigation');
  act(() => root.render(<div>Publiczna strona</div>));
  expect(window.history.scrollRestoration).toBe('auto');
  expect(document.documentElement.classList.contains('mlpn-tournament-navigation')).toBe(false);
});
