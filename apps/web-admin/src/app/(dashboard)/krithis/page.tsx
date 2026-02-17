"use client";

import { useState } from "react";
import type { Krithi, ContentStatus } from "@/types/database";
import Link from "next/link";
import { BookOpen, Plus, Eye, Pencil, Trash2, Youtube } from "lucide-react";
import { krithiService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

export default function KrithisPage() {
  const { toast } = useToast();
  const { data: krithis, loading, error, refetch } = useQuery<Krithi>(
    () => krithiService.getAll()
  );

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const perPage = 10;

  // ── Filtering & pagination ───────────────────────────────

  const filtered = krithis.filter((k) => {
    const matchesSearch =
      k.title.toLowerCase().includes(search.toLowerCase()) ||
      k.description.toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || k.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  // ── Handlers ─────────────────────────────────────────────

  async function handleToggleStatus(krithi: Krithi) {
    const result = await krithiService.toggleStatus(krithi);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast(krithi.status === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await krithiService.softDelete(id);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Krithi deleted", "success");
    refetch();
  }

  // ── Render ───────────────────────────────────────────────

  if (loading) return <LoadingState message="Loading krithis..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Guru Krithis"
        subtitle="Manage sacred poems"
        action={
          <Link
            href="/krithis/new"
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
          >
            <Plus className="h-4 w-4" />
            New Krithi
          </Link>
        }
      />

      {/* Filters */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search krithis..." className="sm:w-72" />
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

      {/* Table */}
      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Krithi</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">Category</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-muted">Status</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border-light">
            {paged.map((krithi) => (
              <tr key={krithi.id} className="transition hover:bg-surface-hover">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="rounded-lg bg-purple-50 dark:bg-purple-500/10 p-2">
                      <BookOpen className="h-4 w-4 text-purple-600" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">{krithi.title}</p>
                      <p className="text-xs text-muted">
                        {krithi.description.slice(0, 60)}{krithi.description.length > 60 ? "..." : ""}
                      </p>
                    </div>
                    {krithi.youtube_url && <Youtube className="h-4 w-4 text-red-500" />}
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell">
                  <span className="rounded-full bg-gray-100 dark:bg-gray-800 px-2.5 py-1 text-xs font-medium text-foreground">
                    {krithi.category?.name ?? "—"}
                  </span>
                </td>
                <td className="px-6 py-4 text-center">
                  <StatusBadge status={krithi.status} />
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <Link href={`/krithis/${krithi.id}`} className="rounded-md p-1.5 text-muted hover:bg-surface-hover">
                      <Pencil className="h-4 w-4" />
                    </Link>
                    <button onClick={() => handleToggleStatus(krithi)} className="rounded-md p-1.5 text-muted hover:bg-surface-hover" title={krithi.status === "draft" ? "Publish" : "Unpublish"}>
                      <Eye className="h-4 w-4" />
                    </button>
                    <button onClick={() => handleDelete(krithi.id)} className="rounded-md p-1.5 text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10">
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {paged.length === 0 && <EmptyState asTableRow message="No krithis found" />}
          </tbody>
        </table>
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
