import type { Dharma, DharmaItem, DharmaWord, ContentCategory } from "@/types/database";
import { serviceCall, getSupabase } from "./base";
import type { ServiceResult } from "./base";

// ── Dharma service ─────────────────────────────────────

export const dharmaService = {
  async getAll(): Promise<ServiceResult<Dharma[]>> {
    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("is_deleted", false)
        .eq("status", "published")
        .order("display_order")
    );
  },

  async getById(id: string): Promise<ServiceResult<Dharma>> {
    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("id", id)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getBySlug(slug: string): Promise<ServiceResult<Dharma>> {
    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("slug", slug)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getByCategory(categoryId: string): Promise<ServiceResult<Dharma[]>> {
    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("category_id", categoryId)
        .eq("status", "published")
        .eq("is_deleted", false)
        .order("display_order")
    );
  },

  async getItems(dharmaId: string): Promise<ServiceResult<DharmaItem[]>> {
    return serviceCall((sb) =>
      sb
        .from("dharma_items")
        .select("*")
        .eq("dharma_id", dharmaId)
        .eq("is_deleted", false)
        .order("item_number", { ascending: true })
    );
  },

  async getWords(dharmaId: string): Promise<ServiceResult<DharmaWord[]>> {
    return serviceCall((sb) =>
      sb
        .from("dharma_words")
        .select("*")
        .eq("dharma_id", dharmaId)
        .order("display_order", { ascending: true })
    );
  },

  async getCategories(): Promise<ServiceResult<ContentCategory[]>> {
    const sb = getSupabase();
    const { data, error } = await sb
      .from("content_categories")
      .select("*, content_type:content_types!inner(table_name)")
      .eq("is_active", true)
      .eq("content_type.table_name", "dharmas")
      .order("name");

    if (error) return { data: null, error: error.message };
    return { data: data as unknown as ContentCategory[], error: null };
  },
};
