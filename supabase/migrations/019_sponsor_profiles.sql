-- Rozszerzenie sponsorow o dane profilu publicznego i kategorie ekspozycji.
ALTER TABLE sponsors
  ADD COLUMN IF NOT EXISTS category TEXT NOT NULL DEFAULT 'sponsor',
  ADD COLUMN IF NOT EXISTS profile_slug TEXT,
  ADD COLUMN IF NOT EXISTS short_description TEXT,
  ADD COLUMN IF NOT EXISTS facebook_url TEXT,
  ADD COLUMN IF NOT EXISTS instagram_url TEXT,
  ADD COLUMN IF NOT EXISTS contact_email TEXT,
  ADD COLUMN IF NOT EXISTS phone TEXT,
  ADD COLUMN IF NOT EXISTS cta_label TEXT;

CREATE UNIQUE INDEX IF NOT EXISTS idx_sponsors_profile_slug
  ON sponsors (profile_slug)
  WHERE profile_slug IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_sponsors_category_order
  ON sponsors (category, display_order)
  WHERE is_active = true;
