"use client";

import { useState } from "react";
import {
  Calendar,
  User,
  ArrowUpCircle,
  PlusCircle,
  Trash2,
  ChevronDown,
  ChevronUp,
} from "lucide-react";
import { auditLogService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import SearchInput from "@/components/ui/search-input";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import type { AuditAction, AuditLog, Profile } from "@/types/database";

// Audit log with joined user profile
interface AuditLogWithUser extends Omit<AuditLog, 'user'> {
  user: Profile | null;
}

const tableOptions = [
  "all",
  "krithis",
  "slokas",
  "dharmas",
  "dharma_items",
  "guru_photos",
  "content_categories",
  "authors",
] as const;

const actionIcons: Record<AuditAction, typeof PlusCircle> = {
  INSERT: PlusCircle,
  UPDATE: ArrowUpCircle,
  DELETE: Trash2,
};

const actionColors: Record<AuditAction, string> = {
  INSERT: "text-green-600 bg-green-50 dark:bg-green-500/10",
  UPDATE: "text-blue-600 bg-blue-50 dark:bg-blue-500/10",
  DELETE: "text-red-600 bg-red-50 dark:bg-red-500/10",
};

const tableLabels: Record<string, string> = {
  krithis: "Krithis",
  slokas: "Slokas",
  dharmas: "Dharmas",
  dharma_items: "Dharma Items",
  guru_photos: "Guru Photos",
  content_categories: "Content Categories",
  authors: "Authors",
  profiles: "Profiles",
};

export default function AuditLogPage() {
  const { data: logs, loading, error, refetch } = useQuery<AuditLogWithUser>(
    () => auditLogService.getRecent() as Promise<import("@/services/base").ServiceResult<AuditLogWithUser[]>>
  );

  const [search, setSearch] = useState("");
  const [tableFilter, setTableFilter] = useState<string>("all");
  const [actionFilter, setActionFilter] = useState<"all" | AuditAction>("all");
  const [page, setPage] = useState(1);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const perPage = 20;

  const filtered = logs.filter((log) => {
    const userName = log.user?.full_name ?? "";
    const matchesSearch =
      log.table_name.toLowerCase().includes(search.toLowerCase()) ||
      log.record_id.toLowerCase().includes(search.toLowerCase()) ||
      userName.toLowerCase().includes(search.toLowerCase());
    const matchesTable = tableFilter === "all" || log.table_name === tableFilter;
    const matchesAction = actionFilter === "all" || log.action === actionFilter;
    return matchesSearch && matchesTable && matchesAction;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  function formatDate(iso: string) {
    const d = new Date(iso);
    return d.toLocaleDateString("en-IN", {
      day: "numeric",
      month: "short",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  }

  if (loading) return <LoadingState message="Loading audit logs..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader title="Audit Log" subtitle="Track all changes made to content and settings" />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search logs..." className="sm:w-60" />
        <select
          value={tableFilter}
          onChange={(e) => setTableFilter(e.target.value)}
          className="rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        >
          <option value="all">All Tables</option>
          {tableOptions.filter((t) => t !== "all").map((t) => (
            <option key={t} value={t}>{tableLabels[t] || t}</option>
          ))}
        </select>
        <div className="flex gap-2">
          {([{ label: "All", value: "all" }, { label: "Created", value: "INSERT" }, { label: "Updated", value: "UPDATE" }, { label: "Deleted", value: "DELETE" }] as const).map((f) => (
            <button
              key={f.value}
              onClick={() => setActionFilter(f.value)}
              className={`rounded-lg px-3 py-1.5 text-sm font-medium transition ${actionFilter === f.value ? "bg-indigo-600 text-white" : "border border-border-main bg-card text-gray-600 dark:text-gray-400 hover:bg-surface-hover"}`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      <div className="space-y-2">
        {paged.map((log) => {
          const ActionIcon = actionIcons[log.action];
          const isExpanded = expandedId === log.id;

          return (
            <div key={log.id} className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
              <button
                onClick={() => setExpandedId(isExpanded ? null : log.id)}
                className="flex w-full items-center gap-3 px-4 py-3 text-left transition hover:bg-surface-hover"
              >
                <div className={`rounded-lg p-1.5 ${actionColors[log.action]}`}>
                  <ActionIcon className="h-4 w-4" />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <span className="rounded bg-gray-100 dark:bg-gray-800 px-2 py-0.5 text-xs font-medium text-foreground">{tableLabels[log.table_name] || log.table_name}</span>
                    <span className="text-sm font-medium text-foreground">{log.action === "INSERT" ? "Created" : log.action === "UPDATE" ? "Updated" : "Deleted"}</span>
                    <span className="hidden text-xs text-muted sm:inline">#{log.record_id}</span>
                  </div>
                </div>
                <div className="hidden items-center gap-1.5 text-xs text-muted md:flex">
                  <User className="h-3.5 w-3.5" />
                  {log.user?.full_name ?? "System"}
                </div>
                <div className="flex items-center gap-1.5 text-xs text-muted">
                  <Calendar className="h-3.5 w-3.5" />
                  {formatDate(log.changed_at)}
                </div>
                {isExpanded ? <ChevronUp className="h-4 w-4 text-muted" /> : <ChevronDown className="h-4 w-4 text-muted" />}
              </button>

              {isExpanded && (
                <div className="border-t border-border-light bg-surface-hover/50 px-4 py-3">
                  <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                    {log.old_data && (
                      <div>
                        <h4 className="mb-1 text-xs font-semibold uppercase text-red-500">Old Data</h4>
                        <pre className="overflow-x-auto rounded-lg border border-red-100 dark:border-red-500/20 bg-red-50 dark:bg-red-500/10 p-3 text-xs text-foreground">{JSON.stringify(log.old_data, null, 2)}</pre>
                      </div>
                    )}
                    {log.new_data && (
                      <div>
                        <h4 className="mb-1 text-xs font-semibold uppercase text-green-500">New Data</h4>
                        <pre className="overflow-x-auto rounded-lg border border-green-100 dark:border-green-500/20 bg-green-50 dark:bg-green-500/10 p-3 text-xs text-foreground">{JSON.stringify(log.new_data, null, 2)}</pre>
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          );
        })}

        {filtered.length === 0 && (
          <div className="py-12 text-center text-sm text-muted">No audit logs found</div>
        )}
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
