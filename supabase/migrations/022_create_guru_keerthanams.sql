-- ============================================================
-- 022_create_guru_keerthanams.sql
-- Guru Keerthanams – like Krithis but with multiple categories
-- and an author field.  Uses a junction table for many-to-many
-- category relationships.
-- Run in: Supabase SQL Editor (after 021)
-- ============================================================

-- ══════════════════════════════════════════════════════════════
-- PART 1: Guru Keerthanams table
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.guru_keerthanams (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  description   TEXT DEFAULT '',
  author_name   TEXT DEFAULT '',
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

-- Handle re-run: if table was created with old author_id column, fix it
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'guru_keerthanams' AND column_name = 'author_id'
  ) THEN
    ALTER TABLE public.guru_keerthanams DROP COLUMN author_id;
  END IF;
END $$;
ALTER TABLE public.guru_keerthanams ADD COLUMN IF NOT EXISTS author_name TEXT DEFAULT '';

CREATE INDEX IF NOT EXISTS idx_guru_keerthanams_status    ON public.guru_keerthanams(status) WHERE NOT is_deleted;

CREATE INDEX IF NOT EXISTS idx_guru_keerthanams_language  ON public.guru_keerthanams(language) WHERE NOT is_deleted;
CREATE INDEX IF NOT EXISTS idx_guru_keerthanams_slug      ON public.guru_keerthanams(slug);
CREATE INDEX IF NOT EXISTS idx_guru_keerthanams_published ON public.guru_keerthanams(published_at DESC) WHERE status = 'published' AND NOT is_deleted;

-- Full-text search (Tamil + English)
ALTER TABLE public.guru_keerthanams ADD COLUMN IF NOT EXISTS search_vector tsvector
  GENERATED ALWAYS AS (
    to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(description, ''))
  ) STORED;

CREATE INDEX IF NOT EXISTS idx_guru_keerthanams_search ON public.guru_keerthanams USING GIN(search_vector);

-- ══════════════════════════════════════════════════════════════
-- PART 2: Junction table – keerthanam ↔ categories (many-to-many)
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.guru_keerthanam_categories (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  keerthanam_id   UUID NOT NULL REFERENCES public.guru_keerthanams(id) ON DELETE CASCADE,
  category_id     UUID NOT NULL REFERENCES public.content_categories(id) ON DELETE CASCADE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(keerthanam_id, category_id)
);

CREATE INDEX IF NOT EXISTS idx_gkc_keerthanam ON public.guru_keerthanam_categories(keerthanam_id);
CREATE INDEX IF NOT EXISTS idx_gkc_category   ON public.guru_keerthanam_categories(category_id);

-- ══════════════════════════════════════════════════════════════
-- PART 3: RLS
-- ══════════════════════════════════════════════════════════════

-- guru_keerthanams
ALTER TABLE public.guru_keerthanams ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS guru_keerthanams_select ON public.guru_keerthanams;
CREATE POLICY guru_keerthanams_select ON public.guru_keerthanams
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted) OR public.is_admin()
  );

DROP POLICY IF EXISTS guru_keerthanams_insert ON public.guru_keerthanams;
CREATE POLICY guru_keerthanams_insert ON public.guru_keerthanams
  FOR INSERT WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS guru_keerthanams_update ON public.guru_keerthanams;
CREATE POLICY guru_keerthanams_update ON public.guru_keerthanams
  FOR UPDATE USING (public.is_admin());

DROP POLICY IF EXISTS guru_keerthanams_delete ON public.guru_keerthanams;
CREATE POLICY guru_keerthanams_delete ON public.guru_keerthanams
  FOR DELETE USING (public.is_admin());

GRANT SELECT ON public.guru_keerthanams TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.guru_keerthanams TO authenticated;

-- guru_keerthanam_categories
ALTER TABLE public.guru_keerthanam_categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS gkc_select ON public.guru_keerthanam_categories;
CREATE POLICY gkc_select ON public.guru_keerthanam_categories
  FOR SELECT USING (TRUE);

DROP POLICY IF EXISTS gkc_insert ON public.guru_keerthanam_categories;
CREATE POLICY gkc_insert ON public.guru_keerthanam_categories
  FOR INSERT WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS gkc_update ON public.guru_keerthanam_categories;
CREATE POLICY gkc_update ON public.guru_keerthanam_categories
  FOR UPDATE USING (public.is_admin());

DROP POLICY IF EXISTS gkc_delete ON public.guru_keerthanam_categories;
CREATE POLICY gkc_delete ON public.guru_keerthanam_categories
  FOR DELETE USING (public.is_admin());

GRANT SELECT ON public.guru_keerthanam_categories TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.guru_keerthanam_categories TO authenticated;

-- ══════════════════════════════════════════════════════════════
-- PART 4: Triggers
-- ══════════════════════════════════════════════════════════════

DROP TRIGGER IF EXISTS guru_keerthanams_updated_at ON public.guru_keerthanams;
CREATE TRIGGER guru_keerthanams_updated_at
  BEFORE UPDATE ON public.guru_keerthanams
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS audit_guru_keerthanams ON public.guru_keerthanams;
CREATE TRIGGER audit_guru_keerthanams
  AFTER INSERT OR UPDATE OR DELETE ON public.guru_keerthanams
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

-- ══════════════════════════════════════════════════════════════
-- PART 5: Register in content_types
-- ══════════════════════════════════════════════════════════════

INSERT INTO public.content_types (name, display_name, description, icon, color, table_name, display_order)
VALUES ('guru_keerthanams', 'Guru Keerthanams', 'Sacred songs with multiple categories', '🎵', '#f59e0b', 'guru_keerthanams', 5)
ON CONFLICT (name) DO NOTHING;

-- ── Reload schema cache ────────────────────────────────────

NOTIFY pgrst, 'reload schema';
