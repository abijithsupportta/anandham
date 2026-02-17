"use client";

import { useState, useEffect, useCallback } from "react";
import type { Krithi, ContentStatus, ContentLanguage } from "@/types/database";
import Link from "next/link";
import {
  BookOpen,
  Plus,
  Eye,
  Pencil,
  Trash2,
  MoreVertical,
  Globe,
  FileText,
  Youtube,
} from "lucide-react";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import { createClient } from "@/lib/supabase/client";

const languageLabels: Record<ContentLanguage, string> = {
  ta: "Tamil",
  en: "English",
  sa: "Sanskrit",
  ml: "Malayalam",
  hi: "Hindi",
};

export default function KrithisPage() {
  const [krithis, setKrithis] = useState<Krithi[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [languageFilter, setLanguageFilter] = useState<"all" | ContentLanguage>("all");
  const [page, setPage] = useState(1);
  const [openMenu, setOpenMenu] = useState<string | null>(null);
  const perPage = 10;

  const supabase = createClient();

  const fetchKrithis = useCallback(async () => {
    setLoading(true);
    const query = supabase
      .from("krithis")
      .select("*, category:categories(id, name), author:authors(id, name)")
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
    const matchesLanguage = languageFilter === "all" || k.language === languageFilter;
    return matchesSearch && matchesStatus && matchesLanguage;
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
    setOpenMenu(null);
  }

  async function handleDelete(id: string) {
    const { error } = await supabase
      .from("krithis")
      .update({ is_deleted: true, deleted_at: new Date().toISOString() })
      .eq("id", id);

    if (!error) setKrithis((prev) => prev.filter((k) => k.id !== id));
    setOpenMenu(null);
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Guru Krithis</h1>
          <p className="mt-1 text-sm text-gray-500">Manage sacred poems with slokas</p>
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
        <div className="flex gap-2">
          <select
            value={statusFilter}
            onChange={(e) => { setStatusFilter(e.target.value as "all" | ContentStatus); setPage(1); }}
            className="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
          >
            <option value="all">All Status</option>
            <option value="draft">Draft</option>
            <option value="published">Published</option>
          </select>
          <select
            value={languageFilter}
            onChange={(e) => { setLanguageFilter(e.target.value as "all" | ContentLanguage); setPage(1); }}
            className="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
          >
            <option value="all">All Languages</option>
            <option value="ta">Tamil</option>
            <option value="en">English</option>
            <option value="sa">Sanskrit</option>
            <option value="ml">Malayalam</option>
            <option value="hi">Hindi</option>
          </select>
        </div>
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
                <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 lg:table-cell">Author</th>
                <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-gray-500">Slokas</th>
                <th className="hidden px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-gray-500 sm:table-cell">Lang</th>
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
                          {krithi.description.slice(0, 50)}{krithi.description.length > 50 ? "..." : ""}
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
                  <td className="hidden px-6 py-4 lg:table-cell">
                    <span className="text-sm text-gray-700">{krithi.author?.name ?? "—"}</span>
                  </td>
                  <td className="px-6 py-4 text-center">
                    <div className="flex items-center justify-center gap-1">
                      <FileText className="h-3.5 w-3.5 text-gray-400" />
                      <span className="text-sm font-medium text-gray-700">{krithi.sloka_count ?? 0}</span>
                    </div>
                  </td>
                  <td className="hidden px-6 py-4 text-center sm:table-cell">
                    <span className="inline-flex items-center gap-1 text-xs text-gray-500">
                      <Globe className="h-3 w-3" />
                      {languageLabels[krithi.language]}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-center">
                    <StatusBadge status={krithi.status} />
                  </td>
                  <td className="px-6 py-4 text-right">
                    <div className="relative inline-block">
                      <button
                        onClick={() => setOpenMenu(openMenu === krithi.id ? null : krithi.id)}
                        className="rounded-lg p-1.5 text-gray-400 transition hover:bg-gray-100 hover:text-gray-600"
                      >
                        <MoreVertical className="h-4 w-4" />
                      </button>
                      {openMenu === krithi.id && (
                        <div className="absolute right-0 z-10 mt-1 w-40 rounded-lg border border-gray-200 bg-white py-1 shadow-lg">
                          <Link
                            href={`/krithis/${krithi.id}`}
                            className="flex items-center gap-2 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50"
                          >
                            <Eye className="h-4 w-4" />
                            View / Edit
                          </Link>
                          <button
                            onClick={() => handleToggleStatus(krithi)}
                            className="flex w-full items-center gap-2 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50"
                          >
                            {krithi.status === "draft" ? (
                              <><BookOpen className="h-4 w-4" />Publish</>
                            ) : (
                              <><Pencil className="h-4 w-4" />Unpublish</>
                            )}
                          </button>
                          <button
                            onClick={() => handleDelete(krithi.id)}
                            className="flex w-full items-center gap-2 px-3 py-2 text-sm text-red-600 hover:bg-red-50"
                          >
                            <Trash2 className="h-4 w-4" />
                            Delete
                          </button>
                        </div>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
              {paged.length === 0 && (
                <tr>
                  <td colSpan={7} className="py-12 text-center text-sm text-gray-400">
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
