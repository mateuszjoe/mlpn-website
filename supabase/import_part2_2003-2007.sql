-- Import archiwum MLPN 2003-2007
-- Uruchom PO part1_setup.sql

-- === I liga 2003 (16 drużyn, 198 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2003 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2003-05-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dragon''s' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młode Żółwie Ninja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KKP Grabaż' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, NULL, NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, NULL, NULL, 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, NULL, NULL, 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, NULL, NULL, 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, NULL, NULL, 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, NULL, NULL, 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, NULL, NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, NULL, NULL, 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, NULL, NULL, 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, NULL, NULL, 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pogoń Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Siwe Bobki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, NULL, NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, NULL, NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2003 (7 drużyn, 36 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2003 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Phenian Club' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2003-09-07', NULL, 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Phenian Club' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2003-09-07', '14:00', 0, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2003-09-07', NULL, 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2003-08-23', NULL, 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2003-08-23', '10:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Phenian Club' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2003-08-23', NULL, 13, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Phenian Club' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2003-08-17', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2003-08-17', NULL, 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2003-08-17', '14:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, 15, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Phenian Club' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2003-08-30', NULL, 0, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Phenian Club' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2003-08-30', NULL, 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2003-08-30', '10:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2003-09-06', '14:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2003-09-06', NULL, 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2003-09-06', NULL, 0, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2003-09-14', NULL, 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Phenian Club' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2003-09-14', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2003-09-14', '12:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2003-10-12', NULL, 14, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2003-10-12', '06:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2003-10-05', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2003-10-05', '10:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 0, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2003-10-04', NULL, 20, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2003-10-04', '14:30', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2003-10-19', '09:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KP Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2003-10-19', NULL, 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2003-10-19', NULL, 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2003-09-21', NULL, 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2003-09-21', '11:00', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2004 (12 drużyn, 121 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2004 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-05-04', NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-05-04', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-05-04', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-05-04', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-05-04', NULL, 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-05-04', NULL, 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-24', NULL, 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-24', NULL, 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-24', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-24', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-24', NULL, 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-24', NULL, 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-01', NULL, 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-01', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-01', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-01', NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-01', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-01', NULL, 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-08', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-08', NULL, 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-08', NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-08', NULL, 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-08', NULL, 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-08', NULL, 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-15', NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-15', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-15', NULL, 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-15', NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-15', NULL, 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-15', NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-08-20', '13:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-08-20', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-08-20', NULL, 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-08-20', NULL, 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-08-20', NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-08-27', '13:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-08-28', '13:00', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-08-29', '13:00', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-08-29', '13:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-08-29', '13:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-09-04', '08:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-09-04', '12:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-09-04', '14:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-09-05', '08:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-09-05', '15:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-09-11', '09:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-09-11', '10:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-09-11', '12:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-09-11', '15:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-09-12', '13:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-09-19', '07:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-09-19', '12:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-09-19', '13:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-09-19', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-09-26', '14:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-25', '10:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-26', '10:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-26', '11:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-26', '13:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-29', '15:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-10-02', '13:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-10-03', '08:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-10-03', '11:30', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-10-06', '14:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-10-10', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-10-08', '14:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-10-09', '14:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-10-10', '09:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-10-10', '14:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-10-17', '13:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-10-16', '08:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-10-16', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-10-17', '14:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-10-24', '12:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-10-30', '06:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-23', '12:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-24', '06:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-24', '07:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-24', '09:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-30', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-30', '10:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zabraniec' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-30', '12:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-31', '07:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-31', '09:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-31', '13:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2004 (14 drużyn, 169 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2004 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', '15:30', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', '15:30', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2004-04-03', NULL, 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2004-04-18', NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2004-04-18', '07:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2004-04-18', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2004-04-18', NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2004-04-18', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2004-04-18', NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2004-04-18', NULL, 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-25', NULL, 0, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-25', NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-25', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-25', NULL, 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-25', NULL, 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-25', NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2004-04-25', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-03', '13:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-03', NULL, 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-03', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-03', NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-03', NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-03', NULL, 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2004-05-03', NULL, 0, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-09', NULL, 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-09', NULL, 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-09', NULL, 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-09', NULL, 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-09', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-09', NULL, 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2004-05-09', '13:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-16', NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-16', '10:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-16', NULL, 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-16', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-16', NULL, 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-16', NULL, 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2004-05-16', NULL, 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', '13:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2004-05-22', NULL, 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2004-05-30', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2004-05-30', NULL, 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2004-05-30', '13:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2004-05-30', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2004-05-30', NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2004-05-30', NULL, 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2004-05-30', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2004-06-06', NULL, 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2004-06-06', NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2004-06-06', NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2004-06-06', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2004-06-06', '13:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2004-06-06', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2004-06-06', NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2004-06-10', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2004-06-10', NULL, 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2004-06-10', NULL, 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2004-06-10', '13:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2004-06-10', NULL, 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2004-06-10', NULL, 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2004-06-10', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2004-06-13', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2004-06-13', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2004-06-13', NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2004-06-13', '13:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2004-06-13', NULL, 13, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2004-06-13', NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2004-06-13', NULL, 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-06-19', NULL, 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-06-19', NULL, 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-06-19', NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-06-19', NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-06-19', '13:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-06-19', NULL, 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2004-06-19', NULL, 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-06-26', NULL, 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Belfast' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-06-26', NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-06-26', '12:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-06-26', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-06-26', NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-06-26', NULL, 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2004-06-26', NULL, 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-08-16', NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-08-16', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-08-16', NULL, 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-08-16', NULL, 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-08-16', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2004-08-16', '17:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-05-22', NULL, 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-08-22', '13:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-05-22', NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-05-22', NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-05-22', NULL, 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2004-05-22', NULL, 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-08-28', '13:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-08-28', '13:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-08-29', '13:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-08-29', '13:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-08-29', '13:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2004-08-29', '13:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-04', '15:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-05', '09:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-05', '11:00', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-05', '12:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-05', '14:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2004-09-06', '15:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-09-11', '07:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-09-11', '13:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-09-12', '09:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-09-12', '10:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-09-12', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2004-09-12', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-09-17', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-09-18', '13:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-09-18', '15:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-09-19', '09:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-09-19', '10:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2004-09-27', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-09-25', '11:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-09-25', '13:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-09-25', '14:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-09-26', '07:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-09-26', '08:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2004-10-07', '14:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-01', '14:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-02', '11:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-02', '14:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-03', '07:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-03', '10:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2004-10-03', '13:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-09', '08:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-09', '12:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-10', '06:30', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-10', '08:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-10', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2004-10-21', '14:15', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2004-10-16', '14:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2004-10-17', '08:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2004-10-17', '09:30', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2004-10-17', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2004-10-17', '12:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2004-10-19', '14:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2004-10-23', '07:30', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2004-10-23', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2004-10-23', '10:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2004-10-23', '13:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2004-10-24', '10:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2004-10-24', '13:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2004-10-30', '07:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2004-10-30', '13:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2004-10-31', '10:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2004-10-31', '12:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Global' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2004-11-06', '10:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2004-11-06', '12:00', 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Global' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2004-11-06', '09:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2004-11-06', '13:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2004-11-07', '08:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2004-11-07', '10:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2004-11-07', '11:30', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2004-11-07', '13:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2005 (13 drużyn, 133 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2005 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-16', '11:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-16', '12:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-16', '15:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-17', '06:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-17', '08:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-17', '09:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-23', '11:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-23', '15:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-24', '09:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-24', '14:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-24', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-05-01', '11:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-04-30', '13:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-04-30', '16:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-05-01', '14:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-05-06', '16:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-05-14', '16:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-05-15', '10:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-03', '06:30', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-03', '08:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-03', '12:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-03', '14:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-03', '15:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-03', '16:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-07', '12:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-07', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-08', '10:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-08', '12:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-08', '13:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-08', '16:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-13', '16:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-14', '13:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-14', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-15', '12:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-15', '15:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-15', '16:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-21', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-21', '14:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-21', '15:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-21', '17:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-22', '09:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-22', '12:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-29', '08:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-29', '09:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-29', '11:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-29', '14:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-29', '15:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-06-04', '08:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-05-03', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-05-04', '14:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-05-04', '15:30', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-05-05', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-05-05', '12:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-05-05', '15:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-10', '17:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '10:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '13:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '14:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-16', '16:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-18', '08:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-18', '14:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-19', '08:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-19', '12:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-19', '14:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-24', '17:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-22', '17:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Viking' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-26', '11:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-26', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-26', '14:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-26', '15:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-26', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'C Klasa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-06-30', '17:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-01', '17:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-03', '09:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-03', '11:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-03', '14:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Viking' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-03', '17:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-27', '14:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-28', '08:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-28', '11:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-28', '14:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-28', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-04', '08:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-04', '14:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-04', '10:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-04', '16:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-01', '16:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-10', '15:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-17', '15:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-11', '12:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-11', '14:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-11', '09:45', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-18', '12:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-18', '08:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-18', '14:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-13', '15:45', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-24', '13:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-25', '10:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-24', '10:45', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-25', '09:15', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-25', '13:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-10-01', '13:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-02', '12:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-02', '15:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-02', '06:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-02', '07:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-02', '09:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-08', '10:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-09', '08:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-08', '13:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-09', '14:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-09', '11:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-16', '11:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-23', '12:50', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-16', '12:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-15', '09:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-23', '14:10', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-22', '10:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-23', '09:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-22', '09:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-22', '12:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-23', '11:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-29', '14:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-30', '12:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-29', '08:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-30', '11:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Szlachecka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-30', '14:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-06', '12:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-06', '13:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-05', '11:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-05', '09:50', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-05', '13:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2005 (13 drużyn, 144 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2005 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-16', '08:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-16', '14:00', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-17', '11:00', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-17', '12:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-17', '14:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2005-04-17', '15:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-23', '06:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-23', '12:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-23', '14:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-24', '08:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-24', '11:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2005-04-24', '12:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-04-28', '16:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-04-30', '07:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-04-30', '08:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-04-30', '14:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-05-01', '10:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2005-05-01', '13:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-07', '10:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-07', '13:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-07', '16:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-08', '07:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-08', '09:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2005-05-08', '15:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-13', '15:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-15', '07:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-15', '09:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-15', '13:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-19', '16:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2005-05-20', '16:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-21', '07:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-21', '12:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-22', '07:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-22', '10:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-22', '13:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2005-05-22', '16:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-26', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-26', '12:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-26', '14:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-26', '15:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-26', '17:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2005-05-29', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-28', '14:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-28', '15:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-28', '17:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-29', '06:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-05-29', '12:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2005-06-09', '17:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-06-03', '17:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-06-04', '17:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-06-05', '08:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-06-05', '09:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-06-05', '14:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2005-06-05', '17:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-10', '16:00', 2, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '07:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '08:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '11:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-12', '17:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2005-06-16', '17:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-18', '15:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-18', '17:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-19', '09:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-19', '11:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-19', '15:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2005-06-19', '17:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-22', '15:45', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-23', '17:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-25', '09:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-25', '15:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-25', '17:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2005-06-26', '09:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-06-29', '16:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-06-29', '17:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-01', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-02', '14:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Cyganka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-03', '12:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2005-07-03', '15:30', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-27', '16:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-28', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-28', '10:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-28', '13:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-30', '15:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2005-08-31', '16:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-04', '11:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-04', '13:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-03', '14:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-02', '16:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-03', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2005-09-03', '08:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-11', '15:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-10', '07:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-11', '11:15', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-09', '16:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-10', '14:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2005-09-10', '08:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-18', '06:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-18', '15:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-25', '15:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-17', '14:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-18', '09:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2005-09-18', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-25', '12:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-25', '06:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-25', '07:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-24', '15:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-23', '15:15', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2005-09-24', '12:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-02', '10:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-01', '12:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-09-30', '15:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-01', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-02', '13:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2005-10-01', '09:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-08', '11:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-16', '14:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-09', '13:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-09', '10:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-08', '14:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2005-10-09', '07:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-15', '08:15', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-15', '11:15', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-15', '14:15', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-15', '12:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-16', '09:45', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2005-10-19', '18:15', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-23', '07:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-23', '06:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-23', '10:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-22', '11:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-31', '14:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2005-10-22', '14:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-30', '10:00', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-28', '14:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-29', '12:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-31', '11:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-30', '07:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2005-10-30', '08:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-06', '09:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-06', '08:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-05', '12:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-06', '11:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-11-06', '07:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2005-08-13', '12:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2006 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2006 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-08', '10:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-09', '15:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-09', '10:45', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-09', '06:15', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-09', '13:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-09', '09:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-22', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-19', '16:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-22', '14:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-29', '07:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-23', '08:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-23', '10:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '07:15', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '06:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-28', '16:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-29', '16:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '10:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '16:15', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-18', '17:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-06', '10:45', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-07', '12:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-07', '16:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-06', '13:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-07', '09:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-13', '12:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-14', '17:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-14', '08:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-14', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-13', '17:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-14', '14:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-21', '13:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-20', '14:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-26', '17:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-21', '08:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-21', '11:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-20', '16:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-06-22', '16:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-06-08', '16:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-06-15', '17:45', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-27', '11:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-27', '13:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-27', '14:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-06-04', '14:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-06-05', '17:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-06-03', '14:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-06-08', '17:45', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-06-04', '13:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-06-03', '16:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-10', '17:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-11', '13:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-10', '14:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-11', '11:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-10', '16:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-11', '17:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-14', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-17', '16:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-18', '16:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-22', '17:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-21', '17:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-18', '14:45', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-25', '11:45', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-25', '16:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-24', '16:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-25', '17:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-24', '07:15', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-25', '07:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-08-20', '08:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-08-29', '18:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-08-20', '15:10', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-09-05', '18:30', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-08-20', '12:30', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-09-15', '16:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-08-27', '08:15', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-08-27', '09:35', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-08-27', '06:55', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-08-27', '13:35', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-08-27', '14:55', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-08-27', '12:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-09-03', '14:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-09-03', '10:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-09-03', '09:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-09-02', '14:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-09-03', '08:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-09-02', '13:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-09-10', '09:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-09-10', '15:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-09-09', '14:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-09-10', '11:40', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-09-20', '18:45', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-09-10', '14:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-09-17', '14:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-09-17', '07:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-09-17', '13:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-09-17', '15:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-09-16', '14:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-09-17', '10:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-09-24', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-09-23', '14:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-09-26', '18:30', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-09-23', '12:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-09-24', '14:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-09-24', '12:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-10-01', '07:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-09-30', '15:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-10-01', '13:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-10-05', '14:30', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-10-01', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-10-01', '09:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-10-07', '14:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-10-03', '18:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-10-08', '10:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-10-08', '14:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-10-07', '13:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-10-08', '13:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-10-19', '14:15', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-10-15', '14:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-10-13', '18:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-10-14', '08:50', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-10-15', '06:10', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-10-15', '12:50', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-10-22', '14:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-10-22', '06:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-10-22', '07:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-10-22', '18:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-10-22', '10:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-10-22', '12:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-10-29', '19:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-10-29', '10:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-10-28', '08:40', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-10-29', '14:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-10-29', '07:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-10-29', '08:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2006 (16 drużyn, 240 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2006 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-07', '15:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-09', '07:45', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-20', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-09', '12:15', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-08', '09:15', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-08', '13:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-08', '07:45', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2006-04-08', '12:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-23', '11:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-22', '08:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-22', '13:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-23', '13:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-23', '16:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-21', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-23', '14:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2006-04-22', '11:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-29', '10:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '13:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '11:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-29', '11:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-29', '14:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '08:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-27', '16:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2006-04-30', '14:45', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-15', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-09', '16:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-01', '13:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-02', '15:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-12', '14:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-01', '10:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-02', '16:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2006-05-19', '17:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-03', '07:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-03', '16:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-11', '15:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-03', '06:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-03', '12:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-03', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-03', '13:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2006-05-11', '16:45', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-05', '15:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-06', '16:45', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-07', '15:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-07', '10:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-06', '15:15', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-07', '13:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-06', '12:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2006-05-13', '14:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-12', '16:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-13', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-14', '15:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-14', '12:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-13', '11:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-14', '09:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-13', '15:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2006-05-14', '06:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-21', '07:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-24', '17:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-21', '17:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-21', '10:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-21', '14:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-21', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-20', '17:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2006-05-22', '16:45', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-05-27', '10:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-05-27', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-04', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-05-26', '16:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-06', '17:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-07-02', '11:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-05-27', '17:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2006-06-16', '16:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-02', '17:30', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-04', '10:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-03', '17:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-02', '16:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-04', '17:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-01', '17:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-09', '17:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2006-06-04', '07:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-09', '15:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-11', '08:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-11', '10:15', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-11', '14:45', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-10', '13:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-10', '08:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-11', '07:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2006-06-11', '16:15', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-16', '17:45', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-15', '16:15', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-15', '11:45', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-13', '17:45', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-14', '17:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-15', '13:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-15', '14:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2006-06-15', '07:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-17', '17:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-17', '14:45', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-18', '11:45', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-18', '13:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-18', '07:15', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-17', '11:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-20', '17:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2006-06-18', '17:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-25', '10:15', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-25', '14:45', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-25', '08:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-25', '13:15', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-24', '10:15', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-24', '14:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-24', '08:45', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2006-06-24', '17:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-07-02', '17:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-06-30', '17:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-06-30', '16:15', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-07-02', '13:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-06-28', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-06-29', '17:30', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-07-02', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2006-07-01', '08:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-06', '11:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-06', '15:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-06', '13:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-17', '16:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-10', '16:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-06', '14:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-05', '14:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2006-08-06', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-13', '12:45', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-13', '16:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-13', '14:05', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-13', '15:25', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-13', '11:25', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-12', '15:25', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-12', '14:05', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2006-08-12', '16:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '08:45', 0, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '14:05', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '11:25', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '07:25', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '12:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '15:25', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '10:05', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2006-08-15', '16:45', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-08-20', '09:50', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-08-25', '16:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-08-19', '13:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-08-20', '16:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-08-20', '11:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-08-19', '11:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-09-06', '15:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2006-08-20', '13:50', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-27', '16:15', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-26', '10:55', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-26', '12:15', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-26', '13:35', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-26', '14:55', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-26', '16:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-26', '09:35', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2006-08-27', '10:55', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-03', '12:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-03', '16:00', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-02', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-03', '06:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-02', '12:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-02', '10:40', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-02', '09:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2006-09-03', '13:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-10', '13:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-10', '10:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-09', '09:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-09', '15:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-09', '13:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-10', '07:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-09', '10:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2006-09-12', '16:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-30', '13:40', 8, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-16', '11:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-17', '09:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-28', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-16', '10:20', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-16', '09:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-16', '13:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2006-09-17', '11:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-23', '10:00', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-23', '15:20', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-24', '15:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-23', '08:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-24', '07:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-24', '10:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-24', '08:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2006-09-23', '11:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-09-30', '08:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-09-30', '11:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-09-30', '12:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-10-01', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-10-01', '12:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-09-30', '07:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-10-01', '08:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 25, '2006-09-30', '09:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-08', '11:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-08', '07:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-07', '11:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-08', '06:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-07', '10:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-07', '07:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-08', '09:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 26, '2006-10-07', '09:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-14', '10:10', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-14', '12:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-14', '14:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-15', '08:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-15', '07:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-14', '11:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-15', '11:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 27, '2006-10-15', '10:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-21', '08:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-21', '10:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-22', '08:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-21', '07:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-21', '12:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-22', '11:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-21', '14:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 28, '2006-10-21', '11:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-29', '12:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-28', '12:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-28', '14:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-28', '10:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-28', '11:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-28', '06:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-29', '11:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 29, '2006-10-28', '07:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bravado' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-04', '10:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-04', '12:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-05', '10:40', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-05', '12:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-04', '13:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-05', '08:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-05', '13:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 30, '2006-11-05', '09:20', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2007 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2007 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-14', '15:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '17:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '09:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '12:45', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-14', '17:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '08:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '11:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '13:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '10:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '14:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '16:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '09:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '06:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '17:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '12:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '08:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-05', '16:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '07:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '10:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '08:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '17:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-12', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '15:15', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-12', '18:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-12', '16:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '16:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '13:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '16:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '09:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-19', '12:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-19', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-19', '18:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '18:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '14:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-26', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '17:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '13:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-26', '13:30', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '18:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '12:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '15:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '13:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '16:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '10:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '11:00', 18, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '16:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '12:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '15:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '09:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-17', '16:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-17', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-17', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-17', '12:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-17', '13:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-17', '09:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-24', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-24', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-24', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-24', '12:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-24', '11:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-24', '09:40', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-26', '13:40', 2, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-26', '15:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-11', '18:30', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-25', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-18', '18:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-25', '16:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-02', '15:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-02', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-02', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-01', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-01', '16:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-01', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-09', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-08', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-08', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-08', '16:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-09', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-09', '15:00', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-15', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-15', '16:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-16', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-16', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-15', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-16', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-22', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-22', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-23', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-23', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-23', '16:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-22', '15:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-11', '14:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-10', '16:00', 4, 17, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-11', '17:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-11', '16:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-10', '17:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-09-29', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-06', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-07', '15:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-06', '15:00', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-07', '16:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-07', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-06', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '15:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '08:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '09:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '13:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '14:20', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-13', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-20', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-20', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-20', '16:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-21', '13:40', 13, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-21', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-19', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-27', '16:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-28', '14:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-23', '18:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-28', '16:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-27', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-27', '15:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki Nieruchomości Belweder' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zakład Mięsny Miśko' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-04', '14:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-04', '16:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pętla Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-03', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-03', '16:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-10-30', '19:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-03', '17:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2007 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2007 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '12:45', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '08:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-14', '15:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '15:45', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-14', '14:15', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-14', '10:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-21', '16:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '14:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-21', '14:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '11:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '10:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '14:45', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-28', '14:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '10:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '11:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-28', '13:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '13:15', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '16:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '12:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '09:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-05', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '13:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '10:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '07:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '16:45', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-12', '16:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-12', '13:45', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '10:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '15:15', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '14:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '17:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '09:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-19', '14:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '12:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-26', '17:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '17:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-26', '15:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '15:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '08:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '11:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '11:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '14:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '15:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '17:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '09:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-02', '17:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '16:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '12:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-16', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-16', '17:40', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-16', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-16', '13:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-16', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-06-16', '11:00', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-23', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-23', '12:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-23', '15:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-23', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-23', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-06-23', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-25', '13:40', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-25', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-26', '11:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-26', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-07', '18:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-08-25', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-02', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-02', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-02', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-01', '11:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-01', '12:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-01', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-08', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-09', '12:20', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-08', '11:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-08', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-08', '13:40', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-09', '09:40', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-16', '12:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-15', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-15', '12:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-15', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-16', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-09-15', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-22', '11:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-22', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-22', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-23', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-23', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-09-23', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-10', '13:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-10', '14:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-11', '10:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-11', '12:00', 0, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-09-29', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-11-10', '12:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-06', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-07', '09:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-06', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-07', '12:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-06', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-06', '12:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '12:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-13', '11:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-13', '12:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-13', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '09:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2007-10-14', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-20', '11:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-20', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-20', '13:40', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-20', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-21', '11:00', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2007-10-21', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-27', '12:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-27', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-27', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-28', '12:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-28', '13:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2007-10-27', '11:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MKS Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-04', '10:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-03', '13:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-03', '14:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-04', '12:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-03', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hydro Instal Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DKL Żurawka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2007-11-04', '13:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2007 (10 drużyn, 85 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2007 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-14', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '14:15', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '09:45', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2007-04-15', '11:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '08:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-22', '13:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-21', '13:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2007-04-21', '11:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-28', '16:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '16:15', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '08:45', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2007-04-29', '07:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '07:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-06', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-05', '12:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2007-05-05', '13:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-12', '15:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '12:15', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '09:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2007-05-13', '13:45', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-19', '11:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-19', '12:30', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '08:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-19', '15:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2007-05-20', '15:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '09:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-26', '12:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '14:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-26', '14:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2007-05-27', '12:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '12:30', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-02', '14:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-02', '12:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-02', '15:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2007-06-03', '08:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '09:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '07:00', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-09', '08:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2007-06-10', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-08-25', '09:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-08-26', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-08-25', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-08-26', '07:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2007-08-25', '08:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-09-01', '09:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-09-02', '07:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-09-02', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-09-01', '13:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2007-09-01', '08:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-09', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-08', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-09', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-08', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2007-09-08', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-16', '08:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-15', '07:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-15', '08:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-15', '09:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2007-09-16', '11:00', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-22', '12:20', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-22', '08:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-22', '09:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-23', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2007-09-23', '08:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-10-27', '08:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-10-27', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-10-28', '10:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-10-28', '09:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2007-11-03', '12:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-10-06', '09:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-10-07', '11:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-10-07', '08:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-10-06', '07:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2007-10-06', '08:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-10-14', '07:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-10-14', '08:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-10-13', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-10-13', '08:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2007-10-13', '09:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'A-Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-21', '08:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-21', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-20', '08:20', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-20', '09:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2007-10-20', '07:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Gotowe! Import 2003-2007 zakończony.