-- ============================================================
-- MLPN - CZĘŚĆ 2 z 3: Auth, Zabezpieczenia (RLS), Triggery, Funkcje
-- Skopiuj CAŁY ten plik i wklej do SQL Editor w Supabase
-- UWAGA: Najpierw musisz uruchomić Część 1!
-- ============================================================

-- Czyszczenie po ewentualnych poprzednich próbach
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
DROP TRIGGER IF EXISTS trg_recalculate_standings ON matches;
DROP TRIGGER IF EXISTS trg_recalculate_player_stats ON match_events;
DROP TRIGGER IF EXISTS trg_check_auto_suspension ON match_events;
DROP TRIGGER IF EXISTS trg_update_poll_aggregates ON poll_votes;
DROP TRIGGER IF EXISTS trg_update_typer_aggregates ON typer_predictions;


-- ============================================================
-- PROFILES (konta użytkowników z rolami)
-- Usuwamy starą wersję jeśli istnieje (np. po poprzedniej próbie)
-- ============================================================
DROP TABLE IF EXISTS profiles CASCADE;
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
-- FUNKCJE POMOCNICZE (używane w zabezpieczeniach)
-- ============================================================

CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role = 'admin'
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


CREATE OR REPLACE FUNCTION is_editor_or_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role IN ('admin', 'editor')
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


CREATE OR REPLACE FUNCTION get_my_player_id()
RETURNS UUID AS $$
    SELECT player_id FROM profiles
    WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- ============================================================
-- AUTO-CREATE PROFILE (automatyczne tworzenie profilu po rejestracji)
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


-- ============================================================
-- USUWANIE STARYCH POLITYK (jeśli istnieją z poprzednich prób)
-- ============================================================
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT schemaname, tablename, policyname
        FROM pg_policies
        WHERE schemaname = 'public'
    ) LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', r.policyname, r.schemaname, r.tablename);
    END LOOP;
END $$;

-- ============================================================
-- WŁĄCZENIE ZABEZPIECZEŃ (RLS) NA WSZYSTKICH TABELACH
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
-- REGUŁY DOSTĘPU: Publiczny odczyt, admin pisze
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

-- PLAYERS
CREATE POLICY "players_public_read" ON players FOR SELECT USING (true);
CREATE POLICY "players_admin_insert" ON players FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "players_admin_update" ON players FOR UPDATE USING (is_admin());
CREATE POLICY "players_admin_delete" ON players FOR DELETE USING (is_admin());

-- TEAM_PLAYERS
CREATE POLICY "team_players_public_read" ON team_players FOR SELECT USING (true);
CREATE POLICY "team_players_admin_insert" ON team_players FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "team_players_admin_update" ON team_players FOR UPDATE USING (is_admin());
CREATE POLICY "team_players_admin_delete" ON team_players FOR DELETE USING (is_admin());

-- STANDINGS
CREATE POLICY "standings_public_read" ON standings FOR SELECT USING (true);
CREATE POLICY "standings_system_all" ON standings FOR ALL USING (is_admin());

-- PLAYER_SEASON_STATS
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
-- REGUŁY DOSTĘPU: Publiczny odczyt, admin + editor pisze
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
-- REGUŁY DOSTĘPU: RODO - dane prywatne zawodników
-- ============================================================

CREATE POLICY "players_private_admin_all" ON players_private
    FOR ALL USING (is_admin());

CREATE POLICY "players_private_own_read" ON players_private
    FOR SELECT USING (player_id = get_my_player_id());


-- ============================================================
-- REGUŁY DOSTĘPU: Treści publikowane
-- ============================================================

-- NEWS
CREATE POLICY "news_public_read" ON news
    FOR SELECT USING (is_published = true OR is_editor_or_admin());
CREATE POLICY "news_editor_insert" ON news FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "news_editor_update" ON news FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "news_admin_delete" ON news FOR DELETE USING (is_admin());

-- POLLS
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

-- GALLERY_ALBUMS
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
-- REGUŁY DOSTĘPU: Anonimowe głosowanie
-- ============================================================

-- TYPER_PREDICTIONS
CREATE POLICY "typer_public_insert" ON typer_predictions
    FOR INSERT WITH CHECK (true);
CREATE POLICY "typer_public_read" ON typer_predictions
    FOR SELECT USING (true);
CREATE POLICY "typer_admin_update" ON typer_predictions
    FOR UPDATE USING (is_admin());
