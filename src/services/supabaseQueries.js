import { publicSupabase } from '../lib/supabase';

// Drużyny-atrapy (rezerwacje miejsc, pauzy) - filtrowane z wyników
const PLACEHOLDER_TEAMS = ['przerwa', '-przerwa-', 'xxx', 'wolne miejsce', 'wolne miejsce ii'];
const isPlaceholder = (name) => PLACEHOLDER_TEAMS.includes(name?.toLowerCase().trim());

// ============================================================
// SEZONY
// ============================================================

export async function fetchSeasons() {
  const SUPABASE_URL = process.env.REACT_APP_SUPABASE_URL;
  const SUPABASE_KEY = process.env.REACT_APP_SUPABASE_ANON_KEY;

  // Bezpośredni fetch (bypass publicSupabase-js klienta)
  const url = `${SUPABASE_URL}/rest/v1/seasons?select=id,year,name,status,is_current&order=year.asc`;
  const resp = await fetch(url, {
    headers: {
      'apikey': SUPABASE_KEY,
      'Authorization': `Bearer ${SUPABASE_KEY}`,
    },
  });

  if (!resp.ok) {
    throw new Error(`Seasons fetch failed: ${resp.status} ${resp.statusText}`);
  }

  const data = await resp.json();
  return data || [];
}

export async function fetchSeasonConfig(seasonYear) {
  const { data: season, error: sErr } = await publicSupabase
    .from('seasons')
    .select('id, status')
    .eq('year', seasonYear)
    .single();

  if (sErr || !season) return { currentRound: 1, playedRounds: 0, totalRounds: 18 };

  // Zawsze obliczaj z rzeczywistych meczów (season_leagues bywa nieaktualne)
  const { data: matchStats } = await publicSupabase
    .from('v_matches')
    .select('round, status, match_date, league_code')
    .eq('season_year', seasonYear);

  if (!matchStats?.length) {
    return { currentRound: 1, playedRounds: 0, totalRounds: 0, totalRoundsByLeague: {}, playedRoundsByLeague: {} };
  }

  const isCompleted = (s) => s === 'completed' || s === 'walkover_home' || s === 'walkover_away';

  // ── Globalne statystyki (zachowane dla kompatybilności) ──
  const allRounds = matchStats.map(m => m.round);
  const completedRounds = matchStats.filter(m => isCompleted(m.status)).map(m => m.round);

  const maxRound = Math.max(...allRounds);
  const maxCompleted = completedRounds.length > 0 ? Math.max(...completedRounds) : 0;

  const totalRounds = maxRound;
  const playedRounds = maxCompleted;

  // ── Statystyki PER LIGA ──
  const byLeague = {};
  for (const m of matchStats) {
    const lc = m.league_code;
    if (!lc) continue;
    if (!byLeague[lc]) byLeague[lc] = { rounds: [], completedRounds: [] };
    byLeague[lc].rounds.push(m.round);
    if (isCompleted(m.status)) byLeague[lc].completedRounds.push(m.round);
  }

  const totalRoundsByLeague = {};
  const playedRoundsByLeague = {};
  for (const [lc, data] of Object.entries(byLeague)) {
    totalRoundsByLeague[lc] = Math.max(...data.rounds);
    playedRoundsByLeague[lc] = data.completedRounds.length > 0 ? Math.max(...data.completedRounds) : 0;
  }

  // ── Oblicz bieżącą kolejkę na podstawie daty ──
  const today = new Date().toISOString().slice(0, 10);
  let currentRound;

  if (season.status === 'completed') {
    currentRound = maxCompleted;
  } else {
    const roundDates = {};
    for (const m of matchStats) {
      if (!roundDates[m.round]) roundDates[m.round] = { min: m.match_date, max: m.match_date };
      if (m.match_date && m.match_date < roundDates[m.round].min) roundDates[m.round].min = m.match_date;
      if (m.match_date && m.match_date > roundDates[m.round].max) roundDates[m.round].max = m.match_date;
    }

    currentRound = maxCompleted + 1;
    for (let r = 1; r <= maxRound; r++) {
      const rd = roundDates[r];
      if (rd && rd.max >= today) {
        currentRound = r;
        break;
      }
    }
    currentRound = Math.min(currentRound, maxRound);
  }

  return {
    currentRound: currentRound || 1,
    playedRounds: playedRounds || 0,
    totalRounds: totalRounds || 18,
    totalRoundsByLeague,
    playedRoundsByLeague,
  };
}

