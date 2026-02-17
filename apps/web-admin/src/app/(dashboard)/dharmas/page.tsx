"use client";

import { useState, useEffect, useCallback } from "react";
import type { Dharma, ContentStatus } from "@/types/database";
import Link from "next/link";
import {
  ScrollText,
  Plus,
  Eye,
  Pencil,
  Trash2,
  Globe,
  ClipboardList,
} from "lucide-react";
import SearchInput from "@/components/ui/search-input";
import Pagination from "@/components/ui/pagination";
import { createClient } from "@/lib/supabase/client";

export default function DharmasPage() {
  const supabase = createClient();
  const [dharmas, setDharmas] = useState<Dharma[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>(
    "all"
  );
  const [page, setPage] = useState(1);
  const perPage = 10;

  const loadDharmas = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from("dharmas")
      .select("*, category:categories(*), author:authors(*)")
      .eq("is_deleted", false)
      .order("created_at", { ascending: false });
    if (data) setDharmas(data as Dharma[]);
    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    loadDharmas();
  }, [loadDharmas]);

  async function handleDelete(id: string) {
    await supabase
      .from("dharmas")
      .update({ is_deleted: true, deleted_at: new Date().toISOString() })
      .eq("id", id);
    loadDharmas();
  }

  const filtered = dharmas.filter((d) => {
    const matchesSearch =
      d.title.toLowerCase().includes(search.toLowerCase()) ||
      d.description.toLowerCase().includes(search.toLowerCase()) ||
      (d.author?.name ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || d.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <p className="text-sm text-gray-400">Loading dharmas...</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Guru Dharmas</h1>
          <p className="mt-1 text-sm text-gray-500">Manage dharma teaching lists</p>
        </div>
        <Link
          href="/dharmas/new"
          className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
        >
          <Plus className="h-4 w-4" />
          New Dharma
        </Link>
      </div>

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search dharmas..." className="sm:w-72" />
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value as "all" | ContentStatus)}
          className="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        >
          <option value="all">All Status</option>
          <option value="draft">Draft</option>
          <option value="published">Published</option>
        </select>
      </div>

      <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-gray-200 bg-gray-50">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">Dharma</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 md:table-cell">Category</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 lg:table-cell">Author</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-gray-500">Items</th>
              <th className="hidden px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-gray-500 sm:table-cell">Lang</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-gray-500">Status</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-gray-500">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {paged.map((dharma) => (
              <tr key={dharma.id} className="transition hover:bg-gray-50">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="rounded-lg bg-amber-50 p-2">
                      <ScrollText className="h-4 w-4 text-amber-600" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900">{dharma.title}</p>
                      <p className="text-xs text-gray-500">{dharma.description?.slice(0, 50)}{dharma.description && dharma.description.length > 50 ? "..." : ""}</p>
                    </div>
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell">
                  <span className="rounded-full bg-gray-100 px-2.5 py-1 text-xs font-medium text-gray-700">{dharma.category?.name ?? "—"}</span>
                </td>
                <td className="hidden px-6 py-4 lg:table-cell">
                  <span className="text-sm text-gray-700">{dharma.author?.name ?? "—"}</span>
                </td>
                <td className="px-6 py-4 text-center">
                  <div className="flex items-center justify-center gap-1">
                    <ClipboardList className="h-3.5 w-3.5 text-gray-400" />
                    <span className="text-sm font-medium text-gray-700">{dharma.item_count ?? 0}</span>
                  </div>
                </td>
                <td className="hidden px-6 py-4 text-center sm:table-cell">
                  <span className="inline-flex items-center gap-1 text-xs text-gray-500"><Globe className="h-3 w-3" />{dharma.language}</span>
                </td>
                <td className="px-6 py-4 text-center">
                  <span className="inline-flex items-center rounded-full px-2 py-0.5 text-xs font-semibold text-gray-700">{dharma.status}</span>
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <Link href={`/dharmas/${dharma.id}`} className="rounded-md p-1 text-gray-500 hover:bg-gray-100"><Eye className="h-4 w-4" /></Link>
                    <Link href={`/dharmas/${dharma.id}`} className="rounded-md p-1 text-gray-500 hover:bg-gray-100"><Pencil className="h-4 w-4" /></Link>
                    <button onClick={() => handleDelete(dharma.id)} className="rounded-md p-1 text-red-500 hover:bg-red-50"><Trash2 className="h-4 w-4" /></button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {totalPages > 1 && (
        <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
      )}
    </div>
  );
}
