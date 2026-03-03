-- ============================================================
-- 032_create_guru_stories.sql
-- Adds Guru Stories content module
-- ============================================================

CREATE TABLE IF NOT EXISTS public.guru_stories (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title          TEXT NOT NULL,
  slug           TEXT NOT NULL UNIQUE,
  body           TEXT NOT NULL DEFAULT '',
  author_name    TEXT NOT NULL DEFAULT '',
  reference_book TEXT NOT NULL DEFAULT '',
  status         public.content_status NOT NULL DEFAULT 'draft',
  published_at   TIMESTAMPTZ,
  is_deleted     BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at     TIMESTAMPTZ,
  created_by     UUID REFERENCES auth.users(id),
  updated_by     UUID REFERENCES auth.users(id),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_guru_stories_slug
  ON public.guru_stories(slug);

CREATE INDEX IF NOT EXISTS idx_guru_stories_status
  ON public.guru_stories(status)
  WHERE NOT is_deleted;

CREATE INDEX IF NOT EXISTS idx_guru_stories_created_at
  ON public.guru_stories(created_at DESC)
  WHERE NOT is_deleted;

ALTER TABLE public.guru_stories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS guru_stories_select ON public.guru_stories;
DROP POLICY IF EXISTS guru_stories_insert ON public.guru_stories;
DROP POLICY IF EXISTS guru_stories_update ON public.guru_stories;
DROP POLICY IF EXISTS guru_stories_delete ON public.guru_stories;

CREATE POLICY guru_stories_select ON public.guru_stories
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY guru_stories_insert ON public.guru_stories
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY guru_stories_update ON public.guru_stories
  FOR UPDATE USING (public.is_admin());

CREATE POLICY guru_stories_delete ON public.guru_stories
  FOR DELETE USING (public.is_admin());

GRANT SELECT ON public.guru_stories TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.guru_stories TO authenticated;

DROP TRIGGER IF EXISTS guru_stories_updated_at ON public.guru_stories;
CREATE TRIGGER guru_stories_updated_at
  BEFORE UPDATE ON public.guru_stories
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS audit_guru_stories ON public.guru_stories;
CREATE TRIGGER audit_guru_stories
  AFTER INSERT OR UPDATE OR DELETE ON public.guru_stories
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

INSERT INTO public.content_types (name, display_name, description, icon, color, table_name, display_order)
VALUES ('guru_stories', 'Guru Stories', 'Narrative stories and references', '📖', '#0ea5e9', 'guru_stories', 7)
ON CONFLICT (name) DO NOTHING;

NOTIFY pgrst, 'reload schema';
