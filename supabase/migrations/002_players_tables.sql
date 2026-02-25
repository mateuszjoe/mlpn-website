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
