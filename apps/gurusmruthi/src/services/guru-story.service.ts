import type { GuruStory } from "@/types/database";
import { serviceCall } from "./base";
import type { ServiceResult } from "./base";

// ── Guru Story service ─────────────────────────────────────

export const guruStoryService = {
  async getAll(): Promise<ServiceResult<GuruStory[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_stories")
        .select("*")
        .eq("is_deleted", false)
        .eq("status", "published")
        .order("published_at", { ascending: false })
    );
  },

  async getById(id: string): Promise<ServiceResult<GuruStory>> {
    return serviceCall((sb) =>
      sb
        .from("guru_stories")
        .select("*")
        .eq("id", id)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getBySlug(slug: string): Promise<ServiceResult<GuruStory>> {
    return serviceCall((sb) =>
      sb
        .from("guru_stories")
        .select("*")
        .eq("slug", slug)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },
};
