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
