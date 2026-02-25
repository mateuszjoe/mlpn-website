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
