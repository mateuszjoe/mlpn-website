-- ============================================================
-- MLPN - Polityki Storage (buckety na zdjęcia)
-- Wklej to w SQL Editor AFTER creating buckets in Dashboard
-- ============================================================

-- Team logos - publiczny odczyt, admin zapis
CREATE POLICY "team_logos_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'team-logos');

CREATE POLICY "team_logos_admin_insert" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'team-logos' AND is_admin());

CREATE POLICY "team_logos_admin_update" ON storage.objects
  FOR UPDATE USING (bucket_id = 'team-logos' AND is_admin());

CREATE POLICY "team_logos_admin_delete" ON storage.objects
  FOR DELETE USING (bucket_id = 'team-logos' AND is_admin());

-- Player photos - publiczny odczyt, admin zapis
CREATE POLICY "player_photos_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'player-photos');

CREATE POLICY "player_photos_admin_insert" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'player-photos' AND is_admin());

CREATE POLICY "player_photos_admin_update" ON storage.objects
  FOR UPDATE USING (bucket_id = 'player-photos' AND is_admin());

CREATE POLICY "player_photos_admin_delete" ON storage.objects
  FOR DELETE USING (bucket_id = 'player-photos' AND is_admin());
