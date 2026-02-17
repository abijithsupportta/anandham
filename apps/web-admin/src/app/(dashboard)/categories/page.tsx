"use client";

import { useState, useCallback } from "react";
import type { Category, ContentType } from "@/types/database";
import { categoryService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
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
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

// ── Form data type ─────────────────────────────────────────

interface CategoryFormData {
  content_type_id: string;
  name: string;
  description: string;
  is_active: boolean;
}

const emptyForm: CategoryFormData = {
  content_type_id: "",
  name: "",
  description: "",
  is_active: true,
};

// ── Section icon mapping ───────────────────────────────────

const sectionIcons: Record<string, React.ComponentType<{ className?: string }>> = {
  krithis: BookOpen,
  dharmas: ScrollText,
  guru_photos: Image,
};

// ── Page Component ─────────────────────────────────────────

export default function CategoriesPage() {
  const { toast } = useToast();

  // Data fetching via service layer
  const {
    data: categories,
    loading: catLoading,
    error: catError,
    refetch: refetchCategories,
  } = useQuery<Category>(() => categoryService.getAll());

  const { data: contentTypes, loading: ctLoading, error: ctError } = useQuery<ContentType>(
    () => categoryService.getContentTypes()
  );

  // UI state
  const [search, setSearch] = useState("");
  const [activeTab, setActiveTab] = useState("all");
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<CategoryFormData>(emptyForm);
  const [saving, setSaving] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState<string | null>(null);

  const loading = catLoading || ctLoading;

  // ── Filtering ────────────────────────────────────────────

  const filtered = categories.filter((c) => {
    const matchesSearch =
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      c.description.toLowerCase().includes(search.toLowerCase());
    const matchesTab = activeTab === "all" || c.content_type_id === activeTab;
    return matchesSearch && matchesTab;
  });

  // ── Handlers ─────────────────────────────────────────────

  function handleAdd() {
    setEditingId(null);
    setForm({
      ...emptyForm,
      content_type_id: activeTab !== "all" ? activeTab : "",
    });
    setShowForm(true);
  }

  function handleEdit(cat: Category) {
    setEditingId(cat.id);
    setForm({
      content_type_id: cat.content_type_id,
      name: cat.name,
      description: cat.description,
      is_active: cat.is_active,
    });
    setShowForm(true);
  }

  function handleCancel() {
    setShowForm(false);
    setEditingId(null);
    setForm(emptyForm);
  }

  const handleSave = useCallback(async () => {
    if (!form.name.trim() || !form.content_type_id) {
      toast("Please fill in all required fields", "error");
      return;
    }

    setSaving(true);

    const result = editingId
      ? await categoryService.update(editingId, form)
      : await categoryService.create(form);

    setSaving(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast(editingId ? "Category updated" : "Category created", "success");
    handleCancel();
    refetchCategories();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form, editingId, refetchCategories, toast]);

  async function handleDelete(id: string) {
    const result = await categoryService.delete(id);
    setDeleteConfirm(null);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Category deleted", "success");
    refetchCategories();
  }

  async function handleToggleActive(cat: Category) {
    const result = await categoryService.toggleActive(cat.id, cat.is_active);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast(cat.is_active ? "Category deactivated" : "Category activated", "info");
    refetchCategories();
  }

  function getCategoryCount(contentTypeId: string) {
    return categories.filter((c) => c.content_type_id === contentTypeId).length;
  }

  // ── Render ───────────────────────────────────────────────

  if (loading) return <LoadingState message="Loading categories..." />;
  if (catError || ctError) return <ErrorState message={catError || ctError || "Failed to load categories"} onRetry={refetchCategories} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Categories"
        subtitle="Manage categories for each content section"
        action={
          <button
            onClick={handleAdd}
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
          >
            <Plus className="h-4 w-4" />
            Add Category
          </button>
        }
      />

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
                onChange={(e) => setForm({ ...form, content_type_id: e.target.value })}
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
              disabled={saving}
              className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50"
            >
              <Check className="h-4 w-4" />
              {saving ? "Saving..." : editingId ? "Update" : "Create"}
            </button>
            <button
              onClick={handleCancel}
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

              <div className="hidden sm:flex">
                <span className="inline-flex items-center gap-1.5 rounded-full bg-gray-100 px-2.5 py-1 text-xs font-medium text-gray-700">
                  <Icon className="h-3 w-3" />
                  {ct?.display_name ?? "Unknown"}
                </span>
              </div>

              <div className="flex items-center gap-1">
                <button
                  onClick={() => handleToggleActive(cat)}
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

        {filtered.length === 0 && <EmptyState message="No categories found" />}
      </div>
    </div>
  );
}
