-- ============================================================
-- 031_create_guru_photo_likes.sql
-- Track one photo like per user with like counts support
-- ============================================================

CREATE TABLE IF NOT EXISTS public.guru_photo_likes (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  guru_photo_id UUID NOT NULL REFERENCES public.guru_photos(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, guru_photo_id)
);

CREATE INDEX IF NOT EXISTS idx_guru_photo_likes_photo
  ON public.guru_photo_likes(guru_photo_id);

CREATE INDEX IF NOT EXISTS idx_guru_photo_likes_created_at
  ON public.guru_photo_likes(created_at DESC);

ALTER TABLE public.guru_photo_likes ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'guru_photo_likes'
      AND policyname = 'guru_photo_likes_select_public'
  ) THEN
    CREATE POLICY guru_photo_likes_select_public
      ON public.guru_photo_likes
      FOR SELECT
      USING (TRUE);
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'guru_photo_likes'
      AND policyname = 'guru_photo_likes_insert_own'
  ) THEN
    CREATE POLICY guru_photo_likes_insert_own
      ON public.guru_photo_likes
      FOR INSERT
      WITH CHECK (auth.uid() = user_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'guru_photo_likes'
      AND policyname = 'guru_photo_likes_delete_own'
  ) THEN
    CREATE POLICY guru_photo_likes_delete_own
      ON public.guru_photo_likes
      FOR DELETE
      USING (auth.uid() = user_id);
  END IF;
END
$$;

NOTIFY pgrst, 'reload schema';
