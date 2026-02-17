-- ============================================================
-- 018_create_guru_photo_images.sql
-- Adds multi-image support to guru_photos
-- Each guru_photo can have multiple images stored in R2
-- Run in: Supabase SQL Editor (after 017)
-- ============================================================

-- ── Step 1: Create guru_photo_images table ─────────────────

CREATE TABLE IF NOT EXISTS public.guru_photo_images (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  guru_photo_id UUID NOT NULL REFERENCES public.guru_photos(id) ON DELETE CASCADE,
  image_url     TEXT NOT NULL,
  display_order INT NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_guru_photo_images_photo
  ON public.guru_photo_images(guru_photo_id, display_order);

-- ── Step 2: Enable RLS ─────────────────────────────────────

ALTER TABLE public.guru_photo_images ENABLE ROW LEVEL SECURITY;

-- ── Step 3: RLS Policies ───────────────────────────────────

DROP POLICY IF EXISTS guru_photo_images_select ON public.guru_photo_images;
DROP POLICY IF EXISTS guru_photo_images_insert ON public.guru_photo_images;
DROP POLICY IF EXISTS guru_photo_images_update ON public.guru_photo_images;
DROP POLICY IF EXISTS guru_photo_images_delete ON public.guru_photo_images;

CREATE POLICY guru_photo_images_select ON public.guru_photo_images
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.guru_photos gp
      WHERE gp.id = guru_photo_id
      AND gp.status = 'published'
      AND NOT gp.is_deleted
    )
    OR public.is_admin()
  );

CREATE POLICY guru_photo_images_insert ON public.guru_photo_images
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY guru_photo_images_update ON public.guru_photo_images
  FOR UPDATE USING (public.is_admin());

CREATE POLICY guru_photo_images_delete ON public.guru_photo_images
  FOR DELETE USING (public.is_admin());

-- ── Step 4: Grant permissions ──────────────────────────────

GRANT SELECT ON public.guru_photo_images TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.guru_photo_images TO authenticated;

-- ── Step 5: Triggers ───────────────────────────────────────

DROP TRIGGER IF EXISTS guru_photo_images_updated_at ON public.guru_photo_images;
CREATE TRIGGER guru_photo_images_updated_at
  BEFORE UPDATE ON public.guru_photo_images
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS audit_guru_photo_images ON public.guru_photo_images;
CREATE TRIGGER audit_guru_photo_images
  AFTER INSERT OR UPDATE OR DELETE ON public.guru_photo_images
  FOR EACH ROW
  EXECUTE FUNCTION public.audit_trigger_func();

-- ── Step 6: Reload schema cache ────────────────────────────

NOTIFY pgrst, 'reload schema';