// ============================================================
// TABELE LIGOWE (standings)
// ============================================================

export async function fetchStandings(seasonYear) {
  const { data, error } = await publicSupabase
    .from('v_standings')
    .select('*')
    .eq('season_year', seasonYear)
    .order('league_code')
    .order('position');

  if (error) throw error;

  const tableByLeague = {};
  const teamStats = {};

  // Mapowanie wyników formy: angielski (DB) → polski (frontend)
  const mapFormResult = (r) => r === 'D' ? 'R' : r === 'L' ? 'P' : r;

  let pos = {};  // osobny licznik pozycji per liga (po odfiltrowaniu atrapy)

  for (const row of (data || [])) {
    // Filtruj drużyny-atrapy
    if (isPlaceholder(row.team_name)) continue;

    const code = row.league_code;
    if (!tableByLeague[code]) tableByLeague[code] = [];
    if (!pos[code]) pos[code] = 0;
    pos[code]++;

    // Forma: odwróć (najnowszy na prawo) + mapowanie D→R, L→P
    const rawForm = row.form_last5 || [];
    const form5 = rawForm.slice().reverse().map(f => ({
      ...f,
      result: mapFormResult(f.result),
    }));

    const entry = {
      team: row.team_name,
      league: code,
      played: row.played || 0,
      win: row.won || 0,
      draw: row.drawn || 0,
      loss: row.lost || 0,
      gf: row.goals_for || 0,
      ga: row.goals_against || 0,
      pts: row.points || 0,
      pos: pos[code],
      form5,
      lastResults: form5,
      streakUnbeaten: row.streak_unbeaten || 0,
      streakWins: row.streak_wins || 0,
      streakWinless: row.streak_winless || 0,
      logoUrl: row.team_logo_url,
    };

    tableByLeague[code].push(entry);
    teamStats[row.team_name] = entry;
  }

  return { tableByLeague, teamStats };
}

// ============================================================
// MECZE (fixtures + matches)
// ============================================================

export async function fetchAllMatches(seasonYear) {
  const { data, error } = await publicSupabase
    .from('v_matches')
    .select('*')
    .eq('season_year', seasonYear)
    .order('round')
    .order('match_date')
    .order('match_time');

  if (error) throw error;

  const fixtures = [];
  const matches = [];

  for (const row of (data || [])) {
    // Filtruj mecze z drużynami-atrapami
    if (isPlaceholder(row.home_team_name) || isPlaceholder(row.away_team_name)) continue;

    const fixture = {
      id: row.id,
      league: row.league_code,
      homeTeamId: row.home_team_id,
      awayTeamId: row.away_team_id,
      status: row.status || 'scheduled',
      round: row.round,
      date: row.match_date,
      time: row.match_time ? row.match_time.slice(0, 5) : '',
      venue: row.venue || '',
      home: row.home_team_name,
      away: row.away_team_name,
      videoUrl: row.video_url || null,
      galleryUrl: row.gallery_url || null,
      homeLogoUrl: row.home_team_logo,
      awayLogoUrl: row.away_team_logo,
    };
    fixtures.push(fixture);

    const isCompleted = row.status === 'completed' ||
      row.status === 'walkover_home' ||
      row.status === 'walkover_away';

    if (isCompleted) {
      matches.push({
        ...fixture,
        played: true,
        homeGoals: row.home_goals ?? 0,
        awayGoals: row.away_goals ?? 0,
        status: row.status,
        referee: row.referee || '',
        mvp: row.mvp_name ? {
          playerId: row.mvp_player_id,
          playerName: row.mvp_name,
          team:
            row.mvp_team_id === row.home_team_id
              ? row.home_team_name
              : row.mvp_team_id === row.away_team_id
                ? row.away_team_name
                : null,
        } : null,
        events: [],
        homeLineup: [],
        awayLineup: [],
      });
    }
  }

  return { fixtures, matches };
}

