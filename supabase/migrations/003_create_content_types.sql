-- ============================================================
-- 003_create_content_types.sql
-- Registry of all content types shown on home screen
-- Run in: Supabase SQL Editor (after 002)
-- ============================================================

CREATE TABLE public.content_types (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL UNIQUE,          -- 'guru_krithis', 'guru_dharmas', 'guru_photos'
  display_name  TEXT NOT NULL,                 -- 'Guru Krithis', 'Guru Dharmas', 'Guru Photos'
  description   TEXT DEFAULT '',
  icon          TEXT DEFAULT '📚',             -- Emoji or icon name
  color         TEXT DEFAULT '#6366f1',         -- Hex color for UI
  table_name    TEXT NOT NULL,                 -- Actual DB table: 'krithis', 'dharmas', 'guru_photos'
  display_order INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_content_types_active ON public.content_types(is_active, display_order);

CREATE TRIGGER content_types_updated_at
  BEFORE UPDATE ON public.content_types
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
