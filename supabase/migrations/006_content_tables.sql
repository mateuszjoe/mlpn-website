-- ============================================================
-- MLPN - Migracja 006: Tabele Content
-- News, Free Agents, Sponsors, Static Pages, Gallery, Contact
-- ============================================================

-- NEWS (aktualnosci)
CREATE TABLE news (
    id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category            TEXT NOT NULL CHECK (category IN ('pauza', 'komunikat', 'wazne')),
    title               TEXT NOT NULL,
    body                TEXT,

    -- Dla kategorii "pauza" - lista zawieszonych zawodnikow
    suspended_players   JSONB,

    -- Powiazanie z meczem (opcjonalne)
    related_match_id    UUID REFERENCES matches(id) ON DELETE SET NULL,

    -- Publikacja
    is_published        BOOLEAN NOT NULL DEFAULT false,
    published_at        TIMESTAMPTZ,

    season_id           UUID REFERENCES seasons(id),
    created_at          TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at          TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_news_published ON news (published_at DESC) WHERE is_published = true;
CREATE INDEX idx_news_category ON news (category, published_at DESC);
CREATE INDEX idx_news_season ON news (season_id, published_at DESC);


-- FREE_AGENTS (wolni zawodnicy - z formularzem publicznym)
CREATE TABLE free_agents (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name            TEXT NOT NULL,
    age             INTEGER,
    positions       TEXT[] NOT NULL,
    region          TEXT,
    experience      TEXT,

    -- Dane kontaktowe (widoczne po zatwierdzeniu)
    phone           TEXT,
    email           TEXT,
    instagram       TEXT,
    facebook        TEXT,

    -- Moderacja
    is_active       BOOLEAN NOT NULL DEFAULT true,
    is_approved     BOOLEAN NOT NULL DEFAULT false,
    submitted_at    TIMESTAMPTZ DEFAULT now(),

    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_free_agents_active ON free_agents (is_active, is_approved)
    WHERE is_active = true AND is_approved = true;


-- SPONSORS
CREATE TABLE sponsors (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name            TEXT NOT NULL,
    logo_url        TEXT,
    website_url     TEXT,
    description     TEXT,
    display_order   INTEGER NOT NULL DEFAULT 0,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_sponsors_active ON sponsors (is_active, display_order)
    WHERE is_active = true;


-- STATIC_PAGES (regulamin, rodo, polityka prywatnosci, o nas)
CREATE TABLE static_pages (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    slug            TEXT NOT NULL UNIQUE,
    title           TEXT NOT NULL,
    content         TEXT NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);


-- GALLERY_ALBUMS (albumy zdjec)
CREATE TABLE gallery_albums (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title           TEXT NOT NULL,
    description     TEXT,
    match_id        UUID REFERENCES matches(id) ON DELETE SET NULL,
    season_id       UUID REFERENCES seasons(id),
    cover_photo_url TEXT,
    is_published    BOOLEAN NOT NULL DEFAULT false,
    published_at    TIMESTAMPTZ DEFAULT now(),
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_gallery_albums_published ON gallery_albums (published_at DESC)
    WHERE is_published = true;
CREATE INDEX idx_gallery_albums_season ON gallery_albums (season_id);
CREATE INDEX idx_gallery_albums_match ON gallery_albums (match_id) WHERE match_id IS NOT NULL;


-- GALLERY_PHOTOS (zdjecia w albumach)
CREATE TABLE gallery_photos (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    album_id        UUID NOT NULL REFERENCES gallery_albums(id) ON DELETE CASCADE,
    photo_url       TEXT NOT NULL,
    caption         TEXT,
    display_order   INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_gallery_photos_album ON gallery_photos (album_id, display_order);


-- CONTACT_MESSAGES (formularz kontaktowy)
CREATE TABLE contact_messages (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sender_name     TEXT NOT NULL,
    sender_email    TEXT NOT NULL,
    subject         TEXT NOT NULL,
    message         TEXT NOT NULL,
    is_read         BOOLEAN NOT NULL DEFAULT false,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX idx_contact_unread ON contact_messages (is_read, created_at DESC)
    WHERE is_read = false;