// ============================================================
// DRUŻYNY W SEZONIE
// ============================================================

export async function fetchTeamsForSeason(seasonYear) {
  const { data: season } = await publicSupabase
    .from('seasons')
    .select('id')
    .eq('year', seasonYear)
    .single();

  if (!season) return [];

  const { data: seasonTeams, error } = await publicSupabase
    .from('season_teams')
    .select(`
      team_id,
      final_position,
      promoted,
      relegated,
      champion,
      teams ( id, name, abbreviation, logo_url, founded_year, home_venue, district, team_photo_url ),
      leagues!inner ( code, name )
    `)
    .eq('season_id', season.id)
    .order('final_position');

  if (error) throw error;

  const leagues = {};
  for (const st of (seasonTeams || [])) {
    // Filtruj drużyny-atrapy
    if (isPlaceholder(st.teams?.name)) continue;

    const code = st.leagues.code;
    if (!leagues[code]) {
      leagues[code] = {
        id: code,
        name: st.leagues.name,
        teams: [],
      };
    }
    leagues[code].teams.push(st.teams.name);
  }

  return Object.values(leagues).sort((a, b) => {
    const order = { '1st': 1, '2nd': 2, '3rd': 3 };
    return (order[a.id] || 99) - (order[b.id] || 99);
  });
}

// ============================================================
// STATYSTYKI ZAWODNIKÓW
// ============================================================

export async function fetchTopScorers(seasonYear) {
  const { data, error } = await publicSupabase
    .from('v_top_scorers')
    .select('*')
    .eq('season_year', seasonYear)
    .order('goals', { ascending: false })
    .order('assists', { ascending: false });

  if (error) throw error;

  return (data || []).map(row => ({
    playerId: row.player_id,
    name: row.display_name,
    team: row.team_name,
    league: row.league_code,
    goals: row.goals || 0,
    assists: row.assists || 0,
  }));
}

export async function fetchTopAssists(seasonYear) {
  const { data, error } = await publicSupabase
    .from('v_top_assists')
    .select('*')
    .eq('season_year', seasonYear)
    .order('assists', { ascending: false })
    .order('goals', { ascending: false });

  if (error) throw error;

  return (data || []).map(row => ({
    playerId: row.player_id,
    name: row.display_name,
    team: row.team_name,
    league: row.league_code,
    goals: row.goals || 0,
    assists: row.assists || 0,
  }));
}

export async function fetchTopYellow(seasonYear) {
  const { data, error } = await publicSupabase
    .from('v_top_yellow_cards')
    .select('*')
    .eq('season_year', seasonYear)
    .order('yellow_cards', { ascending: false });

  if (error) throw error;

  return (data || []).map(row => ({
    playerId: row.player_id,
    name: row.display_name,
    team: row.team_name,
    league: row.league_code,
    yellow: row.yellow_cards || 0,
    red: row.red_cards || 0,
  }));
}

export async function fetchTopRed(seasonYear) {
  // Próbuj widok v_top_red_cards, fallback na puste
  const { data, error } = await publicSupabase
    .from('v_top_red_cards')
    .select('*')
    .eq('season_year', seasonYear)
    .order('red_cards', { ascending: false });

  if (error) {
    // Widok może nie istnieć jeszcze - zwróć puste
    console.warn('v_top_red_cards niedostępny:', error.message);
    const { data: fallbackData, error: fallbackError } = await publicSupabase
      .from('player_season_stats')
      .select(`
        player_id,
        red_cards,
        yellow_cards,
        players ( display_name ),
        teams ( name ),
        leagues ( code ),
        seasons!inner ( year )
      `)
      .eq('seasons.year', seasonYear)
      .gt('red_cards', 0)
      .order('red_cards', { ascending: false })
      .order('yellow_cards', { ascending: false });

    if (fallbackError) {
      console.warn('Fallback top red cards failed:', fallbackError.message);
      return [];
    }

    return (fallbackData || []).map(row => ({
      playerId: row.player_id,
      name: row.players?.display_name || '',
      team: row.teams?.name || '',
      league: row.leagues?.code || '',
      red: row.red_cards || 0,
      yellow: row.yellow_cards || 0,
    }));
  }

  return (data || []).map(row => ({
    playerId: row.player_id,
    name: row.display_name,
    team: row.team_name,
    league: row.league_code,
    red: row.red_cards || 0,
    yellow: row.yellow_cards || 0,
  }));
}

