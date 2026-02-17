-- ============================================================
-- fix_permissions.sql
-- Run this in Supabase SQL Editor to fix 403 errors
-- This ensures proper GRANT permissions + RLS policies
-- ============================================================

-- ── Step 1: Grant schema usage ─────────────────────────────
GRANT USAGE ON SCHEMA public TO anon, authenticated;

-- ── Step 2: Grant table permissions ────────────────────────
-- Anon (unauthenticated) can only SELECT
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;

-- Authenticated users can do everything (RLS policies control access)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;

-- Ensure future tables also get grants
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT ON TABLES TO anon;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO authenticated;

-- ── Step 3: Ensure RLS is enabled ──────────────────────────
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.authors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.krithis ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.slokas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dharmas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dharma_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guru_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.author_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dharma_words ENABLE ROW LEVEL SECURITY;

-- ── Step 4: Recreate helper functions ──────────────────────
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
    AND role IN ('super_admin', 'admin')
    AND is_active = TRUE
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
    AND role = 'super_admin'
    AND is_active = TRUE
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ── Step 5: Recreate all RLS policies (DROP IF EXISTS first) ───

-- Profiles
DROP POLICY IF EXISTS profiles_select_own ON public.profiles;
DROP POLICY IF EXISTS profiles_select_admin ON public.profiles;
DROP POLICY IF EXISTS profiles_update_admin ON public.profiles;
DROP POLICY IF EXISTS profiles_update_own ON public.profiles;

CREATE POLICY profiles_select_own ON public.profiles
  FOR SELECT USING (id = auth.uid());
CREATE POLICY profiles_select_admin ON public.profiles
  FOR SELECT USING (public.is_admin());
CREATE POLICY profiles_update_admin ON public.profiles
  FOR UPDATE USING (public.is_admin());
CREATE POLICY profiles_update_own ON public.profiles
  FOR UPDATE USING (id = auth.uid());

-- Content Types
DROP POLICY IF EXISTS content_types_select ON public.content_types;
DROP POLICY IF EXISTS content_types_insert ON public.content_types;
DROP POLICY IF EXISTS content_types_update ON public.content_types;
DROP POLICY IF EXISTS content_types_delete ON public.content_types;

CREATE POLICY content_types_select ON public.content_types
  FOR SELECT USING (TRUE);
CREATE POLICY content_types_insert ON public.content_types
  FOR INSERT WITH CHECK (public.is_super_admin());
CREATE POLICY content_types_update ON public.content_types
  FOR UPDATE USING (public.is_super_admin());
CREATE POLICY content_types_delete ON public.content_types
  FOR DELETE USING (public.is_super_admin());

-- Content Categories
DROP POLICY IF EXISTS content_categories_select ON public.content_categories;
DROP POLICY IF EXISTS content_categories_insert ON public.content_categories;
DROP POLICY IF EXISTS content_categories_update ON public.content_categories;
DROP POLICY IF EXISTS content_categories_delete ON public.content_categories;

CREATE POLICY content_categories_select ON public.content_categories
  FOR SELECT USING (TRUE);
CREATE POLICY content_categories_insert ON public.content_categories
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY content_categories_update ON public.content_categories
  FOR UPDATE USING (public.is_admin());
CREATE POLICY content_categories_delete ON public.content_categories
  FOR DELETE USING (public.is_admin());

-- Authors
DROP POLICY IF EXISTS authors_select ON public.authors;
DROP POLICY IF EXISTS authors_insert ON public.authors;
DROP POLICY IF EXISTS authors_update ON public.authors;

CREATE POLICY authors_select ON public.authors
  FOR SELECT USING (TRUE);
CREATE POLICY authors_insert ON public.authors
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY authors_update ON public.authors
  FOR UPDATE USING (public.is_admin());

-- Krithis
DROP POLICY IF EXISTS krithis_select_public ON public.krithis;
DROP POLICY IF EXISTS krithis_insert ON public.krithis;
DROP POLICY IF EXISTS krithis_update ON public.krithis;

CREATE POLICY krithis_select_public ON public.krithis
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );
CREATE POLICY krithis_insert ON public.krithis
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY krithis_update ON public.krithis
  FOR UPDATE USING (public.is_admin());

-- Slokas
DROP POLICY IF EXISTS slokas_select_public ON public.slokas;
DROP POLICY IF EXISTS slokas_insert ON public.slokas;
DROP POLICY IF EXISTS slokas_update ON public.slokas;

