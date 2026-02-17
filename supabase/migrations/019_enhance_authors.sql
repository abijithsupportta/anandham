-- ============================================================
-- 019_enhance_authors.sql
-- Adds authentication & profile fields to authors
-- Links authors to auth.users for login capability
-- Run in: Supabase SQL Editor (after 018)
-- ============================================================

-- ── Step 1: Add new columns to authors ─────────────────────

ALTER TABLE public.authors
  ADD COLUMN IF NOT EXISTS user_id  UUID UNIQUE REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS email    TEXT,
  ADD COLUMN IF NOT EXISTS phone    TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS address  TEXT DEFAULT '';

CREATE INDEX IF NOT EXISTS idx_authors_user_id ON public.authors(user_id);
CREATE INDEX IF NOT EXISTS idx_authors_email   ON public.authors(email);

-- ── Step 2: Ensure author_assignments RLS ──────────────────
-- (Table was created in 011 but may not have RLS policies)

ALTER TABLE public.author_assignments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS author_assignments_select ON public.author_assignments;
DROP POLICY IF EXISTS author_assignments_insert ON public.author_assignments;
DROP POLICY IF EXISTS author_assignments_update ON public.author_assignments;
DROP POLICY IF EXISTS author_assignments_delete ON public.author_assignments;

CREATE POLICY author_assignments_select ON public.author_assignments
  FOR SELECT USING (public.is_admin() OR auth.uid() = user_id);

CREATE POLICY author_assignments_insert ON public.author_assignments
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY author_assignments_update ON public.author_assignments
  FOR UPDATE USING (public.is_admin());

CREATE POLICY author_assignments_delete ON public.author_assignments
  FOR DELETE USING (public.is_admin());

-- ── Step 3: Grant permissions on author_assignments ────────

GRANT SELECT ON public.author_assignments TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.author_assignments TO authenticated;

-- ── Step 4: Add trigger for author_assignments ─────────────

DROP TRIGGER IF EXISTS audit_author_assignments ON public.author_assignments;
CREATE TRIGGER audit_author_assignments
  AFTER INSERT OR UPDATE OR DELETE ON public.author_assignments
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

-- ── Step 5: Reload schema cache ────────────────────────────

NOTIFY pgrst, 'reload schema';