// ============================================================
// TREŚCI (news, polls, free agents, tournaments)
// ============================================================

export async function fetchNews() {
  const { data, error } = await publicSupabase
    .from('news')
    .select('*')
    .eq('is_published', true)
    .order('published_at', { ascending: false })
    .limit(30);

  if (error) {
    console.warn('Błąd pobierania newsów:', error.message);
    return [];
  }

  return (data || []).map(row => ({
    id: row.id,
    date: row.published_at ? row.published_at.slice(0, 10) : '',
    category: row.category || 'komunikat',
    title: row.title || '',
    body: row.body || '',
    suspended: row.suspended_players || [],
    fixtureId: row.related_match_id,
  }));
}

export async function fetchPolls() {
  const { data: polls, error } = await publicSupabase
    .from('polls')
    .select('*, poll_options(*)')
    .eq('is_published', true)
    .order('end_date', { ascending: false });

  if (error) {
    console.warn('Błąd pobierania ankiet:', error.message);
    return [];
  }

  return (polls || []).map(poll => {
    const options = (poll.poll_options || [])
      .sort((a, b) => (a.display_order || 0) - (b.display_order || 0));

    // Format daty i godziny zakończenia
    let endDate = null;
    let endTime = null;
    if (poll.end_date) {
      const d = new Date(poll.end_date);
      endDate = d.toLocaleDateString('pl-PL', { day: '2-digit', month: '2-digit', year: 'numeric' });
      endTime = d.toLocaleTimeString('pl-PL', { hour: '2-digit', minute: '2-digit' });
    }

    return {
      id: poll.id,
      question: poll.title,
      title: poll.title,
      options: options.map(o => o.option_text),
      votes: options.map(o => o.vote_count || 0),
      active: poll.status === 'active',
      status: poll.status || 'active',
      endDate,
      endTime,
    };
  });
}

export async function fetchActiveTyperConfig(seasonYear, round) {
  if (!seasonYear || !round) return null;

  try {
    const { data: season, error: seasonError } = await publicSupabase
      .from('seasons')
      .select('id')
      .eq('year', seasonYear)
      .single();

    if (seasonError || !season?.id) return null;

    const { data, error } = await publicSupabase
      .from('typer_round_configs')
      .select(`
        id,
        title,
        description,
        round,
        is_active,
        typer_round_config_matches (
          match_id,
          display_order
        )
      `)
      .eq('season_id', season.id)
      .eq('round', round)
      .eq('is_active', true)
      .maybeSingle();

    if (error || !data) {
      // Jeśli tabela jeszcze nie istnieje na danym środowisku, frontend ma działać po staremu.
      return null;
    }

    const rows = (data.typer_round_config_matches || [])
      .slice()
      .sort((a, b) => (a.display_order || 0) - (b.display_order || 0));

    return {
      id: data.id,
      title: data.title || null,
      description: data.description || null,
      round: data.round,
      matchIds: rows.map((r) => r.match_id).filter(Boolean),
    };
  } catch (err) {
    console.warn('Błąd pobierania konfiguracji typera:', err?.message || err);
    return null;
  }
}

function sortGalleryPhotos(rows) {
  return (rows || [])
    .slice()
    .sort((a, b) => {
      const orderDiff = (a.display_order || 0) - (b.display_order || 0);
      if (orderDiff !== 0) return orderDiff;
      return String(a.created_at || "").localeCompare(String(b.created_at || ""));
    })
    .map((photo) => ({
      id: photo.id,
      url: photo.photo_url || '',
      caption: photo.caption || '',
      displayOrder: photo.display_order || 0,
      createdAt: photo.created_at || null,
    }))
    .filter((photo) => photo.url);
}

