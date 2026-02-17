-- ============================================================
-- 010_create_guru_photos.sql
-- Guru Photos – sacred images with descriptions
-- Run in: Supabase SQL Editor (after 009)
-- ============================================================

CREATE TABLE public.guru_photos (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  description   TEXT DEFAULT '',
  image_url     TEXT NOT NULL,
  category_id   UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  author_id     UUID REFERENCES public.authors(id) ON DELETE SET NULL,
  display_order INT NOT NULL DEFAULT 0,
  status        public.content_status NOT NULL DEFAULT 'draft',
  published_at  TIMESTAMPTZ,
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at    TIMESTAMPTZ,
  created_by    UUID REFERENCES auth.users(id),
  updated_by    UUID REFERENCES auth.users(id),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_guru_photos_status ON public.guru_photos(status, display_order) WHERE NOT is_deleted;
CREATE INDEX idx_guru_photos_category ON public.guru_photos(category_id) WHERE NOT is_deleted;
CREATE INDEX idx_guru_photos_slug ON public.guru_photos(slug);

CREATE TRIGGER guru_photos_updated_at
  BEFORE UPDATE ON public.guru_photos
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
