import { NextRequest, NextResponse } from "next/server";
import { ID, Query } from "node-appwrite";
import { requireAdminCookie } from "@/lib/appwrite/api-auth";
import {
  getAppwriteDatabaseId,
  getAppwriteDatabases,
  getContentCategoriesCollectionId,
} from "@/lib/appwrite/content-server";

export const runtime = "nodejs";

export async function GET(request: NextRequest) {
  try {
    const auth = await requireAdminCookie();
    if (!auth.ok) {
      return NextResponse.json({ error: auth.error }, { status: auth.status });
    }

    const module = request.nextUrl.searchParams.get("module");
    const queries = [Query.equal("is_deleted", false), Query.orderAsc("display_order"), Query.limit(500)];
    if (module) {
      queries.push(Query.equal("content_type_id", module));
    }

    const databases = getAppwriteDatabases();
    const databaseId = getAppwriteDatabaseId();
    const collectionId = getContentCategoriesCollectionId();
    const result = await databases.listDocuments(databaseId, collectionId, queries);
    const data = result.documents.map((doc) => ({ id: doc.$id, ...doc }));
    return NextResponse.json({ data });
  } catch (error) {
    console.error("GET /api/content-management/categories failed:", error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Failed to load categories" },
      { status: 500 },
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const auth = await requireAdminCookie();
    if (!auth.ok) {
      return NextResponse.json({ error: auth.error }, { status: auth.status });
    }

    const body = (await request.json()) as {
      content_type_id?: string;
      name?: string;
      description?: string;
      is_active?: boolean;
      display_order?: number;
      icon?: string;
      color?: string;
    };

    if (!body.content_type_id || !body.name?.trim()) {
      return NextResponse.json({ error: "content_type_id and name are required" }, { status: 400 });
    }

    const now = new Date().toISOString();
    const slug = body.name
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9\s-]/g, "")
      .replace(/\s+/g, "-");

    const databases = getAppwriteDatabases();
    const databaseId = getAppwriteDatabaseId();
    const collectionId = getContentCategoriesCollectionId();

    const created = await databases.createDocument(databaseId, collectionId, ID.unique(), {
      content_type_id: body.content_type_id,
      name: body.name.trim(),
      slug,
      description: body.description || "",
      icon: body.icon || "",
      color: body.color || "",
      is_active: body.is_active ?? true,
      is_deleted: false,
      display_order: body.display_order ?? 0,
      created_at: now,
      updated_at: now,
    });

    return NextResponse.json({ data: { id: created.$id, ...created } }, { status: 201 });
  } catch (error) {
    console.error("POST /api/content-management/categories failed:", error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Failed to create category" },
      { status: 500 },
    );
  }
}
