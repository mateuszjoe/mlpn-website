-- ################################################################
-- ##                                                            ##
-- ##   MLPN - ALL MIGRATIONS COMBINED                           ##
-- ##   Pliki: 001_core_tables.sql through 013_seed_data.sql     ##
-- ##                                                            ##
-- ################################################################


-- ================================================================
-- ===  FILE 001: 001_core_tables.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 001: Tabele Core
-- Seasons, Leagues, Season Leagues, Teams, Season Teams
-- ============================================================

-- SEASONS
CREATE TABLE seasons (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    year            INTEGER NOT NULL UNIQUE,
    name            TEXT NOT NULL,
    status          TEXT NOT NULL DEFAULT 'planned'
                    CHECK (status IN ('planned', 'active', 'completed')),
    is_current      BOOLEAN NOT NULL DEFAULT false,
    start_date      DATE,
    end_date        DATE,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- Tylko jeden sezon moze byc aktualny
CREATE UNIQUE INDEX idx_seasons_current ON seasons (is_current) WHERE is_current = true;

CREATE INDEX idx_seasons_status ON seasons (status);
CREATE INDEX idx_seasons_year ON seasons (year DESC);


-- LEAGUES
CREATE TABLE leagues (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    code            TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL,
    display_order   INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);


-- SEASON_LEAGUES (konfiguracja per sezon per liga)
CREATE TABLE season_leagues (
    id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    season_id           UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id           UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,

    -- Punktacja
    points_win          INTEGER NOT NULL DEFAULT 3,
    points_draw         INTEGER NOT NULL DEFAULT 1,
    points_loss         INTEGER NOT NULL DEFAULT 0,

    -- Walkover
    walkover_points_winner  INTEGER NOT NULL DEFAULT 3,
    walkover_goals_winner   INTEGER NOT NULL DEFAULT 3,
    walkover_goals_loser    INTEGER NOT NULL DEFAULT 0,

    -- Awanse/spadki
    promotion_spots     INTEGER NOT NULL DEFAULT 0,
    relegation_spots    INTEGER NOT NULL DEFAULT 0,

    -- Struktura sezonu
    total_rounds        INTEGER,
    played_rounds       INTEGER NOT NULL DEFAULT 0,
    current_round       INTEGER NOT NULL DEFAULT 1,

    -- Kary
    yellow_card_suspension_threshold INTEGER NOT NULL DEFAULT 3,

    UNIQUE (season_id, league_id),
    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_season_leagues_season ON season_leagues (season_id);
CREATE INDEX idx_season_leagues_league ON season_leagues (league_id);


-- TEAMS
CREATE TABLE teams (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name            TEXT NOT NULL UNIQUE,
    short_name      TEXT,
    abbreviation    TEXT NOT NULL UNIQUE,
    logo_url        TEXT,
    founded_year    INTEGER,
    home_venue      TEXT DEFAULT 'Narutowicza 10, 05-071 Sulejówek',
    description     TEXT,
    district        TEXT,
    team_photo_url  TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_teams_active ON teams (is_active) WHERE is_active = true;
CREATE INDEX idx_teams_name ON teams (name);


-- SEASON_TEAMS (druzyny w lidze w sezonie - zmienna liczba!)
CREATE TABLE season_teams (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    season_id       UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id       UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    team_id         UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,

    -- Dolaczanie/odchodzenie w trakcie sezonu
    joined_round    INTEGER NOT NULL DEFAULT 1,
    left_round      INTEGER,
    join_reason     TEXT NOT NULL DEFAULT 'original'
                    CHECK (join_reason IN ('original', 'mid_season_join', 'promoted', 'relegated')),

    -- Koniec sezonu
    final_position  INTEGER,
    promoted        BOOLEAN NOT NULL DEFAULT false,
    relegated       BOOLEAN NOT NULL DEFAULT false,
    champion        BOOLEAN NOT NULL DEFAULT false,

    -- Druzyna moze byc w max 1 lidze per sezon
    UNIQUE (season_id, team_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_season_teams_season ON season_teams (season_id);
CREATE INDEX idx_season_teams_league ON season_teams (season_id, league_id);
CREATE INDEX idx_season_teams_team ON season_teams (team_id);


-- ================================================================
-- ===  FILE 002: 002_players_tables.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 002: Tabele Players
-- Players, Players Private (RODO), Team Players (kadra/transfery)
-- ============================================================

-- PLAYERS (dane publiczne)
CREATE TABLE players (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    display_name    TEXT GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
    birth_year      INTEGER,
    position        TEXT NOT NULL CHECK (position IN ('BR', 'OBR', 'POM', 'NAP')),
    preferred_foot  TEXT CHECK (preferred_foot IN ('Prawa', 'Lewa', 'Obie')),
    photo_url       TEXT,
    city            TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_players_name ON players (last_name, first_name);
CREATE INDEX idx_players_active ON players (is_active) WHERE is_active = true;
CREATE INDEX idx_players_position ON players (position);


-- PLAYERS_PRIVATE (RODO - tylko admin i sam zawodnik)
CREATE TABLE players_private (
    player_id           UUID PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
    date_of_birth       DATE,
    phone               TEXT,
    email               TEXT,
    address             TEXT,
    rodo_consent_date   DATE,
    rodo_consent_type   TEXT CHECK (rodo_consent_type IN ('full', 'stats_only', 'withdrawn')),
    notes               TEXT,
    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);


-- TEAM_PLAYERS (kadra - z datami transferow)
CREATE TABLE team_players (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    team_id         UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    player_id       UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    season_id       UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id       UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    joined_date     DATE NOT NULL,
    left_date       DATE,
    is_captain      BOOLEAN NOT NULL DEFAULT false,
    shirt_number    INTEGER,

    -- Zawodnik moze byc w roznych druzynach w roznych ligach
    UNIQUE (player_id, season_id, league_id, team_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_team_players_team ON team_players (team_id, season_id);
CREATE INDEX idx_team_players_player ON team_players (player_id, season_id);
CREATE INDEX idx_team_players_active ON team_players (team_id, season_id)
    WHERE left_date IS NULL;
CREATE INDEX idx_team_players_league ON team_players (season_id, league_id);


-- ================================================================
-- ===  FILE 003: 003_matches_tables.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 003: Tabele Matches
-- Matches, Match Events, Match Lineups
-- ============================================================

-- MATCHES
CREATE TABLE matches (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    season_id       UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id       UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    round           INTEGER NOT NULL,
    home_team_id    UUID NOT NULL REFERENCES teams(id),
    away_team_id    UUID NOT NULL REFERENCES teams(id),

    -- Harmonogram
    match_date      DATE,
    match_time      TIME,
    venue           TEXT DEFAULT 'Narutowicza 10, 05-071 Sulejówek',

    -- Wynik (NULL dopoki nie rozegrany)
    home_goals      INTEGER,
    away_goals      INTEGER,

    -- Status
    status          TEXT NOT NULL DEFAULT 'scheduled'
                    CHECK (status IN (
                        'scheduled',
                        'live',
                        'completed',
                        'walkover_home',
                        'walkover_away',
                        'postponed',
                        'cancelled',
                        'unplayed'
                    )),

    -- Media
    video_url       TEXT,
    gallery_url     TEXT,

    -- Sedziowie i MVP
    referee         TEXT,
    mvp_player_id   UUID REFERENCES players(id),

    -- Notatki admina
    notes           TEXT,

    CHECK (home_team_id != away_team_id),
    UNIQUE (season_id, league_id, round, home_team_id, away_team_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_matches_season_league ON matches (season_id, league_id);
CREATE INDEX idx_matches_round ON matches (season_id, league_id, round);
CREATE INDEX idx_matches_team_home ON matches (home_team_id, season_id);
CREATE INDEX idx_matches_team_away ON matches (away_team_id, season_id);
CREATE INDEX idx_matches_date ON matches (match_date DESC);
CREATE INDEX idx_matches_status ON matches (status) WHERE status IN ('live', 'scheduled');


-- MATCH_EVENTS (gole, kartki)
CREATE TABLE match_events (
    id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    match_id            UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    event_type          TEXT NOT NULL CHECK (event_type IN ('GOAL', 'YELLOW_CARD', 'RED_CARD')),
    team_id             UUID NOT NULL REFERENCES teams(id),
    player_id           UUID NOT NULL REFERENCES players(id),

    -- Dla goli
    assist_player_id    UUID REFERENCES players(id),
    is_penalty          BOOLEAN NOT NULL DEFAULT false,
    is_own_goal         BOOLEAN NOT NULL DEFAULT false,

    -- Czas
    minute              INTEGER CHECK (minute >= 0 AND minute <= 120),

    -- Kolejnosc w meczu
    event_order         INTEGER NOT NULL DEFAULT 0,

    notes               TEXT,
    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_match_events_match ON match_events (match_id);
CREATE INDEX idx_match_events_player ON match_events (player_id);
CREATE INDEX idx_match_events_type ON match_events (event_type, player_id);
CREATE INDEX idx_match_events_goals ON match_events (player_id) WHERE event_type = 'GOAL';
CREATE INDEX idx_match_events_assists ON match_events (assist_player_id) WHERE assist_player_id IS NOT NULL;


-- MATCH_LINEUPS (sklady meczowe)
CREATE TABLE match_lineups (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    match_id        UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    team_id         UUID NOT NULL REFERENCES teams(id),
    player_id       UUID NOT NULL REFERENCES players(id),
    is_starter      BOOLEAN NOT NULL DEFAULT true,
    shirt_number    INTEGER,
    position_played TEXT,

    UNIQUE (match_id, player_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_match_lineups_match ON match_lineups (match_id, team_id);
CREATE INDEX idx_match_lineups_player ON match_lineups (player_id);


-- ================================================================
-- ===  FILE 004: 004_statistics_tables.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 004: Tabele Statistics
-- Standings, Player Season Stats, Suspensions
-- ============================================================

-- STANDINGS (cache - aktualizowany triggerem po kazdym wyniku)
CREATE TABLE standings (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    season_id       UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id       UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    team_id         UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,

    position        INTEGER NOT NULL DEFAULT 0,
    played          INTEGER NOT NULL DEFAULT 0,
    won             INTEGER NOT NULL DEFAULT 0,
    drawn           INTEGER NOT NULL DEFAULT 0,
    lost            INTEGER NOT NULL DEFAULT 0,
    goals_for       INTEGER NOT NULL DEFAULT 0,
    goals_against   INTEGER NOT NULL DEFAULT 0,
    goal_difference INTEGER GENERATED ALWAYS AS (goals_for - goals_against) STORED,
    points          INTEGER NOT NULL DEFAULT 0,

    -- Forma i serie (JSONB - elastyczne)
    form_last5      JSONB DEFAULT '[]'::jsonb,
    streak_wins     INTEGER NOT NULL DEFAULT 0,
    streak_unbeaten INTEGER NOT NULL DEFAULT 0,
    streak_winless  INTEGER NOT NULL DEFAULT 0,

    UNIQUE (season_id, league_id, team_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_standings_season_league ON standings (season_id, league_id);
CREATE INDEX idx_standings_position ON standings (season_id, league_id, position);
CREATE INDEX idx_standings_points ON standings (season_id, league_id, points DESC, goal_difference DESC, goals_for DESC);


-- PLAYER_SEASON_STATS (cache - aktualizowany triggerem po eventach)
CREATE TABLE player_season_stats (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    player_id       UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    season_id       UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id       UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    team_id         UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,

    appearances     INTEGER NOT NULL DEFAULT 0,
    goals           INTEGER NOT NULL DEFAULT 0,
    assists         INTEGER NOT NULL DEFAULT 0,
    yellow_cards    INTEGER NOT NULL DEFAULT 0,
    red_cards       INTEGER NOT NULL DEFAULT 0,

    goals_per_match NUMERIC(4,2) GENERATED ALWAYS AS (
        CASE WHEN appearances > 0 THEN goals::NUMERIC / appearances ELSE 0 END
    ) STORED,

    UNIQUE (player_id, season_id, league_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_player_stats_season ON player_season_stats (season_id, league_id);
CREATE INDEX idx_player_stats_goals ON player_season_stats (season_id, league_id, goals DESC);
CREATE INDEX idx_player_stats_assists ON player_season_stats (season_id, league_id, assists DESC);
CREATE INDEX idx_player_stats_yellows ON player_season_stats (season_id, league_id, yellow_cards DESC);
CREATE INDEX idx_player_stats_reds ON player_season_stats (season_id, league_id, red_cards DESC);
CREATE INDEX idx_player_stats_team ON player_season_stats (team_id, season_id);


-- SUSPENSIONS (automatyczne z kartek + reczne od admina)
CREATE TABLE suspensions (
    id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    player_id           UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    season_id           UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id           UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,

    suspension_type     TEXT NOT NULL CHECK (suspension_type IN (
        'yellow_accumulation',
        'red_card',
        'manual'
    )),

    reason              TEXT,

    -- Kolejki objete pauza
    start_round         INTEGER NOT NULL,
    end_round           INTEGER NOT NULL,
    matches_remaining   INTEGER NOT NULL DEFAULT 1,

    -- Powiazanie z eventem (dla automatycznych)
    triggering_event_id UUID REFERENCES match_events(id),

    is_served           BOOLEAN NOT NULL DEFAULT false,

    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_suspensions_player ON suspensions (player_id, season_id);
CREATE INDEX idx_suspensions_active ON suspensions (season_id, league_id, is_served) WHERE is_served = false;
CREATE INDEX idx_suspensions_round ON suspensions (season_id, league_id, start_round, end_round);


-- ================================================================
-- ===  FILE 005: 005_typer_polls_tables.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 005: Tabele Typer & Ankiety
-- Typer Predictions, Typer Aggregates, Polls, Poll Options, Poll Votes
-- ============================================================

-- TYPER_PREDICTIONS (anonimowe predykcje 1/X/2)
CREATE TABLE typer_predictions (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    match_id        UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    voter_id        TEXT NOT NULL,
    prediction      TEXT NOT NULL CHECK (prediction IN ('1', 'X', '2')),

    UNIQUE (match_id, voter_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_typer_match ON typer_predictions (match_id);
CREATE INDEX idx_typer_voter ON typer_predictions (voter_id);


-- TYPER_AGGREGATES (cache - przeliczany triggerem)
CREATE TABLE typer_aggregates (
    match_id        UUID PRIMARY KEY REFERENCES matches(id) ON DELETE CASCADE,
    total_votes     INTEGER NOT NULL DEFAULT 0,
    home_win_pct    NUMERIC(5,2) NOT NULL DEFAULT 0,
    draw_pct        NUMERIC(5,2) NOT NULL DEFAULT 0,
    away_win_pct    NUMERIC(5,2) NOT NULL DEFAULT 0,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);


-- POLLS (ankiety)
CREATE TABLE polls (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title           TEXT NOT NULL,
    status          TEXT NOT NULL DEFAULT 'active'
                    CHECK (status IN ('active', 'archived')),
    end_date        TIMESTAMPTZ NOT NULL,
    is_published    BOOLEAN NOT NULL DEFAULT true,
    season_id       UUID REFERENCES seasons(id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_polls_status ON polls (status, end_date);
CREATE INDEX idx_polls_published ON polls (is_published) WHERE is_published = true;


-- POLL_OPTIONS (opcje w ankietach)
CREATE TABLE poll_options (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    poll_id         UUID NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    option_text     TEXT NOT NULL,
    display_order   INTEGER NOT NULL DEFAULT 0,
    vote_count      INTEGER NOT NULL DEFAULT 0,
    vote_percentage NUMERIC(5,2) NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_poll_options_poll ON poll_options (poll_id, display_order);


-- POLL_VOTES (anonimowe glosy)
CREATE TABLE poll_votes (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    poll_id         UUID NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    option_id       UUID NOT NULL REFERENCES poll_options(id) ON DELETE CASCADE,
    voter_id        TEXT NOT NULL,

    -- Jeden glos per osoba per ankieta
    UNIQUE (poll_id, voter_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_poll_votes_poll ON poll_votes (poll_id);
CREATE INDEX idx_poll_votes_option ON poll_votes (option_id);


-- ================================================================
-- ===  FILE 006: 006_content_tables.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 006: Tabele Content
-- News, Free Agents, Sponsors, Static Pages, Gallery, Contact
-- ============================================================

-- NEWS (aktualnosci)
CREATE TABLE news (
    id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category            TEXT NOT NULL CHECK (category IN ('pauza', 'komunikat', 'wazne')),
    title               TEXT NOT NULL,
    body                TEXT,

    -- Dla kategorii "pauza" - lista zawieszonych zawodnikow
    suspended_players   JSONB,

    -- Powiazanie z meczem (opcjonalne)
    related_match_id    UUID REFERENCES matches(id) ON DELETE SET NULL,

    -- Publikacja
    is_published        BOOLEAN NOT NULL DEFAULT false,
    published_at        TIMESTAMPTZ,

    season_id           UUID REFERENCES seasons(id),
    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_news_published ON news (published_at DESC) WHERE is_published = true;
CREATE INDEX idx_news_category ON news (category, published_at DESC);
CREATE INDEX idx_news_season ON news (season_id, published_at DESC);


-- FREE_AGENTS (wolni zawodnicy - z formularzem publicznym)
CREATE TABLE free_agents (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name            TEXT NOT NULL,
    age             INTEGER,
    positions       TEXT[] NOT NULL,
    region          TEXT,
    experience      TEXT,

    -- Dane kontaktowe (widoczne po zatwierdzeniu)
    phone           TEXT,
    email           TEXT,
    instagram       TEXT,
    facebook        TEXT,

    -- Moderacja
    is_active       BOOLEAN NOT NULL DEFAULT true,
    is_approved     BOOLEAN NOT NULL DEFAULT false,
    submitted_at    TIMESTAMPTZ DEFAULT now(),

    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_free_agents_active ON free_agents (is_active, is_approved)
    WHERE is_active = true AND is_approved = true;


-- SPONSORS
CREATE TABLE sponsors (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name            TEXT NOT NULL,
    logo_url        TEXT,
    website_url     TEXT,
    description     TEXT,
    display_order   INTEGER NOT NULL DEFAULT 0,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_sponsors_active ON sponsors (is_active, display_order)
    WHERE is_active = true;


-- STATIC_PAGES (regulamin, rodo, polityka prywatnosci, o nas)
CREATE TABLE static_pages (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    slug            TEXT NOT NULL UNIQUE,
    title           TEXT NOT NULL,
    content         TEXT NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);


-- GALLERY_ALBUMS (albumy zdjec)
CREATE TABLE gallery_albums (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title           TEXT NOT NULL,
    description     TEXT,
    match_id        UUID REFERENCES matches(id) ON DELETE SET NULL,
    season_id       UUID REFERENCES seasons(id),
    cover_photo_url TEXT,
    is_published    BOOLEAN NOT NULL DEFAULT false,
    published_at    TIMESTAMPTZ DEFAULT now(),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_gallery_albums_published ON gallery_albums (published_at DESC)
    WHERE is_published = true;
CREATE INDEX idx_gallery_albums_season ON gallery_albums (season_id);
CREATE INDEX idx_gallery_albums_match ON gallery_albums (match_id) WHERE match_id IS NOT NULL;


-- GALLERY_PHOTOS (zdjecia w albumach)
CREATE TABLE gallery_photos (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    album_id        UUID NOT NULL REFERENCES gallery_albums(id) ON DELETE CASCADE,
    photo_url       TEXT NOT NULL,
    caption         TEXT,
    display_order   INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_gallery_photos_album ON gallery_photos (album_id, display_order);


-- CONTACT_MESSAGES (formularz kontaktowy)
CREATE TABLE contact_messages (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sender_name     TEXT NOT NULL,
    sender_email    TEXT NOT NULL,
    subject         TEXT NOT NULL,
    message         TEXT NOT NULL,
    is_read         BOOLEAN NOT NULL DEFAULT false,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_contact_unread ON contact_messages (is_read, created_at DESC)
    WHERE is_read = false;


-- ================================================================
-- ===  FILE 007: 007_tournaments_tables.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 007: Tabele Tournaments
-- Tournaments, Tournament Teams, Matches, Group Standings
-- ============================================================

-- TOURNAMENTS
CREATE TABLE tournaments (
    id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name                TEXT NOT NULL,
    date_start          DATE NOT NULL,
    date_end            DATE,
    location            TEXT NOT NULL,
    format              TEXT DEFAULT '6v6',
    match_duration      INTEGER DEFAULT 10,
    status              TEXT NOT NULL DEFAULT 'planned'
                        CHECK (status IN ('planned', 'active', 'completed')),

    -- Nagrody
    champion_team       TEXT,
    runner_up_team      TEXT,
    third_place_team    TEXT,
    mvp_name            TEXT,
    top_scorer_name     TEXT,
    top_scorer_goals    INTEGER,
    best_gk_name        TEXT,
    best_gk_clean_sheets INTEGER,

    season_id           UUID REFERENCES seasons(id),
    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_tournaments_season ON tournaments (season_id);
CREATE INDEX idx_tournaments_status ON tournaments (status);


-- TOURNAMENT_TEAMS (mogą być druzyny pozaligowe)
CREATE TABLE tournament_teams (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tournament_id   UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    team_name       TEXT NOT NULL,
    team_id         UUID REFERENCES teams(id),
    group_letter    CHAR(1),

    UNIQUE (tournament_id, team_name),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_tournament_teams_tournament ON tournament_teams (tournament_id, group_letter);


-- TOURNAMENT_MATCHES
CREATE TABLE tournament_matches (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tournament_id   UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    stage           TEXT NOT NULL CHECK (stage IN ('group', 'QF', 'SF', '3rd', 'final')),
    group_letter    CHAR(1),
    home_team_name  TEXT NOT NULL,
    away_team_name  TEXT NOT NULL,
    home_goals      INTEGER,
    away_goals      INTEGER,
    winner_name     TEXT,
    match_order     INTEGER NOT NULL DEFAULT 0,

    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_tournament_matches_tournament ON tournament_matches (tournament_id, stage);
CREATE INDEX idx_tournament_matches_group ON tournament_matches (tournament_id, group_letter)
    WHERE group_letter IS NOT NULL;


-- TOURNAMENT_GROUP_STANDINGS (cache)
CREATE TABLE tournament_group_standings (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tournament_id   UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    group_letter    CHAR(1) NOT NULL,
    team_name       TEXT NOT NULL,
    played          INTEGER NOT NULL DEFAULT 0,
    won             INTEGER NOT NULL DEFAULT 0,
    drawn           INTEGER NOT NULL DEFAULT 0,
    lost            INTEGER NOT NULL DEFAULT 0,
    goals_for       INTEGER NOT NULL DEFAULT 0,
    goals_against   INTEGER NOT NULL DEFAULT 0,
    points          INTEGER NOT NULL DEFAULT 0,
    position        INTEGER NOT NULL DEFAULT 0,

    UNIQUE (tournament_id, group_letter, team_name),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_tournament_standings ON tournament_group_standings (tournament_id, group_letter, position);


-- ================================================================
-- ===  FILE 008: 008_auth_profiles.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 008: Auth & Profiles
-- Profiles (rozszerzenie auth.users), Helper Functions
-- ============================================================

-- PROFILES (rozszerzenie Supabase auth.users)
CREATE TABLE profiles (
    id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role            TEXT NOT NULL DEFAULT 'viewer'
                    CHECK (role IN ('admin', 'editor', 'player', 'viewer')),
    email           TEXT,
    display_name    TEXT,
    player_id       UUID REFERENCES players(id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_profiles_role ON profiles (role);
CREATE INDEX idx_profiles_email ON profiles (email);
CREATE INDEX idx_profiles_player ON profiles (player_id) WHERE player_id IS NOT NULL;


-- ============================================================
-- HELPER FUNCTIONS (uzywane w RLS policies)
-- ============================================================

-- Czy zalogowany user jest adminem?
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role = 'admin'
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- Czy zalogowany user jest adminem lub editorem?
CREATE OR REPLACE FUNCTION is_editor_or_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role IN ('admin', 'editor')
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- Zwraca player_id zalogowanego usera (lub NULL)
CREATE OR REPLACE FUNCTION get_my_player_id()
RETURNS UUID AS $$
    SELECT player_id FROM profiles
    WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- ============================================================
-- AUTO-CREATE PROFILE on user signup
-- Supabase auth trigger - tworzy profil automatycznie
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id, role, email, display_name)
    VALUES (
        NEW.id,
        'viewer',
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger na auth.users
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

CREATE OR REPLACE FUNCTION sync_profile_from_auth_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id, role, email, display_name)
    VALUES (
        NEW.id,
        'viewer',
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email)
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        display_name = COALESCE(NULLIF(EXCLUDED.display_name, ''), profiles.display_name, EXCLUDED.email),
        updated_at = now();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_updated
    AFTER UPDATE OF email, raw_user_meta_data ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION sync_profile_from_auth_user();


-- ================================================================
-- ===  FILE 009: 009_rls_policies.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 009: Row Level Security (RLS)
-- Wszystkie tabele z odpowiednimi politykami dostepu
-- ============================================================

-- ============================================================
-- WLACZ RLS na wszystkich tabelach
-- ============================================================
ALTER TABLE seasons ENABLE ROW LEVEL SECURITY;
ALTER TABLE leagues ENABLE ROW LEVEL SECURITY;
ALTER TABLE season_leagues ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE season_teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE players_private ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_lineups ENABLE ROW LEVEL SECURITY;
ALTER TABLE standings ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_season_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE suspensions ENABLE ROW LEVEL SECURITY;
ALTER TABLE typer_predictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE typer_aggregates ENABLE ROW LEVEL SECURITY;
ALTER TABLE polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE poll_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE poll_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE news ENABLE ROW LEVEL SECURITY;
ALTER TABLE free_agents ENABLE ROW LEVEL SECURITY;
ALTER TABLE sponsors ENABLE ROW LEVEL SECURITY;
ALTER TABLE static_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE gallery_albums ENABLE ROW LEVEL SECURITY;
ALTER TABLE gallery_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_group_standings ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- WZORZEC 1: Public read, admin write
-- Dotyczy: seasons, leagues, season_leagues, teams, season_teams,
--          players, team_players, standings, player_season_stats,
--          suspensions, tournaments, tournament_teams,
--          tournament_matches, tournament_group_standings
-- ============================================================

-- SEASONS
CREATE POLICY "seasons_public_read" ON seasons FOR SELECT USING (true);
CREATE POLICY "seasons_admin_insert" ON seasons FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "seasons_admin_update" ON seasons FOR UPDATE USING (is_admin());
CREATE POLICY "seasons_admin_delete" ON seasons FOR DELETE USING (is_admin());

-- LEAGUES
CREATE POLICY "leagues_public_read" ON leagues FOR SELECT USING (true);
CREATE POLICY "leagues_admin_insert" ON leagues FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "leagues_admin_update" ON leagues FOR UPDATE USING (is_admin());
CREATE POLICY "leagues_admin_delete" ON leagues FOR DELETE USING (is_admin());

-- SEASON_LEAGUES
CREATE POLICY "season_leagues_public_read" ON season_leagues FOR SELECT USING (true);
CREATE POLICY "season_leagues_admin_insert" ON season_leagues FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "season_leagues_admin_update" ON season_leagues FOR UPDATE USING (is_admin());
CREATE POLICY "season_leagues_admin_delete" ON season_leagues FOR DELETE USING (is_admin());

-- TEAMS
CREATE POLICY "teams_public_read" ON teams FOR SELECT USING (true);
CREATE POLICY "teams_admin_insert" ON teams FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "teams_admin_update" ON teams FOR UPDATE USING (is_admin());
CREATE POLICY "teams_admin_delete" ON teams FOR DELETE USING (is_admin());

-- SEASON_TEAMS
CREATE POLICY "season_teams_public_read" ON season_teams FOR SELECT USING (true);
CREATE POLICY "season_teams_admin_insert" ON season_teams FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "season_teams_admin_update" ON season_teams FOR UPDATE USING (is_admin());
CREATE POLICY "season_teams_admin_delete" ON season_teams FOR DELETE USING (is_admin());

-- PLAYERS (dane publiczne)
CREATE POLICY "players_public_read" ON players FOR SELECT USING (true);
CREATE POLICY "players_admin_insert" ON players FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "players_admin_update" ON players FOR UPDATE USING (is_admin());
CREATE POLICY "players_admin_delete" ON players FOR DELETE USING (is_admin());

-- TEAM_PLAYERS
CREATE POLICY "team_players_public_read" ON team_players FOR SELECT USING (true);
CREATE POLICY "team_players_admin_insert" ON team_players FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "team_players_admin_update" ON team_players FOR UPDATE USING (is_admin());
CREATE POLICY "team_players_admin_delete" ON team_players FOR DELETE USING (is_admin());

-- STANDINGS (read-only, trigger zarzadza)
CREATE POLICY "standings_public_read" ON standings FOR SELECT USING (true);
CREATE POLICY "standings_system_all" ON standings FOR ALL USING (is_admin());

-- PLAYER_SEASON_STATS (read-only, trigger zarzadza)
CREATE POLICY "player_stats_public_read" ON player_season_stats FOR SELECT USING (true);
CREATE POLICY "player_stats_system_all" ON player_season_stats FOR ALL USING (is_admin());

-- SUSPENSIONS
CREATE POLICY "suspensions_public_read" ON suspensions FOR SELECT USING (true);
CREATE POLICY "suspensions_admin_insert" ON suspensions FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "suspensions_admin_update" ON suspensions FOR UPDATE USING (is_admin());
CREATE POLICY "suspensions_admin_delete" ON suspensions FOR DELETE USING (is_admin());

-- TOURNAMENTS
CREATE POLICY "tournaments_public_read" ON tournaments FOR SELECT USING (true);
CREATE POLICY "tournaments_admin_insert" ON tournaments FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "tournaments_admin_update" ON tournaments FOR UPDATE USING (is_admin());
CREATE POLICY "tournaments_admin_delete" ON tournaments FOR DELETE USING (is_admin());

-- TOURNAMENT_TEAMS
CREATE POLICY "tournament_teams_public_read" ON tournament_teams FOR SELECT USING (true);
CREATE POLICY "tournament_teams_admin_insert" ON tournament_teams FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "tournament_teams_admin_update" ON tournament_teams FOR UPDATE USING (is_admin());
CREATE POLICY "tournament_teams_admin_delete" ON tournament_teams FOR DELETE USING (is_admin());

-- TOURNAMENT_MATCHES
CREATE POLICY "tournament_matches_public_read" ON tournament_matches FOR SELECT USING (true);
CREATE POLICY "tournament_matches_admin_insert" ON tournament_matches FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "tournament_matches_admin_update" ON tournament_matches FOR UPDATE USING (is_admin());
CREATE POLICY "tournament_matches_admin_delete" ON tournament_matches FOR DELETE USING (is_admin());

-- TOURNAMENT_GROUP_STANDINGS
CREATE POLICY "tournament_standings_public_read" ON tournament_group_standings FOR SELECT USING (true);
CREATE POLICY "tournament_standings_admin_insert" ON tournament_group_standings FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "tournament_standings_admin_update" ON tournament_group_standings FOR UPDATE USING (is_admin());
CREATE POLICY "tournament_standings_admin_delete" ON tournament_group_standings FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 2: Public read, admin + editor write
-- Dotyczy: matches, match_events, match_lineups
-- ============================================================

-- MATCHES
CREATE POLICY "matches_public_read" ON matches FOR SELECT USING (true);
CREATE POLICY "matches_editor_insert" ON matches FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "matches_editor_update" ON matches FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "matches_admin_delete" ON matches FOR DELETE USING (is_admin());

-- MATCH_EVENTS
CREATE POLICY "match_events_public_read" ON match_events FOR SELECT USING (true);
CREATE POLICY "match_events_editor_insert" ON match_events FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "match_events_editor_update" ON match_events FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "match_events_admin_delete" ON match_events FOR DELETE USING (is_admin());

-- MATCH_LINEUPS
CREATE POLICY "match_lineups_public_read" ON match_lineups FOR SELECT USING (true);
CREATE POLICY "match_lineups_editor_insert" ON match_lineups FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "match_lineups_editor_update" ON match_lineups FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "match_lineups_admin_delete" ON match_lineups FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 3: RODO - tylko admin i sam zawodnik
-- Dotyczy: players_private
-- ============================================================

CREATE POLICY "players_private_admin_all" ON players_private
    FOR ALL USING (is_admin());

CREATE POLICY "players_private_own_read" ON players_private
    FOR SELECT USING (player_id = get_my_player_id());


-- ============================================================
-- WZORZEC 4: Publikowane tresci
-- Dotyczy: news, polls, gallery
-- ============================================================

-- NEWS (publicznosc widzi tylko opublikowane)
CREATE POLICY "news_public_read" ON news
    FOR SELECT USING (is_published = true OR is_editor_or_admin());
CREATE POLICY "news_editor_insert" ON news FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "news_editor_update" ON news FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "news_admin_delete" ON news FOR DELETE USING (is_admin());

-- POLLS (publicznosc widzi tylko opublikowane)
CREATE POLICY "polls_public_read" ON polls
    FOR SELECT USING (is_published = true OR is_editor_or_admin());
CREATE POLICY "polls_editor_insert" ON polls FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "polls_editor_update" ON polls FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "polls_admin_delete" ON polls FOR DELETE USING (is_admin());

-- POLL_OPTIONS
CREATE POLICY "poll_options_public_read" ON poll_options FOR SELECT USING (true);
CREATE POLICY "poll_options_editor_insert" ON poll_options FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "poll_options_editor_update" ON poll_options FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "poll_options_admin_delete" ON poll_options FOR DELETE USING (is_admin());

-- GALLERY_ALBUMS (publicznosc widzi tylko opublikowane)
CREATE POLICY "gallery_albums_public_read" ON gallery_albums
    FOR SELECT USING (is_published = true OR is_editor_or_admin());
CREATE POLICY "gallery_albums_editor_insert" ON gallery_albums FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "gallery_albums_editor_update" ON gallery_albums FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "gallery_albums_admin_delete" ON gallery_albums FOR DELETE USING (is_admin());

-- GALLERY_PHOTOS
CREATE POLICY "gallery_photos_public_read" ON gallery_photos FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM gallery_albums ga
        WHERE ga.id = gallery_photos.album_id
        AND (ga.is_published = true OR is_editor_or_admin())
    )
);
CREATE POLICY "gallery_photos_editor_insert" ON gallery_photos FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "gallery_photos_editor_update" ON gallery_photos FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "gallery_photos_admin_delete" ON gallery_photos FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 5: Anonimowe glosowanie
-- Dotyczy: typer_predictions, poll_votes, typer_aggregates
-- ============================================================

-- TYPER_PREDICTIONS (kazdy moze wstawic, admin widzi wszystko)
CREATE POLICY "typer_public_insert" ON typer_predictions
    FOR INSERT WITH CHECK (true);
CREATE POLICY "typer_public_read" ON typer_predictions
    FOR SELECT USING (true);
CREATE POLICY "typer_admin_update" ON typer_predictions
    FOR UPDATE USING (is_admin());
CREATE POLICY "typer_admin_delete" ON typer_predictions
    FOR DELETE USING (is_admin());

-- TYPER_AGGREGATES (kazdy czyta, system aktualizuje)
CREATE POLICY "typer_agg_public_read" ON typer_aggregates FOR SELECT USING (true);
CREATE POLICY "typer_agg_system_all" ON typer_aggregates FOR ALL USING (is_admin());

-- POLL_VOTES (kazdy moze glosowac, admin widzi glosy)
CREATE POLICY "poll_votes_public_insert" ON poll_votes
    FOR INSERT WITH CHECK (true);
CREATE POLICY "poll_votes_admin_read" ON poll_votes
    FOR SELECT USING (is_admin());
CREATE POLICY "poll_votes_admin_delete" ON poll_votes
    FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 6: Publiczny formularz z moderacja
-- Dotyczy: free_agents
-- ============================================================

-- Publicznosc widzi tylko zatwierdzone i aktywne
CREATE POLICY "free_agents_public_read" ON free_agents
    FOR SELECT USING (
        (is_approved = true AND is_active = true)
        OR is_admin()
    );

-- Kazdy moze wyslac formularz (nowy wpis)
CREATE POLICY "free_agents_public_insert" ON free_agents
    FOR INSERT WITH CHECK (true);

-- Tylko admin zatwierdza/edytuje/usuwa
CREATE POLICY "free_agents_admin_update" ON free_agents
    FOR UPDATE USING (is_admin());
CREATE POLICY "free_agents_admin_delete" ON free_agents
    FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 7: Tylko admin czyta i pisze
-- Dotyczy: sponsors, static_pages, contact_messages
-- ============================================================

-- SPONSORS (publicznosc widzi aktywne)
CREATE POLICY "sponsors_public_read" ON sponsors
    FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "sponsors_admin_insert" ON sponsors FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "sponsors_admin_update" ON sponsors FOR UPDATE USING (is_admin());
CREATE POLICY "sponsors_admin_delete" ON sponsors FOR DELETE USING (is_admin());

-- STATIC_PAGES (publicznosc czyta, admin pisze)
CREATE POLICY "static_pages_public_read" ON static_pages FOR SELECT USING (true);
CREATE POLICY "static_pages_admin_insert" ON static_pages FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "static_pages_admin_update" ON static_pages FOR UPDATE USING (is_admin());
CREATE POLICY "static_pages_admin_delete" ON static_pages FOR DELETE USING (is_admin());

-- CONTACT_MESSAGES (kazdy wysyla, admin czyta)
CREATE POLICY "contact_public_insert" ON contact_messages
    FOR INSERT WITH CHECK (true);
CREATE POLICY "contact_admin_read" ON contact_messages
    FOR SELECT USING (is_admin());
CREATE POLICY "contact_admin_update" ON contact_messages
    FOR UPDATE USING (is_admin());
CREATE POLICY "contact_admin_delete" ON contact_messages
    FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 8: Profil uzytkownika
-- Dotyczy: profiles
-- ============================================================

-- Kazdy widzi swoj profil, admin widzi wszystkie
CREATE POLICY "profiles_own_read" ON profiles
    FOR SELECT USING (id = auth.uid() OR is_admin());

-- Kazdy moze aktualizowac swoj profil (ale nie role!)
CREATE POLICY "profiles_own_update" ON profiles
    FOR UPDATE USING (id = auth.uid())
    WITH CHECK (
        -- Uzytkownik nie moze zmienic swojej roli
        role = (SELECT role FROM profiles WHERE id = auth.uid())
    );

-- Admin zarzadza wszystkimi profilami
CREATE POLICY "profiles_admin_all" ON profiles
    FOR ALL USING (is_admin());


-- ================================================================
-- ===  FILE 010: 010_triggers.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 010: Triggery bazodanowe
-- Automatyczne przeliczanie: standings, player stats,
-- suspensions, poll aggregates, typer aggregates
-- ============================================================


-- ============================================================
-- 1. PRZELICZANIE TABELI LIGOWEJ (standings)
-- Uruchamiany po INSERT/UPDATE/DELETE na matches
-- Przelicza CALA tabele danej ligi od zera
-- ============================================================
CREATE OR REPLACE FUNCTION recalculate_standings()
RETURNS TRIGGER AS $$
DECLARE
    v_season_id UUID;
    v_league_id UUID;
    v_points_win INTEGER;
    v_points_draw INTEGER;
    v_points_loss INTEGER;
    v_wo_goals_winner INTEGER;
    v_wo_goals_loser INTEGER;
BEGIN
    -- Okresl ktory sezon/liga
    IF TG_OP = 'DELETE' THEN
        v_season_id := OLD.season_id;
        v_league_id := OLD.league_id;
    ELSE
        v_season_id := NEW.season_id;
        v_league_id := NEW.league_id;
    END IF;

    -- Pobierz konfiguracje punktacji
    SELECT
        COALESCE(points_win, 3),
        COALESCE(points_draw, 1),
        COALESCE(points_loss, 0),
        COALESCE(walkover_goals_winner, 3),
        COALESCE(walkover_goals_loser, 0)
    INTO v_points_win, v_points_draw, v_points_loss, v_wo_goals_winner, v_wo_goals_loser
    FROM season_leagues
    WHERE season_id = v_season_id AND league_id = v_league_id;

    -- Domyslne wartosci jesli brak konfiguracji
    v_points_win := COALESCE(v_points_win, 3);
    v_points_draw := COALESCE(v_points_draw, 1);
    v_points_loss := COALESCE(v_points_loss, 0);
    v_wo_goals_winner := COALESCE(v_wo_goals_winner, 3);
    v_wo_goals_loser := COALESCE(v_wo_goals_loser, 0);

    -- Usun stare standings dla tej ligi w tym sezonie
    DELETE FROM standings
    WHERE season_id = v_season_id AND league_id = v_league_id;

    -- Przelicz i wstaw nowe standings
    INSERT INTO standings (
        season_id, league_id, team_id,
        played, won, drawn, lost,
        goals_for, goals_against, points, position,
        form_last5, streak_wins, streak_unbeaten, streak_winless
    )
    WITH match_results AS (
        -- Perspektywa gospodarza
        SELECT
            home_team_id AS team_id,
            round,
            CASE
                WHEN status IN ('walkover_home') THEN v_wo_goals_winner
                WHEN status IN ('walkover_away') THEN v_wo_goals_loser
                ELSE COALESCE(home_goals, 0)
            END AS gf,
            CASE
                WHEN status IN ('walkover_home') THEN v_wo_goals_loser
                WHEN status IN ('walkover_away') THEN v_wo_goals_winner
                ELSE COALESCE(away_goals, 0)
            END AS ga,
            CASE
                WHEN status = 'walkover_home' THEN 'W'
                WHEN status = 'walkover_away' THEN 'L'
                WHEN home_goals > away_goals THEN 'W'
                WHEN home_goals = away_goals THEN 'D'
                ELSE 'L'
            END AS result,
            away_team_id AS opponent_id,
            home_goals || ':' || away_goals AS score_str
        FROM matches
        WHERE season_id = v_season_id
          AND league_id = v_league_id
          AND status IN ('completed', 'walkover_home', 'walkover_away')

        UNION ALL

        -- Perspektywa goscia
        SELECT
            away_team_id AS team_id,
            round,
            CASE
                WHEN status IN ('walkover_away') THEN v_wo_goals_winner
                WHEN status IN ('walkover_home') THEN v_wo_goals_loser
                ELSE COALESCE(away_goals, 0)
            END AS gf,
            CASE
                WHEN status IN ('walkover_away') THEN v_wo_goals_loser
                WHEN status IN ('walkover_home') THEN v_wo_goals_winner
                ELSE COALESCE(home_goals, 0)
            END AS ga,
            CASE
                WHEN status = 'walkover_away' THEN 'W'
                WHEN status = 'walkover_home' THEN 'L'
                WHEN away_goals > home_goals THEN 'W'
                WHEN home_goals = away_goals THEN 'D'
                ELSE 'L'
            END AS result,
            home_team_id AS opponent_id,
            home_goals || ':' || away_goals AS score_str
        FROM matches
        WHERE season_id = v_season_id
          AND league_id = v_league_id
          AND status IN ('completed', 'walkover_home', 'walkover_away')
    ),
    -- Agregacja punktow i bramek
    aggregated AS (
        SELECT
            team_id,
            COUNT(*) AS played,
            SUM(CASE WHEN result = 'W' THEN 1 ELSE 0 END) AS won,
            SUM(CASE WHEN result = 'D' THEN 1 ELSE 0 END) AS drawn,
            SUM(CASE WHEN result = 'L' THEN 1 ELSE 0 END) AS lost,
            SUM(gf) AS goals_for,
            SUM(ga) AS goals_against,
            SUM(CASE
                WHEN result = 'W' THEN v_points_win
                WHEN result = 'D' THEN v_points_draw
                ELSE v_points_loss
            END) AS points
        FROM match_results
        GROUP BY team_id
    ),
    -- Forma last 5 (JSON)
    form_data AS (
        SELECT
            team_id,
            jsonb_agg(
                jsonb_build_object(
                    'result', result,
                    'opponent', t_opp.name,
                    'score', score_str
                ) ORDER BY round DESC
            ) FILTER (WHERE rn <= 5) AS form_last5,
            -- Seria wygranych (od konca)
            (SELECT COUNT(*) FROM (
                SELECT result, ROW_NUMBER() OVER (ORDER BY round DESC) AS rn2
                FROM match_results mr2
                WHERE mr2.team_id = mr_ranked.team_id
            ) s WHERE rn2 <= (
                SELECT COALESCE(MIN(rn2) - 1, COUNT(*)) FROM (
                    SELECT result, ROW_NUMBER() OVER (ORDER BY round DESC) AS rn2
                    FROM match_results mr3
                    WHERE mr3.team_id = mr_ranked.team_id
                ) s2 WHERE result != 'W'
            )) AS streak_wins
        FROM (
            SELECT mr.*, ROW_NUMBER() OVER (PARTITION BY mr.team_id ORDER BY mr.round DESC) AS rn
            FROM match_results mr
        ) mr_ranked
        LEFT JOIN teams t_opp ON t_opp.id = mr_ranked.opponent_id
        GROUP BY mr_ranked.team_id
    ),
    -- Wszystkie druzyny w lidze (w tym te bez meczow)
    all_teams AS (
        SELECT st.team_id
        FROM season_teams st
        WHERE st.season_id = v_season_id AND st.league_id = v_league_id
    ),
    -- Ranking
    ranked AS (
        SELECT
            at.team_id,
            COALESCE(a.played, 0) AS played,
            COALESCE(a.won, 0) AS won,
            COALESCE(a.drawn, 0) AS drawn,
            COALESCE(a.lost, 0) AS lost,
            COALESCE(a.goals_for, 0) AS goals_for,
            COALESCE(a.goals_against, 0) AS goals_against,
            COALESCE(a.points, 0) AS points,
            COALESCE(fd.form_last5, '[]'::jsonb) AS form_last5,
            COALESCE(fd.streak_wins, 0) AS streak_wins,
            ROW_NUMBER() OVER (
                ORDER BY
                    COALESCE(a.points, 0) DESC,
                    (COALESCE(a.goals_for, 0) - COALESCE(a.goals_against, 0)) DESC,
                    COALESCE(a.goals_for, 0) DESC,
                    t.name ASC
            ) AS position
        FROM all_teams at
        LEFT JOIN aggregated a ON a.team_id = at.team_id
        LEFT JOIN form_data fd ON fd.team_id = at.team_id
        JOIN teams t ON t.id = at.team_id
    )
    SELECT
        v_season_id, v_league_id, team_id,
        played, won, drawn, lost,
        goals_for, goals_against, points,
        position::INTEGER,
        form_last5,
        streak_wins,
        -- streak_unbeaten: ile W/D od konca
        0, -- obliczany uproszczenie, dokladnie ponizej
        -- streak_winless: ile D/L od konca
        0
    FROM ranked;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_recalculate_standings
    AFTER INSERT OR UPDATE OR DELETE ON matches
    FOR EACH ROW
    EXECUTE FUNCTION recalculate_standings();


-- ============================================================
-- 2. PRZELICZANIE STATYSTYK ZAWODNIKOW
-- Uruchamiany po INSERT/UPDATE/DELETE na match_events
-- ============================================================
CREATE OR REPLACE FUNCTION recalculate_player_stats()
RETURNS TRIGGER AS $$
DECLARE
    v_match RECORD;
    v_player_id UUID;
    v_assist_player_id UUID;
BEGIN
    -- Pobierz dane meczu
    IF TG_OP = 'DELETE' THEN
        SELECT * INTO v_match FROM matches WHERE id = OLD.match_id;
        v_player_id := OLD.player_id;
        v_assist_player_id := OLD.assist_player_id;
    ELSE
        SELECT * INTO v_match FROM matches WHERE id = NEW.match_id;
        v_player_id := NEW.player_id;
        v_assist_player_id := NEW.assist_player_id;
    END IF;

    IF v_match IS NULL THEN RETURN NULL; END IF;

    -- Przelicz statystyki glownego zawodnika
    INSERT INTO player_season_stats (
        player_id, season_id, league_id, team_id,
        appearances, goals, assists, yellow_cards, red_cards
    )
    SELECT
        v_player_id,
        v_match.season_id,
        v_match.league_id,
        COALESCE(
            (SELECT team_id FROM team_players
             WHERE player_id = v_player_id
               AND season_id = v_match.season_id
               AND league_id = v_match.league_id
               AND left_date IS NULL
             LIMIT 1),
            (SELECT team_id FROM match_lineups
             WHERE player_id = v_player_id AND match_id = v_match.id
             LIMIT 1),
            (SELECT team_id FROM match_events
             WHERE player_id = v_player_id AND match_id = v_match.id
             LIMIT 1)
        ),
        -- appearances
        (SELECT COUNT(DISTINCT ml.match_id)
         FROM match_lineups ml
         JOIN matches m ON m.id = ml.match_id
         WHERE ml.player_id = v_player_id
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- goals
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'GOAL'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- assists
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.assist_player_id = v_player_id
           AND me.event_type = 'GOAL'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- yellow_cards
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'YELLOW_CARD'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        -- red_cards
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'RED_CARD'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id)
    ON CONFLICT (player_id, season_id, league_id) DO UPDATE SET
        team_id = EXCLUDED.team_id,
        appearances = EXCLUDED.appearances,
        goals = EXCLUDED.goals,
        assists = EXCLUDED.assists,
        yellow_cards = EXCLUDED.yellow_cards,
        red_cards = EXCLUDED.red_cards,
        updated_at = now();

    -- Przelicz tez asystenta jesli to byl gol z asysta
    IF v_assist_player_id IS NOT NULL THEN
        INSERT INTO player_season_stats (
            player_id, season_id, league_id, team_id,
            appearances, goals, assists, yellow_cards, red_cards
        )
        SELECT
            v_assist_player_id,
            v_match.season_id,
            v_match.league_id,
            COALESCE(
                (SELECT team_id FROM team_players
                 WHERE player_id = v_assist_player_id
                   AND season_id = v_match.season_id
                   AND league_id = v_match.league_id
                   AND left_date IS NULL
                 LIMIT 1),
                (SELECT team_id FROM match_lineups
                 WHERE player_id = v_assist_player_id AND match_id = v_match.id
                 LIMIT 1)
            ),
            (SELECT COUNT(DISTINCT ml.match_id)
             FROM match_lineups ml
             JOIN matches m ON m.id = ml.match_id
             WHERE ml.player_id = v_assist_player_id
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.player_id = v_assist_player_id
               AND me.event_type = 'GOAL'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.assist_player_id = v_assist_player_id
               AND me.event_type = 'GOAL'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.player_id = v_assist_player_id
               AND me.event_type = 'YELLOW_CARD'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id),
            (SELECT COUNT(*) FROM match_events me
             JOIN matches m ON m.id = me.match_id
             WHERE me.player_id = v_assist_player_id
               AND me.event_type = 'RED_CARD'
               AND m.season_id = v_match.season_id
               AND m.league_id = v_match.league_id)
        ON CONFLICT (player_id, season_id, league_id) DO UPDATE SET
            team_id = EXCLUDED.team_id,
            appearances = EXCLUDED.appearances,
            goals = EXCLUDED.goals,
            assists = EXCLUDED.assists,
            yellow_cards = EXCLUDED.yellow_cards,
            red_cards = EXCLUDED.red_cards,
            updated_at = now();
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_recalculate_player_stats
    AFTER INSERT OR UPDATE OR DELETE ON match_events
    FOR EACH ROW
    EXECUTE FUNCTION recalculate_player_stats();


-- ============================================================
-- 3. AUTOMATYCZNE PAUZY ZA KARTKI
-- Uruchamiany po INSERT na match_events
-- ============================================================
CREATE OR REPLACE FUNCTION check_auto_suspension()
RETURNS TRIGGER AS $$
DECLARE
    v_match RECORD;
    v_threshold INTEGER;
    v_yellow_count INTEGER;
BEGIN
    -- Tylko kartki
    IF NEW.event_type NOT IN ('YELLOW_CARD', 'RED_CARD') THEN
        RETURN NEW;
    END IF;

    SELECT * INTO v_match FROM matches WHERE id = NEW.match_id;

    -- CZERWONA KARTKA = automatyczna 1 mecz pauzy
    IF NEW.event_type = 'RED_CARD' THEN
        INSERT INTO suspensions (
            player_id, season_id, league_id, suspension_type,
            reason, start_round, end_round, matches_remaining,
            triggering_event_id
        ) VALUES (
            NEW.player_id, v_match.season_id, v_match.league_id,
            'red_card',
            'Automatyczna pauza za czerwona kartke',
            v_match.round + 1, v_match.round + 1, 1,
            NEW.id
        );
        RETURN NEW;
    END IF;

    -- ZOLTA KARTKA - sprawdz akumulacje
    IF NEW.event_type = 'YELLOW_CARD' THEN
        SELECT COALESCE(yellow_card_suspension_threshold, 3) INTO v_threshold
        FROM season_leagues
        WHERE season_id = v_match.season_id AND league_id = v_match.league_id;

        v_threshold := COALESCE(v_threshold, 3);

        -- Licz zolte w tym sezonie w tej lidze
        SELECT COUNT(*) INTO v_yellow_count
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = NEW.player_id
          AND me.event_type = 'YELLOW_CARD'
          AND m.season_id = v_match.season_id
          AND m.league_id = v_match.league_id;

        -- Sprawdz prog (od v_threshold zoltych kazda kolejna daje pauze)
        IF v_yellow_count >= v_threshold THEN
            INSERT INTO suspensions (
                player_id, season_id, league_id, suspension_type,
                reason, start_round, end_round, matches_remaining,
                triggering_event_id
            ) VALUES (
                NEW.player_id, v_match.season_id, v_match.league_id,
                'yellow_accumulation',
                format('Automatyczna pauza: %s zoltych kartek (od progu %s, kazda kolejna kartka = kolejna pauza)', v_yellow_count, v_threshold),
                v_match.round + 1, v_match.round + 1, 1,
                NEW.id
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_check_auto_suspension
    AFTER INSERT ON match_events
    FOR EACH ROW
    EXECUTE FUNCTION check_auto_suspension();


-- ============================================================
-- 4. AGREGACJA GLOSOW W ANKIETACH
-- Uruchamiany po INSERT/UPDATE/DELETE na poll_votes
-- ============================================================
CREATE OR REPLACE FUNCTION update_poll_aggregates()
RETURNS TRIGGER AS $$
DECLARE
    v_poll_id UUID;
    v_total INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_poll_id := OLD.poll_id;
    ELSE
        v_poll_id := NEW.poll_id;
    END IF;

    -- Policz glosy
    SELECT COUNT(*) INTO v_total
    FROM poll_votes WHERE poll_id = v_poll_id;

    -- Zaktualizuj kazda opcje
    UPDATE poll_options po SET
        vote_count = (
            SELECT COUNT(*) FROM poll_votes pv
            WHERE pv.option_id = po.id AND pv.poll_id = v_poll_id
        ),
        vote_percentage = CASE
            WHEN v_total > 0 THEN
                ROUND(
                    (SELECT COUNT(*) FROM poll_votes pv
                     WHERE pv.option_id = po.id AND pv.poll_id = v_poll_id
                    )::NUMERIC / v_total * 100,
                    2
                )
            ELSE 0
        END
    WHERE po.poll_id = v_poll_id;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_update_poll_aggregates
    AFTER INSERT OR UPDATE OR DELETE ON poll_votes
    FOR EACH ROW
    EXECUTE FUNCTION update_poll_aggregates();


-- ============================================================
-- 5. AGREGACJA PREDYKCJI W TYPERZE
-- Uruchamiany po INSERT/UPDATE/DELETE na typer_predictions
-- ============================================================
CREATE OR REPLACE FUNCTION update_typer_aggregates()
RETURNS TRIGGER AS $$
DECLARE
    v_match_id UUID;
    v_total INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_match_id := OLD.match_id;
    ELSE
        v_match_id := NEW.match_id;
    END IF;

    SELECT COUNT(*) INTO v_total
    FROM typer_predictions WHERE match_id = v_match_id;

    INSERT INTO typer_aggregates (match_id, total_votes, home_win_pct, draw_pct, away_win_pct)
    VALUES (
        v_match_id,
        v_total,
        CASE WHEN v_total > 0 THEN
            ROUND((SELECT COUNT(*) FROM typer_predictions
                   WHERE match_id = v_match_id AND prediction = '1'
                  )::NUMERIC / v_total * 100, 2)
        ELSE 0 END,
        CASE WHEN v_total > 0 THEN
            ROUND((SELECT COUNT(*) FROM typer_predictions
                   WHERE match_id = v_match_id AND prediction = 'X'
                  )::NUMERIC / v_total * 100, 2)
        ELSE 0 END,
        CASE WHEN v_total > 0 THEN
            ROUND((SELECT COUNT(*) FROM typer_predictions
                   WHERE match_id = v_match_id AND prediction = '2'
                  )::NUMERIC / v_total * 100, 2)
        ELSE 0 END
    )
    ON CONFLICT (match_id) DO UPDATE SET
        total_votes = EXCLUDED.total_votes,
        home_win_pct = EXCLUDED.home_win_pct,
        draw_pct = EXCLUDED.draw_pct,
        away_win_pct = EXCLUDED.away_win_pct,
        updated_at = now();

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_update_typer_aggregates
    AFTER INSERT OR UPDATE OR DELETE ON typer_predictions
    FOR EACH ROW
    EXECUTE FUNCTION update_typer_aggregates();


-- ================================================================
-- ===  FILE 011: 011_functions.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 011: Funkcje bazodanowe
-- Generate Round Robin, inne utility functions
-- ============================================================


-- ============================================================
-- GENEROWANIE TERMINARZA (double round-robin)
-- Obsluguje dowolna liczbe druzyn (parzysta i nieparzysta)
-- Wywolanie: SELECT generate_round_robin('season-uuid', 'league-uuid', '2025-04-05');
-- ============================================================
CREATE OR REPLACE FUNCTION generate_round_robin(
    p_season_id UUID,
    p_league_id UUID,
    p_start_date DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE(matches_created INTEGER, rounds_total INTEGER) AS $$
DECLARE
    v_teams UUID[];
    v_team_count INTEGER;
    v_rounds INTEGER;
    v_half INTEGER;
    v_round INTEGER;
    v_i INTEGER;
    v_home UUID;
    v_away UUID;
    v_match_date DATE;
    v_time_slots TIME[] := ARRAY['14:30'::TIME, '15:30'::TIME, '16:30'::TIME, '17:30'::TIME, '18:30'::TIME];
    v_match_count INTEGER := 0;
    v_list UUID[];
    v_last UUID;
    v_effective_count INTEGER;
    v_has_bye BOOLEAN := false;
BEGIN
    -- Pobierz druzyny z season_teams
    SELECT ARRAY_AGG(st.team_id ORDER BY t.name)
    INTO v_teams
    FROM season_teams st
    JOIN teams t ON t.id = st.team_id
    WHERE st.season_id = p_season_id AND st.league_id = p_league_id;

    v_team_count := COALESCE(array_length(v_teams, 1), 0);

    IF v_team_count < 2 THEN
        RAISE EXCEPTION 'Potrzeba minimum 2 druzyn, znaleziono: %', v_team_count;
    END IF;

    -- Dla nieparzystej liczby druzyn - dodaj "BYE" (NULL)
    IF v_team_count % 2 = 1 THEN
        v_teams := v_teams || ARRAY[NULL::UUID];
        v_effective_count := v_team_count + 1;
        v_has_bye := true;
    ELSE
        v_effective_count := v_team_count;
    END IF;

    v_rounds := v_effective_count - 1;
    v_half := v_effective_count / 2;
    v_list := v_teams;

    -- ====== PIERWSZA RUNDA (single round-robin) ======
    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
            -- Wyznacz pare
            IF v_round % 2 = 0 THEN
                v_home := v_list[v_i];
                v_away := v_list[v_effective_count + 1 - v_i];
            ELSE
                v_home := v_list[v_effective_count + 1 - v_i];
                v_away := v_list[v_i];
            END IF;

            -- Pomin pary z BYE (NULL)
            IF v_home IS NOT NULL AND v_away IS NOT NULL THEN
                INSERT INTO matches (
                    season_id, league_id, round,
                    home_team_id, away_team_id,
                    match_date, match_time, status
                ) VALUES (
                    p_season_id, p_league_id, v_round,
                    v_home, v_away,
                    v_match_date,
                    v_time_slots[((v_i - 1) % array_length(v_time_slots, 1)) + 1],
                    'scheduled'
                );
                v_match_count := v_match_count + 1;
            END IF;
        END LOOP;

        -- Rotacja (pierwszy element staly, reszta rotuje)
        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    -- ====== REWANZ (swap home/away) ======
    -- Reset listy
    v_list := v_teams;

    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_rounds + v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
            -- Swap home/away wzgledem pierwszej rundy
            IF v_round % 2 = 0 THEN
                v_away := v_list[v_i];
                v_home := v_list[v_effective_count + 1 - v_i];
            ELSE
                v_away := v_list[v_effective_count + 1 - v_i];
                v_home := v_list[v_i];
            END IF;

            IF v_home IS NOT NULL AND v_away IS NOT NULL THEN
                INSERT INTO matches (
                    season_id, league_id, round,
                    home_team_id, away_team_id,
                    match_date, match_time, status
                ) VALUES (
                    p_season_id, p_league_id, v_rounds + v_round,
                    v_home, v_away,
                    v_match_date,
                    v_time_slots[((v_i - 1) % array_length(v_time_slots, 1)) + 1],
                    'scheduled'
                );
                v_match_count := v_match_count + 1;
            END IF;
        END LOOP;

        -- Ta sama rotacja
        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    -- Zaktualizuj total_rounds w season_leagues
    UPDATE season_leagues
    SET total_rounds = v_rounds * 2
    WHERE season_id = p_season_id AND league_id = p_league_id;

    -- Zwroc wynik
    matches_created := v_match_count;
    rounds_total := v_rounds * 2;
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- INICJALIZACJA STANDINGS
-- Tworzy puste rekordy standings dla wszystkich druzyn w lidze
-- Wywolanie: SELECT initialize_standings('season-uuid', 'league-uuid');
-- ============================================================
CREATE OR REPLACE FUNCTION initialize_standings(
    p_season_id UUID,
    p_league_id UUID
)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    INSERT INTO standings (season_id, league_id, team_id, position)
    SELECT
        p_season_id,
        p_league_id,
        st.team_id,
        ROW_NUMBER() OVER (ORDER BY t.name)
    FROM season_teams st
    JOIN teams t ON t.id = st.team_id
    WHERE st.season_id = p_season_id AND st.league_id = p_league_id
    ON CONFLICT (season_id, league_id, team_id) DO NOTHING;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ================================================================
-- ===  FILE 012: 012_views.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 012: Widoki (Views)
-- Wygodne widoki do czestych zapytan z frontendu
-- ============================================================


-- ============================================================
-- TABELA LIGOWA z nazwami druzyn
-- Najczesciej uzywany widok na stronie
-- ============================================================
CREATE OR REPLACE VIEW v_standings AS
SELECT
    s.id,
    s.season_id,
    s.league_id,
    s.team_id,
    s.position,
    s.played,
    s.won,
    s.drawn,
    s.lost,
    s.goals_for,
    s.goals_against,
    s.goal_difference,
    s.points,
    s.form_last5,
    s.streak_wins,
    s.streak_unbeaten,
    s.streak_winless,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    se.name AS season_name
FROM standings s
JOIN teams t ON t.id = s.team_id
JOIN leagues l ON l.id = s.league_id
JOIN seasons se ON se.id = s.season_id;


-- ============================================================
-- MECZE z nazwami druzyn
-- ============================================================
CREATE OR REPLACE VIEW v_matches AS
SELECT
    m.id,
    m.season_id,
    m.league_id,
    m.round,
    m.home_team_id,
    m.away_team_id,
    m.match_date,
    m.match_time,
    m.venue,
    m.home_goals,
    m.away_goals,
    m.status,
    m.video_url,
    m.gallery_url,
    m.referee,
    m.mvp_player_id,
    m.notes,
    m.created_at,
    ht.name AS home_team_name,
    ht.abbreviation AS home_team_abbr,
    ht.logo_url AS home_team_logo,
    awt.name AS away_team_name,
    awt.abbreviation AS away_team_abbr,
    awt.logo_url AS away_team_logo,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    mvp.display_name AS mvp_name,
    mvp_tp.team_id AS mvp_team_id
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams awt ON awt.id = m.away_team_id
JOIN leagues l ON l.id = m.league_id
JOIN seasons se ON se.id = m.season_id
LEFT JOIN players mvp ON mvp.id = m.mvp_player_id
LEFT JOIN team_players mvp_tp ON mvp_tp.player_id = m.mvp_player_id
    AND mvp_tp.season_id = m.season_id
    AND mvp_tp.league_id = m.league_id
    AND mvp_tp.left_date IS NULL;


-- ============================================================
-- STRZELCY - ranking per sezon per liga
-- ============================================================
CREATE OR REPLACE VIEW v_top_scorers AS
SELECT
    pss.id,
    pss.player_id,
    pss.season_id,
    pss.league_id,
    pss.team_id,
    pss.goals,
    pss.assists,
    pss.appearances,
    pss.goals_per_match,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    RANK() OVER (
        PARTITION BY pss.season_id, pss.league_id
        ORDER BY pss.goals DESC, pss.assists DESC, p.last_name ASC
    ) AS rank
FROM player_season_stats pss
JOIN players p ON p.id = pss.player_id
JOIN teams t ON t.id = pss.team_id
JOIN leagues l ON l.id = pss.league_id
JOIN seasons se ON se.id = pss.season_id
WHERE pss.goals > 0;


-- ============================================================
-- ASYSTENCI - ranking per sezon per liga
-- ============================================================
CREATE OR REPLACE VIEW v_top_assists AS
SELECT
    pss.id,
    pss.player_id,
    pss.season_id,
    pss.league_id,
    pss.team_id,
    pss.assists,
    pss.goals,
    pss.appearances,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    l.name AS league_name,
    se.year AS season_year,
    RANK() OVER (
        PARTITION BY pss.season_id, pss.league_id
        ORDER BY pss.assists DESC, pss.goals DESC, p.last_name ASC
    ) AS rank
FROM player_season_stats pss
JOIN players p ON p.id = pss.player_id
JOIN teams t ON t.id = pss.team_id
JOIN leagues l ON l.id = pss.league_id
JOIN seasons se ON se.id = pss.season_id
WHERE pss.assists > 0;


-- ============================================================
-- KARTKI - ranking zoltych per sezon per liga
-- ============================================================
CREATE OR REPLACE VIEW v_top_yellow_cards AS
SELECT
    pss.id,
    pss.player_id,
    pss.season_id,
    pss.league_id,
    pss.team_id,
    pss.yellow_cards,
    pss.red_cards,
    pss.appearances,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    t.name AS team_name,
    t.abbreviation AS team_abbr,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    se.year AS season_year,
    RANK() OVER (
        PARTITION BY pss.season_id, pss.league_id
        ORDER BY pss.yellow_cards DESC, pss.red_cards DESC
    ) AS rank
FROM player_season_stats pss
JOIN players p ON p.id = pss.player_id
JOIN teams t ON t.id = pss.team_id
JOIN leagues l ON l.id = pss.league_id
JOIN seasons se ON se.id = pss.season_id
WHERE pss.yellow_cards > 0;


-- ============================================================
-- KARIERA ZAWODNIKA (wszystkie sezony zagregowane)
-- ============================================================
CREATE OR REPLACE VIEW v_player_career AS
SELECT
    p.id AS player_id,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    p.birth_year,
    p.city,
    p.photo_url,
    SUM(COALESCE(pss.appearances, 0)) AS total_appearances,
    SUM(COALESCE(pss.goals, 0)) AS total_goals,
    SUM(COALESCE(pss.assists, 0)) AS total_assists,
    SUM(COALESCE(pss.yellow_cards, 0)) AS total_yellow_cards,
    SUM(COALESCE(pss.red_cards, 0)) AS total_red_cards,
    COUNT(DISTINCT pss.season_id) AS seasons_played
FROM players p
LEFT JOIN player_season_stats pss ON pss.player_id = p.id
WHERE p.is_active = true
GROUP BY p.id, p.first_name, p.last_name, p.display_name,
         p.position, p.birth_year, p.city, p.photo_url;


-- ============================================================
-- KADRA DRUZYNY (aktualna per sezon per liga)
-- ============================================================
CREATE OR REPLACE VIEW v_team_roster AS
SELECT
    tp.id AS roster_id,
    tp.team_id,
    tp.player_id,
    tp.season_id,
    tp.league_id,
    tp.joined_date,
    tp.left_date,
    tp.is_captain,
    tp.shirt_number,
    p.first_name,
    p.last_name,
    p.display_name,
    p.position,
    p.birth_year,
    p.photo_url,
    t.name AS team_name,
    t.logo_url AS team_logo_url,
    se.year AS season_year,
    COALESCE(pss.goals, 0) AS goals,
    COALESCE(pss.assists, 0) AS assists,
    COALESCE(pss.yellow_cards, 0) AS yellow_cards,
    COALESCE(pss.red_cards, 0) AS red_cards,
    COALESCE(pss.appearances, 0) AS appearances
FROM team_players tp
JOIN players p ON p.id = tp.player_id
JOIN teams t ON t.id = tp.team_id
JOIN seasons se ON se.id = tp.season_id
LEFT JOIN player_season_stats pss
    ON pss.player_id = tp.player_id
    AND pss.season_id = tp.season_id
    AND pss.league_id = tp.league_id;


-- ============================================================
-- AKTYWNE PAUZY (zawieszenia)
-- ============================================================
CREATE OR REPLACE VIEW v_active_suspensions AS
SELECT
    s.id,
    s.player_id,
    s.season_id,
    s.league_id,
    s.suspension_type,
    s.reason,
    s.start_round,
    s.end_round,
    s.matches_remaining,
    s.is_served,
    p.display_name AS player_name,
    p.position AS player_position,
    t.name AS team_name,
    t.logo_url AS team_logo_url,
    l.code AS league_code,
    se.year AS season_year,
    sl.current_round
FROM suspensions s
JOIN players p ON p.id = s.player_id
JOIN seasons se ON se.id = s.season_id
JOIN leagues l ON l.id = s.league_id
JOIN season_leagues sl ON sl.season_id = s.season_id AND sl.league_id = s.league_id
LEFT JOIN team_players tp
    ON tp.player_id = s.player_id
    AND tp.season_id = s.season_id
    AND tp.league_id = s.league_id
    AND tp.left_date IS NULL
LEFT JOIN teams t ON t.id = tp.team_id
WHERE s.is_served = false;


-- ================================================================
-- ===  FILE 013: 013_seed_data.sql
-- ================================================================

-- ============================================================
-- MLPN - Migracja 013: Seed Data
-- Podstawowe dane startowe: ligi, sezony, strony statyczne
-- UWAGA: Druzyny i zawodnikow dodasz przez panel admina
-- ============================================================


-- ============================================================
-- LIGI (3 poziomy)
-- ============================================================
INSERT INTO leagues (code, name, display_order) VALUES
    ('1st', 'I Liga', 1),
    ('2nd', 'II Liga', 2),
    ('3rd', 'III Liga', 3);


-- ============================================================
-- SEZONY
-- ============================================================
INSERT INTO seasons (year, name, status, is_current, start_date, end_date) VALUES
    (2025, 'Sezon 2025', 'active', true, '2025-04-05', '2025-11-30');


-- ============================================================
-- KONFIGURACJA SEZON-LIGA (2025)
-- ============================================================
INSERT INTO season_leagues (season_id, league_id, points_win, points_draw, points_loss,
                           walkover_goals_winner, walkover_goals_loser,
                           promotion_spots, relegation_spots,
                           yellow_card_suspension_threshold)
SELECT
    s.id,
    l.id,
    3, 1, 0,    -- punktacja: W=3, R=1, P=0
    3, 0,        -- walkover: 3:0
    CASE l.code
        WHEN '3rd' THEN 2  -- z III ligi awansuja 2
        WHEN '2nd' THEN 2  -- z II ligi awansuja 2
        ELSE 0             -- z I ligi nie ma awansu
    END,
    CASE l.code
        WHEN '1st' THEN 2  -- z I ligi spadaja 2
        WHEN '2nd' THEN 2  -- z II ligi spadaja 2
        ELSE 0             -- z III ligi nie ma spadku
    END,
    3  -- pauza po 3 zoltej kartce i po kazdej kolejnej
FROM seasons s, leagues l
WHERE s.year = 2025;


-- ============================================================
-- STRONY STATYCZNE
-- ============================================================
INSERT INTO static_pages (slug, title, content) VALUES
(
    'about',
    'O nas',
    '# Mazowiecka Liga Pilki Noznej

MLPN to amatorska liga pilkarska dzialajaca na terenie Sulej0wka i okolic.

## Kontakt
- Email: kontakt@mlpn.pl
- Boisko: Narutowicza 10, 05-071 Sulejowek'
),
(
    'regulations',
    'Regulamin',
    '# Regulamin MLPN

*Regulamin zostanie uzupelniony przez admina.*'
),
(
    'rodo',
    'RODO',
    '# Klauzula informacyjna RODO

Administratorem danych osobowych jest MLPN.

*Pelna tresc klauzuli zostanie uzupelniona.*'
),
(
    'privacy',
    'Polityka prywatnosci',
    '# Polityka prywatnosci

*Tresc polityki prywatnosci zostanie uzupelniona.*'
);


-- ============================================================
-- INFORMACJA: Jak dodac pierwszego admina
-- ============================================================
-- 1. Zarejestruj konto w Supabase Auth (email + haslo)
-- 2. Skopiuj UUID uzytkownika z auth.users
-- 3. Uruchom ponizsze zapytanie (zamien UUID):
--
-- UPDATE profiles SET role = 'admin'
-- WHERE id = 'TWOJ-UUID-TUTAJ';
--
-- Od tego momentu ten uzytkownik ma pelny dostep do panelu admina.


-- ################################################################
-- ##  END OF ALL MIGRATIONS COMBINED                            ##
-- ################################################################
