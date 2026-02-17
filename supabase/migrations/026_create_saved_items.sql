-- ============================================================
-- 026_create_saved_items.sql
-- Saved items for users (krithis, keerthanams)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.saved_items (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content_type TEXT NOT NULL,
  content_id   UUID NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_saved_items_user_content
  ON public.saved_items(user_id, content_type, content_id);

CREATE INDEX IF NOT EXISTS idx_saved_items_user
  ON public.saved_items(user_id);

ALTER TABLE public.saved_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS saved_items_select ON public.saved_items;
CREATE POLICY saved_items_select
  ON public.saved_items
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS saved_items_insert ON public.saved_items;
CREATE POLICY saved_items_insert
  ON public.saved_items
  FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS saved_items_delete ON public.saved_items;
CREATE POLICY saved_items_delete
  ON public.saved_items
  FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

NOTIFY pgrst, 'reload schema';
