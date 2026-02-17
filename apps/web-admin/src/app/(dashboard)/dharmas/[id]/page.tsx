"use client";

import { useState, useEffect, useCallback, use } from "react";
import type { Category, Author } from "@/types/database";
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
  Globe,
  ScrollText,
} from "lucide-react";
import type { ContentLanguage, ContentStatus, DharmaItem } from "@/types/database";
import { createClient } from "@/lib/supabase/client";

interface DharmaItemForm {
  id: string;
  item_number: number;
  text: string;
  explanation: string;
  collapsed: boolean;
}

interface DharmaForm {
  title: string;
  description: string;
  category_id: string;
  author_id: string;
  language: ContentLanguage;
  status: ContentStatus;
}

const emptyDharma: DharmaForm = {
  title: "",
  description: "",
  category_id: "",
  author_id: "",
  language: "ta",
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
  const [items, setItems] = useState<DharmaItemForm[]>([]);
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
          author_id: dharma.author_id ?? "",
          language: dharma.language as ContentLanguage,
          status: dharma.status as ContentStatus,
        });
      }

      const { data: itemData } = await supabase
        .from("dharma_items")
        .select("*")
        .eq("dharma_id", id)
        .eq("is_deleted", false)
        .order("item_number");

      if (itemData) {
        setItems(
          (itemData as DharmaItem[]).map((it) => ({
            id: it.id,
            item_number: it.item_number,
            text: it.text,
            explanation: it.explanation,
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

  function updateForm(field: keyof DharmaForm, value: string) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  function addItem() {
    const newItem: DharmaItemForm = {
      id: `temp-${Date.now()}`,
      item_number: items.length + 1,
      text: "",
      explanation: "",
      collapsed: false,
    };
    setItems((prev) => [...prev, newItem]);
  }

  function updateItem(
    id: string,
    field: "text" | "explanation",
    value: string
  ) {
    setItems((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, [field]: value } : item
      )
    );
  }

  function removeItem(id: string) {
    setItems((prev) =>
      prev
        .filter((item) => item.id !== id)
        .map((item, i) => ({ ...item, item_number: i + 1 }))
    );
  }

  function toggleItem(id: string) {
    setItems((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, collapsed: !item.collapsed } : item
      )
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

    const dharmaPayload = {
      title: form.title,
      slug,
      description: form.description,
      category_id: form.category_id || null,
      author_id: form.author_id || null,
      language: form.language,
      status: publish ? ("published" as const) : form.status,
      published_at: publish ? now : null,
      updated_at: now,
    };

    let dharmaId = id;

    if (isNew) {
      const { data, error } = await supabase
        .from("dharmas")
        .insert({ ...dharmaPayload, created_at: now })
        .select("id")
        .single();

      if (error || !data) {
        console.error("Error creating dharma:", error);
        setSaving(false);
        return;
      }
      dharmaId = data.id;
    } else {
      const { error } = await supabase
        .from("dharmas")
        .update(dharmaPayload)
        .eq("id", id);

      if (error) {
        console.error("Error updating dharma:", error);
        setSaving(false);
        return;
      }

      const keptItemIds = items
        .filter((it) => !it.id.startsWith("temp-"))
        .map((it) => it.id);

      if (keptItemIds.length > 0) {
        await supabase
          .from("dharma_items")
          .update({ is_deleted: true, deleted_at: now })
          .eq("dharma_id", id)
          .not("id", "in", `(${keptItemIds.join(",")})`);
      }
    }

    for (const item of items) {
      const itemPayload = {
        dharma_id: dharmaId,
        item_number: item.item_number,
        text: item.text,
        explanation: item.explanation,
        updated_at: now,
      };

      if (item.id.startsWith("temp-")) {
        await supabase.from("dharma_items").insert({ ...itemPayload, created_at: now });
      } else {
        await supabase.from("dharma_items").update(itemPayload).eq("id", item.id);
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
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link
            href="/dharmas"
            className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-100 hover:text-gray-600"
          >
            <ArrowLeft className="h-5 w-5" />
          </Link>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {isNew ? "New Dharma" : "Edit Dharma"}
            </h1>
            <p className="mt-0.5 text-sm text-gray-500">
              {isNew
                ? "Create a new dharma teaching list"
                : "Edit dharma details and items"}
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
            disabled={saving || !form.title.trim() || items.length === 0}
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
                  placeholder="Enter dharma title"
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">
                  Description
                </label>
                <textarea
                  value={form.description}
                  onChange={(e) =>
                    updateForm("description", e.target.value)
                  }
                  rows={3}
                  className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  placeholder="Brief description of the dharma teachings"
                />
              </div>
            </div>
          </div>

          {/* Dharma Items Section */}
          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <div className="mb-4 flex items-center justify-between">
              <h2 className="text-lg font-semibold text-gray-900">
                Dharma Items ({items.length})
              </h2>
              <button
                onClick={addItem}
                className="inline-flex items-center gap-1.5 rounded-lg border border-amber-200 bg-amber-50 px-3 py-1.5 text-sm font-medium text-amber-700 transition hover:bg-amber-100"
              >
                <Plus className="h-4 w-4" />
                Add Item
              </button>
            </div>

            {items.length === 0 ? (
              <div className="rounded-lg border-2 border-dashed border-gray-200 py-12 text-center">
                <ScrollText className="mx-auto h-8 w-8 text-gray-300" />
                <p className="mt-2 text-sm text-gray-500">
                  No dharma items added yet
                </p>
                <button
                  onClick={addItem}
                  className="mt-3 inline-flex items-center gap-1 text-sm font-medium text-amber-600 hover:text-amber-700"
                >
                  <Plus className="h-4 w-4" />
                  Add first item
                </button>
              </div>
            ) : (
              <div className="space-y-3">
                {items.map((item) => (
                  <div
                    key={item.id}
                    className="rounded-lg border border-gray-200 bg-gray-50/50"
                  >
                    {/* Item Header */}
                    <div className="flex items-center justify-between border-b border-gray-200 px-4 py-2.5">
                      <div className="flex items-center gap-2">
                        <GripVertical className="h-4 w-4 cursor-grab text-gray-300" />
                        <span className="text-sm font-semibold text-gray-900">
                          Item {item.item_number}
                        </span>
                        {item.text && (
                          <span className="text-xs text-gray-400">
                            — {item.text.slice(0, 40)}
                            {item.text.length > 40 ? "..." : ""}
                          </span>
                        )}
                      </div>
                      <div className="flex items-center gap-1">
                        <button
                          onClick={() => toggleItem(item.id)}
                          className="rounded p-1 text-gray-400 hover:bg-gray-200 hover:text-gray-600"
                        >
                          {item.collapsed ? (
                            <ChevronDown className="h-4 w-4" />
                          ) : (
                            <ChevronUp className="h-4 w-4" />
                          )}
                        </button>
                        <button
                          onClick={() => removeItem(item.id)}
                          className="rounded p-1 text-gray-400 hover:bg-red-50 hover:text-red-600"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                    </div>

                    {/* Item Body */}
                    {!item.collapsed && (
                      <div className="space-y-3 p-4">
                        <div>
                          <label className="mb-1 block text-xs font-medium text-gray-600">
                            Text *
                          </label>
                          <textarea
                            value={item.text}
                            onChange={(e) =>
                              updateItem(item.id, "text", e.target.value)
                            }
                            rows={2}
                            className="w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                            placeholder="Dharma teaching text..."
                          />
                        </div>
                        <div>
                          <label className="mb-1 block text-xs font-medium text-gray-600">
                            Explanation
                          </label>
                          <textarea
                            value={item.explanation}
                            onChange={(e) =>
                              updateItem(
                                item.id,
                                "explanation",
                                e.target.value
                              )
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
            <h3 className="mb-3 text-sm font-semibold text-gray-900">
              Status
            </h3>
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
            <h3 className="mb-3 text-sm font-semibold text-gray-900">
              Category
            </h3>
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
            <h3 className="mb-3 text-sm font-semibold text-gray-900">
              Author
            </h3>
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
