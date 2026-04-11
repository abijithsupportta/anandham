import type { Krithi, Sloka, ContentCategory } from "@/types/database";
import { serviceCall, getSupabase } from "./base";
import type { ServiceResult } from "./base";

// ── Krithi service ─────────────────────────────────────

export const krithiService = {
  async getAll(): Promise<ServiceResult<Krithi[]>> {
    return serviceCall((sb) =>
      sb
        .from("krithis")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("is_deleted", false)
        .eq("status", "published")
        .order("display_order")
    );
  },

  async getById(id: string): Promise<ServiceResult<Krithi>> {
    return serviceCall((sb) =>
      sb
        .from("krithis")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("id", id)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getBySlug(slug: string): Promise<ServiceResult<Krithi>> {
    return serviceCall((sb) =>
      sb
        .from("krithis")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("slug", slug)
        .eq("status", "published")
        .eq("is_deleted", false)
        .maybeSingle()
    );
  },

  async getByCategory(categoryId: string): Promise<ServiceResult<Krithi[]>> {
    return serviceCall((sb) =>
      sb
        .from("krithis")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("category_id", categoryId)
        .eq("status", "published")
        .eq("is_deleted", false)
        .order("display_order")
    );
  },

  async getSlokas(krithiId: string): Promise<ServiceResult<Sloka[]>> {
    return serviceCall((sb) =>
      sb
        .from("slokas")
        .select("*")
        .eq("krithi_id", krithiId)
        .eq("is_deleted", false)
        .order("sloka_number", { ascending: true })
    );
  },

  async getCategories(): Promise<ServiceResult<ContentCategory[]>> {
    const sb = getSupabase();
    const { data, error } = await sb
      .from("content_categories")
      .select("*, content_type:content_types!inner(table_name)")
      .eq("is_active", true)
      .eq("content_type.table_name", "krithis")
      .order("name");

    if (error) return { data: null, error: error.message };
    return { data: data as unknown as ContentCategory[], error: null };
  },
};
