import { useLayoutEffect } from 'react';
import './tournamentNavigation.css';

export default function useTournamentScroll(route) {
  useLayoutEffect(() => {
    const root = document.documentElement;
    const alreadyEnabled = root.classList.contains('mlpn-tournament-navigation');
    const previousRestoration = window.history.scrollRestoration;
    root.classList.add('mlpn-tournament-navigation');
    window.history.scrollRestoration = 'manual';
    return () => {
      if (!alreadyEnabled) root.classList.remove('mlpn-tournament-navigation');
      window.history.scrollRestoration = previousRestoration;
    };
  }, []);

  // Reset after the new view is committed, before it is painted. Keeping the
  // previous offset can put a shorter match/profile view straight in the footer.
  useLayoutEffect(() => {
    window.scrollTo({ top: 0, left: 0, behavior: 'instant' });
  }, [route]);
}
