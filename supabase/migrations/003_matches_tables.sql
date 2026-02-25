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
