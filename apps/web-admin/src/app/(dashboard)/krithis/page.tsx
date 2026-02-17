"use client";

import { useState, useEffect, useCallback } from "react";
import type { Krithi, ContentStatus } from "@/types/database";
import Link from "next/link";
import {
  BookOpen,
  Plus,
  Eye,
  Pencil,
  Trash2,
  Youtube,
} from "lucide-react";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import { createClient } from "@/lib/supabase/client";

export default function KrithisPage() {
  const [krithis, setKrithis] = useState<Krithi[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const perPage = 10;

  const supabase = createClient();

  const fetchKrithis = useCallback(async () => {
    setLoading(true);
    const query = supabase
      .from("krithis")
      .select("*, category:categories(id, name)")
      .eq("is_deleted", false)
      .order("created_at", { ascending: false });

    const { data, error } = await query;
    if (!error && data) {
      setKrithis(data as unknown as Krithi[]);
    }
    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    fetchKrithis();
  }, [fetchKrithis]);

  const filtered = krithis.filter((k) => {
    const matchesSearch =
      k.title.toLowerCase().includes(search.toLowerCase()) ||
      k.description.toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || k.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  async function handleToggleStatus(krithi: Krithi) {
    const newStatus: ContentStatus = krithi.status === "draft" ? "published" : "draft";
    const updates: Record<string, unknown> = {
      status: newStatus,
      updated_at: new Date().toISOString(),
    };
    if (newStatus === "published") updates.published_at = new Date().toISOString();

    const { error } = await supabase.from("krithis").update(updates).eq("id", krithi.id);
    if (!error) {
      setKrithis((prev) =>
        prev.map((k) => (k.id === krithi.id ? { ...k, ...updates } as Krithi : k))
      );
    }
  }

  async function handleDelete(id: string) {
    const { error } = await supabase
      .from("krithis")
      .update({ is_deleted: true, deleted_at: new Date().toISOString() })
      .eq("id", id);

    if (!error) setKrithis((prev) => prev.filter((k) => k.id !== id));
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Guru Krithis</h1>
          <p className="mt-1 text-sm text-gray-500">Manage sacred poems</p>
        </div>
        <Link
          href="/krithis/new"
          className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
        >
          <Plus className="h-4 w-4" />
          New Krithi
        </Link>
      </div>

      {/* Filters */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search krithis..." className="sm:w-72" />
        <select
          value={statusFilter}
          onChange={(e) => { setStatusFilter(e.target.value as "all" | ContentStatus); setPage(1); }}
          className="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        >
          <option value="all">All Status</option>
          <option value="draft">Draft</option>
          <option value="published">Published</option>
        </select>
      </div>

      {/* Table */}
      <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
        {loading ? (
          <div className="flex items-center justify-center py-24">
            <p className="text-sm text-gray-400">Loading krithis...</p>
          </div>
        ) : (
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200 bg-gray-50">
                <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">Krithi</th>
                <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 md:table-cell">Category</th>
                <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-gray-500">Status</th>
                <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-gray-500">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {paged.map((krithi) => (
                <tr key={krithi.id} className="transition hover:bg-gray-50">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="rounded-lg bg-purple-50 p-2">
                        <BookOpen className="h-4 w-4 text-purple-600" />
                      </div>
                      <div>
                        <p className="text-sm font-semibold text-gray-900">{krithi.title}</p>
                        <p className="text-xs text-gray-500">
                          {krithi.description.slice(0, 60)}{krithi.description.length > 60 ? "..." : ""}
                        </p>
                      </div>
                      {krithi.youtube_url && <Youtube className="h-4 w-4 text-red-500" />}
                    </div>
                  </td>
                  <td className="hidden px-6 py-4 md:table-cell">
                    <span className="rounded-full bg-gray-100 px-2.5 py-1 text-xs font-medium text-gray-700">
                      {krithi.category?.name ?? "—"}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-center">
                    <StatusBadge status={krithi.status} />
                  </td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <Link
                        href={`/krithis/${krithi.id}`}
                        className="rounded-md p-1.5 text-gray-500 hover:bg-gray-100"
                      >
                        <Pencil className="h-4 w-4" />
                      </Link>
                      <button
                        onClick={() => handleToggleStatus(krithi)}
                        className="rounded-md p-1.5 text-gray-500 hover:bg-gray-100"
                        title={krithi.status === "draft" ? "Publish" : "Unpublish"}
                      >
                        <Eye className="h-4 w-4" />
                      </button>
                      <button
                        onClick={() => handleDelete(krithi.id)}
                        className="rounded-md p-1.5 text-red-500 hover:bg-red-50"
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
              {paged.length === 0 && (
                <tr>
                  <td colSpan={4} className="py-12 text-center text-sm text-gray-400">
                    No krithis found
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        )}
      </div>

      {/* Pagination */}
      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
