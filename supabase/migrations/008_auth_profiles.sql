-- ============================================================
-- MLPN - Migracja 008: Auth & Profiles
-- Profiles (rozszerzenie auth.users), Helper Functions
-- ============================================================

-- PROFILES (rozszerzenie Supabase auth.users)
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
-- HELPER FUNCTIONS (uzywane w RLS policies)
-- ============================================================

-- Czy zalogowany user jest adminem?
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role = 'admin'
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- Czy zalogowany user jest adminem lub editorem?
CREATE OR REPLACE FUNCTION is_editor_or_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role IN ('admin', 'editor')
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- Zwraca player_id zalogowanego usera (lub NULL)
CREATE OR REPLACE FUNCTION get_my_player_id()
RETURNS UUID AS $$
    SELECT player_id FROM profiles
    WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- ============================================================
-- AUTO-CREATE PROFILE on user signup
-- Supabase auth trigger - tworzy profil automatycznie
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

-- Trigger na auth.users
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
