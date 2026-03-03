-- ============================================================
-- 033_create_sponsors.sql
-- Adds Sponsors module
-- ============================================================

CREATE TABLE IF NOT EXISTS public.sponsors (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sponsor_name   TEXT NOT NULL,
  house_name     TEXT NOT NULL DEFAULT '',
  photo_url      TEXT NOT NULL DEFAULT '',
  donated_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (donated_amount >= 0),
  status         public.content_status NOT NULL DEFAULT 'draft',
  published_at   TIMESTAMPTZ,
  is_deleted     BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at     TIMESTAMPTZ,
  created_by     UUID REFERENCES auth.users(id),
  updated_by     UUID REFERENCES auth.users(id),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_sponsors_status
  ON public.sponsors(status)
  WHERE NOT is_deleted;

CREATE INDEX IF NOT EXISTS idx_sponsors_amount_desc
  ON public.sponsors(donated_amount DESC)
  WHERE NOT is_deleted;

CREATE INDEX IF NOT EXISTS idx_sponsors_created_at
  ON public.sponsors(created_at DESC)
  WHERE NOT is_deleted;

ALTER TABLE public.sponsors ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS sponsors_select ON public.sponsors;
DROP POLICY IF EXISTS sponsors_insert ON public.sponsors;
DROP POLICY IF EXISTS sponsors_update ON public.sponsors;
DROP POLICY IF EXISTS sponsors_delete ON public.sponsors;

CREATE POLICY sponsors_select ON public.sponsors
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY sponsors_insert ON public.sponsors
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY sponsors_update ON public.sponsors
  FOR UPDATE USING (public.is_admin());

CREATE POLICY sponsors_delete ON public.sponsors
  FOR DELETE USING (public.is_admin());

GRANT SELECT ON public.sponsors TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.sponsors TO authenticated;

DROP TRIGGER IF EXISTS sponsors_updated_at ON public.sponsors;
CREATE TRIGGER sponsors_updated_at
  BEFORE UPDATE ON public.sponsors
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS audit_sponsors ON public.sponsors;
CREATE TRIGGER audit_sponsors
  AFTER INSERT OR UPDATE OR DELETE ON public.sponsors
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

INSERT INTO public.content_types (name, display_name, description, icon, color, table_name, display_order)
VALUES ('sponsors', 'Sponsors', 'Sponsor profiles with donated amount ranking', '🏅', '#f59e0b', 'sponsors', 8)
ON CONFLICT (name) DO NOTHING;

NOTIFY pgrst, 'reload schema';
