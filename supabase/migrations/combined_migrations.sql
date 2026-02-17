-- ============================================================
-- Combined Migrations: 001..015
-- Run this single file in Supabase SQL Editor to apply all migrations
-- NOTE: Storage buckets must be created via Supabase Storage UI or API
-- ============================================================

-- ============================================================
-- BEGIN: 001_create_enums.sql
-- ============================================================

-- User roles
CREATE TYPE public.user_role AS ENUM ('super_admin', 'admin', 'author');

-- Content status
CREATE TYPE public.content_status AS ENUM ('draft', 'published');

-- Supported languages
CREATE TYPE public.content_language AS ENUM ('ta', 'en', 'sa', 'ml', 'hi');

-- Audit log actions
CREATE TYPE public.audit_action AS ENUM ('INSERT', 'UPDATE', 'DELETE');


-- ============================================================
-- BEGIN: 002_create_profiles.sql
-- ============================================================

CREATE TABLE public.profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name   TEXT NOT NULL DEFAULT '',
  avatar_url  TEXT,
  role        public.user_role NOT NULL DEFAULT 'author',
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for role-based queries
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_profiles_is_active ON public.profiles(is_active);

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'author')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 003_create_content_types.sql
-- ============================================================

CREATE TABLE public.content_types (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL UNIQUE,          -- 'guru_krithis', 'guru_dharmas', 'guru_photos'
  display_name  TEXT NOT NULL,                 -- 'Guru Krithis', 'Guru Dharmas', 'Guru Photos'
  description   TEXT DEFAULT '',
  icon          TEXT DEFAULT '📚',             -- Emoji or icon name
  color         TEXT DEFAULT '#6366f1',         -- Hex color for UI
  table_name    TEXT NOT NULL,                 -- Actual DB table: 'krithis', 'dharmas', 'guru_photos'
  display_order INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_content_types_active ON public.content_types(is_active, display_order);

CREATE TRIGGER content_types_updated_at
  BEFORE UPDATE ON public.content_types
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 004_create_categories.sql
-- ============================================================

CREATE TABLE public.categories (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_type_id UUID NOT NULL REFERENCES public.content_types(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  slug            TEXT NOT NULL,
  description     TEXT DEFAULT '',
  icon            TEXT DEFAULT '📁',
  color           TEXT DEFAULT '#6366f1',
  display_order   INT NOT NULL DEFAULT 0,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(content_type_id, slug)
);

CREATE INDEX idx_categories_content_type ON public.categories(content_type_id);
CREATE INDEX idx_categories_active ON public.categories(is_active, display_order);

CREATE TRIGGER categories_updated_at
  BEFORE UPDATE ON public.categories
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 005_create_authors.sql
-- ============================================================

CREATE TABLE public.authors (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  bio         TEXT DEFAULT '',
  photo_url   TEXT,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_by  UUID REFERENCES auth.users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_authors_active ON public.authors(is_active);
CREATE INDEX idx_authors_verified ON public.authors(is_verified);

CREATE TRIGGER authors_updated_at
  BEFORE UPDATE ON public.authors
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 006_create_krithis.sql
-- ============================================================

CREATE TABLE public.krithis (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  description   TEXT DEFAULT '',
  category_id   UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  author_id     UUID REFERENCES public.authors(id) ON DELETE SET NULL,
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

CREATE INDEX idx_krithis_status ON public.krithis(status) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_category ON public.krithis(category_id) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_author ON public.krithis(author_id) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_language ON public.krithis(language) WHERE NOT is_deleted;
CREATE INDEX idx_krithis_slug ON public.krithis(slug);

-- Full-text search (supports Tamil + English)
ALTER TABLE public.krithis ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(description, ''))
  ) STORED;

CREATE INDEX idx_krithis_search ON public.krithis USING GIN(search_vector);

CREATE TRIGGER krithis_updated_at
  BEFORE UPDATE ON public.krithis
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 007_create_slokas.sql
-- ============================================================

CREATE TABLE public.slokas (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  krithi_id       UUID NOT NULL REFERENCES public.krithis(id) ON DELETE CASCADE,
  sloka_number    INT NOT NULL,
  original_text   TEXT NOT NULL DEFAULT '',       -- Original sacred text
  transliteration TEXT DEFAULT '',                -- Romanized version
  translation     TEXT DEFAULT '',                -- English/other translation
  explanation     TEXT DEFAULT '',                -- Detailed meaning
  is_deleted      BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at      TIMESTAMPTZ,
  created_by      UUID REFERENCES auth.users(id),
  updated_by      UUID REFERENCES auth.users(id),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(krithi_id, sloka_number)
);

CREATE INDEX idx_slokas_krithi ON public.slokas(krithi_id, sloka_number) WHERE NOT is_deleted;

CREATE TRIGGER slokas_updated_at
  BEFORE UPDATE ON public.slokas
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 008_create_dharmas.sql
-- ============================================================

CREATE TABLE public.dharmas (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,
  description   TEXT DEFAULT '',
  category_id   UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  author_id     UUID REFERENCES public.authors(id) ON DELETE SET NULL,
  language      public.content_language NOT NULL DEFAULT 'ta',
  status        public.content_status NOT NULL DEFAULT 'draft',
  published_at  TIMESTAMPTZ,
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at    TIMESTAMPTZ,
  created_by    UUID REFERENCES auth.users(id),
  updated_by    UUID REFERENCES auth.users(id),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_dharmas_status ON public.dharmas(status) WHERE NOT is_deleted;
CREATE INDEX idx_dharmas_category ON public.dharmas(category_id) WHERE NOT is_deleted;
CREATE INDEX idx_dharmas_author ON public.dharmas(author_id) WHERE NOT is_deleted;
CREATE INDEX idx_dharmas_slug ON public.dharmas(slug);

-- Full-text search
ALTER TABLE public.dharmas ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(description, ''))
  ) STORED;

CREATE INDEX idx_dharmas_search ON public.dharmas USING GIN(search_vector);

CREATE TRIGGER dharmas_updated_at
  BEFORE UPDATE ON public.dharmas
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 009_create_dharma_items.sql
-- ============================================================

CREATE TABLE public.dharma_items (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dharma_id     UUID NOT NULL REFERENCES public.dharmas(id) ON DELETE CASCADE,
  item_number   INT NOT NULL,
  text          TEXT NOT NULL DEFAULT '',
  explanation   TEXT DEFAULT '',
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at    TIMESTAMPTZ,
  created_by    UUID REFERENCES auth.users(id),
  updated_by    UUID REFERENCES auth.users(id),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(dharma_id, item_number)
);

CREATE INDEX idx_dharma_items_dharma ON public.dharma_items(dharma_id, item_number) WHERE NOT is_deleted;

CREATE TRIGGER dharma_items_updated_at
  BEFORE UPDATE ON public.dharma_items
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- BEGIN: 010_create_guru_photos.sql
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


-- ============================================================
-- BEGIN: 011_create_author_assignments.sql
-- ============================================================

CREATE TABLE public.author_assignments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content_type_id UUID NOT NULL REFERENCES public.content_types(id) ON DELETE CASCADE,
  record_id       UUID,              -- NULL = all records of this type; specific UUID = single record
  can_create      BOOLEAN NOT NULL DEFAULT FALSE,
  can_edit        BOOLEAN NOT NULL DEFAULT TRUE,
  can_delete      BOOLEAN NOT NULL DEFAULT FALSE,
  assigned_by     UUID REFERENCES auth.users(id),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, content_type_id, record_id)
);

