import { NextRequest, NextResponse } from "next/server";
import { requireAdminCookie } from "@/lib/appwrite/api-auth";
import {
  getAppwriteDatabaseId,
  getAppwriteDatabases,
  getModuleCollectionId,
} from "@/lib/appwrite/content-server";
import { isContentModuleKey } from "@/lib/content/content-modules";

export const runtime = "nodejs";

export async function GET(
  _request: NextRequest,
  context: { params: Promise<{ module: string; id: string }> },
) {
  const auth = await requireAdminCookie();
  if (!auth.ok) {
    return NextResponse.json({ error: auth.error }, { status: auth.status });
  }

  const { module, id } = await context.params;
  if (!isContentModuleKey(module)) {
    return NextResponse.json({ error: "Invalid module" }, { status: 400 });
  }

  const databases = getAppwriteDatabases();
  const doc = await databases.getDocument(getAppwriteDatabaseId(), getModuleCollectionId(module), id);
  return NextResponse.json({ data: { id: doc.$id, ...doc } });
}

export async function PATCH(
  request: NextRequest,
  context: { params: Promise<{ module: string; id: string }> },
) {
  const auth = await requireAdminCookie();
  if (!auth.ok) {
    return NextResponse.json({ error: auth.error }, { status: auth.status });
  }

  const { module, id } = await context.params;
  if (!isContentModuleKey(module)) {
    return NextResponse.json({ error: "Invalid module" }, { status: 400 });
  }

  const body = (await request.json()) as Record<string, unknown>;
  const updates: Record<string, unknown> = {
    ...body,
    updated_at: new Date().toISOString(),
  };

  if (typeof body.title === "string") {
    updates.slug = body.title
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9\s-]/g, "")
      .replace(/\s+/g, "-");
  }

  if (body.status !== undefined) {
    updates.published_at = body.status === "published" ? new Date().toISOString() : null;
  }

  const databases = getAppwriteDatabases();
  const updated = await databases.updateDocument(
    getAppwriteDatabaseId(),
    getModuleCollectionId(module),
    id,
    updates,
  );

  return NextResponse.json({ data: { id: updated.$id, ...updated } });
}

export async function DELETE(
  _request: NextRequest,
  context: { params: Promise<{ module: string; id: string }> },
) {
  const auth = await requireAdminCookie();
  if (!auth.ok) {
    return NextResponse.json({ error: auth.error }, { status: auth.status });
  }

  const { module, id } = await context.params;
  if (!isContentModuleKey(module)) {
    return NextResponse.json({ error: "Invalid module" }, { status: 400 });
  }

  const databases = getAppwriteDatabases();
  const updated = await databases.updateDocument(
    getAppwriteDatabaseId(),
    getModuleCollectionId(module),
    id,
    {
      is_deleted: true,
      deleted_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
  );

  return NextResponse.json({ data: { id: updated.$id, ...updated } });
}
