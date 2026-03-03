import { NextRequest, NextResponse } from "next/server";
import { ID, Query } from "node-appwrite";
import { requireAdminCookie } from "@/lib/appwrite/api-auth";
import {
  getAppwriteDatabaseId,
  getAppwriteDatabases,
  getModuleCollectionId,
} from "@/lib/appwrite/content-server";
import { isContentModuleKey } from "@/lib/content/content-modules";

export const runtime = "nodejs";

export async function GET(
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

  const status = request.nextUrl.searchParams.get("status");
  const queries = [
    Query.equal("is_deleted", false),
    Query.orderAsc("display_order"),
    Query.orderDesc("created_at"),
    Query.limit(500),
  ];

  if (status === "draft" || status === "published") {
    queries.push(Query.equal("status", status));
  }

  const categoryId = request.nextUrl.searchParams.get("categoryId");
  if (categoryId) {
    queries.push(Query.equal("category_id", categoryId));
  }

  const databases = getAppwriteDatabases();
  const result = await databases.listDocuments(
    getAppwriteDatabaseId(),
    getModuleCollectionId(module),
    queries,
  );

  const data = result.documents.map((doc) => ({ id: doc.$id, ...doc }));
  return NextResponse.json({ data });
}

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

  const body = (await request.json()) as Record<string, unknown>;
  if (typeof body.title !== "string" || !body.title.trim()) {
    return NextResponse.json({ error: "title is required" }, { status: 400 });
  }

  const now = new Date().toISOString();
  const slug = body.title
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "-");

  const payload = {
    ...body,
    title: body.title,
    slug,
    status: (body.status as string) || "draft",
    is_deleted: false,
    display_order: (body.display_order as number) ?? 0,
    created_at: now,
    updated_at: now,
    published_at: body.status === "published" ? now : null,
  };

  const databases = getAppwriteDatabases();
  const created = await databases.createDocument(
    getAppwriteDatabaseId(),
    getModuleCollectionId(module),
    ID.unique(),
    payload,
  );

  return NextResponse.json({ data: { id: created.$id, ...created } }, { status: 201 });
}
