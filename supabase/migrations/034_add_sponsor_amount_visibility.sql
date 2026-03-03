-- ============================================================
-- 034_add_sponsor_amount_visibility.sql
-- Adds amount visibility toggle for sponsors
-- ============================================================

ALTER TABLE public.sponsors
  ADD COLUMN IF NOT EXISTS amount_visible BOOLEAN NOT NULL DEFAULT TRUE;

NOTIFY pgrst, 'reload schema';