function normalizeGalleryAlbum(album) {
  const photos = sortGalleryPhotos(album?.gallery_photos || []);
  return {
    id: album?.id || null,
    matchId: album?.match_id || null,
    title: album?.title || '',
    description: album?.description || '',
    coverUrl: album?.cover_photo_url || photos[0]?.url || '',
    publishedAt: album?.published_at || album?.created_at || null,
    photoCount: photos.length,
    photos,
  };
}

export async function fetchSeasonMatchGalleries(seasonYear) {
  const { data: season, error: seasonError } = await publicSupabase
    .from('seasons')
    .select('id')
    .eq('year', seasonYear)
    .single();

  if (seasonError || !season?.id) return [];

  const { data, error } = await publicSupabase
    .from('gallery_albums')
    .select(`
      id,
      title,
      description,
      match_id,
      cover_photo_url,
      published_at,
      created_at,
      gallery_photos (
        id,
        photo_url,
        display_order,
        created_at
      )
    `)
    .eq('season_id', season.id)
    .not('match_id', 'is', null)
    .order('published_at', { ascending: false })
    .order('created_at', { ascending: false });

  if (error) {
    console.warn('Błąd pobierania galerii meczowych:', error.message);
    return [];
  }

  return (data || [])
    .map(normalizeGalleryAlbum)
    .filter((album) => album.matchId && album.photoCount > 0);
}

export async function fetchMatchGallery(matchId) {
  if (!matchId) return null;

  const { data, error } = await publicSupabase
    .from('gallery_albums')
    .select(`
      id,
      title,
      description,
      match_id,
      cover_photo_url,
      published_at,
      created_at,
      gallery_photos (
        id,
        photo_url,
        caption,
        display_order,
        created_at
      )
    `)
    .eq('match_id', matchId)
    .order('created_at', { ascending: true })
    .limit(1);

  if (error) throw error;

  const album = data?.[0];
  if (!album) return null;

  const normalized = normalizeGalleryAlbum(album);
  if (normalized.photoCount === 0) return null;
  return normalized;
}

export async function fetchFreeAgents() {
  const { data, error } = await publicSupabase
    .from('free_agents')
    .select('*')
    .eq('is_active', true)
    .eq('is_approved', true)
    .order('created_at', { ascending: false });

  if (error) {
    console.warn('Błąd pobierania wolnych zawodników:', error.message);
    return [];
  }

  return (data || []).map(row => ({
    id: row.id,
    name: row.name || '',
    age: row.age || null,
    positions: row.positions || [],
    region: row.region || '',
    experience: row.experience || '',
    phone: row.phone || '',
    email: row.email || '',
    instagram: row.instagram || '',
    facebook: row.facebook || '',
  }));
}

export async function fetchTournaments() {
  const { data: tournaments, error } = await publicSupabase
    .from('tournaments')
    .select('*')
    .order('date_start', { ascending: false });

  if (error || !tournaments?.length) return [];

  const ids = tournaments.map(t => t.id);

  const [
    { data: teams },
    { data: tMatches },
    { data: standings },
  ] = await Promise.all([
    publicSupabase.from('tournament_teams').select('*').in('tournament_id', ids),
    publicSupabase.from('tournament_matches').select('*').in('tournament_id', ids).order('match_order'),
    publicSupabase.from('tournament_group_standings').select('*').in('tournament_id', ids).order('position'),
  ]);

  return tournaments.map(t => {
    const tTeams = (teams || []).filter(tt => tt.tournament_id === t.id);
    const tM = (tMatches || []).filter(tm => tm.tournament_id === t.id);
    const tS = (standings || []).filter(ts => ts.tournament_id === t.id);

    const groups = {};
    for (const tt of tTeams) {
      const g = tt.group_letter || 'A';
      if (!groups[g]) groups[g] = [];
      groups[g].push(tt.team_name);
    }

    const groupTables = {};
    for (const gs of tS) {
      const g = gs.group_letter;
      if (!groupTables[g]) groupTables[g] = [];
      groupTables[g].push({
        team: gs.team_name,
        played: gs.played || 0,
        win: gs.won || 0,
        draw: gs.drawn || 0,
        loss: gs.lost || 0,
        gf: gs.goals_for || 0,
        ga: gs.goals_against || 0,
        pts: gs.points || 0,
      });
    }

    const groupMatches = tM.filter(m => m.stage === 'group').map(m => ({
      group: m.group_letter,
      home: m.home_team_name,
      away: m.away_team_name,
      homeGoals: m.home_goals,
      awayGoals: m.away_goals,
    }));

    const playoffs = tM.filter(m => m.stage !== 'group').map(m => ({
      stage: m.stage,
      home: m.home_team_name,
      away: m.away_team_name,
      homeGoals: m.home_goals,
      awayGoals: m.away_goals,
      winner: m.winner_name,
    }));

    return {
      id: t.id,
      name: t.name,
      date: t.date_start,
      location: t.location,
      format: t.format,
      groups,
      groupMatches,
      groupTables,
      playoffs,
      champion: t.champion_team,
      runnerUp: t.runner_up_team,
      thirdPlace: t.third_place_team,
      mvp: t.mvp_name ? { name: t.mvp_name } : null,
      topScorer: t.top_scorer_name ? { name: t.top_scorer_name, goals: t.top_scorer_goals } : null,
      bestGK: t.best_gk_name ? { name: t.best_gk_name } : null,
    };
  });
}

