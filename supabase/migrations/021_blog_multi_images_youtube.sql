-- ============================================================
-- Migration 021 – Blog: multiple cover images + YouTube URL
-- ============================================================

-- 1. Convert single cover_image TEXT → cover_images TEXT[]
ALTER TABLE public.blogs
  ADD COLUMN cover_images TEXT[] DEFAULT '{}';

-- Migrate existing data
UPDATE public.blogs
  SET cover_images = ARRAY[cover_image]
  WHERE cover_image IS NOT NULL AND cover_image <> '';

ALTER TABLE public.blogs
  DROP COLUMN cover_image;

-- 2. Add youtube_url column
ALTER TABLE public.blogs
  ADD COLUMN youtube_url TEXT;
