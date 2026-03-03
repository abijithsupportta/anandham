import { NextRequest, NextResponse } from "next/server";
import { requireAdminCookie } from "@/lib/appwrite/api-auth";
import {
  getAppwriteDatabaseId,
  getAppwriteDatabases,
  getContentCategoriesCollectionId,
} from "@/lib/appwrite/content-server";

export const runtime = "nodejs";

export async function PATCH(
  request: NextRequest,
  context: { params: Promise<{ id: string }> },
) {
  try {
    const auth = await requireAdminCookie();
    if (!auth.ok) {
      return NextResponse.json({ error: auth.error }, { status: auth.status });
    }

    const { id } = await context.params;
    const body = (await request.json()) as Record<string, unknown>;
    const updates: Record<string, unknown> = {
      ...body,
      updated_at: new Date().toISOString(),
    };

    if (typeof body.name === "string") {
      updates.slug = body.name
        .toLowerCase()
        .trim()
        .replace(/[^a-z0-9\s-]/g, "")
        .replace(/\s+/g, "-");
    }

    const databases = getAppwriteDatabases();
    const updated = await databases.updateDocument(
      getAppwriteDatabaseId(),
      getContentCategoriesCollectionId(),
      id,
      updates,
    );

    return NextResponse.json({ data: { id: updated.$id, ...updated } });
  } catch (error) {
    console.error("PATCH /api/content-management/categories/[id] failed:", error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Failed to update category" },
      { status: 500 },
    );
  }
}

export async function DELETE(
  _request: NextRequest,
  context: { params: Promise<{ id: string }> },
) {
  try {
    const auth = await requireAdminCookie();
    if (!auth.ok) {
      return NextResponse.json({ error: auth.error }, { status: auth.status });
    }

    const { id } = await context.params;
    const databases = getAppwriteDatabases();
    const updated = await databases.updateDocument(
      getAppwriteDatabaseId(),
      getContentCategoriesCollectionId(),
      id,
      {
        is_deleted: true,
        is_active: false,
        updated_at: new Date().toISOString(),
      },
    );

    return NextResponse.json({ data: { id: updated.$id, ...updated } });
  } catch (error) {
    console.error("DELETE /api/content-management/categories/[id] failed:", error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Failed to delete category" },
      { status: 500 },
    );
  }
}
