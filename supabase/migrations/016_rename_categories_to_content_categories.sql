-- ============================================================
-- 016_rename_categories_to_content_categories.sql
-- Renames 'categories' → 'content_categories' to reserve
-- 'categories' for a future blog/article categories table.
-- Run in: Supabase SQL Editor
-- ============================================================

-- ── Step 1: Drop existing RLS policies ─────────────────────
DROP POLICY IF EXISTS categories_select ON public.categories;
DROP POLICY IF EXISTS categories_insert ON public.categories;
DROP POLICY IF EXISTS categories_update ON public.categories;
DROP POLICY IF EXISTS categories_delete ON public.categories;

-- ── Step 2: Drop audit trigger ─────────────────────────────
DROP TRIGGER IF EXISTS audit_categories ON public.categories;

-- ── Step 3: Drop updated_at trigger ────────────────────────
DROP TRIGGER IF EXISTS categories_updated_at ON public.categories;

-- ── Step 4: Rename table ───────────────────────────────────
ALTER TABLE public.categories RENAME TO content_categories;

-- ── Step 5: Rename indexes ─────────────────────────────────
ALTER INDEX IF EXISTS idx_categories_content_type RENAME TO idx_content_categories_content_type;
ALTER INDEX IF EXISTS idx_categories_active RENAME TO idx_content_categories_active;

-- ── Step 6: Recreate triggers on renamed table ─────────────
CREATE TRIGGER content_categories_updated_at
  BEFORE UPDATE ON public.content_categories
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER audit_content_categories
  AFTER INSERT OR UPDATE OR DELETE ON public.content_categories
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

-- ── Step 7: Recreate RLS policies ──────────────────────────
ALTER TABLE public.content_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY content_categories_select ON public.content_categories
  FOR SELECT USING (TRUE);
CREATE POLICY content_categories_insert ON public.content_categories
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY content_categories_update ON public.content_categories
  FOR UPDATE USING (public.is_admin());
CREATE POLICY content_categories_delete ON public.content_categories
  FOR DELETE USING (public.is_admin());

-- ── Verify ─────────────────────────────────────────────────
SELECT tablename FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'content_categories';
