-- ============================================================
-- 027_add_saved_items_position.sql
-- Add ordering support for saved items
-- ============================================================

ALTER TABLE public.saved_items
  ADD COLUMN IF NOT EXISTS position INTEGER;

WITH ranked AS (
  SELECT
    id,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, content_type
      ORDER BY created_at, id
    ) AS rn
  FROM public.saved_items
)
UPDATE public.saved_items AS s
SET position = ranked.rn
FROM ranked
WHERE s.id = ranked.id
  AND s.position IS NULL;

CREATE INDEX IF NOT EXISTS idx_saved_items_user_type_position
  ON public.saved_items(user_id, content_type, position);

NOTIFY pgrst, 'reload schema';
