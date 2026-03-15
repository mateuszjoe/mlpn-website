-- ============================================================
-- MLPN - Migracja 015: Sedziowie
-- Konfigurowalna lista sedziow + powiazanie z meczami
-- ============================================================

CREATE TABLE IF NOT EXISTS referees (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    full_name       TEXT NOT NULL UNIQUE,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_referees_active_name ON referees (is_active, full_name);

ALTER TABLE matches
    ADD COLUMN IF NOT EXISTS referee_id UUID REFERENCES referees(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_matches_referee_id ON matches (referee_id) WHERE referee_id IS NOT NULL;

INSERT INTO referees (full_name)
VALUES
    ('Krzosztof Łaniewski'),
    ('Piotr Śliwa'),
    ('Grzegorz Szynkowski'),
    ('Wojciech Żuk'),
    ('Łukasz Świstak'),
    ('Adam Wosiek'),
    ('Norbert Skórski')
ON CONFLICT (full_name) DO NOTHING;

INSERT INTO referees (full_name)
SELECT DISTINCT btrim(referee)
FROM matches
WHERE referee IS NOT NULL
  AND btrim(referee) <> ''
ON CONFLICT (full_name) DO NOTHING;

UPDATE matches AS m
SET referee_id = r.id
FROM referees AS r
WHERE m.referee_id IS NULL
  AND m.referee IS NOT NULL
  AND btrim(m.referee) <> ''
  AND r.full_name = btrim(m.referee);

ALTER TABLE referees ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "referees_public_read" ON referees;
CREATE POLICY "referees_public_read" ON referees
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "referees_editor_insert" ON referees;
CREATE POLICY "referees_editor_insert" ON referees
    FOR INSERT WITH CHECK (is_editor_or_admin());

DROP POLICY IF EXISTS "referees_editor_update" ON referees;
CREATE POLICY "referees_editor_update" ON referees
    FOR UPDATE USING (is_editor_or_admin());

DROP POLICY IF EXISTS "referees_editor_delete" ON referees;
CREATE POLICY "referees_editor_delete" ON referees
    FOR DELETE USING (is_editor_or_admin());

CREATE OR REPLACE FUNCTION set_referees_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_referees_updated_at ON referees;
CREATE TRIGGER trg_referees_updated_at
    BEFORE UPDATE ON referees
    FOR EACH ROW
    EXECUTE FUNCTION set_referees_updated_at();

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
    COALESCE(r.full_name, m.referee) AS referee,
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
    mvp_tp.team_id AS mvp_team_id,
    m.referee_id AS referee_id
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams awt ON awt.id = m.away_team_id
JOIN leagues l ON l.id = m.league_id
JOIN seasons se ON se.id = m.season_id
LEFT JOIN players mvp ON mvp.id = m.mvp_player_id
LEFT JOIN team_players mvp_tp ON mvp_tp.player_id = m.mvp_player_id
    AND mvp_tp.season_id = m.season_id
    AND mvp_tp.league_id = m.league_id
    AND mvp_tp.left_date IS NULL
LEFT JOIN referees r ON r.id = m.referee_id;
