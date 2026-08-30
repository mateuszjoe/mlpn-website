-- Repair the reversed walkover direction for Lider - 1 WBP.
-- Updating only the match status preserves all player/event statistics and
-- lets trg_recalculate_standings rebuild the I Liga table automatically.
UPDATE public.matches
SET
    status = 'walkover_away',
    updated_at = now()
WHERE id = '3b9167d4-331a-42ce-9b6e-37706b4934c0'::UUID
  AND status = 'walkover_home'
  AND home_goals = 0
  AND away_goals = 3;

-- One imported 2017 walkover has an intentionally incomplete score. Keep the
-- historical row untouched, but enforce the strict rule for every new or
-- edited match. The constraint can be validated after that archive is audited.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'matches_walkover_direction_check'
          AND conrelid = 'public.matches'::regclass
    ) THEN
        ALTER TABLE public.matches
        ADD CONSTRAINT matches_walkover_direction_check
        CHECK (
            CASE status
                WHEN 'walkover_home' THEN
                    home_goals IS NOT NULL
                    AND away_goals IS NOT NULL
                    AND home_goals > away_goals
                WHEN 'walkover_away' THEN
                    home_goals IS NOT NULL
                    AND away_goals IS NOT NULL
                    AND away_goals > home_goals
                ELSE TRUE
            END
        ) NOT VALID;
    END IF;
END
$$;

COMMENT ON CONSTRAINT matches_walkover_direction_check ON public.matches IS
    'Prevents new or edited walkovers whose winner direction contradicts the score. NOT VALID because of one incomplete imported 2017 result.';
