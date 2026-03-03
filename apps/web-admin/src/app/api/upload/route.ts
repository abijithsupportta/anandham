import { NextRequest, NextResponse } from "next/server";
import { uploadToR2, generateKey, deleteFromR2, getKeyFromUrl } from "@/lib/r2";
import sharp from "sharp";

export const runtime = "nodejs";

// Max file size: 10MB
const MAX_SIZE = 10 * 1024 * 1024;
const ALLOWED_TYPES = ["image/jpeg", "image/png", "image/webp", "image/gif", "image/avif"];
const TARGET_RATIO = 0.1;
const MIN_TARGET_BYTES = 40 * 1024;

type EncodedImage = { buffer: Buffer; contentType: string };

function outputTypeForUpload(inputType: string): string {
  if (inputType === "image/jpeg") return "image/jpeg";
  if (inputType === "image/png") return "image/png";
  if (inputType === "image/webp") return "image/webp";
  if (inputType === "image/avif") return "image/avif";
  if (inputType === "image/gif") return "image/webp";
  return "image/jpeg";
}

async function encodeImage(
  source: Buffer,
  outputType: string,
  width: number | null,
  quality: number
): Promise<Buffer> {
  let pipeline = sharp(source, { failOn: "none" }).rotate();

  if (width && width > 0) {
    pipeline = pipeline.resize({
      width,
      fit: "inside",
      withoutEnlargement: true,
    });
  }

  if (outputType === "image/png") {
    return pipeline
      .png({ quality, compressionLevel: 9, palette: true })
      .toBuffer();
  }

  if (outputType === "image/webp") {
    return pipeline.webp({ quality }).toBuffer();
  }

  if (outputType === "image/avif") {
    return pipeline.avif({ quality }).toBuffer();
  }

  return pipeline.jpeg({ quality, mozjpeg: true }).toBuffer();
}

async function compressImageToTarget(buffer: Buffer, inputType: string): Promise<EncodedImage> {
  const outputType = outputTypeForUpload(inputType);
  const targetBytes = Math.max(MIN_TARGET_BYTES, Math.floor(buffer.length * TARGET_RATIO));

  if (buffer.length <= targetBytes) {
    return { buffer, contentType: outputType };
  }

  try {
    const metadata = await sharp(buffer, { failOn: "none" }).metadata();
    let width = metadata.width ?? null;
    let quality = 82;
    let compressed = await encodeImage(buffer, outputType, width, quality);
    let attempts = 0;

    while (compressed.length > targetBytes && attempts < 18) {
      attempts += 1;

      if (quality > 22) {
        quality -= 8;
      } else {
        const currentWidth = width ?? metadata.width ?? 1200;
        width = Math.max(240, Math.floor(currentWidth * 0.82));
      }

      compressed = await encodeImage(buffer, outputType, width, quality);
    }

    return {
      buffer: compressed.length < buffer.length ? compressed : buffer,
      contentType: outputType,
    };
  } catch {
    return { buffer, contentType: inputType };
  }
}

// ── POST: Upload one or more images ────────────────────────

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData();
    const files = formData.getAll("files") as File[];
    const folder = (formData.get("folder") as string) || "guru-photos";

    if (!files || files.length === 0) {
      return NextResponse.json({ error: "No files provided" }, { status: 400 });
    }

    // Validate all files first
    for (const file of files) {
      if (!ALLOWED_TYPES.includes(file.type)) {
        return NextResponse.json(
          { error: `Invalid file type: ${file.type}. Allowed: JPEG, PNG, WebP, GIF, AVIF` },
          { status: 400 }
        );
      }
      if (file.size > MAX_SIZE) {
        return NextResponse.json(
          { error: `File "${file.name}" exceeds 10MB limit` },
          { status: 400 }
        );
      }
    }

    // Upload all files
    const urls: string[] = [];

    for (const file of files) {
      const buffer = Buffer.from(await file.arrayBuffer());
      const compressed = await compressImageToTarget(buffer, file.type);
      const key = generateKey(folder, file.name);
      const url = await uploadToR2(compressed.buffer, key, compressed.contentType);
      urls.push(url);
    }

    return NextResponse.json({ urls });
  } catch (err) {
    console.error("Upload error:", err);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Upload failed" },
      { status: 500 }
    );
  }
}

// ── DELETE: Remove an image from R2 ────────────────────────

export async function DELETE(request: NextRequest) {
  try {
    const { url } = await request.json();

    if (!url) {
      return NextResponse.json({ error: "No URL provided" }, { status: 400 });
    }

    const key = getKeyFromUrl(url);
    if (!key) {
      return NextResponse.json({ error: "Invalid R2 URL" }, { status: 400 });
    }

    await deleteFromR2(key);
    return NextResponse.json({ success: true });
  } catch (err) {
    console.error("Delete error:", err);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Delete failed" },
      { status: 500 }
    );
  }
}
