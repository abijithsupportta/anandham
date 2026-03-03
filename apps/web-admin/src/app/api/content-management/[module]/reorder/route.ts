import { NextRequest, NextResponse } from "next/server";
import { requireAdminCookie } from "@/lib/appwrite/api-auth";
import {
  getAppwriteDatabaseId,
  getAppwriteDatabases,
  getModuleCollectionId,
} from "@/lib/appwrite/content-server";
import { isContentModuleKey } from "@/lib/content/content-modules";

export const runtime = "nodejs";

export async function POST(
  request: NextRequest,
  context: { params: Promise<{ module: string }> },
) {
  const auth = await requireAdminCookie();
  if (!auth.ok) {
    return NextResponse.json({ error: auth.error }, { status: auth.status });
  }

  const { module } = await context.params;
  if (!isContentModuleKey(module)) {
    return NextResponse.json({ error: "Invalid module" }, { status: 400 });
  }

  const body = (await request.json()) as { idsInOrder?: string[] };
  if (!body.idsInOrder || !Array.isArray(body.idsInOrder)) {
    return NextResponse.json({ error: "idsInOrder array is required" }, { status: 400 });
  }

  const databases = getAppwriteDatabases();
  const databaseId = getAppwriteDatabaseId();
  const collectionId = getModuleCollectionId(module);
  const now = new Date().toISOString();

  await Promise.all(
    body.idsInOrder.map((id, index) =>
      databases.updateDocument(databaseId, collectionId, id, {
        display_order: index,
        updated_at: now,
      }),
    ),
  );

  return NextResponse.json({ data: null });
}
