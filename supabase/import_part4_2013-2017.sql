-- Import archiwum MLPN 2013-2017
-- Uruchom PO part1_setup.sql

-- === I liga 2013 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2013 LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
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
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '15:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '16:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '15:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '17:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '15:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '16:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '16:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '17:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-05-09', '18:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '15:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '16:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '16:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '16:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '15:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '17:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '16:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '17:40', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '16:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '16:20', 8, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '17:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '15:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '17:40', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '16:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '17:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '15:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '16:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '17:40', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '15:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '16:20', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '17:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '15:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '15:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '16:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '17:40', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-25', '16:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', '16:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', '17:40', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-25', '15:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-25', '17:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '16:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '14:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '17:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-09-01', '16:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-09-01', '17:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '16:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '17:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-08', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-08', '17:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '16:20', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-15', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-15', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-15', '17:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '17:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '15:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', '16:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', '17:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '17:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', '17:40', 2, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '17:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '15:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '17:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-13', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-13', '15:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-13', '17:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-20', '15:00', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '17:40', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-20', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-20', '16:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '16:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '17:20', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '18:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', '17:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-10', '16:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Wenus' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '18:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '17:20', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pianka Kuflew Kominkisim.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-10', '18:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'SM Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sami Swoi' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-10', '17:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2013 (13 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2013 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '11:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '12:20', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '12:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '11:00', 6, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '12:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '13:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '12:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '13:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '11:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '12:20', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '13:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '11:00', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '13:40', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '11:00', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '12:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '13:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '12:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '11:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '12:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '13:40', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '11:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '12:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '12:20', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '11:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '12:20', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '13:40', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '11:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '12:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '11:00', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '12:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '11:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '12:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '13:40', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '11:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '12:20', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '11:00', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '13:40', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '11:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '12:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '11:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '12:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '13:40', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-25', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', '11:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-25', '12:20', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', '12:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', '13:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '12:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '13:20', 8, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-09-01', '14:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-09-01', '13:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-09-01', '12:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '13:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '12:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-08', '12:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-08', '13:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-08', '14:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '12:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-15', '12:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '13:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-15', '13:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '12:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '11:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '12:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '15:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '12:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', '12:20', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '13:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', '13:40', 17, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', '15:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', '12:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', '15:00', 5, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '12:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', '13:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '13:40', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-13', '13:40', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '12:20', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '13:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-13', '12:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-20', '12:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '12:20', 5, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '13:40', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-20', '13:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '13:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', '13:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', '12:20', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '14:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '14:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy 2003' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki II' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-10', '13:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '13:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-10', '14:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Promil Czarniecki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '16:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2013 (13 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2013 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Revolta' LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'Iniemamocni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '07:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '08:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-13', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '07:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2013-04-14', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-20', '09:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '07:00', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '08:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2013-04-21', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '08:20', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-27', '09:40', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '07:00', 26, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2013-04-28', '09:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '07:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '08:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-11', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '08:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2013-05-12', '09:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '07:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '08:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-18', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '07:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2013-05-19', '09:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '07:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '08:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-25', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2013-05-26', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '07:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '08:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-01', '09:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '07:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '08:20', 4, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2013-06-02', '09:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-08', '09:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '07:00', 13, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '08:20', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2013-06-09', '09:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '07:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '08:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-15', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '08:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2013-06-16', '09:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '07:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '08:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-22', '09:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '08:20', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2013-06-23', '09:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '07:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '08:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-29', '09:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '07:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2013-06-30', '09:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-25', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-25', '11:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', '08:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2013-08-24', NULL, 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '08:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '09:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', '10:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-09-01', '09:20', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-08-31', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2013-09-01', '10:40', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '08:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '10:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-08', '10:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-08', '09:20', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2013-09-07', '09:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '08:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '09:40', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-14', '11:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-15', '08:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2013-09-15', '09:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '09:40', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-21', '11:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Iniemamocni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '07:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '08:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2013-09-22', '09:40', 12, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', '09:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '07:00', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', '11:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '08:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-29', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2013-09-28', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '08:20', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', '09:40', 5, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '09:40', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-06', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2013-10-05', '11:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-13', '08:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-12', '09:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2013-10-13', '09:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '08:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-20', '08:20', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-20', '09:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '11:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2013-10-19', '09:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', '09:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '10:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '08:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-27', '09:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2013-10-26', '11:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-10', '10:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Nieobliczalni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '09:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzące Żółwie' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-10', '09:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore PZU' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '10:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2013-11-09', '12:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2014 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2014 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-29', '16:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '15:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-04-03', '18:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-29', '18:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '16:20', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-05', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-05', '16:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '15:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-05', '15:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '17:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-12', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '16:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-12', '15:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-12', '16:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '17:40', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '17:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-26', '15:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-26', '16:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-26', '17:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '15:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '15:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '17:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '16:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '17:40', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '17:40', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '17:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '16:20', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '15:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '15:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '16:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '16:20', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '15:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '17:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '15:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '17:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '16:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-05', '18:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-01', '17:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-01', '16:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '17:40', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '16:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '17:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '17:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '16:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '15:00', 9, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '15:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '17:40', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '16:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '16:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '15:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '18:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '19:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '17:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-28', '19:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-28', '18:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-28', '17:00', 14, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '15:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-24', '15:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-24', '17:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-24', '14:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-06-28', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '17:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '15:40', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-09-06', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-31', '14:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '17:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-31', '15:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-31', '17:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', '15:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-07', '17:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-07', '15:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', '17:00', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-07', '14:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-14', '15:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', '15:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', '17:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-14', '17:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-14', '14:20', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-21', '15:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-21', '17:00', 15, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', '17:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-21', '14:20', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', '15:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', '15:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-28', '15:40', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-28', '14:20', 4, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', '17:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-28', '17:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', '15:40', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-05', '17:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', '17:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-05', '14:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-05', '15:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', '17:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-12', '15:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', '15:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-12', '14:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-12', '17:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', '17:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-19', '14:20', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-19', '15:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', '15:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-19', '17:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', '15:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-26', '18:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', '17:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-26', '15:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-26', '16:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stm Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', '18:00', 20, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-09', '18:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sm Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-09', '16:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', '16:40', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-09', '15:20', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2014 (11 drużyn, 110 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2014 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-29', '13:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-29', '14:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '13:40', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '11:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-05', '12:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-05', '13:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '11:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-12', '12:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-12', '13:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '12:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-26', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-26', '13:40', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '11:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '12:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '12:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '11:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '13:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '12:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '13:40', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '11:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '12:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '13:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '13:40', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '12:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '12:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '13:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '11:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '12:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '13:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-01', '13:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-01', '11:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-01', '12:20', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '12:20', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '12:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '11:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '13:40', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '13:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '13:40', 1, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '12:20', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '11:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '14:20', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '15:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '13:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-28', '14:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-28', '15:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '11:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-24', '11:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '14:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '13:00', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-24', '13:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-31', '11:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '11:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-31', '13:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '13:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '14:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', '13:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-07', '13:00', 10, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', '14:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', NULL, 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-07', '11:40', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', '11:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-14', '11:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', '13:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', '14:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-14', '13:00', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', '13:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-21', '13:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-21', '11:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', '14:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', '11:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', '13:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-28', '13:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', '11:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-28', '11:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', '14:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', '11:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', '14:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-05', '11:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', '13:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-05', '13:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', '13:00', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-12', '13:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-12', '11:40', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', '11:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', '14:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-19', '13:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-19', '11:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', '14:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', '11:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', '13:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', '14:20', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', '13:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-26', '14:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-26', '12:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', '11:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-09', '14:00', 1, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', '15:20', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-09', '12:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', '14:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', '12:40', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2014 (12 drużyn, 109 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2014 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '08:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-30', '09:40', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-29', '10:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-03-29', '12:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2014-05-25', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-05', '11:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-05', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-04-06', '09:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2014-06-08', '07:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-12', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '08:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-13', '09:40', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-04-12', '11:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2014-06-01', '07:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '09:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-27', '08:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-26', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-04-26', '11:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2014-06-15', '07:00', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '09:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-11', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2014-05-10', '08:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '09:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '09:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '11:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-18', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2014-05-17', '08:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '11:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '08:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-25', '09:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2014-05-24', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-01', '08:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-06-01', '09:40', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '09:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '11:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2014-05-31', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '09:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '08:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-08', '09:40', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2014-06-07', '08:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '09:40', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Teknosystem' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '11:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '08:20', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-15', '09:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2014-06-14', '08:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-28', '11:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '10:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-28', '13:00', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2014-06-29', '11:40', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-24', '10:20', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '09:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '07:40', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-23', '10:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2014-08-24', '09:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '07:40', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-31', '09:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-31', '10:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '09:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2014-08-30', '10:20', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-07', '09:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', '10:20', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', '09:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-06', '11:40', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2014-09-07', '10:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', '09:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-14', '10:20', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-14', '09:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2014-09-13', '10:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-21', '09:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-21', '10:20', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', '09:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', NULL, 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2014-09-20', '10:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', '09:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', '10:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-28', '09:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-27', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2014-09-28', '10:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-05', '10:20', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', '10:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-05', '09:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2014-10-04', '09:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', '09:00', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-12', '10:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-11', '10:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2014-10-12', '09:00', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-19', '09:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-19', '10:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', '09:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', '10:20', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2014-10-18', NULL, 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', '09:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-26', '11:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-26', '10:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2014-10-25', '10:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', '11:20', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-09', '11:20', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pts Lzs Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-09', '10:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Napaciapani' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'GOLD-DENT.P.T LECZNICA STOMATOLOGICZNA' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nafta Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2014-11-08', NULL, 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2015 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2015 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-29', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', '17:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', '16:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-29', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', '18:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-29', '16:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '16:20', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '17:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '15:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '16:20', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '17:40', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '15:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '17:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '16:20', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '16:20', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '17:40', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '15:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '15:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '17:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '15:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '17:40', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '16:20', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '17:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '16:20', 2, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '16:20', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '15:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '17:40', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '15:00', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '16:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-16', '17:40', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '17:40', 7, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '15:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-16', '16:20', 15, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-16', '15:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '17:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '15:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '16:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '15:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '17:40', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '16:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '16:20', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-28', '18:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '17:40', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-31', '17:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-31', '16:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '15:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-11', '18:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '16:20', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '17:40', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '15:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-06', '15:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-06', '16:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-13', '16:20', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '15:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '17:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-18', '18:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-13', '17:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '16:20', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-20', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '15:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-27', '16:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-23', '18:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '16:20', 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '17:40', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '15:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '14:15', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '16:45', 3, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '16:45', 8, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '15:30', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '14:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '16:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '13:45', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '15:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '15:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '16:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '13:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '15:40', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '14:35', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '14:35', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '13:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '15:40', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '13:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '15:10', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '15:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '14:05', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '13:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '14:05', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '13:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '15:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '12:50', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '13:55', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '12:50', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '15:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '13:55', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '12:40', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '14:50', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '14:50', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '12:40', 9, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '13:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '13:45', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '13:35', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '14:40', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '13:35', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '14:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '12:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '12:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '14:35', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '14:35', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '13:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '12:25', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '13:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '12:25', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '13:25', 9, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-11-11', '10:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', '14:30', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', '12:20', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '14:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', '13:25', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', '13:15', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', '12:10', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-08', '14:15', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', '14:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-08', '12:10', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-08', '13:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-14', '12:45', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Prawie Jak Mistrz' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-15', '11:40', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-15', '12:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-14', '13:50', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-15', '13:50', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alabama' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Dziadki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-11', '14:00', 2, 19, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2015 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2015 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-29', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', '14:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-29', '12:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', NULL, 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', '13:20', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-29', '13:40', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '11:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '12:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '13:40', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '11:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '13:40', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '13:40', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '11:00', 5, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '11:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '13:40', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '11:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '13:40', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '12:20', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '12:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '11:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '11:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '11:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '07:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-06-06', '07:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '13:40', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '11:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '12:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-16', '09:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-16', '12:20', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-16', '13:40', 6, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '13:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '12:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '11:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '13:40', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '11:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-06-11', '17:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '11:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '12:20', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '13:40', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-31', '11:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-31', '12:20', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-06', '12:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-16', '17:00', 0, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-24', '17:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '11:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '12:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-06', '13:40', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-13', '12:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '13:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '12:20', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-13', '11:00', 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '11:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-13', '13:40', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '12:20', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-20', '12:20', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '13:40', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-20', '11:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '11:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-20', '13:40', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '10:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '13:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '08:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '13:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '11:45', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '11:45', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', NULL, 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '12:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '11:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '10:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '11:15', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '12:30', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '12:25', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '12:25', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '11:20', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '11:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '10:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '10:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '11:55', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '09:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '10:50', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '10:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '09:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '11:55', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '09:35', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '10:40', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '11:45', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '11:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '10:40', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '09:35', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '10:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '10:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '09:25', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '11:35', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '09:25', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '11:35', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '11:25', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '10:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '09:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '10:20', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '09:15', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '11:25', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '10:15', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '09:10', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '11:20', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '09:10', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '11:20', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '10:15', 11, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '11:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '10:10', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', '11:15', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', '09:05', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '12:20', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', '10:10', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', '10:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', '09:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', '11:05', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-08', '10:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-08', '09:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-08', '11:05', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-14', '09:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-14', '11:40', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-11', '12:55', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-15', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-14', '10:35', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2015-11-15', '10:35', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2015 (12 drużyn, 116 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2015 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'LO' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', '10:40', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', '12:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-29', '08:20', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-06-27', '14:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'LO' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2015-03-28', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', '08:20', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-12', '09:40', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'LO' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2015-04-11', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '09:40', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '09:40', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-18', '08:20', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'LO' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2015-04-19', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '08:20', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '09:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-25', '09:40', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'LO' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2015-04-26', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '08:20', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '07:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-10', '08:20', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'LO' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2015-05-09', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '09:40', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-30', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-17', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'LO' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2015-05-16', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '07:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '08:20', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '07:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'LO' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-24', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'LO' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2015-05-23', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-31', '07:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-31', '08:20', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-30', '08:20', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'LO' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2015-05-31', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-06', '09:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '09:40', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '07:00', 17, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-06', '08:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'LO' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2015-06-07', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '09:40', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-13', '08:20', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-13', '09:40', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'LO' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2015-06-14', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '09:40', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-20', '09:40', 1, 16, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Revolta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-20', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '07:00', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'LO' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2015-06-21', '08:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '06:45', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '06:45', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '08:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-29', '09:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '10:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2015-08-30', '09:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '06:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '08:45', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '10:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-06', '07:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '08:45', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2015-09-05', '07:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '08:05', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '09:10', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '09:10', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '07:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-12', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2015-09-13', '08:05', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '06:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '08:40', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', NULL, 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-20', '07:35', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '08:40', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2015-09-19', '07:35', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '08:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '06:20', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '08:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '07:25', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-27', '07:25', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2015-09-26', '06:20', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '08:20', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '06:10', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '08:20', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-03', '07:15', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '06:10', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2015-10-04', '07:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '06:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '07:05', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-10', '08:10', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '07:05', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '06:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2015-10-11', '08:10', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '06:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-17', '08:05', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '08:05', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2015-10-18', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '09:05', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', '08:00', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '08:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-24', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'WSNT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2015-10-25', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-08', '08:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Kosmos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', '08:50', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2015-11-07', NULL, NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2016 (13 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2016 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '15:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '16:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '15:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '18:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '16:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '18:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '17:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '18:10', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', '15:45', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '14:30', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '15:45', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '17:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '14:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-12', '18:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '14:30', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '15:45', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '15:45', 7, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '15:45', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '14:30', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '15:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '14:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-05-15', '18:10', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '17:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '17:00', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '17:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '14:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '15:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '14:30', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '15:45', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '15:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '14:30', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '15:45', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '14:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-15', '17:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-15', '14:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '15:45', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '14:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '17:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-17', '18:30', 4, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '14:30', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '15:45', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '14:30', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '15:45', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '17:00', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '17:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-04', '15:45', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-04', '14:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '15:45', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '18:10', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '17:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-04', '17:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '14:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', '15:45', 8, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', NULL, 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', '14:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', NULL, 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-28', '17:20', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Białowieska' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-25', '18:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '15:45', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '17:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '14:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-27', '18:15', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '15:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '15:45', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '18:10', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '17:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '17:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '14:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '14:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '15:45', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '17:00', 3, 13, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '15:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '14:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '17:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '17:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '15:45', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '14:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '17:00', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '15:45', 8, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '14:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '14:30', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '17:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '14:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '15:45', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '17:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '15:45', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '15:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '14:30', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '17:00', 9, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '14:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '15:45', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '17:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', NULL, 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '17:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '15:45', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '14:30', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '17:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '15:45', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '15:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '17:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '17:00', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '14:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '14:30', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '15:45', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '15:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '15:45', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '18:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '14:30', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '17:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '16:45', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '16:45', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '18:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '15:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '18:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '15:30', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '16:45', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '19:10', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '15:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-12', '16:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '18:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '16:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-12', '18:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '18:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '15:30', 7, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold-Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '16:45', 13, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Orły Stara Miłosna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '15:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '16:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Długa i Michałów' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '18:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2016 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2016 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '14:15', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '13:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '14:15', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '13:00', 6, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '11:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '11:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '13:15', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '12:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '10:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', '13:15', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', '10:45', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', '12:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '13:15', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '12:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '13:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '12:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '10:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '10:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '12:00', 0, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '13:15', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '10:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '10:45', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-05-14', '18:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '13:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-05-16', '17:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '13:15', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '10:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '12:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '13:15', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '10:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '10:45', 2, 15, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '12:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '13:15', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '13:15', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '12:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '10:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '10:45', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '12:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-06-09', '18:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-15', '10:45', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-15', '12:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '13:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '10:45', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '12:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '13:15', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '10:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '12:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '13:15', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-04', '12:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-04', '10:45', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '10:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '13:15', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-04', '13:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '12:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', '10:45', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', NULL, 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '12:00', 3, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '13:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '10:45', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', '12:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '10:45', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-25', '11:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '18:10', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-29', '17:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-25', '10:15', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '13:15', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '10:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '12:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '12:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '13:15', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '13:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '14:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '10:45', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-25', '18:10', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '12:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '13:15', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '13:15', 11, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '10:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '12:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '10:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '13:15', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '12:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '13:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '10:45', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '10:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '13:15', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '12:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '13:15', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '10:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '12:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '10:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '13:15', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '10:45', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '12:00', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '12:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '13:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '10:45', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '12:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '13:15', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '13:15', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '12:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '10:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '13:15', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '13:15', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '10:45', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '12:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '10:45', 10, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '13:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '13:15', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '12:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '10:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '11:45', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '14:15', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '14:15', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '11:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '11:45', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '13:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '13:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '14:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '13:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '11:45', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-12', '11:45', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-12', '13:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '14:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-12', '14:15', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '14:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PanPierożek.pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '14:15', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '13:00', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '11:45', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '13:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '11:45', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2016 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2016 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '09:15', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '10:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '10:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', '09:15', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-20', '08:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2016-03-19', NULL, 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', '09:30', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', NULL, 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-02', '08:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '07:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2016-04-03', '08:15', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '09:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '07:00', 4, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '09:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-10', '08:15', 3, 17, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '08:15', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2016-04-09', '07:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '08:15', 14, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '09:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '08:15', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-16', '07:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '09:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2016-04-17', '07:00', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '09:30', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '08:15', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '07:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '08:15', 2, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-24', '09:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2016-04-23', '07:00', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '07:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '09:30', 15, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-07', '08:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '08:15', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '07:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2016-05-08', '09:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-15', '08:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '08:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '07:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-15', '13:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-15', '09:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2016-05-14', '09:30', 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '08:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '08:15', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '09:30', 0, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-21', '07:00', 6, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '09:30', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2016-05-22', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '07:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-04', '09:30', 12, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '09:30', 2, 18, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-05-21', '18:10', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '14:30', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2016-06-05', '08:15', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '08:15', 15, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', '07:00', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '09:30', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', '13:15', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-12', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2016-06-11', '08:15', 6, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-25', '07:30', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '07:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '08:15', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '06:00', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-25', '08:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2016-06-26', '09:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '09:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '08:15', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '07:00', 11, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-11', '08:15', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '09:30', 10, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2016-09-10', '10:45', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '07:00', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '07:00', 1, 17, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '08:15', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '08:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-18', '09:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2016-09-17', '09:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '08:15', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '07:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '08:15', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '07:00', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-24', '09:30', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2016-09-25', '09:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '07:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '08:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '09:30', 2, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-01', '08:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2016-10-02', '09:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '08:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '07:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '07:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '08:15', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-08', '09:30', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2016-10-09', '09:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '08:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '08:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '09:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-16', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2016-10-15', '09:30', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '09:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '08:15', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '07:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '08:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-23', '07:00', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2016-10-22', '09:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '07:00', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '10:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '08:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '08:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-30', '09:15', 9, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2016-10-29', '09:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '08:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '10:30', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '09:15', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-05', '10:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '09:15', 0, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2016-11-06', '08:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '08:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '10:30', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-13', '09:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-16', '18:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-12', '10:30', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2016-11-09', '18:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '09:15', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '08:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '10:30', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '18:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'EL Brygada' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-19', '09:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2016-11-20', '10:30', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === I liga 2017 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2017 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '1st' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
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
  SELECT id INTO v_team_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '15:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '18:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '16:45', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '18:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '15:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '16:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '16:45', 9, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '15:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '18:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '14:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '15:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '17:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '15:45', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '14:30', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '17:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '15:45', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '17:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '14:30', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '15:45', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '14:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '17:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '14:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '17:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '15:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-06-24', '13:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '15:45', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '14:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '14:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '17:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '15:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '15:45', 7, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '14:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '14:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '15:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '17:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '17:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '17:00', 5, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '14:30', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '15:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '14:30', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '17:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '15:45', 1, 12, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '15:45', 4, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '14:30', 3, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '17:00', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '14:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-06-11', '18:00', 11, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '16:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '17:00', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '15:45', 5, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-06-25', '18:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-06-22', '17:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '14:30', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-06-25', '15:40', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-08', '18:30', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '15:45', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '14:30', 11, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '15:45', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '14:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '15:45', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '15:45', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '14:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '14:30', 15, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '17:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '17:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '15:45', 9, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '18:05', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-26', '15:45', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '14:30', 0, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-26', '17:00', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '17:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '17:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '15:45', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', '14:30', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', '15:45', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '14:30', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '14:30', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-09', '14:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-09', '17:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '15:45', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-14', '17:15', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '17:00', 8, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-16', '17:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-10-15', '18:05', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-16', '15:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-21', '17:15', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '14:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '17:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '15:45', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '14:30', 2, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '14:30', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '17:00', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '15:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '14:30', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '17:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '15:45', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '14:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '17:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '15:45', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-08', '14:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '17:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-11', '17:15', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '14:30', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '15:45', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-11-02', '19:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '15:45', 5, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '14:30', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '15:45', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '14:30', 0, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '17:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '17:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '15:45', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '14:30', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '17:00', 3, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '15:45', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '14:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-30', '18:15', 7, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Detox' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '15:45', 1, 14, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '17:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-24', '17:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '18:00', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '15:30', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Lider' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '16:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Joga Finito' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Elo Melo' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '16:45', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sparta' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pędzący Kombajn' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '15:30', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Starszaki' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Zieloni' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '18:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gold Dent PT' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Legioholicy' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '16:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Huragan Poręby Nowe' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Detox' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '15:30', 3, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Fanatycy' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Lider' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '18:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === II liga 2017 (12 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2017 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '2nd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '13:00', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '13:00', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '14:15', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '14:15', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '11:45', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '11:45', 1, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '10:45', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '13:00', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '12:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '13:15', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '11:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '14:15', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '13:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '10:45', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-05', '17:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '12:00', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '10:45', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '13:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '10:45', 8, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '13:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '10:45', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '12:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '13:15', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '12:00', 2, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '13:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '10:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '10:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '13:15', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '10:45', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '12:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '12:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '13:15', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '10:45', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '13:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '12:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '12:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '18:10', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '10:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '13:15', 4, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '10:45', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '10:45', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '12:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '12:00', 2, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '13:15', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '13:15', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '10:45', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-06-25', '14:30', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-06-25', '13:20', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '13:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '12:00', 7, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-06-25', '12:10', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '10:45', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '13:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '10:45', 2, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '13:15', 3, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '12:00', 4, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '12:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '10:45', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '12:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '10:45', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '13:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '10:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-25', '11:00', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '13:15', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-26', NULL, 11, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-26', '12:00', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-26', NULL, 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '10:45', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-09-18', '18:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-26', '10:45', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', '12:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '10:45', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-11', '18:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-10-25', '18:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', '13:15', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '13:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '13:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-09', '12:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '12:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-09', '13:15', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '10:45', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-09', '10:45', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-16', '10:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '10:45', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-16', '12:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '12:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-16', '13:15', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '13:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '13:15', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '12:00', 4, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '10:45', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '12:00', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '10:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '13:15', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '10:45', 10, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '13:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '12:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '13:15', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', NULL, 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '10:45', 1, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '10:45', 12, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '12:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '13:15', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-08', '10:45', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-08', '12:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-08', '13:15', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '12:00', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '10:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '13:15', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '12:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '10:45', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '13:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '13:15', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '10:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '12:00', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '12:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '13:15', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '10:45', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '10:45', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '13:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '13:15', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '14:15', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PJM' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '12:00', 4, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '11:45', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Stankan' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Gosuansa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '13:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Południowa Afryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Kominki Sim Pianka Kuflew' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '11:45', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Nowa Drużyna' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Młoda Gwardia' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '14:15', 0, 3, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PTS Tęcza Pustelnik' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Sfinks' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '14:15', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PJM' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'FC Faworyt' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '11:45', 9, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Pan Pierożek_pl' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Nankatsu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '13:00', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- === III liga 2017 (13 drużyn, 132 meczów) ===
DO $$ DECLARE
  v_season_id uuid;
  v_league_id uuid;
  v_team_id uuid;
  v_home_id uuid;
  v_away_id uuid;
BEGIN
  SELECT id INTO v_season_id FROM seasons WHERE year = 2017 LIMIT 1;
  SELECT id INTO v_league_id FROM leagues WHERE code = '3rd' LIMIT 1;

  INSERT INTO season_leagues (season_id, league_id) VALUES (v_season_id, v_league_id) ON CONFLICT DO NOTHING;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_team_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_team_id IS NOT NULL THEN
    INSERT INTO season_teams (season_id, league_id, team_id) VALUES (v_season_id, v_league_id, v_team_id) ON CONFLICT DO NOTHING;
  END IF;

  -- Mecze
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '08:00', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '08:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '10:30', 0, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '09:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-18', '09:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 1, '2017-03-19', '10:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '10:30', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '09:15', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '08:15', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-25', '08:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '09:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 2, '2017-03-26', '07:00', 5, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '07:00', 0, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '08:15', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-01', '09:30', 0, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '08:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 3, '2017-04-02', '07:00', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '07:00', 7, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '08:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-08', '09:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '07:00', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '08:15', 2, 10, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 4, '2017-04-09', '09:30', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '09:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '08:15', 3, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-22', '07:00', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '07:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '09:30', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 5, '2017-04-23', '08:15', 6, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '09:30', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '08:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '08:15', 3, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-06', '07:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '07:00', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 6, '2017-05-07', '09:30', 8, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '09:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '08:15', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '07:00', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '08:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-14', '07:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 7, '2017-05-13', '09:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '07:00', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '08:15', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-20', '09:30', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-18', '17:00', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '08:15', 0, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 8, '2017-05-21', '09:30', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '08:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-28', '08:15', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-28', '09:30', 1, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '09:30', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-27', '07:00', 7, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 9, '2017-05-28', '07:00', NULL, 1, 'walkover_away')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '07:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '08:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '07:00', 4, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-04', '09:30', 2, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '08:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 10, '2017-06-03', '09:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Mordor Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '08:15', NULL, NULL, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-25', '09:50', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '09:30', 1, 8, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '09:30', 1, 11, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-11', '08:15', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 11, '2017-06-10', '07:00', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '09:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '08:15', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-10-30', '19:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '07:00', 6, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-27', '12:00', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 12, '2017-08-26', '08:15', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '09:30', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', '09:30', 1, 9, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', '10:45', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '08:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-03', '07:00', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 13, '2017-09-02', NULL, 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '18:00', 2, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '08:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '07:00', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-20', '17:15', 3, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-10', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 14, '2017-09-09', '09:30', 7, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-16', '08:15', 3, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '08:15', 5, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '15:45', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '07:00', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-16', '09:30', 4, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 15, '2017-09-17', '09:30', 3, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '08:15', 3, 0, 'walkover_home')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '07:00', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '07:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '08:15', 1, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-24', '09:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 16, '2017-09-23', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '07:00', 0, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '07:00', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '08:15', 1, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-10-01', '09:30', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '08:15', 5, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 17, '2017-09-30', '09:30', 16, 0, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-08', '09:30', 1, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-08', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '08:15', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '07:00', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-07', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 18, '2017-10-08', '08:15', 4, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '08:15', 0, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '08:15', 2, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-14', '07:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '07:00', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 19, '2017-10-15', '09:30', 4, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '09:30', 8, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-22', '08:15', 5, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '08:15', 3, 7, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-17', '17:15', 2, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 20, '2017-10-21', '07:00', 5, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '08:15', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Impet' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '09:15', 1, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '08:00', 2, 4, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '07:00', 0, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-28', '09:30', 2, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 21, '2017-10-29', '10:30', 3, 6, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Alchemia Futbolu' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Panika Papryka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '09:15', 6, 5, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'DT Galacticos' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'PKKL' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '19:05', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Chaos Team' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Hardcore Team' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '08:00', 1, 2, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Rebelianci' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Impet' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '09:15', 1, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Olcskul' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Okinawa' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-04', '10:30', 0, 3, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
  SELECT id INTO v_home_id FROM teams WHERE name = 'Eurotherm Walencja' LIMIT 1;
  SELECT id INTO v_away_id FROM teams WHERE name = 'Multi-Medica Zielonka' LIMIT 1;
  IF v_home_id IS NOT NULL AND v_away_id IS NOT NULL THEN
    INSERT INTO matches (season_id, league_id, home_team_id, away_team_id, round, match_date, match_time, home_goals, away_goals, status)
    VALUES (v_season_id, v_league_id, v_home_id, v_away_id, 22, '2017-11-05', '10:30', 2, 1, 'completed')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Gotowe! Import 2013-2017 zakończony.