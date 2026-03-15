-- ============================================================
-- MLPN - Migracja 016: Synchronizacja e-maili kont admina
-- Dodaje email do profiles, uzupełnia stare konta i pilnuje
-- aktualizacji po zmianie e-maila w Supabase Auth.
-- ============================================================

ALTER TABLE public.profiles
    ADD COLUMN IF NOT EXISTS email TEXT;

CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles (email);

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

CREATE OR REPLACE FUNCTION public.sync_profile_from_auth_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, role, email, display_name)
    VALUES (
        NEW.id,
        'viewer',
        NEW.email,
        COALESCE(NULLIF(NEW.raw_user_meta_data->>'display_name', ''), NEW.email)
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        display_name = COALESCE(NULLIF(EXCLUDED.display_name, ''), public.profiles.display_name, EXCLUDED.email),
        updated_at = now();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, role, email, display_name)
    VALUES (
        NEW.id,
        'viewer',
        NEW.email,
        COALESCE(NULLIF(NEW.raw_user_meta_data->>'display_name', ''), NEW.email)
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        display_name = COALESCE(NULLIF(EXCLUDED.display_name, ''), public.profiles.display_name, EXCLUDED.email),
        updated_at = now();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
CREATE TRIGGER on_auth_user_updated
    AFTER UPDATE OF email, raw_user_meta_data ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.sync_profile_from_auth_user();

GRANT USAGE ON SCHEMA public TO supabase_auth_admin;
GRANT SELECT, INSERT, UPDATE ON public.profiles TO supabase_auth_admin;
