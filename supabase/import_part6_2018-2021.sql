-- Import mlpn.pl 2018-2021
-- Uruchom PO part5_setup_2018-2025.sql

-- === I liga 2018 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2018 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '16:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '17:50', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '19:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '17:10', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '18:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '19:30', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-07', '16:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-07', '17:50', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-07', '19:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '17:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '18:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '19:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '16:40', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '17:50', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '19:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '17:10', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '18:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '19:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-21', '16:40', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-21', '17:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-21', '19:00', 3, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '17:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '18:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '19:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '16:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '17:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '19:00', 0, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '17:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '18:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '19:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '16:40', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '17:50', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '19:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '17:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '18:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '19:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '16:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '17:50', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '19:00', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-27', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-02', '17:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-02', '19:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '17:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '18:20', 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '19:30', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '16:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '17:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '19:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '17:10', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '18:20', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '19:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-16', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-16', '17:50', 11, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-16', '19:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '17:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '18:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '19:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-06-18', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-23', '16:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-23', '17:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-23', '19:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-24', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-24', '17:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-24', '18:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-01', '17:50', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-01', '19:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-02', '17:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-02', '19:00', 3, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-08', '17:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-08', '19:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-09', '17:10', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-09', '18:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-09', '19:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-15', '16:40', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-15', '19:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-16', '18:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-16', '19:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-22', '17:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-22', '19:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-23', '17:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-23', '18:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-23', '19:30', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-29', '17:50', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-29', '19:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-30', '17:10', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-30', '18:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-30', '19:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-06', '19:00', 13, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-07', '17:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-07', '18:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-07', '19:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-13', '17:50', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-13', '19:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-14', '17:10', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-14', '18:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-14', '19:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-20', '17:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-20', '19:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-10-20', '20:05', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-21', '17:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-21', '18:20', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-21', '19:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-27', '17:50', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-27', '19:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-10-27', '20:05', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-28', '17:10', 14, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-28', '18:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-28', '19:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-03', '17:50', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-03', '19:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-11-03', '20:05', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-04', '17:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-04', '18:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-04', '19:30', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-11-07', '20:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-10', '17:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-10', '19:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-11', '17:10', 5, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-11', '18:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-11', '19:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2018 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2018 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '13:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '14:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '15:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '14:50', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '16:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-07', '13:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-07', '14:20', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-07', '15:30', 13, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '13:40', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '14:50', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '16:00', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '13:10', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '14:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '15:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '14:50', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '16:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-21', '13:10', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-21', '14:20', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-21', '15:30', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '16:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-23', '20:40', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '13:10', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '14:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '15:30', 13, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '13:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '14:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '16:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '13:10', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '14:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '15:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '13:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '14:50', 18, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '16:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '13:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '14:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '15:30', 13, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-02', '13:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-02', '14:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-02', '15:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '13:40', 9, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '14:50', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '13:10', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '14:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '15:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '13:40', 5, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '14:50', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '16:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-16', '14:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-16', '15:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '13:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-06-18', '19:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-23', '13:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-23', '14:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-23', '15:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-24', '12:30', 5, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-24', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-25', '19:30', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-07-03', '20:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-01', '13:10', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-01', '14:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-01', '15:30', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-01', '16:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-02', '14:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-09-02', '15:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-08', '14:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-08', '15:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-08', '16:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-09', '14:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-09', '16:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-09-10', '20:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-15', '15:30', 3, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-16', '13:40', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-16', '14:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-16', '16:00', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-16', '17:10', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-17', '20:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-22', '15:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-22', '16:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-23', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-23', '14:50', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-23', '16:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-24', '20:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-29', '14:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-29', '15:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-29', '16:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-30', '13:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-30', '14:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-30', '16:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-10-01', '20:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-10-02', '20:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-06', '14:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-06', '15:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-06', '16:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-07', '13:40', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-07', '14:50', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-10-07', '16:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-10-08', '20:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-13', '14:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-13', '15:30', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-13', '16:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-14', '13:40', 0, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-14', '14:50', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-10-15', '20:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-20', '14:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-20', '15:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-20', '16:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-21', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-21', '14:50', 0, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-21', '16:00', 5, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-10-23', '20:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-27', '14:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-27', '15:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-27', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-28', '13:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-28', '14:50', 5, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-28', '16:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-10-31', '19:15', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-03', '14:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-03', '16:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-04', '13:40', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-04', '14:50', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-11-04', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-10', '14:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-10', '15:30', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-10', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-11', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-11', '14:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-11', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2018 (14 drużyn, 157 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2018 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 13) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 14) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '10:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-24', '12:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '09:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '10:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '11:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-03-25', '12:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-07', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '10:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '11:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-08', '12:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2018-04-13', '20:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '10:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-14', '12:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '09:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '10:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '11:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-04-15', '12:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-21', '12:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '11:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-22', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-04-23', '19:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '10:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-28', '12:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '11:20', 8, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-04-29', '12:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '10:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-12', '12:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '09:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '10:10', 0, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '11:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-05-13', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-05-22', '20:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '10:50', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-26', '12:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-27', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-27', '10:10', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-27', '11:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-05-27', '12:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-02', '10:50', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-02', '12:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '09:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '10:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '11:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-06-03', '12:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '10:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-09', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '09:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '10:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '11:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-06-10', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-16', '10:50', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-16', '12:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '09:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '10:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '11:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2018-06-17', '12:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-22', '20:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-23', '10:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-24', '10:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-06-24', '11:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-06-24', '13:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'D.T. Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox U23' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-01', '12:00', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-02', '09:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-02', '10:50', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-02', '12:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-02', '13:10', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-08', '12:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-08', '13:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-09', '10:10', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-09', '11:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-09', '12:30', 2, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2018-09-09', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-15', '13:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-09-15', '14:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-16', '09:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-16', '10:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-16', '11:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2018-09-16', '12:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2018-09-17', '19:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-09-21', '20:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2018-09-22', '10:50', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-09-22', '12:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-09-22', '13:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-09-23', '09:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-09-23', '10:10', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2018-09-23', '11:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2018-09-23', '12:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2018-09-24', '19:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2018-09-29', '12:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-09-29', '13:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-09-29', '13:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-09-30', '09:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-09-30', '10:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-09-30', '11:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2018-09-30', '12:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-10-01', '19:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-06', '12:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-06', '13:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-07', '09:00', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-07', '10:10', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-07', '12:30', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-10-08', '19:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2018-10-13', '10:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-13', '12:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-13', '13:10', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-14', '10:10', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-14', '11:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-14', '12:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2018-10-14', '16:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2018-10-15', '19:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-10-20', '10:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-10-20', '12:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2018-10-20', '13:10', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-10-21', '09:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-10-21', '10:10', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-10-21', '11:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-10-21', '12:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2018-10-22', '19:45', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2018-10-22', '20:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-10-27', '10:50', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2018-10-27', '12:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-10-27', '13:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-10-28', '09:00', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-10-28', '10:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-10-28', '11:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2018-10-28', '12:30', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2018-10-29', '19:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2018-10-29', '20:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-11-03', '10:50', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-03', '12:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-11-03', '13:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-11-04', '09:00', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-11-04', '10:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-11-04', '11:20', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2018-11-04', '12:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2018-11-05', '19:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 23, '2018-11-05', '20:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2018-11-10', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2018-11-10', '10:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2018-11-10', '12:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2018-11-10', '13:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2018-11-11', '10:10', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2018-11-11', '11:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 24, '2018-11-11', '12:30', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2018-11-12', '19:45', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2018-11-12', '20:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2019 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2019 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-30', '16:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-30', '17:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-30', '19:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '17:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '18:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '19:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '16:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '17:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '19:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '17:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '18:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '19:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-13', '16:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-13', '17:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-13', '19:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '17:10', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '18:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '19:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-27', '16:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-27', '17:50', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-27', '19:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '18:20', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '19:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-11', '17:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-11', '19:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '18:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '19:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-14', '20:30', 11, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-18', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-18', '17:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-18', '19:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '18:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '16:40', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '17:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '19:00', 0, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '18:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '19:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-08', '16:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-08', '19:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-08', '20:05', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '19:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-15', '16:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-15', '17:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '17:10', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '18:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '19:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-18', '19:45', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-25', '20:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '16:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '17:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '19:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '17:10', 12, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '18:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '19:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-08-31', '16:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-08-31', '17:50', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '18:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '19:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-07', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-07', '17:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-07', '19:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '17:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '18:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '19:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-14', '16:40', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '17:10', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '18:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '19:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-21', '17:15', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-21', '18:25', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-21', '19:35', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '17:10', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '18:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-25', '20:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-28', '16:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-28', '17:50', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-28', '19:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '18:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '19:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-05', '17:50', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '17:10', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '18:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '19:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-08', '20:40', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-12', '16:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-12', '17:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-12', '19:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '18:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '19:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-19', '16:40', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-19', '17:50', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '18:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '19:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-24', '20:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-26', '17:50', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-26', '19:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '17:10', 6, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '18:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '19:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-02', '17:50', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-02', '19:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '18:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '19:30', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-07', '20:35', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-09', '16:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-09', '17:50', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-09', '19:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '18:20', 17, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '19:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-11-13', '20:35', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-16', '17:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-16', '19:00', 7, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '17:10', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '18:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '19:30', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-11-18', '20:35', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2019 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2019 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-30', '13:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-30', '14:20', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-30', '15:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '14:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '16:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '10:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '13:10', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '14:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '15:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '14:50', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '16:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-13', '13:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-13', '14:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-13', '15:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '14:50', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '16:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-27', '13:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-27', '14:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-27', '15:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '14:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '16:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-11', '13:10', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-11', '14:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-11', '15:30', 10, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '16:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-13', '20:00', 8, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-18', '13:10', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-18', '14:20', 2, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-18', '15:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '14:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '13:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '14:20', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '15:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '13:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '16:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-08', '13:10', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-08', '14:20', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-08', '15:30', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '16:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-15', '13:10', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-15', '14:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-15', '15:30', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '14:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '16:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '13:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '14:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '15:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '14:50', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '16:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-07-01', '19:45', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-08-31', '13:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-08-31', '14:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-08-31', '15:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '14:50', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '16:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-07', '13:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-07', '14:20', 13, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-07', '15:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '14:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '16:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-14', '13:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-14', '14:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-14', '15:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '14:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '16:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-21', '12:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-21', '13:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-21', '14:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '14:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-28', '13:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-28', '14:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-28', '15:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '13:40', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '14:50', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '16:00', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-05', '14:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-05', '15:30', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '14:50', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '16:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-12', '13:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-12', '14:20', 12, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-12', '15:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '14:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '16:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '17:10', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-19', '14:20', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-19', '15:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '13:40', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '14:50', 0, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '16:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '17:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-26', '14:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-26', '15:30', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-26', '16:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '14:50', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '16:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-02', '14:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-02', '15:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-02', '16:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '14:50', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-11-06', '20:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-11-07', '19:35', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-09', '13:10', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-09', '14:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-09', '15:30', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '14:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '16:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '17:10', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-16', '13:10', 2, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-16', '14:20', 6, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-11-16', '15:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-16', '16:40', 5, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '13:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '14:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2019 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2019 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-30', '12:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '10:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '11:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-03-31', '12:30', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-06', '12:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '10:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '12:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-04-07', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-13', '12:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '09:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '10:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '11:20', 13, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-04-14', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-15', '20:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-04-27', '12:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '10:10', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '11:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-04-28', '12:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-11', '12:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '09:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '11:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2019-05-12', '12:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2019-05-13', '20:50', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-18', '12:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '09:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '11:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-05-19', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2019-05-20', '20:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '12:00', 2, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-25', '20:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '10:10', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '11:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2019-05-26', '12:30', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-05-27', '19:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'No Name' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2019-05-27', '20:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '09:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '10:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '11:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '12:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2019-06-09', '18:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-09', '20:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-15', '12:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '09:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '10:10', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '11:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2019-06-16', '12:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2019-06-24', '19:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '10:50', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-29', '12:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '09:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2019-06-30', '10:10', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-06-30', '11:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '09:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '10:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '11:20', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-09-01', '12:30', 10, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '10:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '11:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-08', '12:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '09:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '10:10', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '11:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-09-15', '12:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-21', '11:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '09:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '10:10', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '11:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2019-09-22', '12:30', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '09:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '10:10', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-29', '12:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2019-09-30', '19:40', 5, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-09-30', '20:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-05', '13:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '09:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '10:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-10-06', '11:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '09:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '10:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '11:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '12:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2019-10-13', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-19', '13:10', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '11:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-20', '12:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-26', '20:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '09:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '10:10', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '11:20', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2019-10-27', '12:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-28', '19:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2019-10-28', '20:45', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2019-10-30', '19:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '10:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '11:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-03', '12:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-08', '19:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '10:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '11:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '12:30', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2019-11-10', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'No Name' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-12', '19:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2019-11-12', '20:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2019-11-13', '19:35', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2019-11-14', '19:35', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2019-11-16', '20:05', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC MBM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '09:00', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '10:10', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '11:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-17', '12:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2019-11-18', '19:35', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2019-11-19', '20:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2020 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2020 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-29', '19:00', 5, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '17:10', 0, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '18:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '19:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '20:40', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-05', '16:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-05', '17:50', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-05', '19:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '17:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '18:20', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '19:30', 1, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-12', '19:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '17:10', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '18:20', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '19:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-09-14', '19:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-19', '16:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-19', '19:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-20', '18:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-20', '19:50', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-22', '20:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-26', '16:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-26', '17:50', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-26', '19:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '19:30', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '20:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-03', '17:50', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-03', '19:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-10-03', '20:00', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '18:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '20:40', 4, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-10', '16:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-10', '17:50', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-10', '19:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-11', '19:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-17', '16:40', 1, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-17', '17:50', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-17', '19:00', 9, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '18:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '19:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-24', '17:50', 5, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-24', '19:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '17:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '18:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '19:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-25', '20:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-07', '16:40', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-07', '17:50', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-07', '19:00', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '18:20', 8, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '19:30', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-11-08', '20:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-14', '16:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-14', '17:50', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-14', '19:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '18:20', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '19:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panpierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KOMINKI SIM – Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Bartycka 04' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2020 (12 drużyn, 121 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2020 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-29', '16:40', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-29', '17:50', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '13:40', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '14:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '16:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-05', '14:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-05', '15:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '13:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '14:50', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '16:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '17:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-12', '15:30', 12, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-12', '16:40', 6, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-12', '17:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '14:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '16:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-14', '20:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-19', '14:20', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-19', '15:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-19', '17:50', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-20', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-26', '14:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-26', '15:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '14:50', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '17:10', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '18:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-28', '20:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-03', '15:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-03', '16:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '17:10', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-10', '14:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-10', '15:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-11', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-11', '17:10', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-11', '18:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-17', '14:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-17', '15:30', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '14:50', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '16:00', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-10-19', '20:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-20', '19:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-20', '20:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-24', '12:00', 9, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-24', '13:10', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-24', '15:30', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '13:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '14:50', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '16:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-07', '14:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-07', '15:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '14:50', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '16:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '17:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-11-09', '19:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-11-09', '20:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-14', '14:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-14', '15:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '13:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '14:50', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '16:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '17:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-11-16', '20:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Legion' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2020 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2020 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-29', '14:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-29', '15:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '09:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '10:10', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '11:20', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2020-08-30', '12:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-05', '13:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '10:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '11:20', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-06', '12:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2020-09-12', '12:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-12', '14:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '09:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '10:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '11:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2020-09-13', '13:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-19', '13:10', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-20', '09:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-20', '10:10', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-20', '11:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2020-09-20', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '10:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '11:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-09-27', '13:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-03', '14:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '10:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '11:20', 6, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2020-10-04', '12:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-10', '13:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-11', '09:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-11', '10:10', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-11', '11:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2020-10-15', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-17', '13:10', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '09:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '10:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2020-10-18', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-24', '14:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '09:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '10:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '11:20', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2020-10-25', '12:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2020-10-26', '20:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-07', '13:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '09:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '10:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2020-11-08', '12:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-14', '13:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '09:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '10:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '11:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2020-11-15', '12:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziady' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc International' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Sulejówek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2021 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2021 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 12) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-24', '17:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-24', '18:10', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-24', '19:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '17:10', 14, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '18:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '19:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-08', '18:10', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '17:10', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '18:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '20:35', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-15', '18:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-15', '19:20', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '17:10', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '18:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '19:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-22', '18:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-22', '19:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '17:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '18:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '19:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '20:35', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-29', '17:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-29', '18:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-29', '19:20', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '18:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '19:30', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '20:35', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-12', '17:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-12', '19:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '18:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '19:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-19', '17:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '17:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '18:20', 14, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '19:30', 5, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '20:35', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-26', '17:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-26', '18:10', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-26', '19:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '17:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '18:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-28', '18:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '17:10', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '18:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '19:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-04', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-04', '18:10', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-04', '19:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '18:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '19:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-18', '19:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '16:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '17:10', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '18:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '19:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-25', '19:20', 6, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '16:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '17:10', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '18:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '19:30', 4, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-02', '18:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-02', '19:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '17:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '19:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-09', '19:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-10-09', '20:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '16:00', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '18:20', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '19:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-16', '18:10', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-16', '19:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '17:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '18:20', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '19:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-23', '18:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-23', '19:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '17:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '18:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '19:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-11-03', '20:50', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-06', '18:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-06', '19:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '18:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '19:30', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '20:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-11-10', '20:50', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-13', '19:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '17:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '18:20', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '19:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-20', '19:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-21', '16:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-21', '17:10', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-21', '18:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-21', '19:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-24', '20:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-27', '17:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-11-27', '18:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-28', '17:10', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-28', '18:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-28', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-28', '20:35', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-04', '18:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-04', '19:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-05', '18:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-05', '19:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-05', '20:35', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-11', '17:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Magnatt.eu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent P.T.' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-11', '18:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-11', '19:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-12', '15:50', 8, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-12', '17:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2021 (11 drużyn, 121 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2021 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 11) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-24', '14:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-24', '15:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '13:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '14:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '16:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-08', '15:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-08', '17:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '13:40', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '14:50', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '16:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '2 - 12' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-05-15', '15:50', 2, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '14:50', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-22', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '14:50', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '16:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-29', '15:50', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '16:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '17:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-12', '13:30', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-06-12', '18:10', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '13:40', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '14:50', 5, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '16:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-06-17', '20:00', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-17', '20:50', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'v' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, NULL, NULL, 'scheduled')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '14:50', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-24', '20:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-24', '20:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, NULL, NULL, 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-26', '15:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '14:50', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '16:00', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-08-28', '14:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-28', '15:50', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-28', '17:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '14:50', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '20:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-04', '15:50', 12, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '14:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '16:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '17:10', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-09-05', '20:30', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-11', '15:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-09-18', '15:50', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-09-18', '17:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-18', '18:10', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '13:40', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '14:50', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-25', '18:10', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '11:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '12:30', 18, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '13:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-02', '15:50', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '13:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '14:50', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '16:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-09', '15:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-09', '16:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-09', '17:50', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '13:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '14:50', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-10-16', '15:50', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-16', '17:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '13:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '14:50', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '16:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-23', '17:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '14:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-10-30', '16:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-11-03', '20:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = '0 - 3' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-11-06', '15:50', 14, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-06', '17:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '13:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '16:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '17:10', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-13', '15:50', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '13:40', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '16:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '20:30', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-11-17', '20:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-11-17', '21:00', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, NULL, NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-20', '17:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-20', '18:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-21', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2021-11-24', '20:50', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Avanti' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, NULL, NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-27', '15:10', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-27', '16:20', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-28', '14:50', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2021-11-28', '16:00', 8, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olympique Zgon' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-04', '15:50', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-04', '17:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-05', '14:50', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-05', '17:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Oldrembham Forest' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2021-12-09', '20:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Green Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'KS ProBram24' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-11', '13:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-11', '14:50', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tiger Wołomin' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-11', '16:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2021-12-12', '14:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2021 (10 drużyn, 90 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2021 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 1) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 2) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 3) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 4) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 5) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 6) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 7) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 8) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 9) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id, final_position) VALUES (v_season_id, v_league_id, v_team_id, 10) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-24', '13:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '09:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '10:10', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '11:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2021-04-25', '12:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-08', '14:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '09:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '10:10', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '11:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2021-05-09', '12:30', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '09:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '10:10', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '11:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-05-16', '12:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-22', '14:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '09:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '11:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2021-05-23', '12:30', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-29', '12:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-29', '14:40', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '10:10', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '11:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2021-05-30', '12:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-12', '12:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '09:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '10:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '11:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2021-06-13', '12:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '09:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '10:10', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-06-20', '11:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2021-06-26', '14:40', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '09:00', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '10:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '11:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '12:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2021-06-27', '19:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-08-01', '20:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '09:00', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '10:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '11:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '12:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2021-08-29', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2021-09-01', '20:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '10:10', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '11:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '12:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-09-05', '13:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-18', '14:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '09:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '10:10', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '11:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2021-09-19', '12:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-25', '14:40', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-25', '15:50', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-25', '17:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-09-26', '10:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '09:00', 3, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '10:10', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '11:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '12:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2021-10-03', '20:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '10:10', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '11:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '12:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-10', '20:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-16', '14:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '09:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '10:10', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '11:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2021-10-17', '12:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2021-10-22', '20:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-23', '15:50', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '09:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '10:10', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '11:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2021-10-24', '12:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-06', '14:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '09:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '10:10', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '11:20', 0, 23, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2021-11-07', '12:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2021-11-10', '20:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2021-11-13', '13:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stara Ekipa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sportowe Zakapiory' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-13', '14:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hard Impet Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '09:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SC Halinów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '10:10', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'New Team FC' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tidy Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '11:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fc Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2021-11-14', '12:30', 6, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Gotowe! Import 2018-2021 zakończony.