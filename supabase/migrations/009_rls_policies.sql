-- ============================================================
-- MLPN - Migracja 009: Row Level Security (RLS)
-- Wszystkie tabele z odpowiednimi politykami dostepu
-- ============================================================

-- ============================================================
-- WLACZ RLS na wszystkich tabelach
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
-- WZORZEC 1: Public read, admin write
-- Dotyczy: seasons, leagues, season_leagues, teams, season_teams,
--          players, team_players, standings, player_season_stats,
--          suspensions, tournaments, tournament_teams,
--          tournament_matches, tournament_group_standings
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

-- PLAYERS (dane publiczne)
CREATE POLICY "players_public_read" ON players FOR SELECT USING (true);
CREATE POLICY "players_admin_insert" ON players FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "players_admin_update" ON players FOR UPDATE USING (is_admin());
CREATE POLICY "players_admin_delete" ON players FOR DELETE USING (is_admin());

-- TEAM_PLAYERS
CREATE POLICY "team_players_public_read" ON team_players FOR SELECT USING (true);
CREATE POLICY "team_players_admin_insert" ON team_players FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "team_players_admin_update" ON team_players FOR UPDATE USING (is_admin());
CREATE POLICY "team_players_admin_delete" ON team_players FOR DELETE USING (is_admin());

-- STANDINGS (read-only, trigger zarzadza)
CREATE POLICY "standings_public_read" ON standings FOR SELECT USING (true);
CREATE POLICY "standings_system_all" ON standings FOR ALL USING (is_admin());

-- PLAYER_SEASON_STATS (read-only, trigger zarzadza)
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
-- WZORZEC 2: Public read, admin + editor write
-- Dotyczy: matches, match_events, match_lineups
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
-- WZORZEC 3: RODO - tylko admin i sam zawodnik
-- Dotyczy: players_private
-- ============================================================

CREATE POLICY "players_private_admin_all" ON players_private
    FOR ALL USING (is_admin());

CREATE POLICY "players_private_own_read" ON players_private
    FOR SELECT USING (player_id = get_my_player_id());


-- ============================================================
-- WZORZEC 4: Publikowane tresci
-- Dotyczy: news, polls, gallery
-- ============================================================

-- NEWS (publicznosc widzi tylko opublikowane)
CREATE POLICY "news_public_read" ON news
    FOR SELECT USING (is_published = true OR is_editor_or_admin());
CREATE POLICY "news_editor_insert" ON news FOR INSERT WITH CHECK (is_editor_or_admin());
CREATE POLICY "news_editor_update" ON news FOR UPDATE USING (is_editor_or_admin());
CREATE POLICY "news_admin_delete" ON news FOR DELETE USING (is_admin());

-- POLLS (publicznosc widzi tylko opublikowane)
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

-- GALLERY_ALBUMS (publicznosc widzi tylko opublikowane)
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
-- WZORZEC 5: Anonimowe glosowanie
-- Dotyczy: typer_predictions, poll_votes, typer_aggregates
-- ============================================================

-- TYPER_PREDICTIONS (kazdy moze wstawic, admin widzi wszystko)
CREATE POLICY "typer_public_insert" ON typer_predictions
    FOR INSERT WITH CHECK (true);
CREATE POLICY "typer_public_read" ON typer_predictions
    FOR SELECT USING (true);
CREATE POLICY "typer_admin_update" ON typer_predictions
    FOR UPDATE USING (is_admin());
CREATE POLICY "typer_admin_delete" ON typer_predictions
    FOR DELETE USING (is_admin());

-- TYPER_AGGREGATES (kazdy czyta, system aktualizuje)
CREATE POLICY "typer_agg_public_read" ON typer_aggregates FOR SELECT USING (true);
CREATE POLICY "typer_agg_system_all" ON typer_aggregates FOR ALL USING (is_admin());

-- POLL_VOTES (kazdy moze glosowac, admin widzi glosy)
CREATE POLICY "poll_votes_public_insert" ON poll_votes
    FOR INSERT WITH CHECK (true);
CREATE POLICY "poll_votes_admin_read" ON poll_votes
    FOR SELECT USING (is_admin());
CREATE POLICY "poll_votes_admin_delete" ON poll_votes
    FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 6: Publiczny formularz z moderacja
-- Dotyczy: free_agents
-- ============================================================

-- Publicznosc widzi tylko zatwierdzone i aktywne
CREATE POLICY "free_agents_public_read" ON free_agents
    FOR SELECT USING (
        (is_approved = true AND is_active = true)
        OR is_admin()
    );

-- Kazdy moze wyslac formularz (nowy wpis)
CREATE POLICY "free_agents_public_insert" ON free_agents
    FOR INSERT WITH CHECK (true);

-- Tylko admin zatwierdza/edytuje/usuwa
CREATE POLICY "free_agents_admin_update" ON free_agents
    FOR UPDATE USING (is_admin());
CREATE POLICY "free_agents_admin_delete" ON free_agents
    FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 7: Tylko admin czyta i pisze
-- Dotyczy: sponsors, static_pages, contact_messages
-- ============================================================

-- SPONSORS (publicznosc widzi aktywne)
CREATE POLICY "sponsors_public_read" ON sponsors
    FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "sponsors_admin_insert" ON sponsors FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "sponsors_admin_update" ON sponsors FOR UPDATE USING (is_admin());
CREATE POLICY "sponsors_admin_delete" ON sponsors FOR DELETE USING (is_admin());

-- STATIC_PAGES (publicznosc czyta, admin pisze)
CREATE POLICY "static_pages_public_read" ON static_pages FOR SELECT USING (true);
CREATE POLICY "static_pages_admin_insert" ON static_pages FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "static_pages_admin_update" ON static_pages FOR UPDATE USING (is_admin());
CREATE POLICY "static_pages_admin_delete" ON static_pages FOR DELETE USING (is_admin());

-- CONTACT_MESSAGES (kazdy wysyla, admin czyta)
CREATE POLICY "contact_public_insert" ON contact_messages
    FOR INSERT WITH CHECK (true);
CREATE POLICY "contact_admin_read" ON contact_messages
    FOR SELECT USING (is_admin());
CREATE POLICY "contact_admin_update" ON contact_messages
    FOR UPDATE USING (is_admin());
CREATE POLICY "contact_admin_delete" ON contact_messages
    FOR DELETE USING (is_admin());


-- ============================================================
-- WZORZEC 8: Profil uzytkownika
-- Dotyczy: profiles
-- ============================================================

-- Kazdy widzi swoj profil, admin widzi wszystkie
CREATE POLICY "profiles_own_read" ON profiles
    FOR SELECT USING (id = auth.uid() OR is_admin());

-- Kazdy moze aktualizowac swoj profil (ale nie role!)
CREATE POLICY "profiles_own_update" ON profiles
    FOR UPDATE USING (id = auth.uid())
    WITH CHECK (
        -- Uzytkownik nie moze zmienic swojej roli
        role = (SELECT role FROM profiles WHERE id = auth.uid())
    );

-- Admin zarzadza wszystkimi profilami
CREATE POLICY "profiles_admin_all" ON profiles
    FOR ALL USING (is_admin());
