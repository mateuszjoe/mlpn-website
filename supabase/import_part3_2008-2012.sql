-- Import archiwum MLPN 2008-2012
-- Uruchom PO part1_setup.sql

-- === I liga 2008 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2008 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '16:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '17:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '17:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '15:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '16:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '17:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '16:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '15:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '16:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '16:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '15:00', 2, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '16:20', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '17:40', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '15:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '15:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '16:20', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '17:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '16:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '15:00', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '15:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-17', '18:15', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-27', '18:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '17:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '16:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '17:40', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '16:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '15:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '16:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '17:40', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '15:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '16:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '17:40', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '16:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '15:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '17:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-25', '16:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-10-10', '18:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-24', '18:00', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-07', '15:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-07', '16:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-07', '17:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-13', '15:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-13', '16:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-13', '18:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '15:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '17:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '15:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '15:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '16:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '16:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '17:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '15:00', 5, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '16:20', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '17:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '15:00', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '16:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '17:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '15:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '16:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '17:40', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '16:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '17:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '18:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt Anwa-Tech' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '17:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '18:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MBM Kebab' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '16:00', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA Squad' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KERAM Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '17:20', 5, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '18:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2008 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2008 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '11:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '12:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '11:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '13:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '11:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '12:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '12:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '11:00', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '13:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '11:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '12:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '11:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '12:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '11:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '12:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '13:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '11:00', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '13:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '11:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '11:00', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '12:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '11:00', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '12:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '11:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '12:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '13:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '11:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '11:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '13:40', 12, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '11:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '12:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '11:00', 0, 4, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '12:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '12:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '13:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '12:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '13:40', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '11:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '12:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '12:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '13:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '12:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-07', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-30', '18:30', 0, 6, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-07', '12:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-06', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-06', '13:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-06', '12:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '13:40', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '11:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-28', '12:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '15:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-11-02', '16:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '13:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '12:20', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '13:40', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '12:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '11:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '13:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-11-02', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '11:00', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '12:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '13:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '12:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '12:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '11:00', 2, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '13:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '12:20', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '11:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '12:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '11:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '13:40', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '13:40', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '14:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '13:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '12:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '13:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '11:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '14:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '13:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '12:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '14:40', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '13:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Filmweb.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '12:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2008 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2008 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '07:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '08:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-05', '09:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '07:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '08:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2008-04-06', '09:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '07:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-12', '09:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '08:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2008-04-13', '09:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-19', '09:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '07:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2008-04-20', '09:40', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '07:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '08:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-26', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '07:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '08:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2008-04-27', '09:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '08:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-10', '09:40', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '08:20', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2008-05-11', '09:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '07:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '08:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-17', '09:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '07:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '08:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2008-05-18', '09:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '07:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-24', '09:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '07:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '08:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2008-05-25', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '07:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-05-31', '09:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '07:00', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '08:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2008-06-01', '09:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '07:00', 13, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '08:20', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-07', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '07:00', 0, 17, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2008-06-08', '09:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '08:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-14', '09:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '08:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2008-06-15', '09:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '07:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '08:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-21', '09:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '07:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '08:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2008-06-22', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '07:00', 12, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', '09:40', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '09:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-24', '08:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2008-08-23', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '09:40', 5, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', '08:20', 0, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-30', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '07:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2008-08-31', '09:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-07', '11:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-11-06', '19:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-06', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-06', '11:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-06', '09:40', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2008-09-06', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '09:40', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '08:20', 0, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-14', '07:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-10-14', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-10-23', '18:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2008-09-13', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '09:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '08:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '09:40', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-21', '07:00', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2008-09-20', '07:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '09:40', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '08:20', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-28', '07:00', 2, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', '08:20', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2008-09-27', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '08:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-05', '09:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '08:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2008-10-04', '07:00', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '09:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '08:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-12', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '08:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2008-10-11', '09:40', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-19', '08:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2008-10-18', '07:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '10:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '09:20', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-26', '08:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '09:40', 2, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2008-10-25', '07:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Polutil Rządza' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Szakale Józefin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kortbud Okuniew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '09:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-09', '10:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '10:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '09:20', 4, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2008-11-08', '08:00', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2009 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2009 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '16:00', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '18:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '16:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '17:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '17:40', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '15:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '16:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '17:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '16:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '15:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '17:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '16:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '15:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-07', '18:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '18:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '17:40', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '15:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '15:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '17:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '15:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '16:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '15:00', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '17:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '15:00', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '16:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '17:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '15:00', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '16:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '15:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '16:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '15:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '16:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '17:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '16:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '17:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-22', '15:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-22', '16:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-22', '17:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '15:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '17:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '16:20', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '17:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '15:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '17:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '17:40', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '15:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '16:20', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '16:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '16:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '16:20', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '17:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-26', '15:00', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-26', '16:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-26', '17:40', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '16:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '17:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '15:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '16:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '17:40', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '15:00', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '17:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '15:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '17:40', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-17', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-23', '18:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-22', '18:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '16:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '17:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '18:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '15:00', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate-Palmolive Poland' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '16:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Los Torpedos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '17:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '18:40', 8, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Derejn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-07', '16:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-07', '17:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-07', '18:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2009 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2009 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '12:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '13:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '14:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '12:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '11:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '12:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '13:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '11:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '11:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '13:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '12:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '12:20', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '13:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '11:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '12:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '12:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '13:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '12:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '11:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '12:20', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '13:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '11:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '12:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '11:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '12:20', 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '13:40', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '12:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '11:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '11:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '12:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '13:40', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '12:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '12:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '13:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-22', '11:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-22', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-22', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '12:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '12:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '13:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '11:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '13:40', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '11:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '12:20', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '13:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '11:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '12:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '13:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '11:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '12:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '13:40', 3, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '12:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '13:40', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '11:00', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-26', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-26', '12:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-26', '13:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '13:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '11:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '12:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '13:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '11:00', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '11:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '12:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '13:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '11:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '12:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-17', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-17', '12:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-17', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '12:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '13:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '14:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '11:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '12:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '12:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '13:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '14:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Devils Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-07', '12:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FIFA&Ślimak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-07', '13:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-07', '14:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2009 (11 drużyn, 100 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2009 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '08:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '09:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-28', '10:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '08:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2009-03-29', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '07:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-04', '09:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2009-04-05', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '08:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-18', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '08:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2009-04-19', '09:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-25', '09:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '07:00', 6, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2009-04-26', '09:40', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '07:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-09', '09:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '08:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2009-05-10', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-16', '09:40', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '07:00', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '08:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2009-05-17', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '08:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-23', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '07:00', 1, 20, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '08:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2009-05-24', '09:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '07:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-30', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '07:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2009-05-31', '09:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '08:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-06', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '07:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '08:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2009-06-07', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '07:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '08:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-13', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '08:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2009-06-14', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '08:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-20', '09:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '07:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '08:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2009-06-21', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '07:00', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '08:20', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-23', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2009-08-22', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '08:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-30', '09:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '08:20', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2009-08-29', '09:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '08:20', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-06', '09:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '08:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2009-09-05', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-13', '09:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '08:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2009-09-12', '09:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '08:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-20', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '07:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '08:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2009-09-19', '09:40', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '08:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-26', '07:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2009-09-27', '09:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '08:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-04', '09:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '08:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2009-10-03', '09:40', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '09:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-11', '08:20', 2, 16, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '08:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2009-10-10', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '09:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-17', '07:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2009-10-18', '07:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '09:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-25', '10:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2009-10-24', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '09:20', 9, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '10:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-08', '14:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2009-11-07', '10:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2010 (13 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2010 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '15:00', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '16:20', 6, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '17:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-04', '15:00', 0, 16, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-04', '16:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-04', '17:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '16:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '15:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '16:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '15:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '16:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '17:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '17:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '17:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '17:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '16:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '15:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '16:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '17:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-06-10', '17:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-29', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-29', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '15:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '15:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '16:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '17:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '17:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '15:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '16:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '15:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '15:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '16:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '17:40', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '15:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '16:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '17:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Inter Trade' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '15:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '16:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-28', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-09-03', '18:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-28', '17:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '15:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '17:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '15:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '16:20', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '16:20', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '16:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '17:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '16:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '17:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '15:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '16:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '16:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', '16:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', '17:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-03', '15:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-03', '16:20', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-03', '17:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '17:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '15:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '16:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '15:00', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '17:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-17', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-17', '16:20', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-17', '17:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'P&V' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '16:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', '15:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-31', '16:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-31', '17:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-31', '18:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '15:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '16:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '17:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'P&V' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '16:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '17:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Colgate Palmolive' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '18:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', '17:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', '18:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2010 (14 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2010 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'WMR' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '12:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '13:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-04', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-08-21', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-04', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-07-04', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '12:20', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '13:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '11:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '12:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '11:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WMR' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '13:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WMR' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '13:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '13:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '11:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WMR' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '13:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '11:00', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WMR' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '13:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '11:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '12:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-29', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-29', '12:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-29', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WMR' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WMR' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '13:40', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '11:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '12:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '13:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '12:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '11:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '12:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WMR' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Slimak.com.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '13:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '13:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '11:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '12:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '13:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '12:20', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '13:40', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '11:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '13:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '11:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '12:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '13:40', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-28', '11:00', 13, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-28', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-28', '13:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '11:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-10', '17:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '11:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '12:20', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '11:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '12:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '11:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '11:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '12:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '13:40', 17, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '11:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '11:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '12:20', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', '12:20', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-03', '11:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-03', '12:20', 16, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '12:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '11:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '12:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '13:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '11:00', 14, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-17', '11:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-17', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '11:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', '12:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-31', '12:00', 23, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-31', '14:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '11:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '12:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '13:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '12:00', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '13:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '14:40', 4, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', '12:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pradziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Majtom' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', '13:20', 0, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2010 (11 drużyn, 110 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2010 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-04-10', '07:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '09:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-04', '08:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-04', '09:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2010-07-03', '08:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '07:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '08:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-21', '09:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '08:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2010-08-22', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '07:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-24', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '07:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '08:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2010-04-25', '09:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '07:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-08', '09:40', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '07:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '08:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2010-05-09', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-15', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '08:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2010-05-16', '09:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '08:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-22', '09:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '07:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '08:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2010-05-23', '09:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-29', '07:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-29', '09:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '07:00', 9, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2010-05-30', '09:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '07:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '07:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-05', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '08:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2010-06-06', '09:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '08:20', 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-12', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '07:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '08:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2010-06-13', '09:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '08:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-19', '09:40', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '08:20', 1, 18, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2010-06-20', '09:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '08:20', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-26', '09:40', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '08:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2010-06-27', '09:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '07:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '08:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-29', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-28', '08:20', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2010-08-28', '09:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '07:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '08:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-05', '09:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '08:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2010-09-04', '09:40', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '09:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '07:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-12', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2010-09-11', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '08:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '07:00', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-19', '09:40', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '08:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2010-09-18', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '08:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-26', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2010-09-25', '09:40', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-03', '08:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-03', '09:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '07:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '08:20', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Repra' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2010-10-02', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '08:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-10', '09:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '08:20', 24, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2010-10-09', '09:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-17', '08:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '07:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-17', '09:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2010-10-16', '09:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '08:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-24', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', '09:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2010-10-23', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-31', '09:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'MDT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-31', '10:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '08:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2010-10-30', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samogray' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '09:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-07', '10:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Repra' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', '09:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'MDT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2010-11-06', '10:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2011 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2011 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '15:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '16:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '16:20', 6, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '15:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '16:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '17:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '17:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '15:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '17:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '16:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '17:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '15:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '17:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '16:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '17:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '15:00', 1, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '15:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '17:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-25', '18:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '15:00', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '17:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '16:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '16:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-26', '17:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-26', '16:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-26', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '16:20', 0, 5, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-03', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-03', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-03', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '17:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '16:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '15:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '17:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '15:00', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '17:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '17:40', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '17:40', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-22', '18:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '15:00', 4, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '17:40', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '15:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '17:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '17:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '16:20', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-08', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-20', '18:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-08', '15:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '16:20', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '15:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '17:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '16:20', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '15:00', 14, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '17:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '17:40', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', '17:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '18:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '17:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '16:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '17:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'San Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '16:00', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Marino' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-06', '18:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-06', '17:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-06', '16:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2011 (13 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2011 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '13:40', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '12:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '12:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '11:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '11:00', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '12:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '11:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '13:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '12:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '11:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '13:40', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '12:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '11:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '11:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '11:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '13:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '12:20', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '11:00', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '12:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '12:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '12:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '11:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '12:20', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '13:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '12:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '11:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '12:20', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '13:40', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '12:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '11:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '11:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '12:20', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-26', '13:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-26', '12:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Husaria Hipolitów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-22', '18:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '13:40', 18, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '12:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '11:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '13:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '12:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '12:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-03', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-03', '12:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-03', '11:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '12:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '11:00', 0, 4, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '12:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '11:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '12:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '11:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '12:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '11:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '13:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '12:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '12:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '11:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-08', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-23', '07:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-08', '11:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '13:40', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '12:20', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '11:00', 11, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '13:40', 17, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '12:20', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '13:40', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '12:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '12:20', 0, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '13:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '12:20', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', '13:40', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', '12:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '14:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '13:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '12:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '14:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '13:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '12:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zakręt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-06', '14:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Drink Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-06', '13:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2011 (13 drużyn, 110 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2011 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-03', '08:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '08:20', 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2011-04-02', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-10', '08:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '09:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '08:20', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2011-04-09', '07:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '08:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-17', '07:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '09:40', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2011-04-16', '08:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '09:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-08', '08:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '09:40', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '08:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2011-05-07', '07:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-15', '08:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '09:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2011-05-14', '07:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '08:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-22', '07:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '09:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2011-05-21', '08:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '07:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '08:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-29', '07:00', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '09:40', 14, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2011-05-28', '08:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '09:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-05', '08:20', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '09:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '08:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2011-06-04', '07:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-12', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '09:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2011-06-11', '08:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '09:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-19', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '08:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2011-06-18', '07:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-26', '09:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '08:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wichura' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-07-07', '12:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Samograj' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-25', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2011-06-26', '08:20', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '09:40', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-27', '08:20', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-09-29', '16:30', 13, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '08:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2011-08-28', '07:00', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-10-02', '07:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-03', '08:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2011-09-04', '07:00', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-10', '08:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '08:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-09-11', '09:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2011-10-09', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '09:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-17', '08:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '09:40', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '08:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2011-09-18', '07:00', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '09:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-24', '08:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '09:40', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2011-09-25', '07:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '09:40', 6, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-01', '07:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '09:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2011-10-02', '08:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-08', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-08', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-08', '07:00', 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '09:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2011-10-09', '08:20', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '09:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-15', '08:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '09:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '08:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2011-10-16', '07:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '09:40', 16, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '08:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-22', '07:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '09:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2011-10-23', '08:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Bałtyk Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', '11:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-29', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '10:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '09:20', 0, 7, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2011-10-30', '08:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '10:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '09:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Putka Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-05', '08:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-06', '12:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2011-11-06', '10:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2012 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2012 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '16:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '17:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '15:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '16:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '15:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '15:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '17:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '17:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '15:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '15:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '16:20', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '17:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '17:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '16:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '16:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '16:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '17:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-19', '15:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-19', '16:20', 2, 19, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-19', '17:40', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '15:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '16:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '17:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '15:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '15:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '17:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '15:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '16:20', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '17:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '17:40', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '14:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-08-19', '18:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '15:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '16:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '17:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '17:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '17:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '16:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '15:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '16:20', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '17:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '16:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '17:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '15:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '16:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '17:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '15:00', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '17:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '15:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '16:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '16:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '17:40', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '16:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '17:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '16:20', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '18:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-11-10', '12:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-11-10', '14:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '16:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '17:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-27', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Korsarze' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '17:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '18:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '16:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '17:20', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '18:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2012 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2012 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '12:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '13:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '11:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '13:40', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '12:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '11:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '13:40', 5, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '12:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '13:40', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '11:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '13:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '12:20', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '13:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '11:00', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '11:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '12:20', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '13:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-06-24', '06:00', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-19', '12:20', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-19', '13:40', 12, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '11:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '12:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '13:40', 14, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '11:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '12:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '13:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '12:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '13:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '11:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '13:40', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '11:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '12:20', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '10:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '11:50', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '13:10', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '13:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '11:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '12:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '13:40', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '12:20', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '11:00', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '12:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '11:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '12:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '11:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '12:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '13:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '11:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '12:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '13:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '12:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '15:00', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '12:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '12:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '15:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '12:20', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '13:40', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '12:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '13:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '13:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '12:20', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '13:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-27', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-11-10', '10:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-11-10', '11:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '12:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '13:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '14:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '13:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '14:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '16:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '13:20', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Grafix Bis STM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '14:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pomeczu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2012 (12 drużyn, 120 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2012 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '07:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '08:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-03-31', '09:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '08:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2012-04-01', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '08:20', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-14', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '07:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '08:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2012-04-15', '09:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '07:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-21', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '08:20', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2012-04-22', '09:40', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-28', '09:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '07:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '08:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2012-04-29', '09:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '08:20', 8, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-23', '09:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2012-06-24', '09:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '08:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-12', '09:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '07:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2012-05-13', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-06-06', '16:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-06-03', '07:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-06-09', '07:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '08:20', 15, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2012-05-20', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-26', '09:40', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '07:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '08:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2012-05-27', '09:40', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '07:00', 17, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-02', '09:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2012-06-03', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '08:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-09', '09:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '07:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '08:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2012-06-10', '09:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '07:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '09:10', 24, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-16', '06:30', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '08:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2012-06-17', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '08:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-25', '09:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '07:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '08:20', 8, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2012-08-26', '09:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '07:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '08:20', 2, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-01', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '08:20', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '09:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2012-09-02', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '07:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '08:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '08:20', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-09', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2012-09-08', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '08:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-15', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '07:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '08:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2012-09-16', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '07:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '09:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '08:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '09:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-23', '11:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2012-09-22', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '08:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '09:40', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-29', '11:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '07:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '09:40', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2012-09-30', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '09:40', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '11:00', 1, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '07:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '08:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-07', '09:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2012-10-06', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '08:20', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-13', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '11:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2012-10-14', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '09:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '08:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '09:40', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-21', '11:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2012-10-20', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-27', '08:20', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-27', '09:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-27', '11:00', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '09:20', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '10:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2012-10-28', '08:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '09:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '10:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Posch Titanium' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '09:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Centurio' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '10:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Auto-Pol Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kolejniak' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-04', '12:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2012-11-03', '12:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Gotowe! Import 2008-2012 zakończony.