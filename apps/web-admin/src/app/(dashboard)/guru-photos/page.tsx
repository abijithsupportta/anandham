"use client";

import { useState } from "react";
import type { GuruPhoto, ContentStatus } from "@/types/database";
import {
  Image as ImageIcon,
  Plus,
  Pencil,
  Trash2,
  Eye,
} from "lucide-react";
import Link from "next/link";
import { guruPhotoService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

export default function GuruPhotosPage() {
  const { toast } = useToast();
  const { data: photos, loading, error, refetch } = useQuery<GuruPhoto>(
    () => guruPhotoService.getAll()
  );

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const perPage = 10;

  const filtered = photos.filter((p) => {
    const matchesSearch =
      p.title.toLowerCase().includes(search.toLowerCase()) ||
      (p.description ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || p.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  async function handleToggleStatus(id: string, current: ContentStatus) {
    const result = await guruPhotoService.toggleStatus(id, current);
    if (result.error) { toast(result.error, "error"); return; }
    toast(current === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await guruPhotoService.softDelete(id);
    if (result.error) { toast(result.error, "error"); return; }
    toast("Photo deleted", "success");
    refetch();
  }

  if (loading) return <LoadingState message="Loading photos..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Guru Photos"
        subtitle="Manage sacred guru photo gallery"
        action={
          <Link href="/guru-photos/new" className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700">
            <Plus className="h-4 w-4" />
            Upload Photo
          </Link>
        }
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search photos..." className="sm:w-72" />
        <select
          value={statusFilter}
          onChange={(e) => { setStatusFilter(e.target.value as "all" | ContentStatus); setPage(1); }}
          className="rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        >
          <option value="all">All Status</option>
          <option value="draft">Draft</option>
          <option value="published">Published</option>
        </select>
      </div>

      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Photo</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">Category</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted lg:table-cell">Author</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-muted">Status</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border-light">
            {paged.map((p) => (
              <tr key={p.id} className="transition hover:bg-surface-hover">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="h-12 w-20 overflow-hidden rounded bg-gray-100 dark:bg-gray-800">
                      {p.image_url ? (
                        <img src={p.image_url} alt={p.title} className="h-full w-full object-cover" />
                      ) : (
                        <ImageIcon className="h-full w-full text-gray-300 dark:text-gray-600" />
                      )}
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">{p.title}</p>
                      <p className="text-xs text-muted">{p.description?.slice(0, 50)}</p>
                    </div>
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell"><span className="rounded-full bg-gray-100 dark:bg-gray-800 px-2.5 py-1 text-xs font-medium text-foreground">{p.category?.name ?? "—"}</span></td>
                <td className="hidden px-6 py-4 lg:table-cell"><span className="text-sm text-foreground">{p.author?.name ?? "—"}</span></td>
                <td className="px-6 py-4 text-center"><StatusBadge status={p.status} /></td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <button onClick={() => handleToggleStatus(p.id, p.status)} className="rounded-md p-1 text-muted hover:bg-surface-hover"><Eye className="h-4 w-4" /></button>
                    <Link href={`/guru-photos/${p.id}`} className="rounded-md p-1 text-muted hover:bg-surface-hover"><Pencil className="h-4 w-4" /></Link>
                    <button onClick={() => handleDelete(p.id)} className="rounded-md p-1 text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10"><Trash2 className="h-4 w-4" /></button>
                  </div>
                </td>
              </tr>
            ))}
            {paged.length === 0 && <EmptyState asTableRow colSpan={5} message="No photos found" />}
          </tbody>
        </table>
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
