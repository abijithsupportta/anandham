-- ============================================================
-- 012_create_audit_logs.sql
-- Automatic audit trail for all content changes
-- Run in: Supabase SQL Editor (after 011)
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
