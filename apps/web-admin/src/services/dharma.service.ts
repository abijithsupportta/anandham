import type { Dharma, DharmaWord, ContentStatus, ContentCategory } from "@/types/database";
import { serviceCall, toSlug, now, getSupabase } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface DharmaFormInput {
  title: string;
  description: string;
  translation: string;
  category_id: string;
  youtube_url: string;
  status: ContentStatus;
}

export interface DharmaWordInput {
  id?: string;          // present when editing an existing word
  word: string;
  meaning: string;
  display_order: number;
}

// ── Dharma service ─────────────────────────────────────────

export const dharmaService = {
  async getAll(): Promise<ServiceResult<Dharma[]>> {
    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .select("*, category:content_categories(id, name)")
        .eq("is_deleted", false)
        .order("created_at", { ascending: false })
    );
  },

  async getById(id: string): Promise<ServiceResult<Dharma>> {
    return serviceCall((sb) =>
      sb.from("dharmas").select("*").eq("id", id).single()
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

  // ── Words ──────────────────────────────────────────────

  async getWords(dharmaId: string): Promise<ServiceResult<DharmaWord[]>> {
    return serviceCall((sb) =>
      sb
        .from("dharma_words")
        .select("*")
        .eq("dharma_id", dharmaId)
        .order("display_order", { ascending: true })
    );
  },

  async saveWords(dharmaId: string, words: DharmaWordInput[]): Promise<ServiceResult<null>> {
    const sb = getSupabase();

    // Get existing word IDs for this dharma
    const { data: existing } = await sb
      .from("dharma_words")
      .select("id")
      .eq("dharma_id", dharmaId);

    const existingIds = new Set((existing ?? []).map((w) => w.id));
    const incomingIds = new Set(words.filter((w) => w.id).map((w) => w.id));

    // Delete words that are no longer in the list
    const toDelete = [...existingIds].filter((id) => !incomingIds.has(id));
    if (toDelete.length > 0) {
      const { error } = await sb
        .from("dharma_words")
        .delete()
        .in("id", toDelete);
      if (error) return { data: null, error: error.message };
    }

    // Upsert remaining words
    if (words.length > 0) {
      const rows = words.map((w, i) => ({
        ...(w.id ? { id: w.id } : {}),
        dharma_id: dharmaId,
        word: w.word,
        meaning: w.meaning,
        display_order: i,
      }));

      const { error } = await sb
        .from("dharma_words")
        .upsert(rows, { onConflict: "id" });
      if (error) return { data: null, error: error.message };
    }

    return { data: null, error: null };
  },

  // ── CRUD ───────────────────────────────────────────────

  async create(input: DharmaFormInput): Promise<ServiceResult<Dharma>> {
    const timestamp = now();
    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .insert({
          title: input.title,
          slug: toSlug(input.title),
          description: input.description,
          translation: input.translation,
          category_id: input.category_id || null,
          youtube_url: input.youtube_url || null,
          status: input.status,
          published_at: input.status === "published" ? timestamp : null,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: DharmaFormInput, publish = false): Promise<ServiceResult<Dharma>> {
    const timestamp = now();
    const status = publish ? "published" as const : input.status;

    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .update({
          title: input.title,
          slug: toSlug(input.title),
          description: input.description,
          translation: input.translation,
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

  async toggleStatus(dharma: Dharma): Promise<ServiceResult<null>> {
    const newStatus: ContentStatus = dharma.status === "draft" ? "published" : "draft";
    const timestamp = now();

    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .update({
          status: newStatus,
          published_at: newStatus === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", dharma.id)
    ) as Promise<ServiceResult<null>>;
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("dharmas")
        .update({ is_deleted: true, deleted_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
