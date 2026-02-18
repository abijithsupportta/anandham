-- ============================================================
-- 029_add_krithis_display_order.sql
-- Adds priority ordering support for Guru Krithis
-- ============================================================

ALTER TABLE public.krithis
  ADD COLUMN IF NOT EXISTS display_order INT NOT NULL DEFAULT 0;

WITH ranked AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at DESC, id) - 1 AS rn
  FROM public.krithis
)
UPDATE public.krithis k
SET display_order = ranked.rn
FROM ranked
WHERE k.id = ranked.id
  AND (k.display_order IS NULL OR k.display_order = 0);

CREATE INDEX IF NOT EXISTS idx_krithis_status_order
  ON public.krithis(status, display_order)
  WHERE NOT is_deleted;

NOTIFY pgrst, 'reload schema';