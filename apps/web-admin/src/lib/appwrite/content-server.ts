import { Databases } from "node-appwrite";
import { Client } from "node-appwrite";
import { CONTENT_MODULES, type ContentModuleKey } from "@/lib/content/content-modules";

function getServerEnv() {
  const endpoint = process.env.APPWRITE_ENDPOINT || process.env.NEXT_PUBLIC_APPWRITE_ENDPOINT;
  const projectId = process.env.NEXT_PUBLIC_APPWRITE_PROJECT_ID;
  const apiKey = process.env.APPWRITE_API_KEY;
  const databaseId =
    process.env.APPWRITE_DATABASE_ID ||
    process.env.NEXT_PUBLIC_APPWRITE_DATABASE_ID ||
    process.env.APPWRITE_USERS_DATABASE_ID;

  if (!endpoint || !projectId || !apiKey || !databaseId) {
    throw new Error(
      "Missing Appwrite server env vars: APPWRITE_ENDPOINT, NEXT_PUBLIC_APPWRITE_PROJECT_ID, APPWRITE_API_KEY, APPWRITE_DATABASE_ID/NEXT_PUBLIC_APPWRITE_DATABASE_ID/APPWRITE_USERS_DATABASE_ID",
    );
  }

  return { endpoint, projectId, apiKey, databaseId };
}

export function getAppwriteDatabases() {
  const { endpoint, projectId, apiKey } = getServerEnv();
  const client = new Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  return new Databases(client);
}

export function getAppwriteDatabaseId() {
  return getServerEnv().databaseId;
}

const collectionEnvMap: Record<ContentModuleKey, string | undefined> = {
  krithis: process.env.APPWRITE_COLLECTION_GURU_KRITHIS_ID,
  keerthanams: process.env.APPWRITE_COLLECTION_GURU_KEERTHANAMS_ID,
  dharmas: process.env.APPWRITE_COLLECTION_GURU_DHARMAS_ID,
  photos: process.env.APPWRITE_COLLECTION_GURU_PHOTOS_ID,
  stories: process.env.APPWRITE_COLLECTION_GURU_STORIES_ID,
};

const fallbackMap: Record<ContentModuleKey, string> = {
  krithis: "guru_krithis",
  keerthanams: "guru_keerthanams",
  dharmas: "guru_dharmas",
  photos: "guru_photos",
  stories: "guru_stories",
};

export function getModuleCollectionId(moduleKey: ContentModuleKey) {
  return collectionEnvMap[moduleKey] || fallbackMap[moduleKey];
}

export function getContentCategoriesCollectionId() {
  return process.env.APPWRITE_COLLECTION_CONTENT_CATEGORIES_ID || "content_categories";
}

export function getContentTypesCollectionId() {
  return process.env.APPWRITE_COLLECTION_CONTENT_TYPES_ID || "content_types";
}

export function getStaticContentTypes() {
  return (Object.keys(CONTENT_MODULES) as ContentModuleKey[]).map((moduleKey, index) => ({
    id: moduleKey,
    name: moduleKey,
    display_name: CONTENT_MODULES[moduleKey],
    description: `${CONTENT_MODULES[moduleKey]} content`,
    icon: "",
    color: "",
    table_name: CONTENT_MODULES[moduleKey],
    display_order: index,
    is_active: true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  }));
}
