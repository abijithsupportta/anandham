-- ============================================================
-- 017_add_dharma_words_and_translation.sql
-- Adds:
--   1. youtube_url column to dharmas (was missing!)
--   2. translation column to dharmas (full dharma translation)
--   3. dharma_words table (word + meaning pairs per dharma)
-- Run in: Supabase SQL Editor (after 016)
-- ============================================================

-- ── Step 1: Add missing youtube_url column to dharmas ──────

ALTER TABLE public.dharmas
  ADD COLUMN IF NOT EXISTS youtube_url TEXT;

-- ── Step 2: Add translation column to dharmas ──────────────

ALTER TABLE public.dharmas
  ADD COLUMN IF NOT EXISTS translation TEXT DEFAULT '';

-- Update search vector to also include translation text
-- (drop the old generated column and recreate)
ALTER TABLE public.dharmas DROP COLUMN IF EXISTS search_vector;

ALTER TABLE public.dharmas ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    to_tsvector('simple',
      coalesce(title, '') || ' ' ||
      coalesce(description, '') || ' ' ||
      coalesce(translation, '')
    )
  ) STORED;

CREATE INDEX IF NOT EXISTS idx_dharmas_search ON public.dharmas USING GIN(search_vector);

-- ── Step 2: Create dharma_words table ──────────────────────

CREATE TABLE IF NOT EXISTS public.dharma_words (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dharma_id     UUID NOT NULL REFERENCES public.dharmas(id) ON DELETE CASCADE,
  word          TEXT NOT NULL DEFAULT '',
  meaning       TEXT NOT NULL DEFAULT '',
  display_order INT NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_dharma_words_dharma ON public.dharma_words(dharma_id, display_order);

-- ── Step 3: Enable RLS ─────────────────────────────────────

ALTER TABLE public.dharma_words ENABLE ROW LEVEL SECURITY;

-- ── Step 4: RLS Policies for dharma_words ──────────────────

-- Drop existing policies first (safe re-run)
DROP POLICY IF EXISTS dharma_words_select ON public.dharma_words;
DROP POLICY IF EXISTS dharma_words_insert ON public.dharma_words;
DROP POLICY IF EXISTS dharma_words_update ON public.dharma_words;
DROP POLICY IF EXISTS dharma_words_delete ON public.dharma_words;

-- Anyone can read words for published dharmas; admins can read all
CREATE POLICY dharma_words_select ON public.dharma_words
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.dharmas d
      WHERE d.id = dharma_id
      AND d.status = 'published'
      AND NOT d.is_deleted
    )
    OR public.is_admin()
  );

CREATE POLICY dharma_words_insert ON public.dharma_words
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY dharma_words_update ON public.dharma_words
  FOR UPDATE USING (public.is_admin());

CREATE POLICY dharma_words_delete ON public.dharma_words
  FOR DELETE USING (public.is_admin());

-- ── Step 5: Grant permissions ──────────────────────────────

GRANT SELECT ON public.dharma_words TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.dharma_words TO authenticated;

-- ── Step 6: Updated-at trigger ─────────────────────────────

DROP TRIGGER IF EXISTS dharma_words_updated_at ON public.dharma_words;
CREATE TRIGGER dharma_words_updated_at
  BEFORE UPDATE ON public.dharma_words
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

-- ── Step 7: Audit trigger ──────────────────────────────────

DROP TRIGGER IF EXISTS audit_dharma_words ON public.dharma_words;
CREATE TRIGGER audit_dharma_words
  AFTER INSERT OR UPDATE OR DELETE ON public.dharma_words
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

-- ── Step 8: Reload PostgREST schema cache ──────────────────
-- Required after DDL changes so the API recognizes new columns/tables

NOTIFY pgrst, 'reload schema';
