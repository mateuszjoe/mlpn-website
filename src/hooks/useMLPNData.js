import { useState, useEffect, useRef, useCallback } from 'react';
import {
  fetchSeasons,
  fetchSeasonConfig,
  fetchStandings,
  fetchAllMatches,
  fetchTeamsForSeason,
  fetchTopScorers,
  fetchTopAssists,
  fetchTopYellow,
  fetchTopRed,
  fetchNews,
  fetchPolls,
  fetchActiveTyperConfig,
  fetchFreeAgents,
  fetchTournaments,
  fetchSeasonSummary,
} from '../services/supabaseQueries';

export function useMLPNData() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  // Sezony
  const [availableSeasons, setAvailableSeasons] = useState([]);
  const [currentSeason, setCurrentSeason] = useState(null);
  const [seasonStatus, setSeasonStatus] = useState(null); // 'completed' | 'active' | 'planned' (legacy: 'in_progress')

  // Konfiguracja sezonu
  const [currentRound, setCurrentRound] = useState(1);
  const [playedRounds, setPlayedRounds] = useState(0);
  const [totalRounds, setTotalRounds] = useState(18);
  const [totalRoundsByLeague, setTotalRoundsByLeague] = useState({});
  const [playedRoundsByLeague, setPlayedRoundsByLeague] = useState({});

  // Dane sezonu
  const [standings, setStandings] = useState({ tableByLeague: {}, teamStats: {} });
  const [fixtures, setFixtures] = useState([]);
  const [matches, setMatches] = useState([]);
  const [currentLeagues, setCurrentLeagues] = useState([]);
  const [seasonSummary, setSeasonSummary] = useState(null);

  // Statystyki zawodników
  const [topScorers, setTopScorers] = useState([]);
  const [topAssists, setTopAssists] = useState([]);
  const [topYellow, setTopYellow] = useState([]);
  const [topRed, setTopRed] = useState([]);

  // Treści
  const [news, setNews] = useState([]);
  const [polls, setPolls] = useState([]);
  const [freeAgents, setFreeAgents] = useState([]);
  const [tournaments, setTournaments] = useState([]);
  const [typerConfig, setTyperConfig] = useState(null);

  // Cache sezonów
  const cache = useRef({});
  const seasonsRef = useRef([]); // pełne dane sezonów (z polem status)

  // Fikcyjni gracze (puste - brak w bazie na razie)
  const [players, setPlayers] = useState([]);
  const [playersByTeam, setPlayersByTeam] = useState({});

  // 1. Załaduj listę sezonów przy starcie
  useEffect(() => {
    let cancelled = false;

    async function init() {
      try {
        const seasons = await fetchSeasons();
        if (cancelled) return;

        const years = seasons.map(s => s.year);
        setAvailableSeasons(years);
        seasonsRef.current = seasons;

        // Znajdź aktualny sezon (is_current=true) lub najnowszy
        const current = seasons.find(s => s.is_current) || seasons[seasons.length - 1];
        if (current) {
          setCurrentSeason(current.year);
          setSeasonStatus(current.status);
        } else {
          setLoading(false);
        }
      } catch (err) {
        if (!cancelled) {
          console.error('Błąd ładowania sezonów:', err);
          setError('Nie udało się połączyć z bazą danych. Sprawdź połączenie internetowe.');
          setLoading(false);
        }
      }
    }

    init();
    return () => { cancelled = true; };
  }, []);

  useEffect(() => {
    if (!currentSeason || !currentRound) {
      setTyperConfig(null);
      return;
    }

    let cancelled = false;

    async function loadTyperConfig() {
      try {
        const cfg = await fetchActiveTyperConfig(currentSeason, currentRound);
        if (!cancelled) setTyperConfig(cfg || null);
      } catch (err) {
        if (!cancelled) setTyperConfig(null);
      }
    }

    loadTyperConfig();
    return () => { cancelled = true; };
  }, [currentSeason, currentRound]);

  // 2. Załaduj dane sezonu gdy zmieni się currentSeason
  useEffect(() => {
    if (!currentSeason) return;

    let cancelled = false;

    async function loadSeason(year) {
      setLoading(true);
      setError(null);

      // Nie keszuj sezonu in_progress — zawsze świeże dane
      const seasonObj = seasonsRef.current.find(s => s.year === year);
      const isInProgress = seasonObj?.status === 'in_progress' || seasonObj?.status === 'active';

      if (!isInProgress && cache.current[year]) {
        const cached = cache.current[year];
        applySeasonData(cached);
        setLoading(false);
        return;
      }

      try {
        const [
          config,
          standingsData,
          matchData,
          leaguesData,
          scorers,
          assists,
          yellow,
          red,
          summary,
        ] = await Promise.all([
          fetchSeasonConfig(year),
          fetchStandings(year),
          fetchAllMatches(year),
          fetchTeamsForSeason(year),
          fetchTopScorers(year),
          fetchTopAssists(year),
          fetchTopYellow(year),
          fetchTopRed(year),
          fetchSeasonSummary(year),
        ]);

        if (cancelled) return;

        // Oblicz formę na froncie (wg daty, nie kolejki) i nextOpponent
        computeFormFromMatches(standingsData, matchData.matches);
        enrichStandingsWithNextOpponent(standingsData, matchData.fixtures, matchData.matches);

        const seasonData = {
          config,
          standings: standingsData,
          fixtures: matchData.fixtures,
          matches: matchData.matches,
          leagues: leaguesData,
          topScorers: scorers,
          topAssists: assists,
          topYellow: yellow,
          topRed: red,
          seasonSummary: summary,
        };

        if (!isInProgress) {
          cache.current[year] = seasonData;
        }
        applySeasonData(seasonData);
      } catch (err) {
        if (!cancelled) {
          console.error(`Błąd ładowania sezonu ${year}:`, err);
          setError(`Nie udało się załadować danych sezonu ${year}.`);
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    function applySeasonData(data) {
      setCurrentRound(data.config.currentRound);
      setPlayedRounds(data.config.playedRounds);
      setTotalRounds(data.config.totalRounds);
      setTotalRoundsByLeague(data.config.totalRoundsByLeague || {});
      setPlayedRoundsByLeague(data.config.playedRoundsByLeague || {});
      setStandings(data.standings);
      setFixtures(data.fixtures);
      setMatches(data.matches);
      setCurrentLeagues(data.leagues);
      setTopScorers(data.topScorers);
      setTopAssists(data.topAssists);
      setTopYellow(data.topYellow);
      setTopRed(data.topRed);
      setSeasonSummary(data.seasonSummary);
    }

    loadSeason(currentSeason);
    return () => { cancelled = true; };
  }, [currentSeason]);

  // 3. Załaduj treści (niezależne od sezonu) - raz
  useEffect(() => {
    let cancelled = false;

    async function loadContent() {
      try {
        const [newsData, pollsData, freeData, tourData] = await Promise.all([
          fetchNews(),
          fetchPolls(),
          fetchFreeAgents(),
          fetchTournaments(),
        ]);

        if (cancelled) return;

        setNews(newsData);
        setPolls(pollsData);
        setFreeAgents(freeData);
        setTournaments(tourData);
      } catch (err) {
        console.warn('Błąd ładowania treści:', err);
      }
    }

    loadContent();
    return () => { cancelled = true; };
  }, []);

  // Stats obiekt kompatybilny z App.js
  const stats = {
    tableByLeague: standings.tableByLeague,
    teamStats: standings.teamStats,
    playerStats: {},
    topScorers,
    topAssists,
    topYellow,
    topRed,
  };

  // Zmiana sezonu z invalidacją cache
  const handleSeasonChange = useCallback((year) => {
    delete cache.current[year];
    setCurrentSeason(year);
    const s = seasonsRef.current.find(x => x.year === year);
    if (s) setSeasonStatus(s.status);
  }, []);

  return {
    loading,
    error,
    availableSeasons,
    currentSeason,
    setCurrentSeason: handleSeasonChange,
    seasonStatus,
    currentRound,
    playedRounds,
    totalRounds,
    totalRoundsByLeague,
    playedRoundsByLeague,
    currentLeagues,
    fixtures,
    matches,
    stats,
    players,
    playersByTeam,
    news,
    polls,
    freeAgents,
    tournaments,
    typerConfig,
    seasonSummary,
  };
}

// Oblicz formę (last 5) z meczów posortowanych wg DATY (nie kolejki)
function computeFormFromMatches(standingsData, matches) {
  for (const [code, table] of Object.entries(standingsData.tableByLeague)) {
    for (const row of table) {
      // Znajdź wszystkie mecze tej drużyny w tej lidze, posortowane wg daty malejąco
      const teamMatches = matches
        .filter(m => m.league === code && (m.home === row.team || m.away === row.team))
        .sort((a, b) => {
          // Sortuj wg daty malejąco (najnowsze pierwsze)
          const dateCompare = (b.date || '').localeCompare(a.date || '');
          if (dateCompare !== 0) return dateCompare;
          // Przy tej samej dacie — wg kolejki
          return b.round - a.round;
        })
        .slice(0, 5);

      // Zbuduj form5 (odwróć aby najstarszy był po lewej)
      const form5 = teamMatches.reverse().map(m => {
        const isHome = m.home === row.team;
        const gf = isHome ? m.homeGoals : m.awayGoals;
        const ga = isHome ? m.awayGoals : m.homeGoals;
        const opponent = isHome ? m.away : m.home;
        const result = gf > ga ? 'W' : gf === ga ? 'R' : 'P';
        return {
          result,
          opponent,
          score: `${gf}:${ga}`,
        };
      });

      row.form5 = form5;
      row.lastResults = form5;
    }
  }
}

// Oblicz następnego przeciwnika dla każdej drużyny
function enrichStandingsWithNextOpponent(standingsData, fixtures, matches) {
  const playedIds = new Set(matches.map(m => m.id));

  for (const [code, table] of Object.entries(standingsData.tableByLeague)) {
    for (const row of table) {
      const nextFixture = fixtures
        .filter(f => f.league === code && !playedIds.has(f.id))
        .filter(f => f.home === row.team || f.away === row.team)
        .sort((a, b) => {
          const dateCompare = (a.date || '').localeCompare(b.date || '');
          if (dateCompare !== 0) return dateCompare;
          return a.round - b.round;
        })[0];

      if (nextFixture) {
        row.nextOpponent = nextFixture.home === row.team ? nextFixture.away : nextFixture.home;
      }
    }
  }
}
