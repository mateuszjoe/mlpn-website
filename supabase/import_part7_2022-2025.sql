-- Import mlpn.pl 2022-2025
-- Uruchom PO part5_setup_2018-2025.sql

-- === I liga 2022 (10 drużyn, 90 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2022 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-26', '18:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-26', '19:10', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '17:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '18:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '19:30', 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-09', '18:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-09', '19:10', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '17:10', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '18:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '19:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-23', '19:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '18:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '19:30', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-25', '20:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-27', '20:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-07', '19:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '19:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '20:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-14', '18:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '17:10', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '18:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '19:30', 9, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-16', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-21', '18:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-21', '19:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '18:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '19:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '20:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '18:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '19:30', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '20:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-30', '20:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-30', '21:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-04', '19:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-05', '17:10', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-05', '18:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-05', '19:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-06', '21:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-11', '19:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '18:20', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '19:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '20:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-13', '21:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-06-26', '19:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-09-03', '17:50', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-09-04', '16:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-09-04', '18:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-09-04', '19:30', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-09-10', '19:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-09-11', '16:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-09-11', '17:10', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-09-11', '18:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-09-11', '19:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-17', '17:50', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-17', '19:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-18', '17:10', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-18', '18:20', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-18', '19:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-24', '19:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-25', '17:10', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-25', '18:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-25', '19:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-25', '20:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-10-02', '16:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-10-02', '17:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-10-02', '18:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-10-02', '19:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-10-09', '16:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-10-09', '17:10', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-10-09', '18:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-10-09', '19:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-15', '19:00', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-16', '16:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-16', '17:10', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-16', '18:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-16', '19:30', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-10-22', '19:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-23', '16:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-23', '17:10', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-23', '18:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-23', '19:30', 9, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-23', '20:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-10-27', '20:30', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-11-05', '19:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-11-05', '20:10', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-11-06', '16:00', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-11-06', '17:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-11-06', '19:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-11-19', '20:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2022 (11 drużyn, 110 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2022 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-26', '15:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-26', '16:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '16:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-09', '15:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-09', '16:50', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '13:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '14:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '16:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-23', '16:20', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '14:50', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '16:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '17:10', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '20:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-07', '15:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '13:40', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '14:50', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-14', '15:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '16:00', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '20:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '13:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '14:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '16:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '17:10', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-23', '20:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-26', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '14:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '17:10', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-06-02', '20:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-06-02', '21:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-04', '17:10', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-05', '13:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-05', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-11', '16:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '13:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '14:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '16:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-13', '20:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-06-19', '14:50', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-06-19', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-06-19', '19:30', 5, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-06-20', '20:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-06-20', '21:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-06-23', '20:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-23', '21:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-06-26', '14:50', 16, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-06-26', '16:00', 15, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-06-26', '17:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-06-26', '18:20', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-06-27', '20:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-06-30', '20:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-30', '21:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-03', '15:30', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-03', '16:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-04', '10:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-04', '14:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-10', '15:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-10', '16:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-10', '17:50', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-11', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-11', '14:50', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-17', '16:40', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-18', '12:30', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-18', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-18', '14:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-18', '16:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-24', '16:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-24', '17:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-25', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-25', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-25', '14:50', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-01', '16:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-01', '17:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-02', '13:40', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-02', '14:50', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-08', '15:30', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-08', '16:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-10-08', '17:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-09', '13:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-09', '14:50', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-09', '20:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-15', '17:50', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-16', '13:40', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-16', '14:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-16', '20:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-20', '20:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-22', '16:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-22', '17:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-23', '12:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-23', '14:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-05', '16:40', 5, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-05', '17:50', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-06', '13:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-06', '14:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-06', '18:20', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '14:50', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '16:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '17:10', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '18:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '19:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-11-14', '21:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-11-17', '20:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-11-17', '21:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-19', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-19', '16:10', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-19', '17:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-19', '18:30', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-19', '19:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2022 (11 drużyn, 100 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2022 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-26', '14:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '09:00', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '10:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2022-03-27', '12:30', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-09', '14:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-04-10', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '10:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '11:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2022-04-10', '12:30', 7, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-23', '15:10', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '10:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '11:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2022-04-24', '12:30', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-04-24', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-05-07', '14:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '10:10', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2022-05-08', '12:30', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '09:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '10:10', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '11:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2022-05-15', '12:30', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '10:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '11:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2022-05-22', '12:30', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-28', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '10:10', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '11:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-05-29', '12:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2022-05-29', '13:40', 12, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-04', '13:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-04', '14:50', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-04', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2022-06-06', '20:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-11', '15:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '10:10', 4, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2022-06-12', '11:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-06-19', '11:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2022-06-19', '12:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-06-26', '09:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-06-26', '10:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-06-26', '11:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-03', '14:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-04', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-04', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-04', '13:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2022-09-04', '17:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-10', '14:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-11', '09:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-11', '10:10', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-11', '11:20', 3, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2022-09-11', '12:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-17', '14:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-17', '15:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-18', '09:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-09-18', '10:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-24', '14:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-24', '15:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-25', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-09-25', '10:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-01', '14:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-01', '15:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-02', '10:10', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-10-02', '11:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-08', '14:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-09', '09:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-09', '10:10', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-09', '11:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2022-10-09', '12:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2022-10-15', '13:10', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-15', '14:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-16', '09:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-16', '10:10', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-10-16', '12:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2022-10-22', '12:40', 1, 19, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-22', '13:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-22', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-23', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-23', '10:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2022-10-23', '11:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-05', '14:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-06', '09:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-06', '10:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-06', '11:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2022-11-06', '12:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2022-11-12', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '09:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '10:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '11:20', 0, 18, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '12:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2022-11-13', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2022-11-14', '20:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putkersi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-19', '13:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-20', '10:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2022-11-20', '11:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-20', '11:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2022-11-20', '12:50', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2023 (10 drużyn, 90 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2023 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-25', '18:20', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-25', '19:30', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '16:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '17:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '19:30', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-01', '16:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-01', '17:40', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '18:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '19:30', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '20:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-15', '18:20', 5, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-15', '19:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '18:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '19:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-22', '18:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '17:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '18:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '19:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-06', '17:10', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-06', '18:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-06', '19:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '18:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-13', '18:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-13', '19:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '18:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '19:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-20', '19:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '17:10', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '18:20', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '19:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-27', '18:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '17:10', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '18:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '19:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-03', '19:30', 4, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '17:10', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '19:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '20:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-06-18', '19:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-06-20', '20:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-06-20', '21:00', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-06-25', '20:30', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-28', '20:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-09-02', '18:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-09-02', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-09-03', '18:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-09-03', '19:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-09-03', '20:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-09-09', '18:30', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-09-10', '18:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-09-10', '19:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-09-16', '18:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-09-16', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-09-17', '19:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-09-17', '20:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-23', '18:30', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-24', '17:10', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-24', '18:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-30', '18:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-30', '19:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-10-01', '17:10', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-10-01', '18:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-10-01', '19:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-10-07', '16:10', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-10-07', '18:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-10-07', '19:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-10-08', '19:30', 7, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-10-08', '20:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-10-14', '18:30', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-10-14', '19:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-10-15', '18:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-10-15', '19:30', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-10-15', '20:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-10-21', '18:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-22', '17:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-22', '18:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-22', '19:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-22', '20:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-10-28', '17:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-10-28', '18:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-10-28', '19:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-28', '20:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-11-04', '18:20', 16, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-11-04', '19:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-11-04', '20:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-11-05', '18:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dar Mar' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-11-05', '19:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-11-05', '20:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-11-19', '16:00', NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2023 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2023 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-25', '17:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '12:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '14:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '18:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '20:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-01', '14:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-01', '15:20', 17, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '14:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '16:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '17:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-15', '16:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '13:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '14:50', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '16:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-22', '17:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '13:40', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '14:50', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '20:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-06', '14:50', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-06', '16:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '14:50', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '17:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-13', '17:10', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '13:40', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '17:10', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '20:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-20', '17:10', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '14:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '20:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '12:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '13:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '14:50', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '20:30', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-03', '14:50', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-03', '16:00', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-03', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '14:50', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '16:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-14', '21:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-17', '17:10', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-17', '18:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-17', '19:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-18', '11:20', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-18', '12:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-06-18', '20:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-06-21', '20:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-21', '21:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '16:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '17:10', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '18:20', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '19:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-06-28', '21:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-06-29', '20:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '17:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '18:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '19:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '20:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-02', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-02', '17:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '13:40', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '14:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '16:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '17:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-09', '13:50', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-09', '16:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-10', '14:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-10', '16:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-13', '20:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-16', '14:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '14:50', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '16:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '17:10', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '18:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-23', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-23', '16:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-23', '17:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-24', '14:50', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-24', '16:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-24', '20:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-09-28', '20:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-09-30', '16:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-09-30', '17:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-01', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-01', '14:50', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-01', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-07', '13:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-07', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '14:50', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '17:10', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '18:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-11', '19:50', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-10-11', '20:45', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-14', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-14', '16:10', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-14', '17:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-15', '16:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-15', '17:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-18', '20:45', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-21', '14:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-21', '16:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-21', '17:10', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-22', '13:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-22', '14:50', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-22', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-10-28', '16:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-04', '14:50', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-04', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-04', '17:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '14:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '17:10', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-11-09', '20:45', NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '15:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '16:35', 5, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '17:40', NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '18:45', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '19:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '20:55', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2023 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2023 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-25', '14:50', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-25', '16:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '09:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '10:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2023-03-26', '11:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-01', '13:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '10:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '11:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2023-04-02', '12:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-15', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-15', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '09:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '10:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2023-04-16', '11:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-22', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-22', '14:50', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '09:00', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '10:10', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2023-04-23', '11:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-06', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-06', '20:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '09:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '10:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2023-05-07', '12:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '09:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '10:10', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '11:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-05-14', '12:30', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-20', '14:50', 2, 19, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '09:00', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '10:10', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '11:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2023-05-21', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-27', '13:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-27', '14:50', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '09:00', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '10:10', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2023-05-28', '11:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-03', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '09:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '10:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-04', '11:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2023-06-14', '20:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-17', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-17', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-18', '09:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-06-18', '10:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '09:00', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '10:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '11:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '12:30', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2023-06-25', '13:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '10:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '11:20', 17, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '12:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '13:40', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2023-08-27', '14:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-02', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-02', '14:50', 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '09:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '10:10', 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '11:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2023-09-03', '12:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-09', '12:40', 1, 20, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-10', '09:00', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-10', '11:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-10', '12:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-09-10', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2023-09-10', '20:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-16', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '10:10', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '11:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2023-09-17', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-23', '13:50', 0, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-24', '10:10', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-24', '11:20', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-24', '12:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-09-24', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-09-26', '20:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-09-30', '13:50', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-01', '09:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-01', '10:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-10-01', '12:30', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-07', '12:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2023-10-07', '20:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '09:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '10:10', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '11:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '12:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2023-10-08', '13:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-14', '13:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-15', '09:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-15', '10:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-15', '11:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-15', '12:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2023-10-15', '13:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-21', '13:50', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2023-10-21', '19:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-22', '11:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-22', '12:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-28', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-28', '14:50', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2023-10-29', '10:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2023-10-29', '11:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-04', '13:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '09:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '10:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '11:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '12:30', 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2023-11-05', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2023-11-09', '19:50', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '09:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '10:05', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '11:10', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '12:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '13:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2023-11-12', '14:25', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2024 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2024 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-23', '17:50', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '18:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '19:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '20:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-06', '18:10', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-06', '19:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-13', '18:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-13', '19:10', 13, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '18:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '19:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '20:35', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-15', '19:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-20', '19:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-20', '20:10', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '18:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '20:35', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-22', '19:50', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-27', '19:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-04-27', '20:05', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '18:20', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '19:30', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-05-06', '19:50', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-11', '18:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-11', '19:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '18:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '19:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-13', '19:50', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-05-13', '20:50', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-18', '19:10', 12, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '18:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '19:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-25', '19:10', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '18:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '19:30', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '20:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-27', '20:50', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-06-08', '19:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-06-08', '20:10', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-15', '18:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-15', '19:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '18:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '19:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '20:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-22', '18:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '18:20', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '19:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '20:30', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-06-30', '15:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-30', '16:30', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-08-31', '17:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-08-31', '18:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-08-31', '19:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '20:35', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-07', '18:00', 14, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '18:20', 9, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '19:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-09', '19:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-14', '17:50', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-14', '19:00', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '18:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '20:35', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-21', '18:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-22', '20:35', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-23', '20:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-28', '19:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '17:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '19:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '20:35', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-30', '19:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-10-05', '19:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '18:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '19:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-10-06', '20:35', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-10-07', '19:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-07', '20:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-12', '17:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-12', '19:00', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '18:20', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '19:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '20:35', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-19', '16:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-19', '19:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '19:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '20:35', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-21', '19:50', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-10-21', '20:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-26', '18:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-26', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '17:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '18:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '19:30', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-10-27', '20:35', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-09', '18:00', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '17:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '18:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '19:30', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '20:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '-przerwa-' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-11-16', '19:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '18:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '19:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '20:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-18', '19:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-11-18', '20:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '14:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '16:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '17:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '18:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '19:50', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-11-27', '20:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2024 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2024 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-23', '15:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-23', '16:40', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '16:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '17:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-06', '15:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-06', '17:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-08', '20:50', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-13', '15:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-13', '16:50', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '13:40', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '16:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-20', '15:30', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-20', '16:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '17:10', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-27', '15:30', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-27', '16:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '17:10', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-11', '15:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-11', '16:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '17:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-18', '16:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-18', '18:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '16:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-05-20', '20:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-22', '19:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-22', '20:50', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-25', '15:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-25', '16:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '16:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '17:10', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-05-27', '20:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-06-03', '20:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-15', '17:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '13:30', 2, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-22', '15:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '14:50', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '16:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '17:10', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-06-29', '20:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-30', '13:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-30', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-07-03', '20:50', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-07-28', '19:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-08-31', '15:50', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '12:30', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '18:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '14:50', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '16:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-09', '20:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '13:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '14:50', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '16:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '17:10', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-21', '17:10', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-22', '12:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-22', '18:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-22', '19:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '16:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '18:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-10-02', '20:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-05', '15:10', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-05', '16:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '16:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '17:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'xxx' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '14:50', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '16:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '17:10', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '14:50', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '16:00', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '17:10', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-23', '20:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-26', '17:10', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '14:50', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '16:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-09', '16:50', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '12:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '14:50', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-16', '16:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-16', '17:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '14:50', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '16:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'przerwa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'xxx' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-23', '16:50', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '12:30', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '13:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2024 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2024 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-23', '14:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '09:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '10:10', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '11:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-03-24', '12:30', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-06', '13:30', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-06', '14:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-08', '19:50', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-13', '14:30', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '10:10', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '11:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-04-14', '12:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-04-15', '20:50', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-20', '14:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '09:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '10:10', 12, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '11:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '12:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2024-04-21', '19:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-27', '13:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-27', '14:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '09:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '10:10', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '11:20', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2024-04-28', '12:30', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-05-06', '20:50', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-11', '14:40', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '09:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '10:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '11:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '12:30', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2024-05-12', '20:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-18', '13:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-18', '14:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '09:00', 0, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '10:10', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-05-19', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2024-05-20', '19:50', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-25', '13:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '09:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '11:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-26', '12:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2024-05-27', '19:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2024-06-03', '19:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-08', '14:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-06-08', '15:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2024-06-08', '16:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '08:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '10:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '11:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-06-16', '12:20', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-22', '14:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '09:00', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '10:10', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '11:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '12:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2024-06-23', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2024-06-30', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '09:00', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '10:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '11:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '14:50', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2024-09-01', '19:30', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-07', '14:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '09:00', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '11:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-09-08', '12:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-14', '15:30', 0, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-14', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '09:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '11:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2024-09-15', '12:30', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-21', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-21', '14:50', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-21', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-22', '09:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-22', '10:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2024-09-22', '11:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2024-09-23', '19:50', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-28', '15:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-09-28', '16:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-09-29', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '10:10', 5, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-09-29', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '09:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '10:10', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '11:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '12:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '13:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2024-10-06', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-12', '15:30', 12, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-12', '16:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '09:00', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '10:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '11:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2024-10-13', '12:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-10-14', '19:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2024-10-14', '20:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-19', '15:30', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '10:10', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '11:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2024-10-20', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-26', '14:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-26', '16:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '09:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '10:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2024-10-27', '11:20', 13, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-10-28', '19:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-04', '19:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-09', '15:30', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '09:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '10:10', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2024-11-10', '11:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-11-16', '15:30', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '09:00', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '10:10', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '11:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2024-11-17', '12:30', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Zerzeńskie Pegazy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Podbudowani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-23', '14:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2024-11-23', '15:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '10:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2024-11-24', '11:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2025 (10 drużyn, 90 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2025 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-15', '18:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '17:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '18:10', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '19:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '20:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-03-22', '18:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-03-23', '17:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-03-23', '18:10', 8, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-03-23', '19:20', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-03-23', '20:30', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-29', '17:30', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-29', '18:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '18:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '19:20', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-05', '17:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-05', '18:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-06', '18:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-06', '19:30', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-06', '20:30', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-12', '18:20', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-13', '17:10', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-13', '18:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-13', '19:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-13', '20:30', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-04-26', '18:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-04-27', '18:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-04-27', '19:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-04-27', '20:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-10', '18:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-11', '17:00', 5, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-11', '18:10', 1, 16, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-11', '19:20', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-18', '19:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-05-25', '16:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-05-25', '17:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-05-25', '18:20', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-05-25', '19:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-05-25', '20:30', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-07', '17:50', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '17:10', 6, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '18:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '19:30', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '20:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-06-15', '19:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-06', '17:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-07', '17:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-07', '18:10', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-07', '19:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-07', '20:30', 5, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-13', '17:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-13', '18:30', 14, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-14', '18:20', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-14', '19:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-14', '20:35', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-21', '17:10', 8, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-21', '19:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-21', '20:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-28', '17:10', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-28', '19:30', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-28', '20:35', 5, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-29', '20:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-05', '17:10', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-05', '18:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-05', '19:30', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-06', '20:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-11', '18:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-12', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-12', '17:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-12', '19:30', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-13', '20:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-18', '18:30', 0, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-19', '17:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-19', '18:20', 5, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-19', '19:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-19', '20:30', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-10-20', '20:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-25', '17:10', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-25', '18:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-26', '17:10', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-26', '19:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-10-27', '19:50', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-27', '20:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-08', '19:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-09', '16:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-09', '17:10', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Al Mar Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-09', '18:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-09', '20:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-11-16', '18:50', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-11-16', '19:50', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2025 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2025 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-15', '15:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-15', '16:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-15', '17:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '14:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '15:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-03-22', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-03-23', '13:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-03-23', '14:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-03-23', '15:50', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '12:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '13:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '14:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '15:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '17:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-04-06', '12:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-04-06', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-04-06', '16:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-04-06', '17:10', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-12', '17:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-13', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-13', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-13', '14:50', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-13', '16:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-26', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-27', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-27', '14:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-27', '16:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-10', '16:10', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-10', '17:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-11', '13:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-11', '14:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-11', '15:50', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-05-18', '17:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-05-21', '20:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-24', '14:30', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-25', '13:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-25', '14:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-01', '14:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-01', '16:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-01', '17:10', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-01', '18:20', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-01', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-06-02', '20:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '12:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '13:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-08', '16:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-06-11', '20:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-06-15', '14:50', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-06-15', '16:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-06-15', '17:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-06-15', '18:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-06-22', '15:50', 5, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-06-23', '20:30', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-09-03', '20:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-06', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-07', '13:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-07', '14:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-07', '15:50', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-13', '16:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-14', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-14', '14:50', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-14', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-09-20', '16:10', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-09-20', '17:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-09-21', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-09-21', '14:50', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-09-21', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-24', '20:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-09-28', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-09-28', '14:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-05', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-05', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-05', '20:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-11', '17:10', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-12', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-12', '14:50', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-14', '20:00', 2, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-18', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-10-18', '17:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-10-19', '13:40', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-10-19', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-10-19', '16:00', 6, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2025-10-25', '16:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2025-10-26', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-26', '14:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2025-10-26', '16:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-10-29', '20:45', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2025-11-03', '20:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2025-11-05', '20:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2025-11-08', '16:50', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-11-08', '18:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2025-11-09', '12:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2025-11-09', '13:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2025-11-12', '19:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2025-11-12', '20:45', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2025-11-13', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'wolne miejsce II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2025-11-16', '13:10', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2025-11-16', '14:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2025-11-16', '15:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '1 Warszawska Brygada Pancerna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2025-11-16', '16:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2025-11-16', '17:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2025-11-18', '20:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2025 (10 drużyn, 90 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2025 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '10:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '11:10', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '12:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2025-03-16', '13:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-03-22', '15:10', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-03-23', '10:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-03-23', '11:10', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2025-03-23', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-29', '15:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-29', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '10:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2025-03-30', '11:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-04-06', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-04-06', '11:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-04-12', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-12', '16:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-13', '09:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-13', '10:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2025-04-13', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-26', '16:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-27', '09:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-27', '10:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2025-04-27', '11:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-10', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-11', '11:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-18', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2025-05-18', '18:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-25', '09:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-25', '10:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-05-25', '11:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2025-06-01', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-07', '15:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-08', '09:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-08', '10:10', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2025-06-08', '11:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2025-06-15', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-06', '15:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-07', '10:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-07', '11:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-09-07', '12:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-13', '15:00', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-14', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-14', '10:10', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-14', '11:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-20', '15:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-21', '09:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-21', '10:10', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-09-21', '12:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-28', '09:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-28', '10:10', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-28', '11:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-09-29', '19:45', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2025-09-30', '20:30', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-04', '14:50', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-05', '09:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-05', '10:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-05', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2025-10-05', '12:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-11', '16:10', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-12', '09:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-12', '10:10', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-12', '11:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2025-10-13', '19:50', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-19', '09:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-19', '10:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-19', '11:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-20', '19:50', 17, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2025-10-25', '15:00', 0, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-26', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-26', '10:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-26', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-26', '12:30', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2025-10-26', '20:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2025-11-03', '19:50', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc KSS' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-08', '14:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Faludża' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-08', '15:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-09', '10:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-09', '11:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'STM FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2025-11-09', '19:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2025-11-16', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'AL-Komat' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Es Chobot Meat' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2025-11-16', '12:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Gotowe! Import 2022-2025 zakończony.