CREATE POLICY slokas_select_public ON public.slokas
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.krithis k
      WHERE k.id = krithi_id
      AND k.status = 'published'
      AND NOT k.is_deleted
    )
    OR public.is_admin()
  );
CREATE POLICY slokas_insert ON public.slokas
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY slokas_update ON public.slokas
  FOR UPDATE USING (public.is_admin());

-- Dharmas
DROP POLICY IF EXISTS dharmas_select_public ON public.dharmas;
DROP POLICY IF EXISTS dharmas_insert ON public.dharmas;
DROP POLICY IF EXISTS dharmas_update ON public.dharmas;

CREATE POLICY dharmas_select_public ON public.dharmas
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );
CREATE POLICY dharmas_insert ON public.dharmas
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY dharmas_update ON public.dharmas
  FOR UPDATE USING (public.is_admin());

-- Dharma Items
DROP POLICY IF EXISTS dharma_items_select ON public.dharma_items;
DROP POLICY IF EXISTS dharma_items_insert ON public.dharma_items;
DROP POLICY IF EXISTS dharma_items_update ON public.dharma_items;

CREATE POLICY dharma_items_select ON public.dharma_items
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.dharmas d
      WHERE d.id = dharma_id
      AND d.status = 'published'
      AND NOT d.is_deleted
    )
    OR public.is_admin()
  );
CREATE POLICY dharma_items_insert ON public.dharma_items
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY dharma_items_update ON public.dharma_items
  FOR UPDATE USING (public.is_admin());

-- Guru Photos
DROP POLICY IF EXISTS guru_photos_select ON public.guru_photos;
DROP POLICY IF EXISTS guru_photos_insert ON public.guru_photos;
DROP POLICY IF EXISTS guru_photos_update ON public.guru_photos;

CREATE POLICY guru_photos_select ON public.guru_photos
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );
CREATE POLICY guru_photos_insert ON public.guru_photos
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY guru_photos_update ON public.guru_photos
  FOR UPDATE USING (public.is_admin());

-- Author Assignments
DROP POLICY IF EXISTS author_assignments_select ON public.author_assignments;
DROP POLICY IF EXISTS author_assignments_insert ON public.author_assignments;
DROP POLICY IF EXISTS author_assignments_update ON public.author_assignments;
DROP POLICY IF EXISTS author_assignments_delete ON public.author_assignments;

CREATE POLICY author_assignments_select ON public.author_assignments
  FOR SELECT USING (public.is_admin() OR user_id = auth.uid());
CREATE POLICY author_assignments_insert ON public.author_assignments
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY author_assignments_update ON public.author_assignments
  FOR UPDATE USING (public.is_admin());
CREATE POLICY author_assignments_delete ON public.author_assignments
  FOR DELETE USING (public.is_admin());

-- Audit Logs
DROP POLICY IF EXISTS audit_logs_select ON public.audit_logs;

CREATE POLICY audit_logs_select ON public.audit_logs
  FOR SELECT USING (public.is_admin());

-- Dharma Words
DROP POLICY IF EXISTS dharma_words_select ON public.dharma_words;
DROP POLICY IF EXISTS dharma_words_insert ON public.dharma_words;
DROP POLICY IF EXISTS dharma_words_update ON public.dharma_words;
DROP POLICY IF EXISTS dharma_words_delete ON public.dharma_words;

CREATE POLICY dharma_words_select ON public.dharma_words
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.dharmas d
      WHERE d.id = dharma_id
      AND d.status = 'published'
      AND NOT d.is_deleted
    )
    OR public.is_admin()
  );
CREATE POLICY dharma_words_insert ON public.dharma_words
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY dharma_words_update ON public.dharma_words
  FOR UPDATE USING (public.is_admin());
CREATE POLICY dharma_words_delete ON public.dharma_words
  FOR DELETE USING (public.is_admin());

-- ── Step 6: Ensure your profile has super_admin role ───────
UPDATE public.profiles
SET role = 'super_admin', full_name = 'Super Admin', is_active = true
WHERE id = (SELECT id FROM auth.users WHERE email = 'info@abijithcb.com');

-- ── Verify ─────────────────────────────────────────────────
SELECT id, full_name, role, is_active FROM public.profiles
WHERE id = (SELECT id FROM auth.users WHERE email = 'info@abijithcb.com');
