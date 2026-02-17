import type { AuditLog } from "@/types/database";
import { getSupabase } from "./base";
import type { ServiceResult } from "./base";

// ── Audit Log service ──────────────────────────────────────

export const auditLogService = {
  async getRecent(limit = 500): Promise<ServiceResult<AuditLog[]>> {
    try {
      const sb = getSupabase();
      const { data, error } = await sb
        .from("audit_logs")
        .select("*, user:profiles!changed_by(full_name)")
        .order("changed_at", { ascending: false })
        .limit(limit);

      if (error) return { data: null, error: error.message };
      return { data: data as AuditLog[], error: null };
    } catch (err) {
      const message = err instanceof Error ? err.message : "An unexpected error occurred";
      return { data: null, error: message };
    }
  },
};
