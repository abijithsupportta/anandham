"use client";

import { useState, useEffect, useCallback, use } from "react";
import type { Category, Author, ContentLanguage, ContentStatus, Sloka } from "@/types/database";
import { useRouter } from "next/navigation";
import Link from "next/link";
import {
  ArrowLeft,
  Save,
  Eye,
  Plus,
  Trash2,
  GripVertical,
  ChevronDown,
  ChevronUp,
  Youtube,
  Globe,
  BookOpen,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface SlokaForm {
  id: string;
  sloka_number: number;
  original_text: string;
  transliteration: string;
  translation: string;
  explanation: string;
  collapsed: boolean;
}

interface KrithiForm {
  title: string;
  description: string;
  category_id: string;
  author_id: string;
  language: ContentLanguage;
  youtube_url: string;
  status: ContentStatus;
}

const emptyKrithi: KrithiForm = {
  title: "",
  description: "",
  category_id: "",
  author_id: "",
  language: "ta",
  youtube_url: "",
  status: "draft",
};

export default function KrithiFormPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const router = useRouter();
  const supabase = createClient();

  const [form, setForm] = useState<KrithiForm>(emptyKrithi);
  const [slokas, setSlokas] = useState<SlokaForm[]>([]);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState<Category[]>([]);
  const [authors, setAuthors] = useState<Author[]>([]);

  const isNew = id === "new";

  const loadData = useCallback(async () => {
    setLoading(true);

    const [catRes, authRes] = await Promise.all([
      supabase.from("categories").select("*").eq("is_active", true).order("name"),
      supabase.from("authors").select("*").eq("is_active", true).order("name"),
    ]);

    if (catRes.data) setCategories(catRes.data as Category[]);
    if (authRes.data) setAuthors(authRes.data as Author[]);

    if (!isNew) {
      const { data: krithi } = await supabase
        .from("krithis")
        .select("*")
        .eq("id", id)
        .single();

      if (krithi) {
        setForm({
          title: krithi.title,
          description: krithi.description ?? "",
          category_id: krithi.category_id ?? "",
          author_id: krithi.author_id ?? "",
          language: krithi.language as ContentLanguage,
          youtube_url: krithi.youtube_url ?? "",
          status: krithi.status as ContentStatus,
        });
      }

      const { data: slokaData } = await supabase
        .from("slokas")
        .select("*")
        .eq("krithi_id", id)
        .eq("is_deleted", false)
        .order("sloka_number");

      if (slokaData) {
        setSlokas(
          (slokaData as Sloka[]).map((s) => ({
            id: s.id,
            sloka_number: s.sloka_number,
            original_text: s.original_text,
            transliteration: s.transliteration,
            translation: s.translation,
            explanation: s.explanation,
            collapsed: true,
          }))
        );
      }
    }

    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  function updateForm(field: keyof KrithiForm, value: string) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  function addSloka() {
    const newSloka: SlokaForm = {
      id: `temp-${Date.now()}`,
      sloka_number: slokas.length + 1,
      original_text: "",
      transliteration: "",
      translation: "",
      explanation: "",
      collapsed: false,
    };
    setSlokas((prev) => [...prev, newSloka]);
  }

  function updateSloka(
    slokaId: string,
    field: keyof Omit<SlokaForm, "id" | "sloka_number" | "collapsed">,
    value: string
  ) {
    setSlokas((prev) =>
      prev.map((s) => (s.id === slokaId ? { ...s, [field]: value } : s))
    );
  }

  function removeSloka(slokaId: string) {
    setSlokas((prev) =>
      prev.filter((s) => s.id !== slokaId).map((s, i) => ({ ...s, sloka_number: i + 1 }))
    );
  }

  function toggleSloka(slokaId: string) {
    setSlokas((prev) =>
      prev.map((s) => (s.id === slokaId ? { ...s, collapsed: !s.collapsed } : s))
    );
  }

  async function handleSave(publish = false) {
    setSaving(true);
    const now = new Date().toISOString();
    const slug = form.title
      .toLowerCase()
      .replace(/[^a-z0-9\s-]/g, "")
      .replace(/\s+/g, "-")
      .slice(0, 80);

    const krithiPayload = {
      title: form.title,
      slug,
      description: form.description,
      category_id: form.category_id || null,
      author_id: form.author_id || null,
      language: form.language,
      youtube_url: form.youtube_url || null,
      status: publish ? ("published" as const) : form.status,
      published_at: publish ? now : null,
      updated_at: now,
    };

    let krithiId = id;

    if (isNew) {
      const { data, error } = await supabase
        .from("krithis")
        .insert({ ...krithiPayload, created_at: now })
        .select("id")
        .single();

      if (error || !data) {
        console.error("Error creating krithi:", error);
        setSaving(false);
        return;
      }
      krithiId = data.id;
    } else {
      const { error } = await supabase
        .from("krithis")
        .update(krithiPayload)
        .eq("id", id);

      if (error) {
        console.error("Error updating krithi:", error);
        setSaving(false);
        return;
      }

      const keptSlokaIds = slokas
        .filter((s) => !s.id.startsWith("temp-"))
        .map((s) => s.id);

      if (keptSlokaIds.length > 0) {
        await supabase
          .from("slokas")
          .update({ is_deleted: true, deleted_at: now })
          .eq("krithi_id", id)
          .not("id", "in", `(${keptSlokaIds.join(",")})`);
      }
    }

    for (const sloka of slokas) {
      const slokaPayload = {
        krithi_id: krithiId,
        sloka_number: sloka.sloka_number,
        original_text: sloka.original_text,
        transliteration: sloka.transliteration,
        translation: sloka.translation,
        explanation: sloka.explanation,
        updated_at: now,
      };

      if (sloka.id.startsWith("temp-")) {
        await supabase.from("slokas").insert({ ...slokaPayload, created_at: now });
      } else {
        await supabase.from("slokas").update(slokaPayload).eq("id", sloka.id);
      }
    }

    setSaving(false);
    router.push("/krithis");
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <p className="text-sm text-gray-400">Loading...</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link
            href="/krithis"
            className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-100 hover:text-gray-600"
          >
            <ArrowLeft className="h-5 w-5" />
          </Link>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {isNew ? "New Krithi" : "Edit Krithi"}
            </h1>
            <p className="mt-0.5 text-sm text-gray-500">
              {isNew
                ? "Create a new sacred poem with slokas"
                : "Edit krithi details and slokas"}
            </p>
          </div>
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
            disabled={saving || !form.title.trim() || slokas.length === 0}
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50"
          >
            <Eye className="h-4 w-4" />
            Publish
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        {/* Main Content */}
        <div className="space-y-6 lg:col-span-2">
          {/* Basic Info */}
          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <h2 className="mb-4 text-lg font-semibold text-gray-900">
              Basic Information
            </h2>
            <div className="space-y-4">
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">
                  Title *
                </label>
                <input
                  type="text"
                  value={form.title}
                  onChange={(e) => updateForm("title", e.target.value)}
                  className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  placeholder="Enter krithi title"
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">
                  Description
                </label>
                <textarea
                  value={form.description}
                  onChange={(e) => updateForm("description", e.target.value)}
                  rows={3}
                  className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  placeholder="Brief description of the krithi"
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">
                  <span className="flex items-center gap-1.5">
                    <Youtube className="h-4 w-4 text-red-500" />
                    YouTube URL
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
            </div>
          </div>

          {/* Slokas Section */}
          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <div className="mb-4 flex items-center justify-between">
              <h2 className="text-lg font-semibold text-gray-900">
                Slokas ({slokas.length})
              </h2>
              <button
                onClick={addSloka}
                className="inline-flex items-center gap-1.5 rounded-lg border border-indigo-200 bg-indigo-50 px-3 py-1.5 text-sm font-medium text-indigo-600 transition hover:bg-indigo-100"
              >
                <Plus className="h-4 w-4" />
                Add Sloka
              </button>
            </div>

            {slokas.length === 0 ? (
              <div className="rounded-lg border-2 border-dashed border-gray-200 py-12 text-center">
                <BookOpen className="mx-auto h-8 w-8 text-gray-300" />
                <p className="mt-2 text-sm text-gray-500">No slokas added yet</p>
                <button
                  onClick={addSloka}
                  className="mt-3 inline-flex items-center gap-1 text-sm font-medium text-indigo-600 hover:text-indigo-700"
                >
                  <Plus className="h-4 w-4" />
                  Add first sloka
                </button>
              </div>
            ) : (
              <div className="space-y-3">
                {slokas.map((sloka) => (
                  <div
                    key={sloka.id}
                    className="rounded-lg border border-gray-200 bg-gray-50/50"
                  >
                    <div className="flex items-center justify-between border-b border-gray-200 px-4 py-2.5">
                      <div className="flex items-center gap-2">
                        <GripVertical className="h-4 w-4 cursor-grab text-gray-300" />
                        <span className="text-sm font-semibold text-gray-900">
                          Sloka {sloka.sloka_number}
                        </span>
                        {sloka.original_text && (
                          <span className="text-xs text-gray-400">
                            — {sloka.original_text.slice(0, 30)}...
                          </span>
                        )}
                      </div>
                      <div className="flex items-center gap-1">
                        <button
                          onClick={() => toggleSloka(sloka.id)}
                          className="rounded p-1 text-gray-400 hover:bg-gray-200 hover:text-gray-600"
                        >
                          {sloka.collapsed ? (
                            <ChevronDown className="h-4 w-4" />
                          ) : (
                            <ChevronUp className="h-4 w-4" />
                          )}
                        </button>
                        <button
                          onClick={() => removeSloka(sloka.id)}
                          className="rounded p-1 text-gray-400 hover:bg-red-50 hover:text-red-600"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                    </div>
                    {!sloka.collapsed && (
                      <div className="space-y-3 p-4">
                        <div>
                          <label className="mb-1 block text-xs font-medium text-gray-600">
                            Original Text *
                          </label>
                          <textarea
                            value={sloka.original_text}
                            onChange={(e) =>
                              updateSloka(sloka.id, "original_text", e.target.value)
                            }
                            rows={2}
                            className="w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                            placeholder="Original sloka text..."
                          />
                        </div>
                        <div>
                          <label className="mb-1 block text-xs font-medium text-gray-600">
                            Transliteration
                          </label>
                          <textarea
                            value={sloka.transliteration}
                            onChange={(e) =>
                              updateSloka(sloka.id, "transliteration", e.target.value)
                            }
                            rows={2}
                            className="w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                            placeholder="Transliteration..."
                          />
                        </div>
                        <div>
                          <label className="mb-1 block text-xs font-medium text-gray-600">
                            Translation
                          </label>
                          <textarea
                            value={sloka.translation}
                            onChange={(e) =>
                              updateSloka(sloka.id, "translation", e.target.value)
                            }
                            rows={2}
                            className="w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                            placeholder="English translation..."
                          />
                        </div>
                        <div>
                          <label className="mb-1 block text-xs font-medium text-gray-600">
                            Explanation
                          </label>
                          <textarea
                            value={sloka.explanation}
                            onChange={(e) =>
                              updateSloka(sloka.id, "explanation", e.target.value)
                            }
                            rows={2}
                            className="w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                            placeholder="Detailed explanation..."
                          />
                        </div>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <h3 className="mb-3 text-sm font-semibold text-gray-900">Status</h3>
            <select
              value={form.status}
              onChange={(e) => updateForm("status", e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="draft">Draft</option>
              <option value="published">Published</option>
            </select>
          </div>

          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <h3 className="mb-3 text-sm font-semibold text-gray-900">Category</h3>
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

          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <h3 className="mb-3 text-sm font-semibold text-gray-900">Author</h3>
            <select
              value={form.author_id}
              onChange={(e) => updateForm("author_id", e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="">Select author</option>
              {authors.map((a) => (
                <option key={a.id} value={a.id}>
                  {a.name}
                </option>
              ))}
            </select>
          </div>

          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <h3 className="mb-3 text-sm font-semibold text-gray-900">
              <span className="flex items-center gap-1.5">
                <Globe className="h-4 w-4 text-gray-400" />
                Language
              </span>
            </h3>
            <select
              value={form.language}
              onChange={(e) => updateForm("language", e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="ta">Tamil</option>
              <option value="en">English</option>
              <option value="sa">Sanskrit</option>
              <option value="ml">Malayalam</option>
              <option value="hi">Hindi</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  );
}
