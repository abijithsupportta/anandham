import { S3Client, PutObjectCommand, DeleteObjectCommand } from "@aws-sdk/client-s3";

// ── R2 Client (S3-compatible) ──────────────────────────────

const r2 = new S3Client({
  region: "auto",
  endpoint: process.env.R2_ENDPOINT!,
  credentials: {
    accessKeyId: process.env.R2_ACCESS_KEY_ID!,
    secretAccessKey: process.env.R2_SECRET_ACCESS_KEY!,
  },
});

const BUCKET = process.env.R2_BUCKET_NAME!;
const PUBLIC_URL = process.env.R2_PUBLIC_URL!;

// ── Upload a file to R2 ───────────────────────────────────

export async function uploadToR2(
  file: Buffer,
  key: string,
  contentType: string
): Promise<string> {
  await r2.send(
    new PutObjectCommand({
      Bucket: BUCKET,
      Key: key,
      Body: file,
      ContentType: contentType,
    })
  );

  // Return the public URL
  return `${PUBLIC_URL}/${key}`;
}

// ── Delete a file from R2 ─────────────────────────────────

export async function deleteFromR2(key: string): Promise<void> {
  await r2.send(
    new DeleteObjectCommand({
      Bucket: BUCKET,
      Key: key,
    })
  );
}

// ── Extract the R2 key from a full public URL ─────────────

export function getKeyFromUrl(url: string): string | null {
  if (!url.startsWith(PUBLIC_URL)) return null;
  return url.replace(`${PUBLIC_URL}/`, "");
}

// ── Generate a unique key for an upload ───────────────────

export function generateKey(folder: string, filename: string): string {
  const timestamp = Date.now();
  const random = Math.random().toString(36).substring(2, 8);
  const sanitized = filename
    .toLowerCase()
    .replace(/[^a-z0-9._-]/g, "-")
    .replace(/-+/g, "-");
  return `${folder}/${timestamp}-${random}-${sanitized}`;
}
