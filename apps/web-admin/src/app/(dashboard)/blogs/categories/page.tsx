"use client";

import { useState } from "react";
import type { BlogCategory } from "@/types/database";
import {
  FolderTree,
  Plus,
  Pencil,
  Trash2,
  Check,
  X,
  ChevronRight,
  CornerDownRight,
} from "lucide-react";
import { blogCategoryService, type BlogCategoryFormInput } from "@/services/blog-category.service";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";

const emptyForm: BlogCategoryFormInput = {
  name: "",
  description: "",
  parent_id: "",
  is_active: true,
};

export default function BlogCategoriesPage() {
  const { toast } = useToast();
  const { data: categories, loading, error, refetch } = useQuery<BlogCategory>(
    () => blogCategoryService.getAll()
  );

  const [search, setSearch] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<BlogCategoryFormInput>(emptyForm);
  const [deleteConfirm, setDeleteConfirm] = useState<string | null>(null);

  // Build tree: top-level categories, with children nested
  const topLevel = categories.filter((c) => !c.parent_id);
  const getChildren = (parentId: string) =>
    categories.filter((c) => c.parent_id === parentId);

  const filtered = categories.filter((c) =>
    c.name.toLowerCase().includes(search.toLowerCase()) ||
    (c.description ?? "").toLowerCase().includes(search.toLowerCase())
  );

  // When searching, show flat list; otherwise show tree
  const isSearching = search.trim().length > 0;

  function handleAdd(parentId = "") {
    setEditingId(null);
    setForm({ ...emptyForm, parent_id: parentId });
    setShowForm(true);
  }

  function handleEdit(cat: BlogCategory) {
    setEditingId(cat.id);
    setForm({
      name: cat.name,
      description: cat.description,
      parent_id: cat.parent_id ?? "",
      is_active: cat.is_active,
    });
    setShowForm(true);
  }

  async function handleSave() {
    if (!form.name.trim()) {
      toast("Name is required", "error");
      return;
    }

    const result = editingId
      ? await blogCategoryService.update(editingId, form)
      : await blogCategoryService.create(form);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast(editingId ? "Category updated" : "Category created", "success");
    setShowForm(false);
    setEditingId(null);
    setForm(emptyForm);
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await blogCategoryService.delete(id);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Category deleted", "success");
    setDeleteConfirm(null);
    refetch();
  }

  async function handleToggleActive(cat: BlogCategory) {
    const result = await blogCategoryService.toggleActive(cat.id, cat.is_active);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    refetch();
  }

  const activeCount = categories.filter((c) => c.is_active).length;

  if (loading) return <LoadingState message="Loading blog categories..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  function renderCategoryRow(cat: BlogCategory, isChild = false) {
    const children = getChildren(cat.id);
    const parentName = cat.parent_id
      ? categories.find((c) => c.id === cat.parent_id)?.name
      : null;

    return (
      <div key={cat.id}>
        <div
          className={`flex items-center gap-3 rounded-lg border bg-card p-3 shadow-sm transition ${
            cat.is_active ? "border-border-main" : "border-border-light opacity-60"
          } ${isChild ? "ml-8" : ""}`}
        >
          {isChild && <CornerDownRight className="h-4 w-4 flex-shrink-0 text-gray-300 dark:text-gray-600" />}
          {!isChild && children.length > 0 && (
            <ChevronRight className="h-4 w-4 flex-shrink-0 text-muted" />
          )}
          {!isChild && children.length === 0 && (
            <FolderTree className="h-4 w-4 flex-shrink-0 text-muted" />
          )}

          <div className="min-w-0 flex-1">
            <div className="flex items-center gap-2">
              <h3 className="text-sm font-semibold text-foreground">{cat.name}</h3>
              {!cat.is_active && (
                <span className="rounded bg-gray-100 dark:bg-gray-800 px-1.5 py-0.5 text-xs text-muted">
                  Inactive
                </span>
              )}
              {isSearching && parentName && (
                <span className="rounded bg-indigo-50 dark:bg-indigo-500/10 px-1.5 py-0.5 text-xs text-indigo-600 dark:text-indigo-400">
                  in {parentName}
                </span>
              )}
            </div>
            {cat.description && (
              <p className="truncate text-xs text-muted">{cat.description}</p>
            )}
          </div>

          {!isChild && (
            <button
              onClick={() => handleAdd(cat.id)}
              className="rounded-md p-1.5 text-muted hover:bg-surface-hover hover:text-indigo-600 dark:text-indigo-400"
              title="Add subcategory"
            >
              <Plus className="h-3.5 w-3.5" />
            </button>
          )}

          <button
            onClick={() => handleToggleActive(cat)}
            className={`rounded-md px-2 py-1 text-xs font-medium transition ${
              cat.is_active
                ? "bg-green-50 dark:bg-green-500/10 text-green-700 hover:bg-green-100 dark:bg-green-500/15"
                : "bg-surface-hover text-muted hover:bg-surface-hover"
            }`}
          >
            {cat.is_active ? "Active" : "Inactive"}
          </button>

          <button
            onClick={() => handleEdit(cat)}
            className="rounded-md p-1.5 text-muted hover:bg-surface-hover hover:text-indigo-600 dark:text-indigo-400"
            title="Edit"
          >
            <Pencil className="h-3.5 w-3.5" />
          </button>

          {deleteConfirm === cat.id ? (
            <div className="flex items-center gap-1">
              <button
                onClick={() => handleDelete(cat.id)}
                className="rounded-md p-1.5 text-red-600 hover:bg-red-50 dark:hover:bg-red-500/10"
                title="Confirm"
              >
                <Check className="h-3.5 w-3.5" />
              </button>
              <button
                onClick={() => setDeleteConfirm(null)}
                className="rounded-md p-1.5 text-muted hover:bg-surface-hover"
                title="Cancel"
              >
                <X className="h-3.5 w-3.5" />
              </button>
            </div>
          ) : (
            <button
              onClick={() => setDeleteConfirm(cat.id)}
              className="rounded-md p-1.5 text-muted hover:bg-surface-hover hover:text-red-600"
              title="Delete"
            >
              <Trash2 className="h-3.5 w-3.5" />
            </button>
          )}
        </div>

        {/* Render children */}
        {!isSearching && children.length > 0 && (
          <div className="mt-1.5 space-y-1.5">
            {children.map((child) => renderCategoryRow(child, true))}
          </div>
        )}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Blog Categories"
        subtitle={`${categories.length} total · ${activeCount} active · ${topLevel.length} top-level`}
        action={
          <button
            onClick={() => handleAdd()}
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
          >
            <Plus className="h-4 w-4" />
            Add Category
          </button>
        }
      />

      <SearchInput
        value={search}
        onChange={setSearch}
        placeholder="Search blog categories..."
        className="sm:w-72"
      />

      {/* Add/Edit Form */}
      {showForm && (
        <div className="rounded-xl border border-indigo-200 dark:border-indigo-500 dark:border-indigo-400/30 bg-indigo-50 dark:bg-indigo-500/10/30 p-6 shadow-sm">
          <h2 className="mb-4 text-lg font-semibold text-foreground">
            {editingId ? "Edit Category" : "New Category"}
          </h2>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label className="mb-1 block text-sm font-medium text-foreground">
                Name *
              </label>
              <input
                type="text"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Category name"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-foreground">
                Parent Category
              </label>
              <select
                value={form.parent_id}
                onChange={(e) => setForm({ ...form, parent_id: e.target.value })}
                className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              >
                <option value="">None (Top-level)</option>
                {topLevel
                  .filter((c) => c.id !== editingId)
                  .map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
              </select>
            </div>
            <div className="sm:col-span-2">
              <label className="mb-1 block text-sm font-medium text-foreground">
                Description
              </label>
              <input
                type="text"
                value={form.description}
                onChange={(e) =>
                  setForm({ ...form, description: e.target.value })
                }
                className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Optional description"
              />
            </div>
          </div>
          <div className="mt-4 flex items-center gap-6">
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={form.is_active}
                onChange={(e) =>
                  setForm({ ...form, is_active: e.target.checked })
                }
                className="h-4 w-4 rounded border-input-border text-indigo-600 dark:text-indigo-400 focus:ring-indigo-500"
              />
              <span className="text-sm text-foreground">Active</span>
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
              className="inline-flex items-center gap-2 rounded-lg border border-input-border bg-card px-4 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover"
            >
              <X className="h-4 w-4" />
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Category Tree */}
      <div className="space-y-2">
        {isSearching
          ? filtered.map((cat) => renderCategoryRow(cat, !!cat.parent_id))
          : topLevel.map((cat) => renderCategoryRow(cat))}

        {(isSearching ? filtered : topLevel).length === 0 && (
          <div className="py-12 text-center text-sm text-muted">
            No blog categories found
          </div>
        )}
      </div>
    </div>
  );
}
