-- ============================================================
-- 005_create_authors.sql
-- Author profiles (separate from user accounts)
-- Run in: Supabase SQL Editor (after 004)
-- ============================================================

CREATE TABLE public.authors (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  bio         TEXT DEFAULT '',
  photo_url   TEXT,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_by  UUID REFERENCES auth.users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_authors_active ON public.authors(is_active);
CREATE INDEX idx_authors_verified ON public.authors(is_verified);

CREATE TRIGGER authors_updated_at
  BEFORE UPDATE ON public.authors
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
