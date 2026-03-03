"use client";

import { useState } from "react";
import type { Sponsor, ContentStatus } from "@/types/database";
import Link from "next/link";
import { HandCoins, Plus, Eye, Pencil, Trash2, House, IndianRupee } from "lucide-react";
import { sponsorService } from "@/services/sponsor.service";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

function formatAmount(amount: number) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 2,
  }).format(amount);
}

export default function SponsorsPage() {
  const { toast } = useToast();
  const { data: sponsors, loading, error, refetch } = useQuery<Sponsor>(() => sponsorService.getAll());

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const perPage = 10;

  const filtered = sponsors.filter((sponsor) => {
    const q = search.toLowerCase();
    const matchesSearch =
      sponsor.sponsor_name.toLowerCase().includes(q) ||
      sponsor.house_name.toLowerCase().includes(q);

    const matchesStatus =
      statusFilter === "all" || sponsor.status === statusFilter;

    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  async function handleToggleStatus(sponsor: Sponsor) {
    const result = await sponsorService.toggleStatus(sponsor);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast(sponsor.status === "draft" ? "Sponsor is now shown" : "Sponsor is now hidden", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await sponsorService.softDelete(id);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Sponsor deleted", "success");
    refetch();
  }

  if (loading) return <LoadingState message="Loading sponsors..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  const shownCount = sponsors.filter((s) => s.status === "published").length;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Sponsors"
        subtitle={`${sponsors.length} total · ${shownCount} shown`}
        action={
          <Link
            href="/sponsors/new"
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
          >
            <Plus className="h-4 w-4" />
            New Sponsor
          </Link>
        }
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput
          value={search}
          onChange={setSearch}
          placeholder="Search sponsors..."
          className="sm:w-72"
        />
        <select
          value={statusFilter}
          onChange={(e) => {
            setStatusFilter(e.target.value as "all" | ContentStatus);
            setPage(1);
          }}
          className="rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        >
          <option value="all">All Visibility</option>
          <option value="draft">Hidden</option>
          <option value="published">Shown</option>
        </select>
      </div>

      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Rank</th>
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Sponsor</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">House</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">Amount</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-muted">Visibility</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border-light">
            {paged.map((sponsor, index) => {
              const rank = (page - 1) * perPage + index + 1;
              return (
                <tr key={sponsor.id} className="transition hover:bg-surface-hover">
                  <td className="px-4 py-4">
                    <span className="inline-flex h-7 min-w-7 items-center justify-center rounded-full bg-amber-50 px-2 text-xs font-semibold text-amber-700 dark:bg-amber-500/10 dark:text-amber-300">
                      {rank}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="h-10 w-10 overflow-hidden rounded-full bg-gray-100 dark:bg-gray-800">
                        {sponsor.photo_url ? (
                          <img src={sponsor.photo_url} alt={sponsor.sponsor_name} className="h-full w-full object-cover" />
                        ) : (
                          <div className="flex h-full w-full items-center justify-center text-gray-400">
                            <HandCoins className="h-4 w-4" />
                          </div>
                        )}
                      </div>
                      <div className="min-w-0">
                        <p className="truncate text-sm font-semibold text-foreground">{sponsor.sponsor_name}</p>
                      </div>
                    </div>
                  </td>
                  <td className="hidden px-6 py-4 md:table-cell">
                    <span className="inline-flex items-center gap-1 text-sm text-foreground">
                      <House className="h-3.5 w-3.5 text-muted" />
                      {sponsor.house_name || "—"}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <span className="inline-flex items-center gap-1 text-sm font-semibold text-foreground">
                      <IndianRupee className="h-3.5 w-3.5 text-emerald-600" />
                      {formatAmount(Number(sponsor.donated_amount || 0)).replace("₹", "")}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-center">
                    <StatusBadge status={sponsor.status} />
                  </td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <button
                        onClick={() => handleToggleStatus(sponsor)}
                        className="rounded-md p-1.5 text-muted hover:bg-surface-hover"
                        title={sponsor.status === "draft" ? "Show sponsor" : "Hide sponsor"}
                      >
                        <Eye className="h-4 w-4" />
                      </button>
                      <Link
                        href={`/sponsors/${sponsor.id}`}
                        className="rounded-md p-1.5 text-muted hover:bg-surface-hover"
                        title="Edit"
                      >
                        <Pencil className="h-4 w-4" />
                      </Link>
                      <button
                        onClick={() => handleDelete(sponsor.id)}
                        className="rounded-md p-1.5 text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10"
                        title="Delete"
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
            {paged.length === 0 && (
              <EmptyState asTableRow colSpan={6} message="No sponsors found" />
            )}
          </tbody>
        </table>
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
