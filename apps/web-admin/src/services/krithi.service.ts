import type { Krithi, ContentStatus, ContentCategory } from "@/types/database";
import { serviceCall, toSlug, now, getSupabase } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface KrithiFormInput {
  title: string;
  description: string;
  category_id: string;
  youtube_url: string;
  status: ContentStatus;
}

// ── Krithi service ─────────────────────────────────────────

export const krithiService = {
  async getAll(): Promise<ServiceResult<Krithi[]>> {
    return serviceCall((sb) =>
      sb
        .from("krithis")
        .select("*, category:content_categories(id, name)")
        .eq("is_deleted", false)
        .order("display_order", { ascending: true })
        .order("created_at", { ascending: false })
    );
  },

  async reorder(idsInOrder: string[]): Promise<ServiceResult<null>> {
    const sb = getSupabase();

    const updates = idsInOrder.map((id, index) =>
      sb
        .from("krithis")
        .update({ display_order: index, updated_at: now() })
        .eq("id", id)
    );

    const results = await Promise.all(updates);
    const error = results.find((result) => result.error)?.error;
    if (error) return { data: null, error: error.message };

    return { data: null, error: null };
  },

  async getById(id: string): Promise<ServiceResult<Krithi>> {
    return serviceCall((sb) =>
      sb.from("krithis").select("*").eq("id", id).single()
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

  async create(input: KrithiFormInput): Promise<ServiceResult<Krithi>> {
    const sb = getSupabase();
    const timestamp = now();

    const { data: lastRow } = await sb
      .from("krithis")
      .select("display_order")
      .eq("is_deleted", false)
      .order("display_order", { ascending: false })
      .limit(1)
      .maybeSingle();

    const nextOrder = ((lastRow as { display_order?: number } | null)?.display_order ?? -1) + 1;

    return serviceCall((innerSb) =>
      innerSb
        .from("krithis")
        .insert({
          title: input.title,
          slug: toSlug(input.title),
          description: input.description,
          category_id: input.category_id || null,
          youtube_url: input.youtube_url || null,
          status: input.status,
          display_order: nextOrder,
          published_at: input.status === "published" ? timestamp : null,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: KrithiFormInput, publish = false): Promise<ServiceResult<Krithi>> {
    const timestamp = now();
    const status = publish ? "published" as const : input.status;

    return serviceCall((sb) =>
      sb
        .from("krithis")
        .update({
          title: input.title,
          slug: toSlug(input.title),
          description: input.description,
          category_id: input.category_id || null,
          youtube_url: input.youtube_url || null,
          status,
          published_at: status === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", id)
        .select()
        .single()
    );
  },

  async toggleStatus(krithi: Krithi): Promise<ServiceResult<null>> {
    const newStatus: ContentStatus = krithi.status === "draft" ? "published" : "draft";
    const timestamp = now();

    return serviceCall((sb) =>
      sb
        .from("krithis")
        .update({
          status: newStatus,
          published_at: newStatus === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", krithi.id)
    ) as Promise<ServiceResult<null>>;
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("krithis")
        .delete()
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
