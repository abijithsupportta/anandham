"use client";

import { useState, useEffect, useCallback } from "react";
import type { GuruPhoto, ContentStatus } from "@/types/database";
import {
  Image as ImageIcon,
  Plus,
  Pencil,
  Trash2,
  Eye,
} from "lucide-react";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import { createClient } from "@/lib/supabase/client";

export default function GuruPhotosPage() {
  const supabase = createClient();
  const [photos, setPhotos] = useState<GuruPhoto[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const perPage = 10;

  const loadPhotos = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from("guru_photos")
      .select("*, category:categories(*), author:authors(*)")
      .eq("is_deleted", false)
      .order("display_order");
    if (data) setPhotos(data as GuruPhoto[]);
    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    loadPhotos();
  }, [loadPhotos]);

  async function handleDelete(id: string) {
    await supabase
      .from("guru_photos")
      .update({ is_deleted: true, deleted_at: new Date().toISOString() })
      .eq("id", id);
    loadPhotos();
  }

  async function handleToggleStatus(id: string, current: ContentStatus) {
    const newStatus = current === "published" ? "draft" : "published";
    await supabase
      .from("guru_photos")
      .update({
        status: newStatus,
        published_at: newStatus === "published" ? new Date().toISOString() : null,
        updated_at: new Date().toISOString(),
      })
      .eq("id", id);
    loadPhotos();
  }

  const filtered = photos.filter((p) => {
    const matchesSearch =
      p.title.toLowerCase().includes(search.toLowerCase()) ||
      (p.description ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || p.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <p className="text-sm text-gray-400">Loading photos...</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Guru Photos</h1>
          <p className="mt-1 text-sm text-gray-500">Manage sacred guru photo gallery</p>
        </div>
        <button className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700">
          <Plus className="h-4 w-4" />
          Upload Photo
        </button>
      </div>

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search photos..." className="sm:w-72" />
        <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value as any)} className="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700">
          <option value="all">All Status</option>
          <option value="draft">Draft</option>
          <option value="published">Published</option>
        </select>
      </div>

      <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-gray-200 bg-gray-50">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">Photo</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 md:table-cell">Category</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 lg:table-cell">Author</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-gray-500">Status</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-gray-500">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {paged.map((p) => (
              <tr key={p.id} className="transition hover:bg-gray-50">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="h-12 w-20 overflow-hidden rounded bg-gray-100">
                      {p.image_url ? (
                        <img src={p.image_url} alt={p.title} className="h-full w-full object-cover" />
                      ) : (
                        <ImageIcon className="h-full w-full text-gray-300" />
                      )}
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900">{p.title}</p>
                      <p className="text-xs text-gray-500">{p.description?.slice(0, 50)}</p>
                    </div>
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell"><span className="rounded-full bg-gray-100 px-2.5 py-1 text-xs font-medium text-gray-700">{p.category?.name ?? "—"}</span></td>
                <td className="hidden px-6 py-4 lg:table-cell"><span className="text-sm text-gray-700">{p.author?.name ?? "—"}</span></td>
                <td className="px-6 py-4 text-center"><StatusBadge status={p.status} /></td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <button onClick={() => handleToggleStatus(p.id, p.status)} className="rounded-md p-1 text-gray-500 hover:bg-gray-100"><Eye className="h-4 w-4" /></button>
                    <button className="rounded-md p-1 text-gray-500 hover:bg-gray-100"><Pencil className="h-4 w-4" /></button>
                    <button onClick={() => handleDelete(p.id)} className="rounded-md p-1 text-red-500 hover:bg-red-50"><Trash2 className="h-4 w-4" /></button>
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
