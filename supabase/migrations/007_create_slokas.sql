-- ============================================================
-- 007_create_slokas.sql
-- Slokas/verses belonging to a Krithi
-- Each krithi can have ~100 slokas, each 4-6 lines
-- Run in: Supabase SQL Editor (after 006)
-- ============================================================

CREATE TABLE public.slokas (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  krithi_id       UUID NOT NULL REFERENCES public.krithis(id) ON DELETE CASCADE,
  sloka_number    INT NOT NULL,
  original_text   TEXT NOT NULL DEFAULT '',       -- Original sacred text
  transliteration TEXT DEFAULT '',                -- Romanized version
  translation     TEXT DEFAULT '',                -- English/other translation
  explanation     TEXT DEFAULT '',                -- Detailed meaning
  is_deleted      BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at      TIMESTAMPTZ,
  created_by      UUID REFERENCES auth.users(id),
  updated_by      UUID REFERENCES auth.users(id),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(krithi_id, sloka_number)
);

CREATE INDEX idx_slokas_krithi ON public.slokas(krithi_id, sloka_number) WHERE NOT is_deleted;

CREATE TRIGGER slokas_updated_at
  BEFORE UPDATE ON public.slokas
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
