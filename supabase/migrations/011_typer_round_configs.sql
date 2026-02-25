-- ============================================================
-- MLPN - Migracja 011: Konfiguracja Typera na kolejkę
-- Pozwala adminowi ręcznie wybrać mecze do typera dla sezonu/kolejki
-- ============================================================

CREATE TABLE IF NOT EXISTS typer_round_configs (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    season_id       UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    round           INTEGER NOT NULL CHECK (round > 0),
    title           TEXT,
    description     TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE (season_id, round)
);

CREATE INDEX IF NOT EXISTS idx_typer_round_configs_active
    ON typer_round_configs (season_id, round, is_active);

CREATE TABLE IF NOT EXISTS typer_round_config_matches (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    config_id       UUID NOT NULL REFERENCES typer_round_configs(id) ON DELETE CASCADE,
    match_id        UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    display_order   INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE (config_id, match_id)
);

CREATE INDEX IF NOT EXISTS idx_typer_round_cfg_matches_cfg
    ON typer_round_config_matches (config_id, display_order);

CREATE INDEX IF NOT EXISTS idx_typer_round_cfg_matches_match
    ON typer_round_config_matches (match_id);

ALTER TABLE typer_round_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE typer_round_config_matches ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "typer_round_configs_public_read" ON typer_round_configs;
CREATE POLICY "typer_round_configs_public_read" ON typer_round_configs
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "typer_round_configs_editor_insert" ON typer_round_configs;
CREATE POLICY "typer_round_configs_editor_insert" ON typer_round_configs
    FOR INSERT WITH CHECK (is_editor_or_admin());

DROP POLICY IF EXISTS "typer_round_configs_editor_update" ON typer_round_configs;
CREATE POLICY "typer_round_configs_editor_update" ON typer_round_configs
    FOR UPDATE USING (is_editor_or_admin());

DROP POLICY IF EXISTS "typer_round_configs_editor_delete" ON typer_round_configs;
CREATE POLICY "typer_round_configs_editor_delete" ON typer_round_configs
    FOR DELETE USING (is_editor_or_admin());

DROP POLICY IF EXISTS "typer_round_cfg_matches_public_read" ON typer_round_config_matches;
CREATE POLICY "typer_round_cfg_matches_public_read" ON typer_round_config_matches
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "typer_round_cfg_matches_editor_insert" ON typer_round_config_matches;
CREATE POLICY "typer_round_cfg_matches_editor_insert" ON typer_round_config_matches
    FOR INSERT WITH CHECK (is_editor_or_admin());

DROP POLICY IF EXISTS "typer_round_cfg_matches_editor_update" ON typer_round_config_matches;
CREATE POLICY "typer_round_cfg_matches_editor_update" ON typer_round_config_matches
    FOR UPDATE USING (is_editor_or_admin());

DROP POLICY IF EXISTS "typer_round_cfg_matches_editor_delete" ON typer_round_config_matches;
CREATE POLICY "typer_round_cfg_matches_editor_delete" ON typer_round_config_matches
    FOR DELETE USING (is_editor_or_admin());

