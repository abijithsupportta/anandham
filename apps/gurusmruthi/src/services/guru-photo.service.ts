import type { GuruPhoto, GuruPhotoImage, ContentCategory } from "@/types/database";
import { serviceCall, getSupabase } from "./base";
import type { ServiceResult } from "./base";

// ── Guru Photo service ─────────────────────────────────────

export const guruPhotoService = {
  async getAll(): Promise<ServiceResult<GuruPhoto[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("is_deleted", false)
        .eq("status", "published")
        .order("display_order")
    );
  },

  async getById(id: string): Promise<ServiceResult<GuruPhoto>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("id", id)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getBySlug(slug: string): Promise<ServiceResult<GuruPhoto>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("slug", slug)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getByCategory(categoryId: string): Promise<ServiceResult<GuruPhoto[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("category_id", categoryId)
        .eq("status", "published")
        .eq("is_deleted", false)
        .order("display_order")
    );
  },

  async getImages(guruPhotoId: string): Promise<ServiceResult<GuruPhotoImage[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photo_images")
        .select("*")
        .eq("guru_photo_id", guruPhotoId)
        .order("display_order", { ascending: true })
    );
  },

  async getCategories(): Promise<ServiceResult<ContentCategory[]>> {
    const sb = getSupabase();
    const { data, error } = await sb
      .from("content_categories")
      .select("*, content_type:content_types!inner(table_name)")
      .eq("is_active", true)
      .eq("content_type.table_name", "guru_photos")
      .order("name");

    if (error) return { data: null, error: error.message };
    return { data: data as unknown as ContentCategory[], error: null };
  },
};
