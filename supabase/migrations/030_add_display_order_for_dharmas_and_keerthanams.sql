-- ============================================================
-- 030_add_display_order_for_dharmas_and_keerthanams.sql
-- Adds priority ordering support for Guru Dharmas and Keerthanams
-- ============================================================

ALTER TABLE public.dharmas
  ADD COLUMN IF NOT EXISTS display_order INT NOT NULL DEFAULT 0;

ALTER TABLE public.guru_keerthanams
  ADD COLUMN IF NOT EXISTS display_order INT NOT NULL DEFAULT 0;

WITH ranked AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at DESC, id) - 1 AS rn
  FROM public.dharmas
)
UPDATE public.dharmas d
SET display_order = ranked.rn
FROM ranked
WHERE d.id = ranked.id
  AND (d.display_order IS NULL OR d.display_order = 0);

WITH ranked AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at DESC, id) - 1 AS rn
  FROM public.guru_keerthanams
)
UPDATE public.guru_keerthanams k
SET display_order = ranked.rn
FROM ranked
WHERE k.id = ranked.id
  AND (k.display_order IS NULL OR k.display_order = 0);

CREATE INDEX IF NOT EXISTS idx_dharmas_status_order
  ON public.dharmas(status, display_order)
  WHERE NOT is_deleted;

CREATE INDEX IF NOT EXISTS idx_guru_keerthanams_status_order
  ON public.guru_keerthanams(status, display_order)
  WHERE NOT is_deleted;

NOTIFY pgrst, 'reload schema';
