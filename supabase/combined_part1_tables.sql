-- ============================================================
-- MLPN - CZĘŚĆ 1 z 3: Wszystkie tabele
-- Skopiuj CAŁY ten plik i wklej do SQL Editor w Supabase
-- ============================================================


-- ============================================================
-- TABELE CORE: Sezony, Ligi, Drużyny
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
    points_win          INTEGER NOT NULL DEFAULT 3,
    points_draw         INTEGER NOT NULL DEFAULT 1,
    points_loss         INTEGER NOT NULL DEFAULT 0,
    walkover_points_winner  INTEGER NOT NULL DEFAULT 3,
    walkover_goals_winner   INTEGER NOT NULL DEFAULT 3,
    walkover_goals_loser    INTEGER NOT NULL DEFAULT 0,
    promotion_spots     INTEGER NOT NULL DEFAULT 0,
    relegation_spots    INTEGER NOT NULL DEFAULT 0,
    total_rounds        INTEGER,
    played_rounds       INTEGER NOT NULL DEFAULT 0,
    current_round       INTEGER NOT NULL DEFAULT 1,
    yellow_card_suspension_threshold INTEGER NOT NULL DEFAULT 2,
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
    joined_round    INTEGER NOT NULL DEFAULT 1,
    left_round      INTEGER,
    join_reason     TEXT NOT NULL DEFAULT 'original'
                    CHECK (join_reason IN ('original', 'mid_season_join', 'promoted', 'relegated')),
    final_position  INTEGER,
    promoted        BOOLEAN NOT NULL DEFAULT false,
    relegated       BOOLEAN NOT NULL DEFAULT false,
    champion        BOOLEAN NOT NULL DEFAULT false,
    UNIQUE (season_id, team_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_season_teams_season ON season_teams (season_id);
CREATE INDEX idx_season_teams_league ON season_teams (season_id, league_id);
CREATE INDEX idx_season_teams_team ON season_teams (team_id);


-- ============================================================
-- TABELE ZAWODNIKÓW
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
    UNIQUE (player_id, season_id, league_id, team_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_team_players_team ON team_players (team_id, season_id);
CREATE INDEX idx_team_players_player ON team_players (player_id, season_id);
CREATE INDEX idx_team_players_active ON team_players (team_id, season_id)
    WHERE left_date IS NULL;
CREATE INDEX idx_team_players_league ON team_players (season_id, league_id);


-- ============================================================
-- TABELE MECZÓW
-- ============================================================

-- MATCHES
CREATE TABLE matches (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    season_id       UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    league_id       UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    round           INTEGER NOT NULL,
    home_team_id    UUID NOT NULL REFERENCES teams(id),
    away_team_id    UUID NOT NULL REFERENCES teams(id),
    match_date      DATE,
    match_time      TIME,
    venue           TEXT DEFAULT 'Narutowicza 10, 05-071 Sulejówek',
    home_goals      INTEGER,
    away_goals      INTEGER,
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
    video_url       TEXT,
    gallery_url     TEXT,
    referee         TEXT,
    mvp_player_id   UUID REFERENCES players(id),
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
    assist_player_id    UUID REFERENCES players(id),
    is_penalty          BOOLEAN NOT NULL DEFAULT false,
    is_own_goal         BOOLEAN NOT NULL DEFAULT false,
    minute              INTEGER CHECK (minute >= 0 AND minute <= 120),
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


-- ============================================================
-- TABELE STATYSTYK
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
    start_round         INTEGER NOT NULL,
    end_round           INTEGER NOT NULL,
    matches_remaining   INTEGER NOT NULL DEFAULT 1,
    triggering_event_id UUID REFERENCES match_events(id),
    is_served           BOOLEAN NOT NULL DEFAULT false,
    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_suspensions_player ON suspensions (player_id, season_id);
CREATE INDEX idx_suspensions_active ON suspensions (season_id, league_id, is_served) WHERE is_served = false;
CREATE INDEX idx_suspensions_round ON suspensions (season_id, league_id, start_round, end_round);


-- ============================================================
-- TABELE TYPER & ANKIETY
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
    UNIQUE (poll_id, voter_id),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_poll_votes_poll ON poll_votes (poll_id);
CREATE INDEX idx_poll_votes_option ON poll_votes (option_id);


-- ============================================================
-- TABELE TREŚCI (news, wolni zawodnicy, sponsorzy, galeria, kontakt)
-- ============================================================

-- NEWS (aktualnosci)
CREATE TABLE news (
    id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category            TEXT NOT NULL CHECK (category IN ('pauza', 'komunikat', 'wazne')),
    title               TEXT NOT NULL,
    body                TEXT,
    suspended_players   JSONB,
    related_match_id    UUID REFERENCES matches(id) ON DELETE SET NULL,
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
    phone           TEXT,
    email           TEXT,
    instagram       TEXT,
    facebook        TEXT,
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


-- ============================================================
-- TABELE TURNIEJÓW
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


-- ============================================================
-- KONIEC CZĘŚCI 1 - Wszystkie tabele utworzone!
-- Teraz wklej Część 2 (auth, zabezpieczenia, triggery)
-- ============================================================
