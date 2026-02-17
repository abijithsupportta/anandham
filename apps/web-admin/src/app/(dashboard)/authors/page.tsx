"use client";

import { useState, useEffect, useCallback } from "react";
import type { Author } from "@/types/database";
import {
  PenTool,
  Plus,
  Pencil,
  Trash2,
  Check,
  X,
  CheckCircle,
  Calendar,
} from "lucide-react";
import SearchInput from "@/components/ui/search-input";
import Pagination from "@/components/ui/pagination";
import { createClient } from "@/lib/supabase/client";

interface AuthorFormData {
  name: string;
  bio: string;
  is_verified: boolean;
  is_active: boolean;
}

const emptyForm: AuthorFormData = {
  name: "",
  bio: "",
  is_verified: false,
  is_active: true,
};

export default function AuthorsPage() {
  const supabase = createClient();
  const [authors, setAuthors] = useState<Author[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [activeFilter, setActiveFilter] = useState<
    "all" | "active" | "inactive"
  >("all");
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<AuthorFormData>(emptyForm);
  const [deleteConfirm, setDeleteConfirm] = useState<string | null>(null);
  const [page, setPage] = useState(1);

  const loadAuthors = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from("authors")
      .select("*")
      .order("name");
    if (data) setAuthors(data as Author[]);
    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    loadAuthors();
  }, [loadAuthors]);

  const filtered = authors.filter((a) => {
    const matchesSearch =
      a.name.toLowerCase().includes(search.toLowerCase()) ||
      a.bio.toLowerCase().includes(search.toLowerCase());
    const matchesFilter =
      activeFilter === "all" ||
      (activeFilter === "active" && a.is_active) ||
      (activeFilter === "inactive" && !a.is_active);
    return matchesSearch && matchesFilter;
  });

  function handleAdd() {
    setEditingId(null);
    setForm(emptyForm);
    setShowForm(true);
  }

  function handleEdit(author: Author) {
    setEditingId(author.id);
    setForm({
      name: author.name,
      bio: author.bio,
      is_verified: author.is_verified,
      is_active: author.is_active,
    });
    setShowForm(true);
  }

  async function handleSave() {
    if (!form.name.trim()) return;
    const now = new Date().toISOString();

    if (editingId) {
      await supabase
        .from("authors")
        .update({ ...form, updated_at: now })
        .eq("id", editingId);
    } else {
      await supabase.from("authors").insert({
        name: form.name,
        bio: form.bio,
        is_verified: form.is_verified,
        is_active: form.is_active,
        created_at: now,
        updated_at: now,
      });
    }
    setShowForm(false);
    setEditingId(null);
    setForm(emptyForm);
    loadAuthors();
  }

  async function handleDelete(id: string) {
    await supabase.from("authors").delete().eq("id", id);
    setDeleteConfirm(null);
    loadAuthors();
  }

  async function handleToggle(id: string, field: "is_active" | "is_verified") {
    const author = authors.find((a) => a.id === id);
    if (!author) return;
    await supabase
      .from("authors")
      .update({ [field]: !author[field], updated_at: new Date().toISOString() })
      .eq("id", id);
    loadAuthors();
  }

  const verifiedCount = authors.filter((a) => a.is_verified).length;
  const activeCount = authors.filter((a) => a.is_active).length;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Authors</h1>
          <p className="mt-1 text-sm text-gray-500">
            {authors.length} total · {activeCount} active · {verifiedCount}{" "}
            verified
          </p>
        </div>
        <button
          onClick={handleAdd}
          className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
        >
          <Plus className="h-4 w-4" />
          Add Author
        </button>
      </div>

      {/* Filters */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput
          value={search}
          onChange={setSearch}
          placeholder="Search authors..."
          className="sm:w-72"
        />
        <div className="flex gap-2">
          {(
            [
              { label: "All", value: "all" },
              { label: "Active", value: "active" },
              { label: "Inactive", value: "inactive" },
            ] as const
          ).map((f) => (
            <button
              key={f.value}
              onClick={() => {
                setActiveFilter(f.value);
                setPage(1);
              }}
              className={`rounded-lg px-3 py-1.5 text-sm font-medium transition ${
                activeFilter === f.value
                  ? "bg-indigo-600 text-white"
                  : "border border-gray-200 bg-white text-gray-600 hover:bg-gray-50"
              }`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {/* Add/Edit Form */}
      {showForm && (
        <div className="rounded-xl border border-indigo-200 bg-indigo-50/30 p-6 shadow-sm">
          <h2 className="mb-4 text-lg font-semibold text-gray-900">
            {editingId ? "Edit Author" : "New Author"}
          </h2>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Name *
              </label>
              <input
                type="text"
                value={form.name}
                onChange={(e) =>
                  setForm({ ...form, name: e.target.value })
                }
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Author name"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Bio
              </label>
              <input
                type="text"
                value={form.bio}
                onChange={(e) =>
                  setForm({ ...form, bio: e.target.value })
                }
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Short biography"
              />
            </div>
          </div>
          <div className="mt-4 flex items-center gap-6">
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={form.is_verified}
                onChange={(e) =>
                  setForm({ ...form, is_verified: e.target.checked })
                }
                className="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
              />
              <span className="text-sm text-gray-700">Verified</span>
            </label>
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={form.is_active}
                onChange={(e) =>
                  setForm({ ...form, is_active: e.target.checked })
                }
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

      {/* Authors List */}
      <div className="space-y-3">
        {filtered.map((author) => (
          <div
            key={author.id}
            className={`flex items-center gap-4 rounded-xl border bg-white p-4 shadow-sm transition ${
              author.is_active
                ? "border-gray-200"
                : "border-gray-100 opacity-60"
            }`}
          >
            {/* Avatar */}
            <div className="flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-full bg-purple-100">
              <PenTool className="h-5 w-5 text-purple-600" />
            </div>

            {/* Info */}
            <div className="min-w-0 flex-1">
              <div className="flex items-center gap-2">
                <h3 className="text-sm font-semibold text-gray-900">
                  {author.name}
                </h3>
                {author.is_verified && (
                  <CheckCircle className="h-4 w-4 text-blue-500" />
                )}
                {!author.is_active && (
                  <span className="rounded bg-gray-100 px-1.5 py-0.5 text-xs text-gray-500">
                    Inactive
                  </span>
                )}
              </div>
              <p className="truncate text-xs text-gray-500">{author.bio}</p>
            </div>

            {/* Date */}
            <div className="hidden items-center gap-1 text-sm text-gray-500 sm:flex">
              <Calendar className="h-3.5 w-3.5" />
              <span>
                {new Date(author.created_at).toLocaleDateString("en-IN", {
                  day: "numeric",
                  month: "short",
                  year: "numeric",
                })}
              </span>
            </div>

            {/* Actions */}
            <div className="flex items-center gap-1">
              <button
                onClick={() => handleToggle(author.id, "is_verified")}
                className={`rounded-lg p-2 text-sm transition ${
                  author.is_verified
                    ? "text-blue-600 hover:bg-blue-50"
                    : "text-gray-400 hover:bg-gray-50"
                }`}
                title={
                  author.is_verified ? "Remove verification" : "Verify"
                }
              >
                <CheckCircle className="h-4 w-4" />
              </button>
              <button
                onClick={() => handleEdit(author)}
                className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-50 hover:text-indigo-600"
                title="Edit"
              >
                <Pencil className="h-4 w-4" />
              </button>
              {deleteConfirm === author.id ? (
                <div className="flex items-center gap-1">
                  <button
                    onClick={() => handleDelete(author.id)}
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
                  onClick={() => setDeleteConfirm(author.id)}
                  className="rounded-lg p-2 text-gray-400 transition hover:bg-gray-50 hover:text-red-600"
                  title="Delete"
                >
                  <Trash2 className="h-4 w-4" />
                </button>
              )}
            </div>
          </div>
        ))}

        {filtered.length === 0 && (
          <div className="py-12 text-center text-sm text-gray-400">
            No authors found
          </div>
        )}
      </div>

      {/* Pagination */}
      <Pagination
        currentPage={page}
        totalPages={Math.max(1, Math.ceil(filtered.length / 10))}
        onPageChange={setPage}
      />
    </div>
  );
}
