import type { GuruKeerthanam, ContentCategory, ContentStatus } from "@/types/database";
import { serviceCall, getSupabase, toSlug, now } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface KeerthanamFormInput {
  title: string;
  description: string;
  author_name: string;
  category_ids: string[];
  youtube_url: string;
  status: ContentStatus;
}

// ── Keerthanam service ─────────────────────────────────────

export const keerthanamService = {
  async getAll(): Promise<ServiceResult<GuruKeerthanam[]>> {
    const sb = getSupabase();

    // Fetch keerthanams
    const { data, error } = await sb
      .from("guru_keerthanams")
      .select("*")
      .eq("is_deleted", false)
      .order("created_at", { ascending: false });

    if (error) return { data: null, error: error.message };

    // Fetch all category links in one go
    const ids = (data ?? []).map((k: GuruKeerthanam) => k.id);
    if (ids.length === 0) return { data: data as GuruKeerthanam[], error: null };

    const { data: links } = await sb
      .from("guru_keerthanam_categories")
      .select("keerthanam_id, category:content_categories(id, name)")
      .in("keerthanam_id", ids);

    // Group categories by keerthanam_id
    const catMap = new Map<string, ContentCategory[]>();
    for (const link of links ?? []) {
      const rec = link as unknown as { keerthanam_id: string; category: ContentCategory };
      if (!catMap.has(rec.keerthanam_id)) catMap.set(rec.keerthanam_id, []);
      catMap.get(rec.keerthanam_id)!.push(rec.category);
    }

    const result = (data as GuruKeerthanam[]).map((k) => ({
      ...k,
      categories: catMap.get(k.id) ?? [],
    }));

    return { data: result, error: null };
  },

  async getById(id: string): Promise<ServiceResult<GuruKeerthanam>> {
    const sb = getSupabase();

    const { data, error } = await sb
      .from("guru_keerthanams")
      .select("*")
      .eq("id", id)
      .single();

    if (error) return { data: null, error: error.message };

    // Fetch categories for this keerthanam
    const { data: links } = await sb
      .from("guru_keerthanam_categories")
      .select("category:content_categories(id, name)")
      .eq("keerthanam_id", id);

    const categories = (links ?? []).map(
      (l) => (l as unknown as { category: ContentCategory }).category
    );

    return {
      data: { ...(data as GuruKeerthanam), categories } as GuruKeerthanam,
      error: null,
    };
  },

  async getCategories(): Promise<ServiceResult<ContentCategory[]>> {
    const sb = getSupabase();
    const { data, error } = await sb
      .from("content_categories")
      .select("*, content_type:content_types!inner(table_name)")
      .eq("is_active", true)
      .eq("content_type.table_name", "guru_keerthanams")
      .order("name");

    if (error) return { data: null, error: error.message };
    return { data: data as unknown as ContentCategory[], error: null };
  },

  async create(input: KeerthanamFormInput): Promise<ServiceResult<GuruKeerthanam>> {
    const sb = getSupabase();
    const timestamp = now();
    const isPublished = input.status === "published";

    const { data, error } = await sb
      .from("guru_keerthanams")
      .insert({
        title: input.title,
        slug: toSlug(input.title),
        description: input.description,
        author_name: input.author_name || '',
        youtube_url: input.youtube_url || null,
        status: input.status,
        published_at: isPublished ? timestamp : null,
        created_at: timestamp,
        updated_at: timestamp,
      })
      .select()
      .single();

    if (error) return { data: null, error: error.message };

    // Insert category links
    if (input.category_ids.length > 0) {
      await sb.from("guru_keerthanam_categories").insert(
        input.category_ids.map((cid) => ({
          keerthanam_id: (data as GuruKeerthanam).id,
          category_id: cid,
        }))
      );
    }

    return { data: data as GuruKeerthanam, error: null };
  },

  async update(
    id: string,
    input: KeerthanamFormInput,
    publish = false
  ): Promise<ServiceResult<GuruKeerthanam>> {
    const sb = getSupabase();
    const timestamp = now();
    const status = publish ? ("published" as const) : input.status;

    const { data, error } = await sb
      .from("guru_keerthanams")
      .update({
        title: input.title,
        slug: toSlug(input.title),
        description: input.description,
        author_name: input.author_name || '',
        youtube_url: input.youtube_url || null,
        status,
        published_at: status === "published" ? timestamp : null,
        updated_at: timestamp,
      })
      .eq("id", id)
      .select()
      .single();

    if (error) return { data: null, error: error.message };

    // Sync categories: delete old, insert new
    await sb
      .from("guru_keerthanam_categories")
      .delete()
      .eq("keerthanam_id", id);

    if (input.category_ids.length > 0) {
      await sb.from("guru_keerthanam_categories").insert(
        input.category_ids.map((cid) => ({
          keerthanam_id: id,
          category_id: cid,
        }))
      );
    }

    return { data: data as GuruKeerthanam, error: null };
  },

  async toggleStatus(item: GuruKeerthanam): Promise<ServiceResult<null>> {
    const newStatus: ContentStatus =
      item.status === "draft" ? "published" : "draft";
    const timestamp = now();

    return serviceCall((sb) =>
      sb
        .from("guru_keerthanams")
        .update({
          status: newStatus,
          published_at: newStatus === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", item.id)
    ) as Promise<ServiceResult<null>>;
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("guru_keerthanams")
        .update({ is_deleted: true, deleted_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
