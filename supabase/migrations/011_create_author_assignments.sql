-- ============================================================
-- 011_create_author_assignments.sql
-- Assigns authors (users) to manage specific content types
-- Run in: Supabase SQL Editor (after 010)
-- ============================================================

CREATE TABLE public.author_assignments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content_type_id UUID NOT NULL REFERENCES public.content_types(id) ON DELETE CASCADE,
  record_id       UUID,              -- NULL = all records of this type; specific UUID = single record
  can_create      BOOLEAN NOT NULL DEFAULT FALSE,
  can_edit        BOOLEAN NOT NULL DEFAULT TRUE,
  can_delete      BOOLEAN NOT NULL DEFAULT FALSE,
  assigned_by     UUID REFERENCES auth.users(id),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, content_type_id, record_id)
);

CREATE INDEX idx_author_assignments_user ON public.author_assignments(user_id);
CREATE INDEX idx_author_assignments_content_type ON public.author_assignments(content_type_id);
