import { NextResponse } from "next/server";
import { Query } from "node-appwrite";
import { requireAdminCookie } from "@/lib/appwrite/api-auth";
import {
  getAppwriteDatabaseId,
  getAppwriteDatabases,
  getContentTypesCollectionId,
  getStaticContentTypes,
} from "@/lib/appwrite/content-server";

export const runtime = "nodejs";

export async function GET() {
  const auth = await requireAdminCookie();
  if (!auth.ok) {
    return NextResponse.json({ error: auth.error }, { status: auth.status });
  }

  try {
    const databases = getAppwriteDatabases();
    const databaseId = getAppwriteDatabaseId();
    const collectionId = getContentTypesCollectionId();

    const result = await databases.listDocuments(databaseId, collectionId, [
      Query.equal("is_active", true),
      Query.orderAsc("display_order"),
      Query.limit(100),
    ]);

    const data = result.documents.map((doc) => ({ id: doc.$id, ...doc }));
    return NextResponse.json({ data });
  } catch {
    return NextResponse.json({ data: getStaticContentTypes() });
  }
}
