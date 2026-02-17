-- ============================================================
-- 008_create_dharmas.sql
-- Guru Dharmas – collections of teachings/principles
-- Run in: Supabase SQL Editor (after 007)
-- ============================================================

CREATE TABLE public.dharmas (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  description   TEXT DEFAULT '',
  category_id   UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  author_id     UUID REFERENCES public.authors(id) ON DELETE SET NULL,
  language      public.content_language NOT NULL DEFAULT 'ta',
  status        public.content_status NOT NULL DEFAULT 'draft',
  published_at  TIMESTAMPTZ,
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at    TIMESTAMPTZ,
  created_by    UUID REFERENCES auth.users(id),
  updated_by    UUID REFERENCES auth.users(id),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_dharmas_status ON public.dharmas(status) WHERE NOT is_deleted;
CREATE INDEX idx_dharmas_category ON public.dharmas(category_id) WHERE NOT is_deleted;
CREATE INDEX idx_dharmas_author ON public.dharmas(author_id) WHERE NOT is_deleted;
CREATE INDEX idx_dharmas_slug ON public.dharmas(slug);

-- Full-text search
ALTER TABLE public.dharmas ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(description, ''))
  ) STORED;

CREATE INDEX idx_dharmas_search ON public.dharmas USING GIN(search_vector);

CREATE TRIGGER dharmas_updated_at
  BEFORE UPDATE ON public.dharmas
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
