"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { useRouter, useParams } from "next/navigation";
import type { ContentCategory } from "@/types/database";
import { guruPhotoService, type GuruPhotoFormInput } from "@/services/guru-photo.service";
import { useToast } from "@/hooks/useToast";
import {
  ArrowLeft,
  Save,
  Globe,
  Upload,
  X,
  ImageIcon,
  GripVertical,
  Loader2,
} from "lucide-react";
import Link from "next/link";
import Image from "next/image";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";

// ── Upload helper ──────────────────────────────────────────

async function uploadFiles(files: File[]): Promise<string[]> {
  const formData = new FormData();
  files.forEach((f) => formData.append("files", f));
  formData.append("folder", "guru-photos");

  const res = await fetch("/api/upload", { method: "POST", body: formData });
  const json = await res.json();
  if (!res.ok) throw new Error(json.error || "Upload failed");
  return json.urls;
}

async function deleteImage(url: string): Promise<void> {
  await fetch("/api/upload", {
    method: "DELETE",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ url }),
  });
}

export default function GuruPhotoFormPage() {
  const router = useRouter();
  const { id } = useParams<{ id: string }>();
  const isNew = id === "new";
  const { toast } = useToast();

  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [categories, setCategories] = useState<ContentCategory[]>([]);
  const [imageUrls, setImageUrls] = useState<string[]>([]);
  const [dragOver, setDragOver] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [form, setForm] = useState<GuruPhotoFormInput>({
    title: "",
    description: "",
    image_url: "",
    category_id: "",
    status: "draft",
  });

  // ── Load data ────────────────────────────────────────────

  useEffect(() => {
    async function load() {
      const catResult = await guruPhotoService.getCategories();
      if (catResult.data) setCategories(catResult.data);

      if (!isNew) {
        const [result, imagesResult] = await Promise.all([
          guruPhotoService.getById(id),
          guruPhotoService.getImages(id),
        ]);

        if (result.error) {
          toast(result.error, "error");
          router.push("/guru-photos");
          return;
        }
        if (result.data) {
          setForm({
            title: result.data.title,
            description: result.data.description ?? "",
            image_url: result.data.image_url ?? "",
            category_id: result.data.category_id ?? "",
            status: result.data.status,
          });
        }
        if (imagesResult.data && imagesResult.data.length > 0) {
          setImageUrls(imagesResult.data.map((img) => img.image_url));
        } else if (result.data?.image_url) {
          // Fallback: show the primary image_url if no gallery images exist
          setImageUrls([result.data.image_url]);
        }
      }
      setLoading(false);
    }
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  // ── Handlers ─────────────────────────────────────────────

  function onChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  }

  // ── Image upload handlers ────────────────────────────────

  const handleFiles = useCallback(
    async (files: FileList | File[]) => {
      const fileArray = Array.from(files).filter((f) =>
        ["image/jpeg", "image/png", "image/webp", "image/gif", "image/avif"].includes(f.type)
      );

      if (fileArray.length === 0) {
        toast("Please select valid image files (JPEG, PNG, WebP, GIF, AVIF)", "error");
        return;
      }

      // Check file sizes
      const oversized = fileArray.find((f) => f.size > 10 * 1024 * 1024);
      if (oversized) {
        toast(`File "${oversized.name}" exceeds 10MB limit`, "error");
        return;
      }

      setUploading(true);
      try {
        const urls = await uploadFiles(fileArray);
        setImageUrls((prev) => [...prev, ...urls]);

        // Set first image as primary if none set
        if (!form.image_url && urls.length > 0) {
          setForm((prev) => ({ ...prev, image_url: urls[0] }));
        }

        toast(`${urls.length} image${urls.length > 1 ? "s" : ""} uploaded`, "success");
      } catch (err) {
        toast(err instanceof Error ? err.message : "Upload failed", "error");
      } finally {
        setUploading(false);
      }
    },
    [form.image_url, toast]
  );

  function handleDrop(e: React.DragEvent) {
    e.preventDefault();
    setDragOver(false);
    if (e.dataTransfer.files.length > 0) {
      handleFiles(e.dataTransfer.files);
    }
  }

  function handleDragOver(e: React.DragEvent) {
    e.preventDefault();
    setDragOver(true);
  }

  function handleRemoveImage(index: number) {
    const url = imageUrls[index];
    setImageUrls((prev) => prev.filter((_, i) => i !== index));

    // If we removed the primary image, set the next one
    if (form.image_url === url) {
      const remaining = imageUrls.filter((_, i) => i !== index);
      setForm((prev) => ({ ...prev, image_url: remaining[0] || "" }));
    }

    // Try to delete from R2 (fire-and-forget)
    deleteImage(url).catch(() => {});
  }

  function handleSetPrimary(url: string) {
    setForm((prev) => ({ ...prev, image_url: url }));
  }

  // ── Save ─────────────────────────────────────────────────

  async function handleSave(publish = false) {
    if (!form.title.trim()) {
      toast("Title is required", "error");
      return;
    }
    if (imageUrls.length === 0) {
      toast("Please upload at least one image", "error");
      return;
    }

    // Ensure primary image is set
    const primaryUrl = form.image_url || imageUrls[0];

    setSaving(true);

    const input = { ...form, image_url: primaryUrl };
    const result = isNew
      ? await guruPhotoService.create({ ...input, status: publish ? "published" : input.status })
      : await guruPhotoService.update(id, input, publish);

    if (result.error) {
      setSaving(false);
      toast(result.error, "error");
      return;
    }

    // Save gallery images
    const photoId = isNew ? result.data?.id : id;
    if (photoId) {
      const imagesResult = await guruPhotoService.saveImages(photoId, imageUrls);
      if (imagesResult.error) {
        setSaving(false);
        toast(`Photo saved but gallery failed: ${imagesResult.error}`, "error");
        return;
      }
    }

    setSaving(false);
    toast(isNew ? "Guru photo created" : "Guru photo updated", "success");
    router.push("/guru-photos");
  }

  // Keyboard shortcut
  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "s") {
        e.preventDefault();
        handleSave(e.shiftKey);
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [form, imageUrls, isNew, saving]
  );

  // ── Render ───────────────────────────────────────────────

  if (loading) return <LoadingState message="Loading guru photo..." />;

  return (
    <div className="mx-auto max-w-4xl space-y-6" onKeyDown={handleKeyDown}>
      <PageHeader
        title={isNew ? "Upload Guru Photo" : "Edit Guru Photo"}
        subtitle={isNew ? "Add new sacred images to the gallery" : "Update photo details"}
        action={
          <Link href="/guru-photos" className="inline-flex items-center gap-2 text-sm text-muted hover:text-foreground">
            <ArrowLeft className="h-4 w-4" />
            Back
          </Link>
        }
      />

      {/* ── Metadata Panel ────────────────────────────────── */}
      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Title *</label>
            <input
              name="title"
              value={form.title}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter photo title"
            />
          </div>

          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Category</label>
            <select
              name="category_id"
              value={form.category_id}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="">Select a category</option>
              {categories.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </div>

          {!isNew && (
            <div>
              <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Status</label>
              <select
                name="status"
                value={form.status}
                onChange={onChange}
                className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              >
                <option value="draft">Draft</option>
                <option value="published">Published</option>
              </select>
            </div>
          )}

          <div className="sm:col-span-2">
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Description</label>
            <textarea
              name="description"
              value={form.description}
              onChange={onChange}
              rows={3}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Describe this photo..."
            />
          </div>
        </div>
      </div>

      {/* ── Image Upload Zone ─────────────────────────────── */}
      <div className="rounded-xl border border-border-main bg-card shadow-sm">
        <div className="flex items-center justify-between border-b border-border-light px-4 py-3">
          <div className="flex items-center gap-2 text-sm font-medium text-foreground">
            <ImageIcon className="h-4 w-4 text-muted" />
            Images
            {imageUrls.length > 0 && (
              <span className="rounded-full bg-indigo-50 dark:bg-indigo-500/10 px-2 py-0.5 text-xs font-semibold text-indigo-600 dark:text-indigo-400">
                {imageUrls.length}
              </span>
            )}
          </div>
          <button
            type="button"
            onClick={() => fileInputRef.current?.click()}
            disabled={uploading}
            className="inline-flex items-center gap-1.5 rounded-lg bg-indigo-50 dark:bg-indigo-500/10 px-3 py-1.5 text-xs font-medium text-indigo-600 dark:text-indigo-400 transition hover:bg-indigo-100 dark:hover:bg-indigo-500/20 dark:bg-indigo-500/15 disabled:opacity-50"
          >
            {uploading ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <Upload className="h-3.5 w-3.5" />}
            {uploading ? "Uploading..." : "Browse Files"}
          </button>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/jpeg,image/png,image/webp,image/gif,image/avif"
            multiple
            className="hidden"
            onChange={(e) => e.target.files && handleFiles(e.target.files)}
          />
        </div>

        <div className="p-4">
          {/* Drop zone (show when no images or for adding more) */}
          <div
            onDrop={handleDrop}
            onDragOver={handleDragOver}
            onDragLeave={() => setDragOver(false)}
            className={`rounded-lg border-2 border-dashed px-6 py-8 text-center transition ${
              dragOver
                ? "border-indigo-400 dark:border-indigo-500 dark:border-indigo-400 bg-indigo-50 dark:bg-indigo-500/10"
                : imageUrls.length === 0
                  ? "border-input-border bg-surface-hover"
                  : "border-border-main bg-surface-hover/50"
            }`}
          >
            {uploading ? (
              <div className="flex flex-col items-center gap-2">
                <Loader2 className="h-8 w-8 animate-spin text-indigo-500" />
                <p className="text-sm text-muted">Uploading images to R2...</p>
              </div>
            ) : (
              <>
                <Upload className={`mx-auto h-8 w-8 ${dragOver ? "text-indigo-500" : "text-gray-300 dark:text-gray-600"}`} />
                <p className="mt-2 text-sm text-muted">
                  {dragOver ? "Drop images here" : "Drag & drop images here, or click Browse Files"}
                </p>
                <p className="mt-1 text-xs text-muted">
                  JPEG, PNG, WebP, GIF, AVIF — Max 10MB each
                </p>
              </>
            )}
          </div>

          {/* Image gallery grid */}
          {imageUrls.length > 0 && (
            <div className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
              {imageUrls.map((url, i) => (
                <div
                  key={url}
                  className={`group relative overflow-hidden rounded-lg border-2 transition ${
                    form.image_url === url
                      ? "border-indigo-500 dark:border-indigo-400 ring-2 ring-indigo-200 dark:ring-indigo-500/30"
                      : "border-border-main hover:border-input-border"
                  }`}
                >
                  <div className="relative aspect-square">
                    <Image
                      src={url}
                      alt={`Image ${i + 1}`}
                      fill
                      className="object-cover"
                      sizes="(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 25vw"
                    />
                  </div>

                  {/* Overlay controls */}
                  <div className="absolute inset-0 flex items-start justify-between bg-gradient-to-b from-black/40 to-transparent p-2 opacity-0 transition group-hover:opacity-100">
                    <button
                      type="button"
                      onClick={() => handleSetPrimary(url)}
                      className={`rounded-md px-2 py-1 text-xs font-medium transition ${
                        form.image_url === url
                          ? "bg-indigo-600 text-white"
                          : "bg-card/90 text-foreground hover:bg-card"
                      }`}
                    >
                      {form.image_url === url ? "Cover" : "Set Cover"}
                    </button>
                    <button
                      type="button"
                      onClick={() => handleRemoveImage(i)}
                      className="rounded-md bg-red-500/90 p-1 text-white transition hover:bg-red-600"
                    >
                      <X className="h-3.5 w-3.5" />
                    </button>
                  </div>

                  {/* Primary badge */}
                  {form.image_url === url && (
                    <div className="absolute bottom-0 left-0 right-0 bg-indigo-600 px-2 py-1 text-center text-xs font-medium text-white">
                      Cover Image
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* ── Sticky Action Bar ─────────────────────────────── */}
      <div className="sticky bottom-0 -mx-6 border-t border-border-main bg-card/90 px-6 py-3 backdrop-blur-sm">
        <div className="mx-auto flex max-w-4xl items-center justify-between">
          <Link href="/guru-photos" className="text-sm text-muted hover:text-foreground">
            Cancel
          </Link>
          <div className="flex items-center gap-3">
            <button
              onClick={() => handleSave(false)}
              disabled={saving || uploading}
              className="inline-flex items-center gap-2 rounded-lg border border-input-border bg-card px-4 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover disabled:opacity-50"
            >
              <Save className="h-4 w-4" />
              {saving ? "Saving..." : "Save Draft"}
            </button>
            <button
              onClick={() => handleSave(true)}
              disabled={saving || uploading}
              className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50"
            >
              <Globe className="h-4 w-4" />
              {saving ? "Publishing..." : "Publish"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
