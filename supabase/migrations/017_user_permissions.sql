-- ============================================================
-- MLPN - Migracja 017: Konta i szczegółowe uprawnienia admina
-- Rozszerza profiles o dane osobowe, status konta i drzewo
-- uprawnień. Dodaje helpery do RLS i przepina główne polityki.
-- ============================================================

ALTER TABLE public.profiles
    ADD COLUMN IF NOT EXISTS email TEXT,
    ADD COLUMN IF NOT EXISTS first_name TEXT,
    ADD COLUMN IF NOT EXISTS last_name TEXT,
    ADD COLUMN IF NOT EXISTS permissions JSONB NOT NULL DEFAULT '{}'::jsonb,
    ADD COLUMN IF NOT EXISTS account_status TEXT NOT NULL DEFAULT 'active';

CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles (email);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'profiles_account_status_check'
    ) THEN
        ALTER TABLE public.profiles
            ADD CONSTRAINT profiles_account_status_check
            CHECK (account_status IN ('active', 'suspended', 'banned'));
    END IF;
END $$;

UPDATE public.profiles
SET
    permissions = COALESCE(permissions, '{}'::jsonb),
    account_status = COALESCE(NULLIF(account_status, ''), 'active')
WHERE permissions IS NULL
   OR account_status IS NULL
   OR account_status = '';

UPDATE public.profiles p
SET
    email = u.email,
    display_name = COALESCE(NULLIF(p.display_name, ''), NULLIF(u.raw_user_meta_data->>'display_name', ''), u.email),
    updated_at = now()
