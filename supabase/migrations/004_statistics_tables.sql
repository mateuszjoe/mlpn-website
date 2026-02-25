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
