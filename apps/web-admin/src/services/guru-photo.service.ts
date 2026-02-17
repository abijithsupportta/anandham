import type { GuruPhoto, ContentStatus } from "@/types/database";
import { serviceCall, now } from "./base";
import type { ServiceResult } from "./base";

// ── Guru Photo service ─────────────────────────────────────

export const guruPhotoService = {
  async getAll(): Promise<ServiceResult<GuruPhoto[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .select("*, category:categories(*), author:authors(*)")
        .eq("is_deleted", false)
        .order("display_order")
    );
  },

  async toggleStatus(id: string, current: ContentStatus): Promise<ServiceResult<null>> {
    const newStatus = current === "published" ? "draft" : "published";
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .update({
          status: newStatus,
          published_at: newStatus === "published" ? now() : null,
          updated_at: now(),
        })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .update({ is_deleted: true, deleted_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