CREATE INDEX idx_author_assignments_user ON public.author_assignments(user_id);
CREATE INDEX idx_author_assignments_content_type ON public.author_assignments(content_type_id);


-- ============================================================
-- BEGIN: 012_create_audit_logs.sql
-- ============================================================

CREATE TABLE public.audit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name  TEXT NOT NULL,
  record_id   UUID NOT NULL,
  action      public.audit_action NOT NULL,
  changed_by  UUID REFERENCES auth.users(id),
  old_data    JSONB,
  new_data    JSONB,
  changed_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_logs_table ON public.audit_logs(table_name, changed_at DESC);
CREATE INDEX idx_audit_logs_record ON public.audit_logs(record_id);
CREATE INDEX idx_audit_logs_user ON public.audit_logs(changed_by);
CREATE INDEX idx_audit_logs_date ON public.audit_logs(changed_at DESC);


-- ============================================================
-- BEGIN: 013_rls_policies.sql
-- ============================================================

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

CREATE POLICY profiles_select_own ON public.profiles
  FOR SELECT USING (id = auth.uid());

CREATE POLICY profiles_select_admin ON public.profiles
  FOR SELECT USING (public.is_admin());

CREATE POLICY profiles_update_admin ON public.profiles
  FOR UPDATE USING (public.is_admin());

CREATE POLICY profiles_update_own ON public.profiles
  FOR UPDATE USING (id = auth.uid());

CREATE POLICY content_types_select ON public.content_types
  FOR SELECT USING (TRUE);