// ============================================================
// DANE SZCZEGÓŁOWE (on-demand)
// ============================================================

export async function fetchMatchDetails(matchId) {
  const [{ data: events }, { data: lineups }] = await Promise.all([
    publicSupabase
      .from('match_events')
      .select('*, players!match_events_player_id_fkey(display_name), assist:players!match_events_assist_player_id_fkey(display_name), teams(name)')
      .eq('match_id', matchId)
      .order('event_order'),
    publicSupabase
      .from('match_lineups')
      .select('*, players(display_name, position), teams(name)')
      .eq('match_id', matchId),
  ]);

  const transformedEvents = (events || []).map(e => ({
    type: e.event_type === 'YELLOW_CARD' ? 'YELLOW' :
          e.event_type === 'RED_CARD' ? 'RED' :
          e.event_type,
    teamId: e.team_id,
    team: e.teams?.name || '',
    playerId: e.player_id,
    playerName: e.players?.display_name || '',
    assistId: e.assist_player_id,
    assistName: e.assist?.display_name || null,
    penalty: e.is_penalty || false,
    note: e.notes || '',
    minute: e.minute,
  }));

  const transformedLineups = (lineups || []).map(l => ({
    id: l.player_id,
    name: l.players?.display_name || '',
    pos: l.position_played || l.players?.position || '',
    number: l.shirt_number,
    teamId: l.team_id,
    team: l.teams?.name || '',
  }));

  return { events: transformedEvents, lineups: transformedLineups };
}

// ============================================================
// SEASON SUMMARY (champion, promoted, relegated)
// ============================================================

export async function fetchSeasonSummary(seasonYear) {
  const { data: season } = await publicSupabase
    .from('seasons')
    .select('id, status')
    .eq('year', seasonYear)
    .single();

  if (!season || season.status !== 'completed') return null;

  const { data: seasonTeams } = await publicSupabase
    .from('season_teams')
    .select('team_id, teams(name), leagues!inner(code), final_position, promoted, relegated, champion')
    .eq('season_id', season.id);

  if (!seasonTeams?.length) return null;

  const summary = {};
  for (const st of seasonTeams) {
    const code = st.leagues.code;
    if (!summary[code]) {
      summary[code] = { champion: null, promoted: [], relegated: [] };
    }
    if (st.champion) summary[code].champion = st.teams.name;
    if (st.promoted) summary[code].promoted.push(st.teams.name);
    if (st.relegated) summary[code].relegated.push(st.teams.name);
  }

  return summary;
}

// ============================================================
// PROFIL DRUŻYNY
// ============================================================

export async function fetchTeamProfile(teamName) {
  const { data } = await publicSupabase
    .from('teams')
    .select('id, name, abbreviation, logo_url, founded_year, home_venue, district, description, team_photo_url')
    .eq('name', teamName)
    .single();
  return data;
}

