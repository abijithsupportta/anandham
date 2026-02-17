-- ============================================================
-- 020_create_blog_module.sql
-- Blog module: categories (with subcategories) + blogs
-- Separate from content_categories — fully self-contained
-- Run in: Supabase SQL Editor (after 019)
-- ============================================================

-- ══════════════════════════════════════════════════════════════
-- PART 1: Blog Categories (with parent_id for subcategories)
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.blog_categories (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id     UUID REFERENCES public.blog_categories(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  description   TEXT DEFAULT '',
  display_order INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_blog_categories_parent   ON public.blog_categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_blog_categories_slug     ON public.blog_categories(slug);
CREATE INDEX IF NOT EXISTS idx_blog_categories_active   ON public.blog_categories(is_active, display_order);

-- RLS
ALTER TABLE public.blog_categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS blog_categories_select ON public.blog_categories;
DROP POLICY IF EXISTS blog_categories_insert ON public.blog_categories;
DROP POLICY IF EXISTS blog_categories_update ON public.blog_categories;
DROP POLICY IF EXISTS blog_categories_delete ON public.blog_categories;

CREATE POLICY blog_categories_select ON public.blog_categories
  FOR SELECT USING (TRUE); -- public read

CREATE POLICY blog_categories_insert ON public.blog_categories
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY blog_categories_update ON public.blog_categories
  FOR UPDATE USING (public.is_admin());

CREATE POLICY blog_categories_delete ON public.blog_categories
  FOR DELETE USING (public.is_admin());

GRANT SELECT ON public.blog_categories TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.blog_categories TO authenticated;

-- Triggers
DROP TRIGGER IF EXISTS blog_categories_updated_at ON public.blog_categories;
CREATE TRIGGER blog_categories_updated_at
  BEFORE UPDATE ON public.blog_categories
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS audit_blog_categories ON public.blog_categories;
CREATE TRIGGER audit_blog_categories
  AFTER INSERT OR UPDATE OR DELETE ON public.blog_categories
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

-- ══════════════════════════════════════════════════════════════
-- PART 2: Blogs
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.blogs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  excerpt       TEXT DEFAULT '',
  body          TEXT DEFAULT '',
  cover_image   TEXT,
  category_id   UUID REFERENCES public.blog_categories(id) ON DELETE SET NULL,
  author_id     UUID REFERENCES public.authors(id) ON DELETE SET NULL,
  language      public.content_language NOT NULL DEFAULT 'en',
  tags          TEXT[] DEFAULT '{}',
  status        public.content_status NOT NULL DEFAULT 'draft',
  published_at  TIMESTAMPTZ,
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at    TIMESTAMPTZ,
  created_by    UUID REFERENCES auth.users(id),
  updated_by    UUID REFERENCES auth.users(id),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_blogs_slug       ON public.blogs(slug);
CREATE INDEX IF NOT EXISTS idx_blogs_status     ON public.blogs(status) WHERE NOT is_deleted;
CREATE INDEX IF NOT EXISTS idx_blogs_category   ON public.blogs(category_id) WHERE NOT is_deleted;
CREATE INDEX IF NOT EXISTS idx_blogs_author     ON public.blogs(author_id) WHERE NOT is_deleted;
CREATE INDEX IF NOT EXISTS idx_blogs_published  ON public.blogs(published_at DESC) WHERE status = 'published' AND NOT is_deleted;

-- Full-text search
ALTER TABLE public.blogs ADD COLUMN IF NOT EXISTS search_vector tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(excerpt, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(body, '')), 'C')
  ) STORED;

CREATE INDEX IF NOT EXISTS idx_blogs_search ON public.blogs USING gin(search_vector);

-- RLS
ALTER TABLE public.blogs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS blogs_select ON public.blogs;
DROP POLICY IF EXISTS blogs_insert ON public.blogs;
DROP POLICY IF EXISTS blogs_update ON public.blogs;
DROP POLICY IF EXISTS blogs_delete ON public.blogs;

CREATE POLICY blogs_select ON public.blogs
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY blogs_insert ON public.blogs
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY blogs_update ON public.blogs
  FOR UPDATE USING (public.is_admin());

CREATE POLICY blogs_delete ON public.blogs
  FOR DELETE USING (public.is_admin());

GRANT SELECT ON public.blogs TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.blogs TO authenticated;

-- Triggers
DROP TRIGGER IF EXISTS blogs_updated_at ON public.blogs;
CREATE TRIGGER blogs_updated_at
  BEFORE UPDATE ON public.blogs
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS audit_blogs ON public.blogs;
CREATE TRIGGER audit_blogs
  AFTER INSERT OR UPDATE OR DELETE ON public.blogs
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

-- ══════════════════════════════════════════════════════════════
-- PART 3: Add 'blogs' to content_types for author assignments
-- ══════════════════════════════════════════════════════════════

INSERT INTO public.content_types (name, display_name, description, icon, color, table_name, display_order)
VALUES ('blogs', 'Blogs', 'Blog posts and articles', '📝', '#10b981', 'blogs', 4)
ON CONFLICT (name) DO NOTHING;

-- ── Reload schema cache ────────────────────────────────────

NOTIFY pgrst, 'reload schema';