CREATE POLICY "typer_admin_delete" ON typer_predictions
    FOR DELETE USING (is_admin());

-- TYPER_AGGREGATES
CREATE POLICY "typer_agg_public_read" ON typer_aggregates FOR SELECT USING (true);
CREATE POLICY "typer_agg_system_all" ON typer_aggregates FOR ALL USING (is_admin());

-- POLL_VOTES
CREATE POLICY "poll_votes_public_insert" ON poll_votes
    FOR INSERT WITH CHECK (true);
CREATE POLICY "poll_votes_admin_read" ON poll_votes
    FOR SELECT USING (is_admin());
CREATE POLICY "poll_votes_admin_delete" ON poll_votes
    FOR DELETE USING (is_admin());


-- ============================================================
-- REGUŁY DOSTĘPU: Formularz wolnych zawodników
-- ============================================================

CREATE POLICY "free_agents_public_read" ON free_agents
    FOR SELECT USING (
        (is_approved = true AND is_active = true)
        OR is_admin()
    );
CREATE POLICY "free_agents_public_insert" ON free_agents
    FOR INSERT WITH CHECK (true);
CREATE POLICY "free_agents_admin_update" ON free_agents
    FOR UPDATE USING (is_admin());
CREATE POLICY "free_agents_admin_delete" ON free_agents
    FOR DELETE USING (is_admin());


-- ============================================================
-- REGUŁY DOSTĘPU: Sponsorzy, strony, kontakt
-- ============================================================

-- SPONSORS
CREATE POLICY "sponsors_public_read" ON sponsors
    FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "sponsors_admin_insert" ON sponsors FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "sponsors_admin_update" ON sponsors FOR UPDATE USING (is_admin());
CREATE POLICY "sponsors_admin_delete" ON sponsors FOR DELETE USING (is_admin());

-- STATIC_PAGES
CREATE POLICY "static_pages_public_read" ON static_pages FOR SELECT USING (true);
CREATE POLICY "static_pages_admin_insert" ON static_pages FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "static_pages_admin_update" ON static_pages FOR UPDATE USING (is_admin());
CREATE POLICY "static_pages_admin_delete" ON static_pages FOR DELETE USING (is_admin());

-- CONTACT_MESSAGES
CREATE POLICY "contact_public_insert" ON contact_messages
    FOR INSERT WITH CHECK (true);
CREATE POLICY "contact_admin_read" ON contact_messages
    FOR SELECT USING (is_admin());
CREATE POLICY "contact_admin_update" ON contact_messages
    FOR UPDATE USING (is_admin());
CREATE POLICY "contact_admin_delete" ON contact_messages
    FOR DELETE USING (is_admin());


-- ============================================================
-- REGUŁY DOSTĘPU: Profile użytkowników
-- ============================================================

CREATE POLICY "profiles_own_read" ON profiles
    FOR SELECT USING (id = auth.uid() OR is_admin());

CREATE POLICY "profiles_own_update" ON profiles
    FOR UPDATE USING (id = auth.uid())
    WITH CHECK (
        role = (SELECT role FROM profiles WHERE id = auth.uid())
    );

CREATE POLICY "profiles_admin_all" ON profiles
    FOR ALL USING (is_admin());


