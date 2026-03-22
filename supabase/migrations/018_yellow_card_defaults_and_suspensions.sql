-- ============================================================
-- MLPN - Migracja 018: Domyslne zasady i logika pauz za kartki
-- Ustawia domyslny prog na 3 zolte kartki i pauze za kazda
-- kolejna kartke od tego progu.
-- ============================================================

ALTER TABLE public.season_leagues
    ALTER COLUMN yellow_card_suspension_threshold SET DEFAULT 3;

UPDATE public.season_leagues sl
SET yellow_card_suspension_threshold = 3
FROM public.seasons s
WHERE s.id = sl.season_id
  AND sl.yellow_card_suspension_threshold = 2
  AND s.status IN ('planned', 'active');

CREATE OR REPLACE FUNCTION public.check_auto_suspension()
RETURNS TRIGGER AS $$
DECLARE
    v_match RECORD;
    v_threshold INTEGER;
    v_yellow_count INTEGER;
BEGIN
    IF NEW.event_type NOT IN ('YELLOW_CARD', 'RED_CARD') THEN
        RETURN NEW;
    END IF;

    SELECT * INTO v_match FROM public.matches WHERE id = NEW.match_id;

    IF NEW.event_type = 'RED_CARD' THEN
        INSERT INTO public.suspensions (
            player_id, season_id, league_id, suspension_type,
            reason, start_round, end_round, matches_remaining,
            triggering_event_id
        ) VALUES (
            NEW.player_id, v_match.season_id, v_match.league_id,
            'red_card',
            'Automatyczna pauza za czerwona kartke',
            v_match.round + 1, v_match.round + 1, 1,
            NEW.id
        );
        RETURN NEW;
    END IF;

    SELECT COALESCE(yellow_card_suspension_threshold, 3) INTO v_threshold
    FROM public.season_leagues
    WHERE season_id = v_match.season_id
      AND league_id = v_match.league_id;

    v_threshold := COALESCE(v_threshold, 3);

    SELECT COUNT(*) INTO v_yellow_count
    FROM public.match_events me
    JOIN public.matches m ON m.id = me.match_id
    WHERE me.player_id = NEW.player_id
      AND me.event_type = 'YELLOW_CARD'
      AND m.season_id = v_match.season_id
      AND m.league_id = v_match.league_id;

    IF v_yellow_count >= v_threshold THEN
        INSERT INTO public.suspensions (
            player_id, season_id, league_id, suspension_type,
            reason, start_round, end_round, matches_remaining,
            triggering_event_id
        ) VALUES (
            NEW.player_id, v_match.season_id, v_match.league_id,
            'yellow_accumulation',
            format(
                'Automatyczna pauza: %s zoltych kartek (od progu %s, kazda kolejna kartka = kolejna pauza)',
                v_yellow_count,
                v_threshold
            ),
            v_match.round + 1, v_match.round + 1, 1,
            NEW.id
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
