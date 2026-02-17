"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { useRouter, useParams } from "next/navigation";
import Image from "next/image";
import Link from "next/link";
import type { BlogCategory } from "@/types/database";
import { blogService, type BlogFormInput } from "@/services/blog.service";
import { useToast } from "@/hooks/useToast";
import {
  ArrowLeft,
  Save,
  Globe,
  Maximize2,
  Minimize2,
  Type,
  AlignLeft,
  ImageIcon,
  Upload,
  X,
  Tag,
  Plus,
  Youtube,
} from "lucide-react";
import PageHeader from "@/components/ui/page-header";
import { FormPageSkeleton } from "@/components/ui/page-skeleton";

// ── Helpers ────────────────────────────────────────────────

function countStats(text: string) {
  const chars = text.length;
  const words = text.trim() ? text.trim().split(/\s+/).length : 0;
  const lines = text ? text.split("\n").length : 0;
  return { chars, words, lines };
}

export default function BlogFormPage() {
  const router = useRouter();
  const { id } = useParams<{ id: string }>();
  const isNew = id === "new";
  const { toast } = useToast();

  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [categories, setCategories] = useState<BlogCategory[]>([]);
  const [expanded, setExpanded] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [tagInput, setTagInput] = useState("");
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const [form, setForm] = useState<BlogFormInput>({
    title: "",
    excerpt: "",
    body: "",
    cover_images: [],
    youtube_url: "",
    category_id: "",
    language: "en",
    tags: [],
    status: "draft",
  });

  // ── Load data ────────────────────────────────────────────

  useEffect(() => {
    async function load() {
      const catResult = await blogService.getCategories();
      if (catResult.data) setCategories(catResult.data);

      if (!isNew) {
        const result = await blogService.getById(id);
        if (result.error) {
          toast(result.error, "error");
          router.push("/blogs");
          return;
        }
        if (result.data) {
          setForm({
            title: result.data.title,
            excerpt: result.data.excerpt ?? "",
            body: result.data.body ?? "",
            cover_images: result.data.cover_images ?? [],
            youtube_url: result.data.youtube_url ?? "",
            category_id: result.data.category_id ?? "",
            language: result.data.language ?? "en",
            tags: result.data.tags ?? [],
            status: result.data.status,
          });
        }
      }
      setLoading(false);
    }
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  // ── Handlers ─────────────────────────────────────────────

  function onChange(
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >
  ) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  }

  async function handleSave(publish = false) {
    if (!form.title.trim()) {
      toast("Title is required", "error");
      return;
    }

    setSaving(true);
    const result = isNew
      ? await blogService.create({
          ...form,
          status: publish ? "published" : form.status,
        })
      : await blogService.update(id, form, publish);

    setSaving(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast(isNew ? "Blog post created" : "Blog post updated", "success");
    router.push("/blogs");
  }

  // Keyboard shortcuts
  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "s") {
        e.preventDefault();
        handleSave(e.shiftKey);
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [form, isNew, saving]
  );

  // Tab key inserts spaces
  function handleTabKey(e: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === "Tab") {
      e.preventDefault();
      const ta = e.currentTarget;
      const start = ta.selectionStart;
      const end = ta.selectionEnd;
      const newValue =
        form.body.substring(0, start) + "  " + form.body.substring(end);
      setForm((prev) => ({ ...prev, body: newValue }));
      requestAnimationFrame(() => {
        ta.selectionStart = ta.selectionEnd = start + 2;
      });
    }
  }

  // ── Cover image upload ───────────────────────────────────

  async function handleCoverUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const files = Array.from(e.target.files ?? []);
    if (files.length === 0) return;

    const invalid = files.find((f) => !f.type.startsWith("image/"));
    if (invalid) {
      toast("Please select only image files", "error");
      return;
    }

    setUploading(true);
    const formData = new FormData();
    files.forEach((f) => formData.append("files", f));
    formData.append("folder", "blog-covers");

    try {
      const res = await fetch("/api/upload", {
        method: "POST",
        body: formData,
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error ?? "Upload failed");
      setForm((prev) => ({
        ...prev,
        cover_images: [...prev.cover_images, ...data.urls],
      }));
      toast(
        `${data.urls.length} image${data.urls.length > 1 ? "s" : ""} uploaded`,
        "success"
      );
    } catch (err: unknown) {
      toast(err instanceof Error ? err.message : "Upload failed", "error");
    } finally {
      setUploading(false);
      // Reset input so the same file can be re-selected
      e.target.value = "";
    }
  }

  function removeCoverImage(index: number) {
    setForm((prev) => ({
      ...prev,
      cover_images: prev.cover_images.filter((_, i) => i !== index),
    }));
  }

  // ── Tags ─────────────────────────────────────────────────

  function addTag() {
    const tag = tagInput.trim().toLowerCase();
    if (!tag) return;
    if (form.tags.includes(tag)) {
      toast("Tag already exists", "error");
      return;
    }
    setForm((prev) => ({ ...prev, tags: [...prev.tags, tag] }));
    setTagInput("");
  }

  function removeTag(tag: string) {
    setForm((prev) => ({ ...prev, tags: prev.tags.filter((t) => t !== tag) }));
  }

  const stats = countStats(form.body);

  // ── Render ───────────────────────────────────────────────

  if (loading) return <FormPageSkeleton />;

  // Build category options with hierarchy
  const topLevelCats = categories.filter((c) => !c.parent_id);
  const getSubcats = (parentId: string) =>
    categories.filter((c) => c.parent_id === parentId);

  return (
    <div
      className={`space-y-6 ${expanded ? "fixed inset-0 z-50 overflow-y-auto bg-surface-hover p-6" : "mx-auto max-w-4xl"}`}
      onKeyDown={handleKeyDown}
    >
      <PageHeader
        title={isNew ? "New Blog Post" : "Edit Blog Post"}
        subtitle={isNew ? "Write a new blog article" : "Update blog post"}
        action={
          <Link
            href="/blogs"
            className="inline-flex items-center gap-2 text-sm text-muted hover:text-foreground"
          >
            <ArrowLeft className="h-4 w-4" />
            Back
          </Link>
        }
      />

      {/* Metadata Panel */}
      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          <div className="sm:col-span-2 lg:col-span-3">
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              Title *
            </label>
            <input
              name="title"
              value={form.title}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter blog title"
            />
          </div>

          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              Category
            </label>
            <select
              name="category_id"
              value={form.category_id}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="">Select category</option>
              {topLevelCats.map((cat) => {
                const subs = getSubcats(cat.id);
                return (
                  <optgroup key={cat.id} label={cat.name}>
                    <option value={cat.id}>{cat.name}</option>
                    {subs.map((sub) => (
                      <option key={sub.id} value={sub.id}>
                        ↳ {sub.name}
                      </option>
                    ))}
                  </optgroup>
                );
              })}
            </select>
          </div>

          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              Language
            </label>
            <select
              name="language"
              value={form.language}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="en">English</option>
              <option value="ta">Tamil</option>
              <option value="sa">Sanskrit</option>
              <option value="ml">Malayalam</option>
              <option value="hi">Hindi</option>
            </select>
          </div>

          <div className="sm:col-span-2 lg:col-span-3">
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              Excerpt
            </label>
            <input
              name="excerpt"
              value={form.excerpt}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Short summary of the blog post"
            />
          </div>
        </div>
      </div>

      {/* Cover Images, YouTube & Tags */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Cover images */}
        <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
          <h3 className="mb-3 flex items-center gap-2 text-sm font-semibold text-foreground">
            <ImageIcon className="h-4 w-4 text-muted" />
            Cover Images
            {form.cover_images.length > 0 && (
              <span className="rounded-full bg-indigo-100 dark:bg-indigo-500/20 px-2 py-0.5 text-xs font-medium text-indigo-700 dark:text-indigo-400">
                {form.cover_images.length}
              </span>
            )}
          </h3>

          {/* Uploaded images grid */}
          {form.cover_images.length > 0 && (
            <div className="mb-3 grid grid-cols-2 gap-2">
              {form.cover_images.map((url, idx) => (
                <div key={idx} className="group relative overflow-hidden rounded-lg">
                  <Image
                    src={url}
                    alt={`Cover ${idx + 1}`}
                    width={300}
                    height={150}
                    className="h-28 w-full object-cover"
                  />
                  <button
                    onClick={() => removeCoverImage(idx)}
                    className="absolute right-1.5 top-1.5 rounded-full bg-black/50 p-1 text-white opacity-0 transition group-hover:opacity-100 hover:bg-black/70"
                  >
                    <X className="h-3 w-3" />
                  </button>
                </div>
              ))}
            </div>
          )}

          {/* Upload button */}
          <label className="flex h-28 cursor-pointer flex-col items-center justify-center rounded-lg border-2 border-dashed border-border-main bg-surface-hover transition hover:border-indigo-300 dark:hover:border-indigo-500 dark:border-indigo-400/50 hover:bg-indigo-50 dark:bg-indigo-500/10/30">
            <Upload className="mb-1.5 h-6 w-6 text-gray-300 dark:text-gray-600" />
            <span className="text-sm text-muted">
              {uploading ? "Uploading..." : "Click to add images"}
            </span>
            <span className="text-xs text-muted/60">
              You can select multiple files
            </span>
            <input
              type="file"
              accept="image/*"
              multiple
              onChange={handleCoverUpload}
              className="hidden"
              disabled={uploading}
            />
          </label>
        </div>

        {/* YouTube URL + Tags */}
        <div className="space-y-6">
          {/* YouTube URL */}
          <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
            <h3 className="mb-3 flex items-center gap-2 text-sm font-semibold text-foreground">
              <Youtube className="h-4 w-4 text-red-500" />
              YouTube Video
            </h3>
            <input
              name="youtube_url"
              value={form.youtube_url}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="https://www.youtube.com/watch?v=..."
            />
            {form.youtube_url && (
              <div className="mt-2 flex items-center gap-2 text-xs text-muted">
                <Youtube className="h-3.5 w-3.5 text-red-500" />
                <span className="truncate">{form.youtube_url}</span>
                <button
                  onClick={() => setForm((prev) => ({ ...prev, youtube_url: "" }))}
                  className="ml-auto rounded p-0.5 hover:bg-surface-hover"
                >
                  <X className="h-3 w-3" />
                </button>
              </div>
            )}
          </div>

          {/* Tags */}
          <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
            <h3 className="mb-3 flex items-center gap-2 text-sm font-semibold text-foreground">
              <Tag className="h-4 w-4 text-muted" />
              Tags
            </h3>
            <div className="flex gap-2">
              <input
                value={tagInput}
                onChange={(e) => setTagInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter") {
                    e.preventDefault();
                    addTag();
                  }
                }}
                className="flex-1 rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Add a tag and press Enter"
              />
              <button
                onClick={addTag}
                className="inline-flex items-center gap-1 rounded-lg bg-gray-100 dark:bg-gray-800 px-3 py-2 text-sm font-medium text-foreground transition hover:bg-gray-200 dark:hover:bg-gray-700 dark:bg-gray-700"
              >
                <Plus className="h-3.5 w-3.5" />
                Add
              </button>
            </div>
            <div className="mt-3 flex flex-wrap gap-2">
              {form.tags.map((tag) => (
                <span
                  key={tag}
                  className="inline-flex items-center gap-1 rounded-full bg-indigo-50 dark:bg-indigo-500/10 px-2.5 py-1 text-xs font-medium text-indigo-700 dark:text-indigo-400"
                >
                  {tag}
                  <button
                    onClick={() => removeTag(tag)}
                    className="ml-0.5 rounded-full p-0.5 transition hover:bg-indigo-100 dark:hover:bg-indigo-500/20 dark:bg-indigo-500/15"
                  >
                    <X className="h-3 w-3" />
                  </button>
                </span>
              ))}
              {form.tags.length === 0 && (
                <span className="text-xs text-muted">
                  No tags added yet
                </span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Body Editor Panel */}
      <div className="rounded-xl border border-border-main bg-card shadow-sm">
        {/* Editor Toolbar */}
        <div className="flex items-center justify-between border-b border-border-light px-4 py-2.5">
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-1.5 text-sm font-medium text-foreground">
              <Type className="h-4 w-4 text-muted" />
              Body
            </div>
            <div className="hidden items-center gap-3 text-xs text-muted sm:flex">
              <span>
                {stats.lines} {stats.lines === 1 ? "line" : "lines"}
              </span>
              <span className="text-gray-200 dark:text-gray-700">|</span>
              <span>
                {stats.words} {stats.words === 1 ? "word" : "words"}
              </span>
              <span className="text-gray-200 dark:text-gray-700">|</span>
              <span>{stats.chars} chars</span>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={() => {
                setExpanded(!expanded);
                setTimeout(() => textareaRef.current?.focus(), 100);
              }}
              className="rounded-md p-1.5 text-muted transition hover:bg-surface-hover hover:text-gray-600 dark:text-gray-400"
              title={
                expanded ? "Exit fullscreen (Esc)" : "Fullscreen editor"
              }
            >
              {expanded ? (
                <Minimize2 className="h-4 w-4" />
              ) : (
                <Maximize2 className="h-4 w-4" />
              )}
            </button>
          </div>
        </div>

        {/* Editor Area */}
        <div className="relative">
          <textarea
            ref={textareaRef}
            name="body"
            value={form.body}
            onChange={onChange}
            onKeyDown={(e) => {
              handleTabKey(e);
              if (e.key === "Escape" && expanded) setExpanded(false);
            }}
            className={`w-full resize-none border-0 bg-transparent px-5 py-4 font-mono text-sm leading-relaxed text-foreground placeholder-muted focus:outline-none focus:ring-0 ${
              expanded ? "min-h-[calc(100vh-320px)]" : "min-h-[480px]"
            }`}
            placeholder={
              "Start writing the blog post here...\n\nTip: Use Ctrl+S to save, Ctrl+Shift+S to publish.\nTab key inserts spaces. Click the expand icon for fullscreen."
            }
            spellCheck={false}
          />
        </div>

        {/* Editor Footer */}
        <div className="flex items-center justify-between border-t border-border-light px-4 py-2">
          <div className="flex items-center gap-1.5 text-xs text-muted">
            <AlignLeft className="h-3.5 w-3.5" />
            <span>Plain text</span>
            <span className="text-gray-200 dark:text-gray-700">·</span>
            <span>Tab inserts spaces</span>
            <span className="text-gray-200 dark:text-gray-700">·</span>
            <span>Ctrl+S save</span>
          </div>
          {!isNew && (
            <div className="flex items-center gap-2">
              <span className="text-xs text-muted">Status:</span>
              <select
                name="status"
                value={form.status}
                onChange={onChange}
                className="rounded-md border border-border-main bg-surface-hover px-2 py-1 text-xs font-medium text-gray-600 dark:text-gray-400 focus:border-indigo-400 dark:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-400"
              >
                <option value="draft">Draft</option>
                <option value="published">Published</option>
              </select>
            </div>
          )}
        </div>
      </div>

      {/* Sticky Action Bar */}
      <div className="sticky bottom-0 -mx-6 border-t border-border-main bg-card/90 px-6 py-3 backdrop-blur-sm">
        <div className="mx-auto flex max-w-4xl items-center justify-between">
          <Link
            href="/blogs"
            className="text-sm text-muted hover:text-foreground"
          >
            Cancel
          </Link>
          <div className="flex items-center gap-3">
            <button
              onClick={() => handleSave(false)}
              disabled={saving}
              className="inline-flex items-center gap-2 rounded-lg border border-input-border bg-card px-4 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover disabled:opacity-50"
            >
              <Save className="h-4 w-4" />
              {saving ? "Saving..." : "Save Draft"}
            </button>
            <button
              onClick={() => handleSave(true)}
              disabled={saving}
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
