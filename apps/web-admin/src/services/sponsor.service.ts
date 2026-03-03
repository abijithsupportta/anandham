import type { Sponsor, ContentStatus } from "@/types/database";
import { serviceCall, now, getSupabase } from "./base";
import type { ServiceResult } from "./base";

export interface SponsorFormInput {
  sponsor_name: string;
  house_name: string;
  photo_url: string;
  donated_amount: number;
  amount_visible: boolean;
  status: ContentStatus;
}

export const sponsorService = {
  async getAll(): Promise<ServiceResult<Sponsor[]>> {
    return serviceCall((sb) =>
      sb
        .from("sponsors")
        .select("*")
        .eq("is_deleted", false)
        .order("donated_amount", { ascending: false })
        .order("created_at", { ascending: true })
    );
  },

  async getById(id: string): Promise<ServiceResult<Sponsor>> {
    return serviceCall((sb) => sb.from("sponsors").select("*").eq("id", id).single());
  },

  async create(input: SponsorFormInput): Promise<ServiceResult<Sponsor>> {
    const timestamp = now();
    const sb = getSupabase();
    const {
      data: { user },
    } = await sb.auth.getUser();

    return serviceCall((innerSb) =>
      innerSb
        .from("sponsors")
        .insert({
          sponsor_name: input.sponsor_name,
          house_name: input.house_name,
          photo_url: input.photo_url,
          donated_amount: input.donated_amount,
          amount_visible: input.amount_visible,
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

  async update(id: string, input: SponsorFormInput, publish = false): Promise<ServiceResult<Sponsor>> {
    const timestamp = now();
    const status = publish ? ("published" as const) : input.status;
    const sb = getSupabase();
    const {
      data: { user },
    } = await sb.auth.getUser();

    return serviceCall((innerSb) =>
      innerSb
        .from("sponsors")
        .update({
          sponsor_name: input.sponsor_name,
          house_name: input.house_name,
          photo_url: input.photo_url,
          donated_amount: input.donated_amount,
          amount_visible: input.amount_visible,
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

  async toggleStatus(sponsor: Sponsor): Promise<ServiceResult<null>> {
    const newStatus: ContentStatus = sponsor.status === "draft" ? "published" : "draft";
    const timestamp = now();

    return serviceCall((sb) =>
      sb
        .from("sponsors")
        .update({
          status: newStatus,
          published_at: newStatus === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", sponsor.id)
    ) as Promise<ServiceResult<null>>;
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("sponsors")
        .update({ is_deleted: true, deleted_at: now(), updated_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
