import type { GuruPhoto, GuruPhotoImage, ContentStatus, ContentCategory } from "@/types/database";
import { serviceCall, toSlug, now, getSupabase } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface GuruPhotoFormInput {
  title: string;
  description: string;
  image_url: string;        // primary/cover image URL (from R2)
  category_id: string;
  status: ContentStatus;
}

// ── Guru Photo service ─────────────────────────────────────

export const guruPhotoService = {
  async getAll(): Promise<ServiceResult<GuruPhoto[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .select("*, category:content_categories(*), author:authors(*)")
        .eq("is_deleted", false)
        .order("display_order")
    );
  },

  async reorder(idsInOrder: string[]): Promise<ServiceResult<null>> {
    const sb = getSupabase();

    const updates = idsInOrder.map((id, index) =>
      sb
        .from("guru_photos")
        .update({ display_order: index, updated_at: now() })
        .eq("id", id)
    );

    const results = await Promise.all(updates);
    const error = results.find((result) => result.error)?.error;
    if (error) return { data: null, error: error.message };

    return { data: null, error: null };
  },

  async getById(id: string): Promise<ServiceResult<GuruPhoto>> {
    return serviceCall((sb) =>
      sb.from("guru_photos").select("*").eq("id", id).single()
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

  // ── Images ─────────────────────────────────────────────

  async getImages(guruPhotoId: string): Promise<ServiceResult<GuruPhotoImage[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_photo_images")
        .select("*")
        .eq("guru_photo_id", guruPhotoId)
        .order("display_order", { ascending: true })
    );
  },

  async saveImages(guruPhotoId: string, imageUrls: string[]): Promise<ServiceResult<null>> {
    const sb = getSupabase();

    // Delete all existing images for this guru photo
    const { error: delError } = await sb
      .from("guru_photo_images")
      .delete()
      .eq("guru_photo_id", guruPhotoId);
    if (delError) return { data: null, error: delError.message };

    // Insert new images
    if (imageUrls.length > 0) {
      const rows = imageUrls.map((url, i) => ({
        guru_photo_id: guruPhotoId,
        image_url: url,
        display_order: i,
      }));

      const { error } = await sb.from("guru_photo_images").insert(rows);
      if (error) return { data: null, error: error.message };
    }

    return { data: null, error: null };
  },

  // ── CRUD ───────────────────────────────────────────────

  async create(input: GuruPhotoFormInput): Promise<ServiceResult<GuruPhoto>> {
    const sb = getSupabase();
    const timestamp = now();

    const { data: lastRow } = await sb
      .from("guru_photos")
      .select("display_order")
      .eq("is_deleted", false)
      .order("display_order", { ascending: false })
      .limit(1)
      .maybeSingle();

    const nextOrder = ((lastRow as { display_order?: number } | null)?.display_order ?? -1) + 1;

    return serviceCall((innerSb) =>
      innerSb
        .from("guru_photos")
        .insert({
          title: input.title,
          slug: toSlug(input.title),
          description: input.description,
          image_url: input.image_url || "",
          category_id: input.category_id || null,
          display_order: nextOrder,
          status: input.status,
          published_at: input.status === "published" ? timestamp : null,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: GuruPhotoFormInput, publish = false): Promise<ServiceResult<GuruPhoto>> {
    const timestamp = now();
    const status = publish ? ("published" as const) : input.status;

    return serviceCall((sb) =>
      sb
        .from("guru_photos")
        .update({
          title: input.title,
          slug: toSlug(input.title),
          description: input.description,
          image_url: input.image_url || "",
          category_id: input.category_id || null,
          status,
          published_at: status === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", id)
        .select()
        .single()
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
        .delete()
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
