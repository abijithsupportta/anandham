-- ============================================================
-- 006_create_krithis.sql
-- Guru Krithis – sacred poems/songs
-- Run in: Supabase SQL Editor (after 005)
-- ============================================================

CREATE TABLE public.krithis (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  description   TEXT DEFAULT '',
  category_id   UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  author_id     UUID REFERENCES public.authors(id) ON DELETE SET NULL,
  language      public.content_language NOT NULL DEFAULT 'ta',
  youtube_url   TEXT,
  status        public.content_status NOT NULL DEFAULT 'draft',
  published_at  TIMESTAMPTZ,
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at    TIMESTAMPTZ,
  created_by    UUID REFERENCES auth.users(id),
  updated_by    UUID REFERENCES auth.users(id),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_krithis_status ON public.krithis(status) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_category ON public.krithis(category_id) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_author ON public.krithis(author_id) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_language ON public.krithis(language) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_slug ON public.krithis(slug);

-- Full-text search (supports Tamil + English)
ALTER TABLE public.krithis ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(description, ''))
  ) STORED;

CREATE INDEX idx_krithis_search ON public.krithis USING GIN(search_vector);

CREATE TRIGGER krithis_updated_at
  BEFORE UPDATE ON public.krithis
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
