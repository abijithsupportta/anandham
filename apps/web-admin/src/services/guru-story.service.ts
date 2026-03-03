import type { GuruStory, ContentStatus } from "@/types/database";
import { serviceCall, toSlug, now, getSupabase } from "./base";
import type { ServiceResult } from "./base";

export interface GuruStoryFormInput {
  title: string;
  body: string;
  author_name: string;
  reference_book: string;
  status: ContentStatus;
}

export const guruStoryService = {
  async getAll(): Promise<ServiceResult<GuruStory[]>> {
    return serviceCall((sb) =>
      sb
        .from("guru_stories")
        .select("*")
        .eq("is_deleted", false)
        .order("created_at", { ascending: false })
    );
  },

  async getById(id: string): Promise<ServiceResult<GuruStory>> {
    return serviceCall((sb) =>
      sb.from("guru_stories").select("*").eq("id", id).single()
    );
  },

  async create(input: GuruStoryFormInput): Promise<ServiceResult<GuruStory>> {
    const timestamp = now();
    const sb = getSupabase();
    const {
      data: { user },
    } = await sb.auth.getUser();

    return serviceCall((innerSb) =>
      innerSb
        .from("guru_stories")
        .insert({
          title: input.title,
          slug: toSlug(input.title),
          body: input.body,
          author_name: input.author_name,
          reference_book: input.reference_book,
          status: input.status,
          published_at: input.status === "published" ? timestamp : null,
          created_by: user?.id ?? null,
          updated_by: user?.id ?? null,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(
    id: string,
    input: GuruStoryFormInput,
    publish = false
  ): Promise<ServiceResult<GuruStory>> {
    const timestamp = now();
    const status = publish ? ("published" as const) : input.status;
    const sb = getSupabase();
    const {
      data: { user },
    } = await sb.auth.getUser();

    return serviceCall((innerSb) =>
      innerSb
        .from("guru_stories")
        .update({
          title: input.title,
          slug: toSlug(input.title),
          body: input.body,
          author_name: input.author_name,
          reference_book: input.reference_book,
          status,
          published_at: status === "published" ? timestamp : null,
          updated_by: user?.id ?? null,
          updated_at: timestamp,
        })
        .eq("id", id)
        .select()
        .single()
    );
  },

  async toggleStatus(story: GuruStory): Promise<ServiceResult<null>> {
    const newStatus: ContentStatus =
      story.status === "draft" ? "published" : "draft";
    const timestamp = now();

    return serviceCall((sb) =>
      sb
        .from("guru_stories")
        .update({
          status: newStatus,
          published_at: newStatus === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", story.id)
    ) as Promise<ServiceResult<null>>;
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("guru_stories")
        .update({ is_deleted: true, deleted_at: now(), updated_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
