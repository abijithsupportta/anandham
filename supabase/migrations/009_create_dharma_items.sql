-- ============================================================
-- 009_create_dharma_items.sql
-- Individual teaching points within a Dharma
-- Run in: Supabase SQL Editor (after 008)
-- ============================================================

CREATE TABLE public.dharma_items (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dharma_id     UUID NOT NULL REFERENCES public.dharmas(id) ON DELETE CASCADE,
  item_number   INT NOT NULL,
  text          TEXT NOT NULL DEFAULT '',
  explanation   TEXT DEFAULT '',
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at    TIMESTAMPTZ,
  created_by    UUID REFERENCES auth.users(id),
  updated_by    UUID REFERENCES auth.users(id),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(dharma_id, item_number)
);

CREATE INDEX idx_dharma_items_dharma ON public.dharma_items(dharma_id, item_number) WHERE NOT is_deleted;

CREATE TRIGGER dharma_items_updated_at
  BEFORE UPDATE ON public.dharma_items
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
