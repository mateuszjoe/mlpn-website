import React, { useId, useRef, useState } from 'react';
import { ArrowUpRight, ChevronLeft, ChevronRight } from 'lucide-react';
import LeagueSeasonSummary from './LeagueSeasonSummary';
import { season2026Honours } from '../data/season2026Honours';
import './SeasonHonoursCarousel.css';

const LEAGUE_SLIDES = [
  { id: '1st', name: 'I Liga' },
  { id: '2nd', name: 'II Liga' },
  { id: '3rd', name: 'III Liga' },
];

export default function SeasonHonoursCarousel({ TeamLogo, openTeam, goToLeague }) {
  const [activeIndex, setActiveIndex] = useState(0);
  const touchStart = useRef(null);
  const leagueButtons = useRef([]);
  const id = useId();
  const league = LEAGUE_SLIDES[activeIndex];
  const panelId = `${id}-panel`;
  const wrapIndex = index => (index + LEAGUE_SLIDES.length) % LEAGUE_SLIDES.length;

  const changeLeague = direction => setActiveIndex(index => wrapIndex(index + direction));

  const handleLeagueKeys = event => {
    let nextIndex;
    if (event.key === 'ArrowRight') nextIndex = wrapIndex(activeIndex + 1);
    else if (event.key === 'ArrowLeft') nextIndex = wrapIndex(activeIndex - 1);
    else if (event.key === 'Home') nextIndex = 0;
    else if (event.key === 'End') nextIndex = LEAGUE_SLIDES.length - 1;
    else return;
    event.preventDefault();
    setActiveIndex(nextIndex);
    leagueButtons.current[nextIndex]?.focus();
  };

  const handleTouchStart = event => {
    const touch = event.touches.length === 1 ? event.touches[0] : null;
    touchStart.current = touch ? { x: touch.clientX, y: touch.clientY, id: touch.identifier } : null;
  };

  const handleTouchEnd = event => {
    const start = touchStart.current;
    touchStart.current = null;
    if (!start || event.touches.length) return;
    const end = Array.from(event.changedTouches).find(touch => touch.identifier === start.id);
    if (!end) return;
    const horizontal = end.clientX - start.x;
    const vertical = end.clientY - start.y;
    // A tap or a normal vertical page scroll must never change the league.
    if (Math.abs(horizontal) < 60 || Math.abs(horizontal) <= Math.abs(vertical) * 1.5) return;
    changeLeague(horizontal < 0 ? 1 : -1);
  };

  return (
    <section className="season-carousel" aria-labelledby={`${id}-heading`}>
      <header className="season-carousel__heading">
        <div>
          <span className="season-carousel__eyebrow">MLPN · sezon 2026</span>
          <h2 id={`${id}-heading`}>Podsumowanie sezonu</h2>
        </div>
        <div className="season-carousel__controls" aria-label="Przewijanie lig">
          <span className="season-carousel__count" aria-label={`Liga ${activeIndex + 1} z ${LEAGUE_SLIDES.length}`}>
            {activeIndex + 1}<span aria-hidden="true"> / {LEAGUE_SLIDES.length}</span>
          </span>
          <button type="button" onClick={() => changeLeague(-1)} aria-label="Poprzednia liga">
            <ChevronLeft size={20} aria-hidden="true" />
          </button>
          <button type="button" onClick={() => changeLeague(1)} aria-label="Następna liga">
            <ChevronRight size={20} aria-hidden="true" />
          </button>
        </div>
      </header>

      <div className="season-carousel__leagues" role="tablist" aria-label="Wybierz ligę" onKeyDown={handleLeagueKeys}>
        {LEAGUE_SLIDES.map((item, index) => (
          <button
            type="button"
            role="tab"
            key={item.id}
            id={`${id}-${item.id}`}
            aria-selected={index === activeIndex}
            aria-controls={panelId}
            tabIndex={index === activeIndex ? 0 : -1}
            ref={button => { leagueButtons.current[index] = button; }}
            onClick={() => setActiveIndex(index)}
          >
            {item.name}
          </button>
        ))}
      </div>

      <div
        className="season-carousel__panel"
        id={panelId}
        role="tabpanel"
        aria-labelledby={`${id}-${league.id}`}
        onTouchStart={handleTouchStart}
        onTouchEnd={handleTouchEnd}
        onTouchCancel={() => { touchStart.current = null; }}
      >
        <LeagueSeasonSummary
          summary={season2026Honours[league.id]}
          leagueName={league.name}
          darkMode={true}
          TeamLogo={TeamLogo}
          openTeam={openTeam}
          showHeading={false}
        />
      </div>

      <footer className="season-carousel__footer">
        <span className="season-carousel__hint">3 ligi · 12 wyróżnień · 3 najlepsze ósemki</span>
        <button type="button" onClick={() => goToLeague(league.id)}>
          Pełne podsumowanie: {league.name}
          <ArrowUpRight size={16} aria-hidden="true" />
        </button>
      </footer>
    </section>
  );
}
