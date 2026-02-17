"use client";

import { useState, useEffect, useCallback, use } from "react";
import type { Category, ContentStatus } from "@/types/database";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Save, Eye, Youtube } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface DharmaForm {
  title: string;
  description: string;
  category_id: string;
  youtube_url: string;
  status: ContentStatus;
}

const emptyDharma: DharmaForm = {
  title: "",
  description: "",
  category_id: "",
  youtube_url: "",
  status: "draft",
};

export default function DharmaFormPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const router = useRouter();
  const supabase = createClient();

  const [form, setForm] = useState<DharmaForm>(emptyDharma);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState<Category[]>([]);

  const isNew = id === "new";

  const loadData = useCallback(async () => {
    setLoading(true);

    const { data: catData } = await supabase
      .from("categories")
      .select("*")
      .eq("is_active", true)
      .order("name");

    if (catData) setCategories(catData as Category[]);

    if (!isNew) {
      const { data: dharma } = await supabase
        .from("dharmas")
        .select("*")
        .eq("id", id)
        .single();

      if (dharma) {
        setForm({
          title: dharma.title,
          description: dharma.description ?? "",
          category_id: dharma.category_id ?? "",
          youtube_url: dharma.youtube_url ?? "",
          status: dharma.status as ContentStatus,
        });
      }
    }

    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  function updateForm(field: keyof DharmaForm, value: string) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSave(publish = false) {
    setSaving(true);
    const now = new Date().toISOString();
    const slug = form.title
      .toLowerCase()
      .replace(/[^a-z0-9\s-]/g, "")
      .replace(/\s+/g, "-")
      .slice(0, 80);

    const payload = {
      title: form.title,
      slug,
      description: form.description,
      category_id: form.category_id || null,
      youtube_url: form.youtube_url || null,
      status: publish ? ("published" as const) : form.status,
      published_at: publish ? now : null,
      updated_at: now,
    };

    if (isNew) {
      const { error } = await supabase
        .from("dharmas")
        .insert({ ...payload, created_at: now });

      if (error) {
        console.error("Error creating dharma:", error);
        setSaving(false);
        return;
      }
    } else {
      const { error } = await supabase
        .from("dharmas")
        .update(payload)
        .eq("id", id);

      if (error) {
        console.error("Error updating dharma:", error);
        setSaving(false);
        return;
      }
    }

    setSaving(false);
    router.push("/dharmas");
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <p className="text-sm text-gray-400">Loading...</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-3xl space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link
            href="/dharmas"
            className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-100 hover:text-gray-600"
          >
            <ArrowLeft className="h-5 w-5" />
          </Link>
          <h1 className="text-2xl font-bold text-gray-900">
            {isNew ? "New Dharma" : "Edit Dharma"}
          </h1>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => handleSave(false)}
            disabled={saving || !form.title.trim()}
            className="inline-flex items-center gap-2 rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition hover:bg-gray-50 disabled:opacity-50"
          >
            <Save className="h-4 w-4" />
            Save Draft
          </button>
          <button
            onClick={() => handleSave(true)}
            disabled={saving || !form.title.trim()}
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50"
          >
            <Eye className="h-4 w-4" />
            Publish
          </button>
        </div>
      </div>

      {/* Form */}
      <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
        <div className="space-y-5">
          {/* Category */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Category
            </label>
            <select
              value={form.category_id}
              onChange={(e) => updateForm("category_id", e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="">Select category</option>
              {categories.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>

          {/* Title */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Title *
            </label>
            <input
              type="text"
              value={form.title}
              onChange={(e) => updateForm("title", e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter dharma title"
            />
          </div>

          {/* Body */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Body
            </label>
            <textarea
              value={form.description}
              onChange={(e) => updateForm("description", e.target.value)}
              rows={10}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter dharma content..."
            />
          </div>

          {/* YouTube URL */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              <span className="flex items-center gap-1.5">
                <Youtube className="h-4 w-4 text-red-500" />
                YouTube Video Link
              </span>
            </label>
            <input
              type="url"
              value={form.youtube_url}
              onChange={(e) => updateForm("youtube_url", e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="https://youtube.com/watch?v=..."
            />
          </div>

          {/* Status */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Status
            </label>
            <select
              value={form.status}
              onChange={(e) => updateForm("status", e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="draft">Draft</option>
              <option value="published">Published</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  );
}
