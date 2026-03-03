import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { deleteFromR2, getKeyFromUrl } from "@/lib/r2";

type Params = { params: Promise<{ id: string }> };

export async function DELETE(_: Request, { params }: Params) {
  try {
    const { id } = await params;
    if (!id) {
      return NextResponse.json({ error: "Guru photo id is required" }, { status: 400 });
    }

    const sb = createAdminClient();

    const { data: photo, error: photoError } = await sb
      .from("guru_photos")
      .select("id, image_url")
      .eq("id", id)
      .single();

    if (photoError || !photo) {
      return NextResponse.json({ error: "Guru photo not found" }, { status: 404 });
    }

    const { data: images, error: imagesError } = await sb
      .from("guru_photo_images")
      .select("image_url")
      .eq("guru_photo_id", id);

    if (imagesError) {
      return NextResponse.json({ error: imagesError.message }, { status: 400 });
    }

    const allUrls = new Set<string>();
    if (photo.image_url) allUrls.add(photo.image_url);
    for (const image of images ?? []) {
      if (image.image_url) allUrls.add(image.image_url);
    }

    for (const url of allUrls) {
      const key = getKeyFromUrl(url);
      if (!key) continue;
      await deleteFromR2(key);
    }

    const { error: deleteError } = await sb
      .from("guru_photos")
      .delete()
      .eq("id", id);

    if (deleteError) {
      return NextResponse.json({ error: deleteError.message }, { status: 400 });
    }

    return NextResponse.json({ success: true });
  } catch (err) {
    console.error("DELETE /api/guru-photos/[id] error:", err);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Failed to delete guru photo" },
      { status: 500 }
    );
  }
}