export async function fetchTeamRoster(teamName, seasonYear) {
  const { data } = await publicSupabase
    .from('v_team_roster')
    .select('*')
    .eq('team_name', teamName)
    .eq('season_year', seasonYear)
    .is('left_date', null)
    .order('position')
    .order('display_name');

  return (data || []).map(p => ({
    id: p.player_id,
    name: p.display_name,
    pos: p.position || '',
    number: p.shirt_number,
    isCaptain: p.is_captain,
    birthYear: p.birth_year,
    goals: p.goals,
    assists: p.assists,
    yellowCards: p.yellow_cards,
    redCards: p.red_cards,
    appearances: p.appearances,
  }));
}

export async function fetchTeamHistory(teamName) {
  const { data } = await publicSupabase
    .from('season_teams')
    .select('final_position, champion, promoted, relegated, seasons(year), leagues(code, name), teams!inner(name)')
    .eq('teams.name', teamName);

  if (!data) return [];

  return data
    .map(st => ({
      season: st.seasons?.year,
      league: st.leagues?.name || '',
      leagueCode: st.leagues?.code || '',
      position: st.final_position,
      champion: st.champion,
      promoted: st.promoted,
      relegated: st.relegated,
    }))
    .sort((a, b) => (b.season || 0) - (a.season || 0));
}

// ============================================================
// KATALOGI PUBLICZNE (lista druzyn / lista zawodnikow)
// ============================================================

export async function fetchTeamsDirectory() {
  const { data, error } = await publicSupabase
    .from('teams')
    .select('id, name, abbreviation, logo_url, district, is_active')
    .order('is_active', { ascending: false })
    .order('name', { ascending: true });

  if (error) throw error;

  return (data || []).map((t) => ({
    id: t.id,
    name: t.name || '',
    abbreviation: t.abbreviation || '',
    logoUrl: t.logo_url || '',
    district: t.district || '',
    isActive: t.is_active !== false,
  }));
}

export async function fetchPlayersDirectory() {
  const [{ data: players, error: playersErr }, { data: seasonStats }, { data: rosterRows }] = await Promise.all([
    publicSupabase
      .from('players')
      .select('id, first_name, last_name, display_name, position, birth_year, city, is_active')
      .order('last_name', { ascending: true })
      .order('first_name', { ascending: true }),
    publicSupabase
      .from('player_season_stats')
      .select('player_id, goals, assists, yellow_cards, red_cards, appearances'),
    publicSupabase
      .from('team_players')
      .select('player_id, left_date, seasons(year), teams(name), leagues(code, name)'),
  ]);

  if (playersErr) throw playersErr;

  const totalsByPlayer = {};
  for (const row of seasonStats || []) {
    const pid = row.player_id;
    if (!pid) continue;
    if (!totalsByPlayer[pid]) {
      totalsByPlayer[pid] = {
        appearances: 0,
        goals: 0,
        assists: 0,
        yellowCards: 0,
        redCards: 0,
      };
    }
    totalsByPlayer[pid].appearances += row.appearances || 0;
    totalsByPlayer[pid].goals += row.goals || 0;
    totalsByPlayer[pid].assists += row.assists || 0;
    totalsByPlayer[pid].yellowCards += row.yellow_cards || 0;
    totalsByPlayer[pid].redCards += row.red_cards || 0;
  }

  const latestTeamByPlayer = {};
  for (const row of rosterRows || []) {
    const playerId = row.player_id;
    if (!playerId || !row.teams?.name) continue;

    const candidate = {
      team: row.teams.name || '',
      league: row.leagues?.name || '',
      leagueCode: row.leagues?.code || '',
      season: row.seasons?.year || 0,
      isCurrent: !row.left_date,
    };

    const current = latestTeamByPlayer[playerId];
    if (!current) {
      latestTeamByPlayer[playerId] = candidate;
      continue;
    }

    if ((candidate.season || 0) > (current.season || 0)) {
      latestTeamByPlayer[playerId] = candidate;
      continue;
    }

    if ((candidate.season || 0) === (current.season || 0) && candidate.isCurrent && !current.isCurrent) {
      latestTeamByPlayer[playerId] = candidate;
    }
  }

  return (players || []).map((p) => {
    const displayName =
      p.display_name?.trim() ||
      [p.first_name, p.last_name].filter(Boolean).join(' ').trim() ||
      'Bez nazwy';
    const latestTeam = latestTeamByPlayer[p.id] || null;
    return {
      id: p.id,
      name: displayName,
      firstName: p.first_name || '',
      lastName: p.last_name || '',
      position: p.position || '',
      birthYear: p.birth_year || null,
      city: p.city || '',
      isActive: p.is_active !== false,
      currentTeam: latestTeam?.team || '',
      currentLeague: latestTeam?.league || '',
      currentLeagueCode: latestTeam?.leagueCode || '',
      currentSeason: latestTeam?.season || null,
      totals: totalsByPlayer[p.id] || {
        appearances: 0,
        goals: 0,
        assists: 0,
        yellowCards: 0,
        redCards: 0,
      },
    };
  });
}