CREATE POLICY content_types_insert ON public.content_types
  FOR INSERT WITH CHECK (public.is_super_admin());

CREATE POLICY content_types_update ON public.content_types
  FOR UPDATE USING (public.is_super_admin());

CREATE POLICY content_types_delete ON public.content_types
  FOR DELETE USING (public.is_super_admin());

CREATE POLICY categories_select ON public.categories
  FOR SELECT USING (TRUE);

CREATE POLICY categories_insert ON public.categories
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY categories_update ON public.categories
  FOR UPDATE USING (public.is_admin());

CREATE POLICY categories_delete ON public.categories
  FOR DELETE USING (public.is_admin());

CREATE POLICY authors_select ON public.authors
  FOR SELECT USING (TRUE);

CREATE POLICY authors_insert ON public.authors
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY authors_update ON public.authors
  FOR UPDATE USING (public.is_admin());

CREATE POLICY krithis_select_public ON public.krithis
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY krithis_insert ON public.krithis
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY krithis_update ON public.krithis
  FOR UPDATE USING (public.is_admin());

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

CREATE POLICY dharmas_select_public ON public.dharmas
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY dharmas_insert ON public.dharmas
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY dharmas_update ON public.dharmas
  FOR UPDATE USING (public.is_admin());

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

CREATE POLICY guru_photos_select_public ON public.guru_photos
  FOR SELECT USING (
    (status = 'published' AND NOT is_deleted)
    OR public.is_admin()
  );

CREATE POLICY guru_photos_insert ON public.guru_photos
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY guru_photos_update ON public.guru_photos
  FOR UPDATE USING (public.is_admin());

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

CREATE POLICY audit_logs_select ON public.audit_logs
  FOR SELECT USING (
    public.is_admin() OR changed_by = auth.uid()
  );

CREATE POLICY audit_logs_insert ON public.audit_logs
  FOR INSERT WITH CHECK (TRUE);


-- ============================================================
-- BEGIN: 014_audit_triggers.sql
-- ============================================================

CREATE OR REPLACE FUNCTION public.audit_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO public.audit_logs (table_name, record_id, action, changed_by, new_data)
    VALUES (TG_TABLE_NAME, NEW.id, 'INSERT', auth.uid(), to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO public.audit_logs (table_name, record_id, action, changed_by, old_data, new_data)
    VALUES (TG_TABLE_NAME, NEW.id, 'UPDATE', auth.uid(), to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO public.audit_logs (table_name, record_id, action, changed_by, old_data)
    VALUES (TG_TABLE_NAME, OLD.id, 'DELETE', auth.uid(), to_jsonb(OLD));
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER audit_authors
  AFTER INSERT OR UPDATE OR DELETE ON public.authors
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

CREATE TRIGGER audit_krithis
  AFTER INSERT OR UPDATE OR DELETE ON public.krithis
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

CREATE TRIGGER audit_slokas
  AFTER INSERT OR UPDATE OR DELETE ON public.slokas
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

CREATE TRIGGER audit_dharmas
  AFTER INSERT OR UPDATE OR DELETE ON public.dharmas
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

CREATE TRIGGER audit_dharma_items
  AFTER INSERT OR UPDATE OR DELETE ON public.dharma_items
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

CREATE TRIGGER audit_guru_photos
  AFTER INSERT OR UPDATE OR DELETE ON public.guru_photos
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

CREATE TRIGGER audit_categories
  AFTER INSERT OR UPDATE OR DELETE ON public.categories
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

CREATE TRIGGER audit_content_types
  AFTER INSERT OR UPDATE OR DELETE ON public.content_types
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();


-- ============================================================
-- BEGIN: 015_seed_content_types.sql
-- ============================================================

INSERT INTO public.content_types (name, display_name, description, icon, color, table_name, display_order)
VALUES
  ('guru_krithis', 'Guru Krithis', 'Sacred poems and songs with slokas', '📿', '#8b5cf6', 'krithis', 1),
  ('guru_dharmas', 'Guru Dharmas', 'Spiritual teachings and principles', '🙏', '#f59e0b', 'dharmas', 2),
  ('guru_photos', 'Guru Photos', 'Sacred and devotional photographs', '📸', '#3b82f6', 'guru_photos', 3)
ON CONFLICT (name) DO NOTHING;

-- Note: Storage buckets must be created via Supabase Storage UI or API.

UPDATE public.profiles
SET role = 'super_admin', full_name = 'Super Admin'
WHERE id = (SELECT id FROM auth.users WHERE email = 'info@abijithcb.com')
AND role != 'super_admin';

-- End of combined migrations
