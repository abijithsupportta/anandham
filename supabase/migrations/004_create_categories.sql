-- ============================================================
-- 004_create_categories.sql
-- Categories scoped per content type
-- Run in: Supabase SQL Editor (after 003)
-- ============================================================

CREATE TABLE public.categories (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_type_id UUID NOT NULL REFERENCES public.content_types(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  slug            TEXT NOT NULL,
  description     TEXT DEFAULT '',
  icon            TEXT DEFAULT '📁',
  color           TEXT DEFAULT '#6366f1',
  display_order   INT NOT NULL DEFAULT 0,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(content_type_id, slug)
);

CREATE INDEX idx_categories_content_type ON public.categories(content_type_id);
CREATE INDEX idx_categories_active ON public.categories(is_active, display_order);

CREATE TRIGGER categories_updated_at
  BEFORE UPDATE ON public.categories
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
