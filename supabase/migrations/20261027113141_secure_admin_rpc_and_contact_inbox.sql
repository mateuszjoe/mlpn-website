-- Public clients must never execute arbitrary SQL with the database owner's rights.
REVOKE ALL ON FUNCTION public.exec_sql(text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.exec_sql(text) TO service_role;
ALTER FUNCTION public.exec_sql(text) SET search_path = pg_catalog, public, pg_temp;

-- Keep profile-based authorization trustworthy, including direct REST writes/upserts.
CREATE OR REPLACE FUNCTION public.protect_profile_authority()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp AS $$
DECLARE
  v_before public.profiles;
  v_actor uuid := auth.uid();
  v_role text := current_setting('role', true);
  v_change record;
BEGIN
  -- Database maintenance and the Auth signup trigger are trusted server operations.
  -- A SET ROLE authenticated/anon session must still pass all checks below.
  IF v_role = 'service_role' OR
     (COALESCE(v_role, 'none') IN ('none', '') AND
      session_user IN ('postgres', 'supabase_admin', 'supabase_auth_admin')) THEN
    IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
    RETURN NEW;
  END IF;
  IF v_actor IS NULL THEN RAISE EXCEPTION 'PROFILE_ACCESS_DENIED' USING ERRCODE='42501'; END IF;
  IF TG_OP = 'UPDATE' AND NEW.id IS DISTINCT FROM OLD.id THEN
    RAISE EXCEPTION 'PROFILE_ID_IMMUTABLE' USING ERRCODE='42501';
  END IF;
  IF public.is_admin() THEN
    IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
    RETURN NEW;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE id=v_actor AND account_status='active') THEN
    RAISE EXCEPTION 'PROFILE_ACCESS_DENIED' USING ERRCODE='42501';
  END IF;
  IF TG_OP = 'DELETE' THEN
    IF OLD.id=v_actor OR OLD.role IN ('admin','editor') OR NOT public.has_permission('users.delete') THEN
      RAISE EXCEPTION 'PROFILE_ACCESS_DENIED' USING ERRCODE='42501';
    END IF;
    RETURN OLD;
  END IF;
  IF TG_OP = 'INSERT' THEN
    -- BEFORE INSERT also runs for ON CONFLICT UPDATE: compare against the real row.
    SELECT * INTO v_before FROM public.profiles WHERE id=NEW.id;
    IF NOT FOUND THEN
      IF NOT public.has_permission('users.create') THEN
        RAISE EXCEPTION 'PROFILE_ACCESS_DENIED' USING ERRCODE='42501';
      END IF;
      v_before := NEW;
      v_before.role := 'viewer';
      v_before.permissions := '{}'::jsonb;
      v_before.account_status := 'active';
      v_before.player_id := NULL;
    END IF;
  ELSE
    v_before := OLD;
  END IF;
  IF v_before.role IN ('admin','editor') AND v_before.id<>v_actor THEN
    RAISE EXCEPTION 'PROFILE_ADMIN_REQUIRED' USING ERRCODE='42501';
  END IF;
  IF NEW.role IS DISTINCT FROM v_before.role OR NEW.created_at IS DISTINCT FROM v_before.created_at THEN
    RAISE EXCEPTION 'PROFILE_ADMIN_REQUIRED' USING ERRCODE='42501';
  END IF;
  IF NEW.account_status IS DISTINCT FROM v_before.account_status THEN
    IF NEW.id=v_actor OR
       ((NEW.account_status='banned' OR v_before.account_status='banned') AND NOT public.has_permission('users.ban')) OR
       ((NEW.account_status='suspended' OR v_before.account_status='suspended') AND NOT public.has_permission('users.suspend')) THEN
      RAISE EXCEPTION 'PROFILE_STATUS_DENIED' USING ERRCODE='42501';
    END IF;
  END IF;
  IF NEW.player_id IS DISTINCT FROM v_before.player_id AND
     (NEW.id=v_actor OR NOT public.has_permission('users.edit')) THEN
    RAISE EXCEPTION 'PROFILE_LINK_DENIED' USING ERRCODE='42501';
  END IF;
  -- Match has_permission semantics; adding false leaves is not a grant.
  FOR v_change IN
    WITH RECURSIVE old_tree(path,value) AS (
      SELECT ARRAY[]::text[],COALESCE(v_before.permissions,'{}'::jsonb)
      UNION ALL SELECT t.path || e.key,e.value FROM old_tree t
      CROSS JOIN LATERAL jsonb_each(CASE WHEN jsonb_typeof(t.value)='object' THEN t.value ELSE '{}'::jsonb END) e
    ), new_tree(path,value) AS (
      SELECT ARRAY[]::text[],COALESCE(NEW.permissions,'{}'::jsonb)
      UNION ALL SELECT t.path || e.key,e.value FROM new_tree t
      CROSS JOIN LATERAL jsonb_each(CASE WHEN jsonb_typeof(t.value)='object' THEN t.value ELSE '{}'::jsonb END) e
    )
    SELECT COALESCE(n.path,o.path) path,
           COALESCE(o.value #>> '{}' = 'true',false) was_granted,
           COALESCE(n.value #>> '{}' = 'true',false) is_granted
    FROM old_tree o FULL JOIN new_tree n ON n.path=o.path
    WHERE COALESCE(o.value #>> '{}' = 'true',false) IS DISTINCT FROM COALESCE(n.value #>> '{}' = 'true',false)
  LOOP
    IF NEW.id=v_actor THEN RAISE EXCEPTION 'PROFILE_SELF_GRANT_DENIED' USING ERRCODE='42501'; END IF;
    IF v_change.is_granted THEN
      IF NOT public.has_permission('users.permissions.grant') OR v_change.path[1]='users' OR
         NOT public.has_permission(array_to_string(v_change.path,'.')) THEN
        RAISE EXCEPTION 'PROFILE_GRANT_DENIED' USING ERRCODE='42501';
      END IF;
    ELSIF NOT public.has_permission('users.permissions.revoke') THEN
      RAISE EXCEPTION 'PROFILE_REVOKE_DENIED' USING ERRCODE='42501';
    END IF;
  END LOOP;
  IF NEW.id<>v_actor AND
     (NEW.email,NEW.first_name,NEW.last_name,NEW.display_name) IS DISTINCT FROM
     (v_before.email,v_before.first_name,v_before.last_name,v_before.display_name) AND
     NOT public.has_permission('users.edit') THEN
    RAISE EXCEPTION 'PROFILE_EDIT_DENIED' USING ERRCODE='42501';
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public.protect_profile_authority() FROM PUBLIC, anon, authenticated;
CREATE TRIGGER protect_profile_authority BEFORE INSERT OR UPDATE OR DELETE ON public.profiles
FOR EACH ROW EXECUTE FUNCTION public.protect_profile_authority();

-- Reuse the existing private inbox. Only the validated RPC accepts public submissions.
ALTER TABLE public.contact_messages ADD COLUMN status text NOT NULL DEFAULT 'new'
  CHECK (status IN ('new','read','archived'));
ALTER TABLE public.contact_messages ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
UPDATE public.contact_messages SET status='read' WHERE is_read;
ALTER TABLE public.contact_messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS contact_public_insert ON public.contact_messages;
DROP POLICY IF EXISTS contact_admin_read ON public.contact_messages;
DROP POLICY IF EXISTS contact_admin_update ON public.contact_messages;
DROP POLICY IF EXISTS contact_admin_delete ON public.contact_messages;
REVOKE ALL ON public.contact_messages FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.contact_messages TO authenticated;
GRANT UPDATE(status) ON public.contact_messages TO authenticated;
CREATE POLICY contact_inbox_read ON public.contact_messages FOR SELECT TO authenticated
  USING (public.has_any_permission(ARRAY['contact.read','contact.manage']));
CREATE POLICY contact_inbox_update ON public.contact_messages FOR UPDATE TO authenticated
  USING (public.has_permission('contact.manage')) WITH CHECK (public.has_permission('contact.manage'));
CREATE INDEX contact_messages_created_at_idx ON public.contact_messages(created_at DESC);
CREATE INDEX contact_messages_email_created_at_idx ON public.contact_messages(sender_email,created_at DESC);

CREATE OR REPLACE FUNCTION public.sync_contact_message_status()
RETURNS trigger LANGUAGE plpgsql SET search_path = pg_catalog AS $$
BEGIN
  NEW.updated_at := now();
  NEW.is_read := NEW.status <> 'new';
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public.sync_contact_message_status() FROM PUBLIC, anon, authenticated;
CREATE TRIGGER sync_contact_message_status BEFORE UPDATE ON public.contact_messages
FOR EACH ROW EXECUTE FUNCTION public.sync_contact_message_status();

CREATE OR REPLACE FUNCTION public.submit_contact_message(
  p_name text, p_email text, p_subject text, p_message text, p_website text, p_submission_id uuid
) RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public, pg_temp AS $$
DECLARE
  v_name text := btrim(p_name);
  v_email text := lower(btrim(p_email));
  v_subject text := btrim(p_subject);
  v_message text := btrim(p_message);
  v_existing public.contact_messages;
BEGIN
  IF p_submission_id IS NULL OR COALESCE(p_website,'')<>'' OR
     v_name IS NULL OR length(v_name) NOT BETWEEN 2 AND 120 OR
     v_email IS NULL OR length(v_email)>254 OR v_email !~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$' OR
     v_subject IS NULL OR length(v_subject) NOT BETWEEN 3 AND 160 OR
     v_message IS NULL OR length(v_message) NOT BETWEEN 10 AND 5000 THEN
    RAISE EXCEPTION 'CONTACT_INVALID_INPUT' USING ERRCODE='22023';
  END IF;
  -- Serialize acceptance and limits, including concurrent retries with the same UUID.
  PERFORM pg_advisory_xact_lock(728104621);
  SELECT * INTO v_existing FROM public.contact_messages WHERE id=p_submission_id;
  IF FOUND THEN
    IF (v_existing.sender_name,v_existing.sender_email,v_existing.subject,v_existing.message)
       IS DISTINCT FROM (v_name,v_email,v_subject,v_message) THEN
      RAISE EXCEPTION 'CONTACT_SUBMISSION_CONFLICT' USING ERRCODE='22023';
    END IF;
    RETURN v_existing.id;
  END IF;
  IF (SELECT count(*) FROM public.contact_messages WHERE sender_email=v_email AND created_at>now()-interval '1 hour')>=3 OR
     (SELECT count(*) FROM public.contact_messages WHERE created_at>now()-interval '1 hour')>=100 THEN
    RAISE EXCEPTION 'CONTACT_RATE_LIMIT' USING ERRCODE='P0001';
  END IF;
  INSERT INTO public.contact_messages(id,sender_name,sender_email,subject,message)
    VALUES(p_submission_id,v_name,v_email,v_subject,v_message);
  RETURN p_submission_id;
END;
$$;
REVOKE ALL ON FUNCTION public.submit_contact_message(text,text,text,text,text,uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.submit_contact_message(text,text,text,text,text,uuid) TO anon, authenticated;

-- ============================================================
-- MLPN - Migracja 011: Funkcje bazodanowe
-- Generate Round Robin, inne utility functions
-- ============================================================


-- ============================================================
-- GENEROWANIE TERMINARZA (double round-robin)
-- Obsluguje dowolna liczbe druzyn (parzysta i nieparzysta)
-- Wywolanie: SELECT generate_round_robin('season-uuid', 'league-uuid', '2025-04-05');
-- ============================================================
CREATE OR REPLACE FUNCTION public.generate_round_robin(
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
    IF auth.uid() IS NULL OR NOT public.has_any_permission(ARRAY['schedule.edit','seasons.generate']) THEN
        RAISE EXCEPTION 'SCHEDULE_ACCESS_DENIED' USING ERRCODE='42501';
    END IF;
    -- Pobierz druzyny z season_teams
    SELECT ARRAY_AGG(st.team_id ORDER BY t.name)
    INTO v_teams
    FROM season_teams st
    JOIN teams t ON t.id = st.team_id
    WHERE st.season_id = p_season_id AND st.league_id = p_league_id;

    v_team_count := COALESCE(array_length(v_teams, 1), 0);

    IF v_team_count < 2 THEN
        RAISE EXCEPTION 'Potrzeba minimum 2 druzyn, znaleziono: %', v_team_count;
    END IF;

    -- Dla nieparzystej liczby druzyn - dodaj "BYE" (NULL)
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

    -- ====== PIERWSZA RUNDA (single round-robin) ======
    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
            -- Wyznacz pare
            IF v_round % 2 = 0 THEN
                v_home := v_list[v_i];
                v_away := v_list[v_effective_count + 1 - v_i];
            ELSE
                v_home := v_list[v_effective_count + 1 - v_i];
                v_away := v_list[v_i];
            END IF;

            -- Pomin pary z BYE (NULL)
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

        -- Rotacja (pierwszy element staly, reszta rotuje)
        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    -- ====== REWANZ (swap home/away) ======
    -- Reset listy
    v_list := v_teams;

    FOR v_round IN 1..v_rounds LOOP
        v_match_date := p_start_date + ((v_rounds + v_round - 1) * 7);

        FOR v_i IN 1..v_half LOOP
            -- Swap home/away wzgledem pierwszej rundy
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

        -- Ta sama rotacja
        v_last := v_list[v_effective_count];
        FOR v_i IN REVERSE v_effective_count..3 LOOP
            v_list[v_i] := v_list[v_i - 1];
        END LOOP;
        v_list[2] := v_last;
    END LOOP;

    -- Zaktualizuj total_rounds w season_leagues
    UPDATE season_leagues
    SET total_rounds = v_rounds * 2
    WHERE season_id = p_season_id AND league_id = p_league_id;

    -- Zwroc wynik
    matches_created := v_match_count;
    rounds_total := v_rounds * 2;
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public, pg_temp;


-- ============================================================
-- INICJALIZACJA STANDINGS
-- Tworzy puste rekordy standings dla wszystkich druzyn w lidze
-- Wywolanie: SELECT initialize_standings('season-uuid', 'league-uuid');
-- ============================================================
CREATE OR REPLACE FUNCTION public.initialize_standings(
    p_season_id UUID,
    p_league_id UUID
)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    IF auth.uid() IS NULL OR NOT public.has_any_permission(ARRAY['schedule.edit','seasons.generate']) THEN
        RAISE EXCEPTION 'SCHEDULE_ACCESS_DENIED' USING ERRCODE='42501';
    END IF;
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public, pg_temp;

REVOKE ALL ON FUNCTION public.generate_round_robin(uuid,uuid,date) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.initialize_standings(uuid,uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.generate_round_robin(uuid,uuid,date) TO authenticated;
GRANT EXECUTE ON FUNCTION public.initialize_standings(uuid,uuid) TO authenticated;

-- The 2026 withdrawal exception is also used by the season administration tools.
UPDATE public.season_leagues sl SET relegation_spots=1
FROM public.seasons s, public.leagues l
WHERE sl.season_id=s.id AND sl.league_id=l.id AND s.year=2026 AND l.code='1st';
UPDATE public.season_leagues sl SET promotion_spots=3
FROM public.seasons s, public.leagues l
WHERE sl.season_id=s.id AND sl.league_id=l.id AND s.year=2026 AND l.code='3rd';
