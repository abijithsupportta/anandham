-- ============================================================
-- 014_audit_triggers.sql
-- Automatic audit logging triggers for all content tables
-- Run in: Supabase SQL Editor (after 013)
-- ============================================================

-- Generic audit trigger function
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


-- ── Attach triggers to all content tables ──────────────────

-- Authors
CREATE TRIGGER audit_authors
  AFTER INSERT OR UPDATE OR DELETE ON public.authors
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

-- Krithis
CREATE TRIGGER audit_krithis
  AFTER INSERT OR UPDATE OR DELETE ON public.krithis
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

-- Slokas
CREATE TRIGGER audit_slokas
  AFTER INSERT OR UPDATE OR DELETE ON public.slokas
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

-- Dharmas
CREATE TRIGGER audit_dharmas
  AFTER INSERT OR UPDATE OR DELETE ON public.dharmas
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

-- Dharma Items
CREATE TRIGGER audit_dharma_items
  AFTER INSERT OR UPDATE OR DELETE ON public.dharma_items
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

-- Guru Photos
CREATE TRIGGER audit_guru_photos
  AFTER INSERT OR UPDATE OR DELETE ON public.guru_photos
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

-- Categories
CREATE TRIGGER audit_categories
  AFTER INSERT OR UPDATE OR DELETE ON public.categories
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();

-- Content Types
CREATE TRIGGER audit_content_types
  AFTER INSERT OR UPDATE OR DELETE ON public.content_types
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();