-- ============================================================
-- TRIGGERY: Automatyczne przeliczanie tabeli ligowej
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
    IF TG_OP = 'DELETE' THEN
        v_season_id := OLD.season_id;
        v_league_id := OLD.league_id;
    ELSE
        v_season_id := NEW.season_id;
        v_league_id := NEW.league_id;
    END IF;

    SELECT
        COALESCE(points_win, 3),
        COALESCE(points_draw, 1),
        COALESCE(points_loss, 0),
        COALESCE(walkover_goals_winner, 3),
        COALESCE(walkover_goals_loser, 0)
    INTO v_points_win, v_points_draw, v_points_loss, v_wo_goals_winner, v_wo_goals_loser
    FROM season_leagues
    WHERE season_id = v_season_id AND league_id = v_league_id;

    v_points_win := COALESCE(v_points_win, 3);
    v_points_draw := COALESCE(v_points_draw, 1);
    v_points_loss := COALESCE(v_points_loss, 0);
    v_wo_goals_winner := COALESCE(v_wo_goals_winner, 3);
    v_wo_goals_loser := COALESCE(v_wo_goals_loser, 0);

    DELETE FROM standings
    WHERE season_id = v_season_id AND league_id = v_league_id;

    INSERT INTO standings (
        season_id, league_id, team_id,
        played, won, drawn, lost,
        goals_for, goals_against, points, position,
        form_last5, streak_wins, streak_unbeaten, streak_winless
    )
    WITH match_results AS (
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
    all_teams AS (
        SELECT st.team_id
        FROM season_teams st
        WHERE st.season_id = v_season_id AND st.league_id = v_league_id
    ),
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
        0,
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
-- TRIGGERY: Automatyczne przeliczanie statystyk zawodników
-- ============================================================
CREATE OR REPLACE FUNCTION recalculate_player_stats()
RETURNS TRIGGER AS $$
DECLARE
    v_match RECORD;
    v_player_id UUID;
    v_assist_player_id UUID;
BEGIN
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
        (SELECT COUNT(DISTINCT ml.match_id)
         FROM match_lineups ml
         JOIN matches m ON m.id = ml.match_id
         WHERE ml.player_id = v_player_id
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'GOAL'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.assist_player_id = v_player_id
           AND me.event_type = 'GOAL'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
        (SELECT COUNT(*) FROM match_events me
         JOIN matches m ON m.id = me.match_id
         WHERE me.player_id = v_player_id
           AND me.event_type = 'YELLOW_CARD'
           AND m.season_id = v_match.season_id
           AND m.league_id = v_match.league_id),
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
-- TRIGGERY: Automatyczne pauzy za kartki
-- ============================================================
CREATE OR REPLACE FUNCTION check_auto_suspension()
RETURNS TRIGGER AS $$
DECLARE
    v_match RECORD;
    v_threshold INTEGER;
    v_yellow_count INTEGER;
BEGIN
    IF NEW.event_type NOT IN ('YELLOW_CARD', 'RED_CARD') THEN
        RETURN NEW;
    END IF;

    SELECT * INTO v_match FROM matches WHERE id = NEW.match_id;

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

    IF NEW.event_type = 'YELLOW_CARD' THEN
        SELECT COALESCE(yellow_card_suspension_threshold, 3) INTO v_threshold
        FROM season_leagues
        WHERE season_id = v_match.season_id AND league_id = v_match.league_id;

        v_threshold := COALESCE(v_threshold, 3);

        SELECT COUNT(*) INTO v_yellow_count
        FROM match_events me
        JOIN matches m ON m.id = me.match_id
        WHERE me.player_id = NEW.player_id
          AND me.event_type = 'YELLOW_CARD'
          AND m.season_id = v_match.season_id
          AND m.league_id = v_match.league_id;

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
-- TRIGGERY: Agregacja głosów w ankietach
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

    SELECT COUNT(*) INTO v_total
    FROM poll_votes WHERE poll_id = v_poll_id;

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
-- TRIGGERY: Agregacja predykcji w typerze
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


-- ============================================================
-- FUNKCJE: Generowanie terminarza (round-robin)
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
    SELECT ARRAY_AGG(st.team_id ORDER BY t.name)
    INTO v_teams
    FROM season_teams st
    JOIN teams t ON t.id = st.team_id
    WHERE st.season_id = p_season_id AND st.league_id = p_league_id;

    v_team_count := COALESCE(array_length(v_teams, 1), 0);

    IF v_team_count < 2 THEN
        RAISE EXCEPTION 'Potrzeba minimum 2 druzyn, znaleziono: %', v_team_count;
    END IF;

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

    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
            IF v_round % 2 = 0 THEN
                v_home := v_list[v_i];
                v_away := v_list[v_effective_count + 1 - v_i];
            ELSE
                v_home := v_list[v_effective_count + 1 - v_i];
                v_away := v_list[v_i];
            END IF;

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

        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    v_list := v_teams;

    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_rounds + v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
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

        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    UPDATE season_leagues
    SET total_rounds = v_rounds * 2
    WHERE season_id = p_season_id AND league_id = p_league_id;

    matches_created := v_match_count;
    rounds_total := v_rounds * 2;
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FUNKCJE: Inicjalizacja tabeli ligowej
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


-- ============================================================
-- KONIEC CZĘŚCI 2 - Auth, zabezpieczenia, triggery, funkcje!
-- Teraz wklej Część 3 (widoki i dane startowe)
-- ============================================================
