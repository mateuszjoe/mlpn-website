import { useState, useEffect, useRef, useCallback } from 'react';
import { MATCH_DATA_UPDATED_EVENT, MATCH_DATA_UPDATED_STORAGE_KEY } from '../lib/matchDataEvents';
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
  fetchSponsors,
  fetchActiveTyperConfig,
  fetchFreeAgents,
  fetchTournaments,
  fetchSeasonSummary,
  fetchSeasonMatchGalleries,
} from '../services/supabaseQueries';

const LIVE_MATCH_REFRESH_INTERVAL_MS = 12000;
const IDLE_MATCH_REFRESH_INTERVAL_MS = 5 * 60 * 1000;

export function useMLPNData() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [refreshError, setRefreshError] = useState(null);
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
  const [matchGalleries, setMatchGalleries] = useState([]);

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
  const [sponsors, setSponsors] = useState([]);
  const [typerConfig, setTyperConfig] = useState(null);

  // Cache sezonów
  const cache = useRef({});
  const seasonsRef = useRef([]); // pełne dane sezonów (z polem status)
  const selectedSeasonRef = useRef(null);
  const requestGeneration = useRef(0);
  const readySeasonRef = useRef(null);
  const completedMatchesRef = useRef('');
  const matchRefreshRef = useRef(null);
  const [defaultSeason, setDefaultSeason] = useState(null); // sezon z is_current=true
  const [seasonsRefreshTrigger, setSeasonsRefreshTrigger] = useState(0);
  const [refreshTrigger, setRefreshTrigger] = useState(0);
  const [contentRefreshTrigger, setContentRefreshTrigger] = useState(0);

  // Fikcyjni gracze (puste - brak w bazie na razie)
  const [players, setPlayers] = useState([]);
  const [playersByTeam, setPlayersByTeam] = useState({});

  // 1. Załaduj listę sezonów przy starcie
  useEffect(() => {
    let cancelled = false;

    async function init() {
      setLoading(true);
      setError(null);
      try {
        const seasons = await fetchSeasons();
        if (cancelled) return;

        const years = seasons.map(s => s.year);
        setAvailableSeasons(years);
        seasonsRef.current = seasons;

        // Znajdź aktualny sezon (is_current=true) lub najnowszy
        const current = seasons.find(s => s.is_current) || seasons[seasons.length - 1];
        if (current) {
          selectedSeasonRef.current = current.year;
          setCurrentSeason(current.year);
          setSeasonStatus(current.status);
          setDefaultSeason(current.year);
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
  }, [seasonsRefreshTrigger]);

  useEffect(() => {
    if (!currentSeason || !currentRound) {
      setTyperConfig(null);
      return;
    }

    let cancelled = false;

    async function loadTyperConfig() {
      try {
        const cfg = await fetchActiveTyperConfig(currentSeason, currentRound);
        if (!cancelled && selectedSeasonRef.current === currentSeason) setTyperConfig(cfg || null);
      } catch (err) {
        if (!cancelled && selectedSeasonRef.current === currentSeason) setTyperConfig(null);
      }
    }

    loadTyperConfig();
    return () => { cancelled = true; };
  }, [currentSeason, currentRound, refreshTrigger]);

  useEffect(() => {
    if (!currentSeason) return undefined;

    let cancelled = false;

    async function refreshMatchGalleries() {
      const generation = requestGeneration.current;
      const isCurrent = () => !cancelled && selectedSeasonRef.current === currentSeason
        && requestGeneration.current === generation;
      try {
        const galleries = await fetchSeasonMatchGalleries(currentSeason);
        if (!isCurrent()) return;
        setMatchGalleries(galleries);
        if (cache.current[currentSeason]) {
          cache.current[currentSeason] = {
            ...cache.current[currentSeason],
            matchGalleries: galleries,
          };
        }
      } catch (err) {
        if (isCurrent()) {
          console.warn('Błąd odświeżania galerii meczowych:', err);
        }
      }
    }

    function handleGalleryRefresh() {
      refreshMatchGalleries();
    }

    window.addEventListener('mlpn:match-galleries-updated', handleGalleryRefresh);
    return () => {
      cancelled = true;
      window.removeEventListener('mlpn:match-galleries-updated', handleGalleryRefresh);
    };
  }, [currentSeason]);

  // 2. Załaduj dane sezonu gdy zmieni się currentSeason
  useEffect(() => {
    if (!currentSeason) return;

    let cancelled = false;
    const generation = ++requestGeneration.current;
    readySeasonRef.current = null;
    const isCurrent = () => !cancelled && requestGeneration.current === generation
      && selectedSeasonRef.current === currentSeason;

    async function loadSeason(year) {
      setLoading(true);
      setError(null);
      setRefreshError(null);

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
          galleries,
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
          fetchSeasonMatchGalleries(year),
        ]);

        if (!isCurrent()) return;

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
          matchGalleries: galleries,
        };

        if (!isInProgress) {
          cache.current[year] = seasonData;
        }
        applySeasonData(seasonData);
      } catch (err) {
        if (isCurrent()) {
          console.error(`Błąd ładowania sezonu ${year}:`, err);
          setError(`Nie udało się załadować danych sezonu ${year}.`);
        }
      } finally {
        if (isCurrent()) setLoading(false);
      }
    }

    function applySeasonData(data) {
      readySeasonRef.current = currentSeason;
      completedMatchesRef.current = completedMatchesSignature(data.matches);
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
      setMatchGalleries(data.matchGalleries || []);
    }

    loadSeason(currentSeason);
    return () => {
      cancelled = true;
      if (requestGeneration.current === generation) {
        requestGeneration.current += 1;
        readySeasonRef.current = null;
      }
    };
  }, [currentSeason, refreshTrigger]);

  // 3. Załaduj treści (niezależne od sezonu) - raz
  useEffect(() => {
    let cancelled = false;

    async function loadContent() {
      try {
        const [newsData, pollsData, sponsorData, freeData, tourData] = await Promise.all([
          fetchNews(),
          fetchPolls(),
          fetchSponsors(),
          fetchFreeAgents(),
          fetchTournaments(),
        ]);

        if (cancelled) return;

        setNews(newsData);
        setPolls(pollsData);
        setSponsors(sponsorData);
        setFreeAgents(freeData);
        setTournaments(tourData);
      } catch (err) {
        console.warn('Błąd ładowania treści:', err);
      }
    }

    loadContent();
    return () => { cancelled = true; };
  }, [contentRefreshTrigger]);

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

  // Powrót do archiwalnego sezonu korzysta z cache. Zapis danych unieważnia go osobno.
  const handleSeasonChange = useCallback((year) => {
    if (selectedSeasonRef.current === year) return;
    selectedSeasonRef.current = year;
    requestGeneration.current += 1;
    readySeasonRef.current = null;
    setCurrentSeason(year);
    const s = seasonsRef.current.find(x => x.year === year);
    setSeasonStatus(s?.status || null);
  }, []);

  // Odśwież dane (po zmianach w panelu admina)
  const refreshData = useCallback(() => {
    // Zdarzenie zapisu nie zawsze wskazuje sezon, więc unieważnij wszystkie archiwa.
    cache.current = {};
    requestGeneration.current += 1;
    readySeasonRef.current = null;
    setRefreshError(null);
    if (selectedSeasonRef.current) setRefreshTrigger(t => t + 1);
    else setSeasonsRefreshTrigger(t => t + 1);
    setContentRefreshTrigger(t => t + 1);
  }, []);

  const refreshMatchData = useCallback(async () => {
    if (!currentSeason || selectedSeasonRef.current !== currentSeason
      || readySeasonRef.current !== currentSeason) return;

    const generation = requestGeneration.current;
    if (matchRefreshRef.current?.generation === generation) return;
    const request = { generation };
    matchRefreshRef.current = request;
    const isCurrent = () => requestGeneration.current === generation
      && selectedSeasonRef.current === currentSeason && readySeasonRef.current === currentSeason;

    try {
      const matchData = await fetchAllMatches(currentSeason);
      if (!isCurrent()) return;
      const signature = completedMatchesSignature(matchData.matches);

      // Reaguj także na zakończenie jednego z kilku meczów, pominięty live i korektę wyniku.
      if (signature !== completedMatchesRef.current) {
        const [config, standingsData, scorers, assists, yellow, red] = await Promise.all([
          fetchSeasonConfig(currentSeason),
          fetchStandings(currentSeason),
          fetchTopScorers(currentSeason),
          fetchTopAssists(currentSeason),
          fetchTopYellow(currentSeason),
          fetchTopRed(currentSeason),
        ]);
        if (!isCurrent()) return;

        computeFormFromMatches(standingsData, matchData.matches);
        enrichStandingsWithNextOpponent(standingsData, matchData.fixtures, matchData.matches);

        setCurrentRound(config.currentRound);
        setPlayedRounds(config.playedRounds);
        setTotalRounds(config.totalRounds);
        setTotalRoundsByLeague(config.totalRoundsByLeague || {});
        setPlayedRoundsByLeague(config.playedRoundsByLeague || {});
        setStandings(standingsData);
        setTopScorers(scorers);
        setTopAssists(assists);
        setTopYellow(yellow);
        setTopRed(red);
      } else {
        setStandings(prev => {
          const tableByLeague = Object.fromEntries(
            Object.entries(prev.tableByLeague).map(([league, rows]) => [
              league, rows.map(row => ({ ...row })),
            ])
          );
          const next = {
            tableByLeague,
            teamStats: Object.fromEntries(Object.values(tableByLeague).flat().map(row => [row.team, row])),
          };
          computeFormFromMatches(next, matchData.matches);
          enrichStandingsWithNextOpponent(next, matchData.fixtures, matchData.matches);
          return next;
        });
      }

      // Publikuj spójny zestaw dopiero po udanym pobraniu wszystkich zależnych danych.
      setFixtures(matchData.fixtures);
      setMatches(matchData.matches);
      completedMatchesRef.current = signature;
      setRefreshError(null);
    } catch (err) {
      if (isCurrent()) {
        console.warn('Błąd odświeżania danych meczowych:', err);
        setRefreshError('Nie udało się odświeżyć wyników i statystyk. Wyświetlane dane mogą być nieaktualne.');
      }
    } finally {
      if (matchRefreshRef.current === request) matchRefreshRef.current = null;
    }
  }, [currentSeason]);

  useEffect(() => {
    function refreshFromStorage(event) {
      if (event.key === MATCH_DATA_UPDATED_STORAGE_KEY) {
        refreshData();
      }
    }

    window.addEventListener(MATCH_DATA_UPDATED_EVENT, refreshData);
    window.addEventListener('storage', refreshFromStorage);

    return () => {
      window.removeEventListener(MATCH_DATA_UPDATED_EVENT, refreshData);
      window.removeEventListener('storage', refreshFromStorage);
    };
  }, [refreshData]);

  useEffect(() => {
    const liveCapableSeason = seasonStatus === 'active' || seasonStatus === 'in_progress';
    if (!currentSeason || !liveCapableSeason) return undefined;

    const hasLiveFixtures = fixtures.some(fixture => fixture?.status === 'live');
    const intervalMs = hasLiveFixtures ? LIVE_MATCH_REFRESH_INTERVAL_MS : IDLE_MATCH_REFRESH_INTERVAL_MS;

    function refreshWhenVisible() {
      if (document.visibilityState === 'visible') {
        refreshMatchData();
      }
    }

    const intervalId = window.setInterval(refreshWhenVisible, intervalMs);
    document.addEventListener('visibilitychange', refreshWhenVisible);

    return () => {
      window.clearInterval(intervalId);
      document.removeEventListener('visibilitychange', refreshWhenVisible);
    };
  }, [currentSeason, fixtures, refreshMatchData, seasonStatus]);

  return {
    loading,
    error,
    refreshError,
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
    sponsors,
    typerConfig,
    seasonSummary,
    matchGalleries,
    defaultSeason,
    refreshData,
  };
}

function completedMatchesSignature(matches) {
  return JSON.stringify(matches.map(match => [
    match.id, match.status, match.league, match.home, match.away,
    match.homeGoals, match.awayGoals, match.date, match.round,
  ]).sort((a, b) => JSON.stringify(a).localeCompare(JSON.stringify(b))));
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

      row.nextOpponent = nextFixture
        ? (nextFixture.home === row.team ? nextFixture.away : nextFixture.home)
        : null;
    }
  }
}
