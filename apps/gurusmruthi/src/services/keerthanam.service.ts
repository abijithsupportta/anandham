import type { GuruKeerthanam } from "@/types/database";
import { serviceCall } from "./base";
import type { ServiceResult } from "./base";

// ── Guru Keerthanam service ─────────────────────────────

export const keerthanamService = {
  async getAll(): Promise<ServiceResult<GuruKeerthanam[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_keerthanams")
        .select("*, categories:guru_keerthanam_categories(category:content_categories(*))")
        .eq("is_deleted", false)
        .eq("status", "published")
        .order("display_order")
    );
  },

  async getById(id: string): Promise<ServiceResult<GuruKeerthanam>> {
    return serviceCall((sb) =>
      sb
        .from("guru_keerthanams")
        .select("*, categories:guru_keerthanam_categories(category:content_categories(*))")
        .eq("id", id)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getBySlug(slug: string): Promise<ServiceResult<GuruKeerthanam>> {
    return serviceCall((sb) =>
      sb
        .from("guru_keerthanams")
        .select("*, categories:guru_keerthanam_categories(category:content_categories(*))")
        .eq("slug", slug)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getByCategory(): Promise<ServiceResult<GuruKeerthanam[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_keerthanams")
        .select("*, categories:guru_keerthanam_categories(category:content_categories(*))")
        .eq("status", "published")
        .eq("is_deleted", false)
        .order("display_order")
    );
  },
};