// ============================================================
// PROFIL GRACZA
// ============================================================

export async function fetchPlayerProfile(playerId) {
  const [{ data: player }, { data: career }, { data: rosterRows }] = await Promise.all([
    publicSupabase
      .from('players')
      .select('id, first_name, last_name, display_name, position, birth_year, preferred_foot, photo_url, city, is_active')
      .eq('id', playerId)
      .single(),
    publicSupabase
      .from('player_season_stats')
      .select('season_id, league_id, team_id, goals, assists, yellow_cards, red_cards, appearances, seasons(year), leagues(code, name), teams(name)')
      .eq('player_id', playerId),
    publicSupabase
      .from('team_players')
      .select('season_id, league_id, team_id, seasons(year), leagues(code, name), teams(name)')
      .eq('player_id', playerId),
  ]);

  const seasonLeagueKey = (row) => `${row.season_id ?? row.seasonId ?? ''}|${row.league_id ?? row.leagueId ?? ''}`;

  const careerFromStats = (career || []).map(c => ({
    seasonId: c.season_id,
    leagueId: c.league_id,
    teamId: c.team_id,
    season: c.seasons?.year,
    team: c.teams?.name || '',
    league: c.leagues?.name || '',
    leagueCode: c.leagues?.code || '',
    goals: c.goals || 0,
    assists: c.assists || 0,
    yellowCards: c.yellow_cards || 0,
    redCards: c.red_cards || 0,
    appearances: c.appearances || 0,
  }));

  const existingSeasonLeagues = new Set(careerFromStats.map(seasonLeagueKey));
  const seenSupplemental = new Set();

  const supplementalCareer = (rosterRows || [])
    .filter(r => {
      const key = seasonLeagueKey(r);
      if (existingSeasonLeagues.has(key)) return false;
      const dedupe = `${key}|${r.team_id || ''}`;
      if (seenSupplemental.has(dedupe)) return false;
      seenSupplemental.add(dedupe);
      return true;
    })
    .map(r => ({
      seasonId: r.season_id,
      leagueId: r.league_id,
      teamId: r.team_id,
      season: r.seasons?.year,
      team: r.teams?.name || '',
      league: r.leagues?.name || '',
      leagueCode: r.leagues?.code || '',
      goals: 0,
      assists: 0,
      yellowCards: 0,
      redCards: 0,
      appearances: 0,
    }));

  const leagueOrder = { '1st': 1, '2nd': 2, '3rd': 3 };

  const careerRows = [...careerFromStats, ...supplementalCareer]
    .sort((a, b) => {
      const seasonDiff = (b.season || 0) - (a.season || 0);
      if (seasonDiff !== 0) return seasonDiff;

      const appearancesDiff = (b.appearances || 0) - (a.appearances || 0);
      if (appearancesDiff !== 0) return appearancesDiff;

      const leagueDiff = (leagueOrder[a.leagueCode] || 99) - (leagueOrder[b.leagueCode] || 99);
      if (leagueDiff !== 0) return leagueDiff;

      return (a.team || '').localeCompare(b.team || '', 'pl');
    })
    .map(({ seasonId, leagueId, teamId, ...row }) => row);

  return { player, career: careerRows };
}
