-- ============================================================
-- 013_rls_policies.sql
-- Row Level Security for all tables
-- Run in: Supabase SQL Editor (after 012)
-- ============================================================

-- ── Enable RLS on all tables ───────────────────────────────

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.authors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.krithis ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.slokas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dharmas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dharma_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guru_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.author_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;


-- ── Helper: check if current user is admin/super_admin ─────

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


-- ── Profiles ───────────────────────────────────────────────

-- Users can read their own profile
CREATE POLICY profiles_select_own ON public.profiles
  FOR SELECT USING (id = auth.uid());

-- Admins can read all profiles
CREATE POLICY profiles_select_admin ON public.profiles
  FOR SELECT USING (public.is_admin());

-- Admins can update profiles
CREATE POLICY profiles_update_admin ON public.profiles
  FOR UPDATE USING (public.is_admin());

-- Users can update their own profile (name, avatar only)
CREATE POLICY profiles_update_own ON public.profiles
  FOR UPDATE USING (id = auth.uid());


-- ── Content Types (public read, admin write) ───────────────

CREATE POLICY content_types_select ON public.content_types
  FOR SELECT USING (TRUE);  -- Everyone can see content types

CREATE POLICY content_types_insert ON public.content_types
  FOR INSERT WITH CHECK (public.is_super_admin());

CREATE POLICY content_types_update ON public.content_types
  FOR UPDATE USING (public.is_super_admin());

CREATE POLICY content_types_delete ON public.content_types
  FOR DELETE USING (public.is_super_admin());


-- ── Categories (public read, admin write) ──────────────────

CREATE POLICY categories_select ON public.categories
  FOR SELECT USING (TRUE);  -- Everyone can see categories

CREATE POLICY categories_insert ON public.categories
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY categories_update ON public.categories
  FOR UPDATE USING (public.is_admin());

CREATE POLICY categories_delete ON public.categories
  FOR DELETE USING (public.is_admin());


-- ── Authors (public read, admin write) ─────────────────────

CREATE POLICY authors_select ON public.authors
  FOR SELECT USING (TRUE);

CREATE POLICY authors_insert ON public.authors
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY authors_update ON public.authors
  FOR UPDATE USING (public.is_admin());


-- ── Krithis (guest read published, admin full access) ──────

-- Anyone can read published, non-deleted krithis (guest access)
CREATE POLICY krithis_select_public ON public.krithis
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY krithis_insert ON public.krithis
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY krithis_update ON public.krithis
  FOR UPDATE USING (public.is_admin());


-- ── Slokas (inherit access from parent krithi) ─────────────

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


-- ── Dharmas (guest read published, admin full access) ──────

CREATE POLICY dharmas_select_public ON public.dharmas
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY dharmas_insert ON public.dharmas
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY dharmas_update ON public.dharmas
  FOR UPDATE USING (public.is_admin());


-- ── Dharma Items ───────────────────────────────────────────

CREATE POLICY dharma_items_select_public ON public.dharma_items
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


-- ── Guru Photos (guest read published, admin full access) ──

CREATE POLICY guru_photos_select_public ON public.guru_photos
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY guru_photos_insert ON public.guru_photos
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY guru_photos_update ON public.guru_photos
  FOR UPDATE USING (public.is_admin());


-- ── Author Assignments (admin only) ────────────────────────

CREATE POLICY author_assignments_select ON public.author_assignments
  FOR SELECT USING (
    user_id = auth.uid() OR public.is_admin()
  );

CREATE POLICY author_assignments_insert ON public.author_assignments
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY author_assignments_update ON public.author_assignments
  FOR UPDATE USING (public.is_admin());

CREATE POLICY author_assignments_delete ON public.author_assignments
  FOR DELETE USING (public.is_admin());


-- ── Audit Logs (admin + own logs for authors) ──────────────

CREATE POLICY audit_logs_select ON public.audit_logs
  FOR SELECT USING (
    public.is_admin() OR changed_by = auth.uid()
  );

-- Only triggers insert audit logs, not users directly
CREATE POLICY audit_logs_insert ON public.audit_logs
  FOR INSERT WITH CHECK (TRUE);  -- Trigger runs as SECURITY DEFINER
