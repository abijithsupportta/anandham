"use client";

import { useState } from "react";
import type { Dharma, ContentStatus } from "@/types/database";
import Link from "next/link";
import { ScrollText, Plus, Eye, Pencil, Trash2, Youtube } from "lucide-react";
import { dharmaService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import EmptyState from "@/components/ui/empty-state";

export default function DharmasPage() {
  const { toast } = useToast();
  const { data: dharmas, loading, refetch } = useQuery<Dharma>(
    () => dharmaService.getAll()
  );

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const perPage = 10;

  const filtered = dharmas.filter((d) => {
    const matchesSearch =
      d.title.toLowerCase().includes(search.toLowerCase()) ||
      (d.description ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || d.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  async function handleToggleStatus(dharma: Dharma) {
    const result = await dharmaService.toggleStatus(dharma);
    if (result.error) { toast(result.error, "error"); return; }
    toast(dharma.status === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await dharmaService.softDelete(id);
    if (result.error) { toast(result.error, "error"); return; }
    toast("Dharma deleted", "success");
    refetch();
  }

  if (loading) return <LoadingState message="Loading dharmas..." />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Guru Dharmas"
        subtitle="Manage dharma teachings"
        action={
          <Link href="/dharmas/new" className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700">
            <Plus className="h-4 w-4" />
            New Dharma
          </Link>
        }
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search dharmas..." className="sm:w-72" />
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

      <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-gray-200 bg-gray-50">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">Dharma</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 md:table-cell">Category</th>
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
                      <p className="text-xs text-gray-500">
                        {(dharma.description ?? "").slice(0, 60)}{(dharma.description ?? "").length > 60 ? "..." : ""}
                      </p>
                    </div>
                    {dharma.youtube_url && <Youtube className="h-4 w-4 text-red-500" />}
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell">
                  <span className="rounded-full bg-gray-100 px-2.5 py-1 text-xs font-medium text-gray-700">
                    {dharma.category?.name ?? "—"}
                  </span>
                </td>
                <td className="px-6 py-4 text-center">
                  <StatusBadge status={dharma.status} />
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <Link href={`/dharmas/${dharma.id}`} className="rounded-md p-1.5 text-gray-500 hover:bg-gray-100">
                      <Pencil className="h-4 w-4" />
                    </Link>
                    <button onClick={() => handleToggleStatus(dharma)} className="rounded-md p-1.5 text-gray-500 hover:bg-gray-100" title={dharma.status === "draft" ? "Publish" : "Unpublish"}>
                      <Eye className="h-4 w-4" />
                    </button>
                    <button onClick={() => handleDelete(dharma.id)} className="rounded-md p-1.5 text-red-500 hover:bg-red-50">
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {paged.length === 0 && <EmptyState asTableRow message="No dharmas found" />}
          </tbody>
        </table>
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
