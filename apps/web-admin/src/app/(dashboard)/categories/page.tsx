"use client";

import { useState, useEffect, useCallback } from "react";
import type { Category, ContentType } from "@/types/database";
import { createClient } from "@/lib/supabase/client";
import {
  FolderTree,
  Plus,
  Pencil,
  Trash2,
  Check,
  X,
  BookOpen,
  ScrollText,
  Image,
} from "lucide-react";
import SearchInput from "@/components/ui/search-input";

interface CategoryFormData {
  content_type_id: string;
  name: string;
  description: string;
  icon: string;
  color: string;
  is_active: boolean;
}

const emptyForm: CategoryFormData = {
  content_type_id: "",
  name: "",
  description: "",
  icon: "📁",
  color: "#6366f1",
  is_active: true,
};

const sectionIcons: Record<string, React.ComponentType<{ className?: string }>> = {
  krithis: BookOpen,
  dharmas: ScrollText,
  guru_photos: Image,
};

export default function CategoriesPage() {
  const supabase = createClient();
  const [categories, setCategories] = useState<Category[]>([]);
  const [contentTypes, setContentTypes] = useState<ContentType[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [activeTab, setActiveTab] = useState<string>("all");
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<CategoryFormData>(emptyForm);
  const [deleteConfirm, setDeleteConfirm] = useState<string | null>(null);

  const loadData = useCallback(async () => {
    setLoading(true);
    const [catRes, ctRes] = await Promise.all([
      supabase.from("categories").select("*, content_type:content_types(*)").order("display_order"),
      supabase.from("content_types").select("*").eq("is_active", true).order("display_order"),
    ]);
    if (catRes.data) setCategories(catRes.data as Category[]);
    if (ctRes.data) setContentTypes(ctRes.data as ContentType[]);
    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const filtered = categories.filter((c) => {
    const matchesSearch =
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      c.description.toLowerCase().includes(search.toLowerCase());
    const matchesTab =
      activeTab === "all" || c.content_type_id === activeTab;
    return matchesSearch && matchesTab;
  });

  function handleEdit(cat: Category) {
    setEditingId(cat.id);
    setForm({
      content_type_id: cat.content_type_id,
      name: cat.name,
      description: cat.description,
      icon: cat.icon,
      color: cat.color,
      is_active: cat.is_active,
    });
    setShowForm(true);
  }

  function handleAdd() {
    setEditingId(null);
    setForm({
      ...emptyForm,
      content_type_id: activeTab !== "all" ? activeTab : "",
    });
    setShowForm(true);
  }

  async function handleSave() {
    if (!form.name.trim() || !form.content_type_id) return;
    const now = new Date().toISOString();
    const slug = form.name.toLowerCase().replace(/[^a-z0-9\s-]/g, "").replace(/\s+/g, "-");

    if (editingId) {
      await supabase
        .from("categories")
        .update({ ...form, slug, updated_at: now })
        .eq("id", editingId);
    } else {
      const display_order =
        categories.filter((c) => c.content_type_id === form.content_type_id).length + 1;
      await supabase.from("categories").insert({
        ...form,
        slug,
        display_order,
        created_at: now,
        updated_at: now,
      });
    }
    setShowForm(false);
    setEditingId(null);
    setForm(emptyForm);
    loadData();
  }

  async function handleDelete(id: string) {
    await supabase.from("categories").delete().eq("id", id);
    setDeleteConfirm(null);
    loadData();
  }

  async function handleToggleActive(id: string) {
    const cat = categories.find((c) => c.id === id);
    if (!cat) return;
    await supabase
      .from("categories")
      .update({ is_active: !cat.is_active, updated_at: new Date().toISOString() })
      .eq("id", id);
    loadData();
  }

  function getCategoryCount(contentTypeId: string) {
    return categories.filter((c) => c.content_type_id === contentTypeId).length;
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <p className="text-sm text-gray-400">Loading categories...</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Categories</h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage categories for each content section
          </p>
        </div>
        <button
          onClick={handleAdd}
          className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
        >
          <Plus className="h-4 w-4" />
          Add Category
        </button>
      </div>

      {/* Content Type Tabs */}
      <div className="flex flex-wrap gap-2">
        <button
          onClick={() => setActiveTab("all")}
          className={`rounded-lg px-4 py-2 text-sm font-medium transition ${
            activeTab === "all"
              ? "bg-indigo-600 text-white"
              : "border border-gray-200 bg-white text-gray-600 hover:bg-gray-50"
          }`}
        >
          All ({categories.length})
        </button>
        {contentTypes.map((ct) => {
          const Icon = sectionIcons[ct.table_name] ?? FolderTree;
          return (
            <button
              key={ct.id}
              onClick={() => setActiveTab(ct.id)}
              className={`inline-flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium transition ${
                activeTab === ct.id
                  ? "bg-indigo-600 text-white"
                  : "border border-gray-200 bg-white text-gray-600 hover:bg-gray-50"
              }`}
            >
              <Icon className="h-4 w-4" />
              {ct.display_name} ({getCategoryCount(ct.id)})
            </button>
          );
        })}
      </div>

      {/* Search */}
      <SearchInput
        value={search}
        onChange={setSearch}
        placeholder="Search categories..."
        className="sm:w-72"
      />

      {/* Add/Edit Form */}
      {showForm && (
        <div className="rounded-xl border border-indigo-200 bg-indigo-50/30 p-6 shadow-sm">
          <h2 className="mb-4 text-lg font-semibold text-gray-900">
            {editingId ? "Edit Category" : "New Category"}
          </h2>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Content Section *
              </label>
              <select
                value={form.content_type_id}
                onChange={(e) =>
                  setForm({ ...form, content_type_id: e.target.value })
                }
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              >
                <option value="">Select section</option>
                {contentTypes.map((ct) => (
                  <option key={ct.id} value={ct.id}>
                    {ct.display_name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Name *
              </label>
              <input
                type="text"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Category name"
              />
            </div>
            <div className="sm:col-span-2">
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Description
              </label>
              <input
                type="text"
                value={form.description}
                onChange={(e) => setForm({ ...form, description: e.target.value })}
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Short description"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Icon (emoji)
              </label>
              <input
                type="text"
                value={form.icon}
                onChange={(e) => setForm({ ...form, icon: e.target.value })}
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="📁"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Color
              </label>
              <div className="flex items-center gap-2">
                <input
                  type="color"
                  value={form.color}
                  onChange={(e) => setForm({ ...form, color: e.target.value })}
                  className="h-9 w-12 cursor-pointer rounded border border-gray-300"
                />
                <input
                  type="text"
                  value={form.color}
                  onChange={(e) => setForm({ ...form, color: e.target.value })}
                  className="flex-1 rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>
            </div>
          </div>
          <div className="mt-4 flex items-center gap-3">
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={form.is_active}
                onChange={(e) => setForm({ ...form, is_active: e.target.checked })}
                className="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
              />
              <span className="text-sm text-gray-700">Active</span>
            </label>
          </div>
          <div className="mt-4 flex gap-3">
            <button
              onClick={handleSave}
              className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
            >
              <Check className="h-4 w-4" />
              {editingId ? "Update" : "Create"}
            </button>
            <button
              onClick={() => {
                setShowForm(false);
                setEditingId(null);
                setForm(emptyForm);
              }}
              className="inline-flex items-center gap-2 rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition hover:bg-gray-50"
            >
              <X className="h-4 w-4" />
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Categories List */}
      <div className="space-y-3">
        {filtered.map((cat) => {
          const ct = contentTypes.find((t) => t.id === cat.content_type_id);
          const Icon = ct ? (sectionIcons[ct.table_name] ?? FolderTree) : FolderTree;
          return (
            <div
              key={cat.id}
              className={`flex items-center gap-4 rounded-xl border bg-white p-4 shadow-sm transition ${
                cat.is_active ? "border-gray-200" : "border-gray-100 opacity-60"
              }`}
            >
              {/* Icon */}
              <div
                className="flex h-10 w-10 items-center justify-center rounded-lg text-lg"
                style={{ backgroundColor: cat.color + "20" }}
              >
                {cat.icon}
              </div>

              {/* Info */}
              <div className="min-w-0 flex-1">
                <div className="flex items-center gap-2">
                  <h3 className="text-sm font-semibold text-gray-900">{cat.name}</h3>
                  {!cat.is_active && (
                    <span className="rounded bg-gray-100 px-1.5 py-0.5 text-xs text-gray-500">
                      Inactive
                    </span>
                  )}
                </div>
                <p className="text-xs text-gray-500">{cat.description}</p>
              </div>

              {/* Content Type Badge */}
              <div className="hidden sm:flex">
                <span className="inline-flex items-center gap-1.5 rounded-full bg-gray-100 px-2.5 py-1 text-xs font-medium text-gray-700">
                  <Icon className="h-3 w-3" />
                  {ct?.display_name ?? "Unknown"}
                </span>
              </div>

              {/* Actions */}
              <div className="flex items-center gap-1">
                <button
                  onClick={() => handleToggleActive(cat.id)}
                  className={`rounded-lg p-2 text-sm transition ${
                    cat.is_active
                      ? "text-green-600 hover:bg-green-50"
                      : "text-gray-400 hover:bg-gray-50"
                  }`}
                  title={cat.is_active ? "Deactivate" : "Activate"}
                >
                  <Check className="h-4 w-4" />
                </button>
                <button
                  onClick={() => handleEdit(cat)}
                  className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-50 hover:text-indigo-600"
                  title="Edit"
                >
                  <Pencil className="h-4 w-4" />
                </button>
                {deleteConfirm === cat.id ? (
                  <div className="flex items-center gap-1">
                    <button
                      onClick={() => handleDelete(cat.id)}
                      className="rounded-lg p-2 text-red-600 transition hover:bg-red-50"
                      title="Confirm delete"
                    >
                      <Check className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => setDeleteConfirm(null)}
                      className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-50"
                      title="Cancel"
                    >
                      <X className="h-4 w-4" />
                    </button>
                  </div>
                ) : (
                  <button
                    onClick={() => setDeleteConfirm(cat.id)}
                    className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-50 hover:text-red-600"
                    title="Delete"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                )}
              </div>
            </div>
          );
        })}

        {filtered.length === 0 && (
          <div className="py-12 text-center text-sm text-gray-400">
            No categories found
          </div>
        )}
      </div>
    </div>
  );
}
