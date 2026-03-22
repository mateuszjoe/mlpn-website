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
