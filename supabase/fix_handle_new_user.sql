-- ============================================================
-- NAPRAWA: Trigger handle_new_user()
-- Wklej to w SQL Editor i kliknij Run
-- ============================================================

-- 1. Usuń stary trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 2. Odtwórz funkcję z jawnym search_path
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, role, display_name)
    VALUES (
        NEW.id,
        'viewer',
        COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- 3. Nadaj uprawnienia
GRANT USAGE ON SCHEMA public TO supabase_auth_admin;
GRANT ALL ON public.profiles TO supabase_auth_admin;

-- 4. Odtwórz trigger
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();