FROM auth.users u
WHERE u.id = p.id
  AND (
    p.email IS DISTINCT FROM u.email
    OR (NULLIF(p.display_name, '') IS NULL AND COALESCE(NULLIF(u.raw_user_meta_data->>'display_name', ''), u.email) IS NOT NULL)
  );

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (
        id,
        role,
        email,
        first_name,
        last_name,
        display_name,
        permissions,
        account_status
    )
    VALUES (
        NEW.id,
        'viewer',
        NEW.email,
        NULLIF(NEW.raw_user_meta_data->>'first_name', ''),
        NULLIF(NEW.raw_user_meta_data->>'last_name', ''),
        COALESCE(NULLIF(NEW.raw_user_meta_data->>'display_name', ''), NEW.email),
        '{}'::jsonb,
        'active'
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        first_name = COALESCE(EXCLUDED.first_name, public.profiles.first_name),
        last_name = COALESCE(EXCLUDED.last_name, public.profiles.last_name),
        display_name = COALESCE(NULLIF(EXCLUDED.display_name, ''), public.profiles.display_name, EXCLUDED.email),
        updated_at = now();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.sync_profile_from_auth_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (
        id,
        role,
        email,
        first_name,
        last_name,
        display_name,
        permissions,
        account_status
    )
    VALUES (
        NEW.id,
        'viewer',
        NEW.email,
        NULLIF(NEW.raw_user_meta_data->>'first_name', ''),
        NULLIF(NEW.raw_user_meta_data->>'last_name', ''),
        COALESCE(NULLIF(NEW.raw_user_meta_data->>'display_name', ''), NEW.email),
        '{}'::jsonb,
        'active'
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        first_name = COALESCE(EXCLUDED.first_name, public.profiles.first_name),
        last_name = COALESCE(EXCLUDED.last_name, public.profiles.last_name),
        display_name = COALESCE(NULLIF(EXCLUDED.display_name, ''), public.profiles.display_name, EXCLUDED.email),
        updated_at = now();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.profiles
        WHERE id = auth.uid()
          AND role = 'admin'
          AND account_status = 'active'
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.has_permission(permission_key TEXT)
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.profiles
        WHERE id = auth.uid()
          AND account_status = 'active'
          AND (
            role = 'admin'
            OR (
              role = 'editor'
              AND permission_key = ANY (ARRAY[
                'players.edit',
                'rosters.edit',
                'schedule.edit',
                'results.enter',
                'results.edit',
                'referees.create',
                'referees.edit',
                'referees.delete',
                'polls.create',
                'polls.edit',
                'polls.delete',
                'typer.create',
                'typer.edit',
                'typer.delete'
              ])
            )
            OR COALESCE(
              jsonb_extract_path_text(permissions, VARIADIC string_to_array(permission_key, '.')) = 'true',
              false
            )
          )
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.has_any_permission(permission_keys TEXT[])
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1
        FROM unnest(permission_keys) AS permission_key
        WHERE public.has_permission(permission_key)
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.is_editor_or_admin()
RETURNS BOOLEAN AS $$
    SELECT public.has_any_permission(ARRAY[
        'players.edit',
        'rosters.edit',
        'schedule.edit',
        'results.enter',
        'results.edit',
        'referees.create',
        'referees.edit',
        'referees.delete',
        'polls.create',
        'polls.edit',
        'polls.delete',
        'typer.create',
        'typer.edit',
        'typer.delete'
    ]);
$$ LANGUAGE sql SECURITY DEFINER STABLE;

DROP POLICY IF EXISTS "seasons_admin_insert" ON public.seasons;
DROP POLICY IF EXISTS "seasons_admin_update" ON public.seasons;
DROP POLICY IF EXISTS "seasons_admin_delete" ON public.seasons;
CREATE POLICY "seasons_admin_insert" ON public.seasons
    FOR INSERT WITH CHECK (public.has_permission('seasons.generate'));
CREATE POLICY "seasons_admin_update" ON public.seasons
    FOR UPDATE USING (public.has_permission('seasons.edit'));
CREATE POLICY "seasons_admin_delete" ON public.seasons
    FOR DELETE USING (public.has_permission('seasons.delete'));

DROP POLICY IF EXISTS "leagues_admin_insert" ON public.leagues;
DROP POLICY IF EXISTS "leagues_admin_update" ON public.leagues;
DROP POLICY IF EXISTS "leagues_admin_delete" ON public.leagues;
CREATE POLICY "leagues_admin_insert" ON public.leagues
    FOR INSERT WITH CHECK (public.has_permission('seasons.generate'));
CREATE POLICY "leagues_admin_update" ON public.leagues
    FOR UPDATE USING (public.has_permission('seasons.edit'));
CREATE POLICY "leagues_admin_delete" ON public.leagues
    FOR DELETE USING (public.has_permission('seasons.delete'));

DROP POLICY IF EXISTS "season_leagues_admin_insert" ON public.season_leagues;
DROP POLICY IF EXISTS "season_leagues_admin_update" ON public.season_leagues;
DROP POLICY IF EXISTS "season_leagues_admin_delete" ON public.season_leagues;
CREATE POLICY "season_leagues_admin_insert" ON public.season_leagues
    FOR INSERT WITH CHECK (public.has_permission('seasons.generate'));
CREATE POLICY "season_leagues_admin_update" ON public.season_leagues
    FOR UPDATE USING (public.has_permission('seasons.edit'));
CREATE POLICY "season_leagues_admin_delete" ON public.season_leagues
    FOR DELETE USING (public.has_permission('seasons.delete'));

DROP POLICY IF EXISTS "teams_admin_insert" ON public.teams;
DROP POLICY IF EXISTS "teams_admin_update" ON public.teams;
DROP POLICY IF EXISTS "teams_admin_delete" ON public.teams;
CREATE POLICY "teams_admin_insert" ON public.teams
    FOR INSERT WITH CHECK (public.has_permission('teams.create') OR public.has_permission('seasons.generate'));
CREATE POLICY "teams_admin_update" ON public.teams
    FOR UPDATE USING (public.has_permission('teams.edit'));
CREATE POLICY "teams_admin_delete" ON public.teams
    FOR DELETE USING (public.has_permission('teams.delete'));

DROP POLICY IF EXISTS "season_teams_admin_insert" ON public.season_teams;
DROP POLICY IF EXISTS "season_teams_admin_update" ON public.season_teams;
DROP POLICY IF EXISTS "season_teams_admin_delete" ON public.season_teams;
CREATE POLICY "season_teams_admin_insert" ON public.season_teams
    FOR INSERT WITH CHECK (public.has_any_permission(ARRAY['teams.create', 'seasons.generate']));
CREATE POLICY "season_teams_admin_update" ON public.season_teams
    FOR UPDATE USING (public.has_any_permission(ARRAY['teams.edit', 'seasons.edit']));
CREATE POLICY "season_teams_admin_delete" ON public.season_teams
    FOR DELETE USING (public.has_any_permission(ARRAY['teams.delete', 'seasons.delete']));

DROP POLICY IF EXISTS "players_admin_insert" ON public.players;
DROP POLICY IF EXISTS "players_admin_update" ON public.players;
DROP POLICY IF EXISTS "players_admin_delete" ON public.players;
CREATE POLICY "players_admin_insert" ON public.players
    FOR INSERT WITH CHECK (public.has_permission('players.create'));
CREATE POLICY "players_admin_update" ON public.players
    FOR UPDATE USING (public.has_permission('players.edit'));
CREATE POLICY "players_admin_delete" ON public.players
    FOR DELETE USING (public.has_permission('players.delete'));

DROP POLICY IF EXISTS "players_private_admin_all" ON public.players_private;
CREATE POLICY "players_private_admin_read" ON public.players_private
    FOR SELECT USING (public.has_any_permission(ARRAY['players.create', 'players.edit', 'players.delete']) OR player_id = public.get_my_player_id());
CREATE POLICY "players_private_admin_insert" ON public.players_private
    FOR INSERT WITH CHECK (public.has_permission('players.create'));
CREATE POLICY "players_private_admin_update" ON public.players_private
    FOR UPDATE USING (public.has_permission('players.edit'));
CREATE POLICY "players_private_admin_delete" ON public.players_private
    FOR DELETE USING (public.has_permission('players.delete'));

DROP POLICY IF EXISTS "team_players_admin_insert" ON public.team_players;
DROP POLICY IF EXISTS "team_players_admin_update" ON public.team_players;
DROP POLICY IF EXISTS "team_players_admin_delete" ON public.team_players;
CREATE POLICY "team_players_admin_insert" ON public.team_players
    FOR INSERT WITH CHECK (public.has_any_permission(ARRAY['rosters.edit', 'seasons.generate']));
CREATE POLICY "team_players_admin_update" ON public.team_players
    FOR UPDATE USING (public.has_any_permission(ARRAY['rosters.edit', 'seasons.edit']));
CREATE POLICY "team_players_admin_delete" ON public.team_players
    FOR DELETE USING (public.has_any_permission(ARRAY['rosters.edit', 'seasons.delete']));

DROP POLICY IF EXISTS "matches_editor_insert" ON public.matches;
DROP POLICY IF EXISTS "matches_editor_update" ON public.matches;
DROP POLICY IF EXISTS "matches_admin_delete" ON public.matches;
CREATE POLICY "matches_editor_insert" ON public.matches
    FOR INSERT WITH CHECK (public.has_any_permission(ARRAY['schedule.edit', 'results.enter', 'seasons.generate']));
CREATE POLICY "matches_editor_update" ON public.matches
    FOR UPDATE USING (public.has_any_permission(ARRAY['schedule.edit', 'results.enter', 'results.edit', 'seasons.edit']));
CREATE POLICY "matches_admin_delete" ON public.matches
    FOR DELETE USING (public.has_any_permission(ARRAY['schedule.edit', 'seasons.delete']));

DROP POLICY IF EXISTS "match_events_editor_insert" ON public.match_events;
DROP POLICY IF EXISTS "match_events_editor_update" ON public.match_events;
DROP POLICY IF EXISTS "match_events_admin_delete" ON public.match_events;
CREATE POLICY "match_events_editor_insert" ON public.match_events
    FOR INSERT WITH CHECK (public.has_any_permission(ARRAY['results.enter', 'results.edit']));
CREATE POLICY "match_events_editor_update" ON public.match_events
    FOR UPDATE USING (public.has_permission('results.edit'));
CREATE POLICY "match_events_admin_delete" ON public.match_events
    FOR DELETE USING (public.has_permission('results.edit'));

DROP POLICY IF EXISTS "match_lineups_editor_insert" ON public.match_lineups;
DROP POLICY IF EXISTS "match_lineups_editor_update" ON public.match_lineups;
DROP POLICY IF EXISTS "match_lineups_admin_delete" ON public.match_lineups;
CREATE POLICY "match_lineups_editor_insert" ON public.match_lineups
    FOR INSERT WITH CHECK (public.has_any_permission(ARRAY['results.enter', 'results.edit']));
CREATE POLICY "match_lineups_editor_update" ON public.match_lineups
    FOR UPDATE USING (public.has_any_permission(ARRAY['results.enter', 'results.edit']));
CREATE POLICY "match_lineups_admin_delete" ON public.match_lineups
    FOR DELETE USING (public.has_permission('results.edit'));

DROP POLICY IF EXISTS "polls_editor_insert" ON public.polls;
DROP POLICY IF EXISTS "polls_editor_update" ON public.polls;
DROP POLICY IF EXISTS "polls_admin_delete" ON public.polls;
CREATE POLICY "polls_editor_insert" ON public.polls
    FOR INSERT WITH CHECK (public.has_permission('polls.create'));
CREATE POLICY "polls_editor_update" ON public.polls
    FOR UPDATE USING (public.has_permission('polls.edit'));
CREATE POLICY "polls_admin_delete" ON public.polls
    FOR DELETE USING (public.has_permission('polls.delete'));

DROP POLICY IF EXISTS "poll_options_editor_insert" ON public.poll_options;
DROP POLICY IF EXISTS "poll_options_editor_update" ON public.poll_options;
DROP POLICY IF EXISTS "poll_options_admin_delete" ON public.poll_options;
CREATE POLICY "poll_options_editor_insert" ON public.poll_options
    FOR INSERT WITH CHECK (public.has_permission('polls.create'));
CREATE POLICY "poll_options_editor_update" ON public.poll_options
    FOR UPDATE USING (public.has_permission('polls.edit'));
CREATE POLICY "poll_options_admin_delete" ON public.poll_options
    FOR DELETE USING (public.has_permission('polls.delete'));

DO $$
BEGIN
    IF to_regclass('public.typer_round_configs') IS NOT NULL THEN
        EXECUTE 'DROP POLICY IF EXISTS "typer_round_configs_editor_insert" ON public.typer_round_configs';
        EXECUTE 'DROP POLICY IF EXISTS "typer_round_configs_editor_update" ON public.typer_round_configs';
        EXECUTE 'DROP POLICY IF EXISTS "typer_round_configs_editor_delete" ON public.typer_round_configs';
        EXECUTE 'CREATE POLICY "typer_round_configs_editor_insert" ON public.typer_round_configs FOR INSERT WITH CHECK (public.has_permission(''typer.create''))';
        EXECUTE 'CREATE POLICY "typer_round_configs_editor_update" ON public.typer_round_configs FOR UPDATE USING (public.has_permission(''typer.edit''))';
        EXECUTE 'CREATE POLICY "typer_round_configs_editor_delete" ON public.typer_round_configs FOR DELETE USING (public.has_permission(''typer.delete''))';
    END IF;

    IF to_regclass('public.typer_round_config_matches') IS NOT NULL THEN
        EXECUTE 'DROP POLICY IF EXISTS "typer_round_cfg_matches_editor_insert" ON public.typer_round_config_matches';
        EXECUTE 'DROP POLICY IF EXISTS "typer_round_cfg_matches_editor_update" ON public.typer_round_config_matches';
        EXECUTE 'DROP POLICY IF EXISTS "typer_round_cfg_matches_editor_delete" ON public.typer_round_config_matches';
        EXECUTE 'CREATE POLICY "typer_round_cfg_matches_editor_insert" ON public.typer_round_config_matches FOR INSERT WITH CHECK (public.has_permission(''typer.create''))';
        EXECUTE 'CREATE POLICY "typer_round_cfg_matches_editor_update" ON public.typer_round_config_matches FOR UPDATE USING (public.has_permission(''typer.edit''))';
        EXECUTE 'CREATE POLICY "typer_round_cfg_matches_editor_delete" ON public.typer_round_config_matches FOR DELETE USING (public.has_permission(''typer.delete''))';
    END IF;

    IF to_regclass('public.referees') IS NOT NULL THEN
        EXECUTE 'DROP POLICY IF EXISTS "referees_editor_insert" ON public.referees';
        EXECUTE 'DROP POLICY IF EXISTS "referees_editor_update" ON public.referees';
        EXECUTE 'DROP POLICY IF EXISTS "referees_editor_delete" ON public.referees';
        EXECUTE 'CREATE POLICY "referees_editor_insert" ON public.referees FOR INSERT WITH CHECK (public.has_permission(''referees.create''))';
        EXECUTE 'CREATE POLICY "referees_editor_update" ON public.referees FOR UPDATE USING (public.has_permission(''referees.edit''))';
        EXECUTE 'CREATE POLICY "referees_editor_delete" ON public.referees FOR DELETE USING (public.has_permission(''referees.delete''))';
    END IF;
END $$;

DROP POLICY IF EXISTS "profiles_own_read" ON public.profiles;
DROP POLICY IF EXISTS "profiles_own_update" ON public.profiles;
DROP POLICY IF EXISTS "profiles_admin_all" ON public.profiles;
CREATE POLICY "profiles_own_read" ON public.profiles
    FOR SELECT USING (id = auth.uid());
CREATE POLICY "profiles_manage_read" ON public.profiles
    FOR SELECT USING (
        public.has_any_permission(ARRAY[
            'users.create',
            'users.delete',
            'users.ban',
            'users.suspend',
            'users.edit',
            'users.permissions.grant',
            'users.permissions.revoke'
        ])
    );
CREATE POLICY "profiles_own_update" ON public.profiles
    FOR UPDATE USING (id = auth.uid())
    WITH CHECK (
        id = auth.uid()
        AND role = (SELECT role FROM public.profiles WHERE id = auth.uid())
    );
CREATE POLICY "profiles_manage_insert" ON public.profiles
    FOR INSERT WITH CHECK (public.has_permission('users.create'));
CREATE POLICY "profiles_manage_update" ON public.profiles
    FOR UPDATE USING (
        public.has_any_permission(ARRAY[
            'users.edit',
            'users.ban',
            'users.suspend',
            'users.permissions.grant',
            'users.permissions.revoke'
        ])
    )
    WITH CHECK (
        public.has_any_permission(ARRAY[
            'users.edit',
            'users.ban',
            'users.suspend',
            'users.permissions.grant',
            'users.permissions.revoke'
        ])
    );
CREATE POLICY "profiles_manage_delete" ON public.profiles
    FOR DELETE USING (public.has_permission('users.delete'));
