"use client";

import { Account, Client } from "appwrite";

const endpoint = process.env.NEXT_PUBLIC_APPWRITE_ENDPOINT;
const projectId = process.env.NEXT_PUBLIC_APPWRITE_PROJECT_ID;

if (!endpoint || !projectId) {
  throw new Error("Missing Appwrite client env vars: NEXT_PUBLIC_APPWRITE_ENDPOINT or NEXT_PUBLIC_APPWRITE_PROJECT_ID");
}

export const appwriteClient = new Client()
  .setEndpoint(endpoint)
  .setProject(projectId);

export const appwriteAccount = new Account(appwriteClient);
