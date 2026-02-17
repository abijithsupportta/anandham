"use client";

import { useState, useEffect, useCallback } from "react";
import {
  ClipboardList,
  Filter,
  Calendar,
  User,
  ArrowUpCircle,
  PlusCircle,
  Trash2,
  ChevronDown,
  ChevronUp,
} from "lucide-react";
import SearchInput from "@/components/ui/search-input";
import Pagination from "@/components/ui/pagination";
import type { AuditAction, AuditLog } from "@/types/database";
import { createClient } from "@/lib/supabase/client";

const tableOptions = [
  "all",
  "krithis",
  "slokas",
  "dharmas",
  "dharma_items",
  "guru_photos",
  "categories",
  "authors",
] as const;

const actionIcons: Record<AuditAction, typeof PlusCircle> = {
  INSERT: PlusCircle,
  UPDATE: ArrowUpCircle,
  DELETE: Trash2,
};

const actionColors: Record<AuditAction, string> = {
  INSERT: "text-green-600 bg-green-50",
  UPDATE: "text-blue-600 bg-blue-50",
  DELETE: "text-red-600 bg-red-50",
};

const tableLabels: Record<string, string> = {
  krithis: "Krithis",
  slokas: "Slokas",
  dharmas: "Dharmas",
  dharma_items: "Dharma Items",
  guru_photos: "Guru Photos",
  categories: "Categories",
  authors: "Authors",
  profiles: "Profiles",
};

export default function AuditLogPage() {
  const supabase = createClient();
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [tableFilter, setTableFilter] = useState<string>("all");
  const [actionFilter, setActionFilter] = useState<"all" | AuditAction>(
    "all"
  );
  const [page, setPage] = useState(1);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const perPage = 20;

  const loadLogs = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from("audit_logs")
      .select("*, user:profiles!changed_by(full_name)")
      .order("changed_at", { ascending: false })
      .limit(500);
    if (data) setLogs(data as AuditLog[]);
    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    loadLogs();
  }, [loadLogs]);

  const filtered = logs.filter((log) => {
    const userName = (log.user as any)?.full_name ?? "";
    const matchesSearch =
      log.table_name.toLowerCase().includes(search.toLowerCase()) ||
      log.record_id.toLowerCase().includes(search.toLowerCase()) ||
      userName.toLowerCase().includes(search.toLowerCase());
    const matchesTable =
      tableFilter === "all" || log.table_name === tableFilter;
    const matchesAction =
      actionFilter === "all" || log.action === actionFilter;
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

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Audit Log</h1>
        <p className="mt-1 text-sm text-gray-500">
          Track all changes made to content and settings
        </p>
      </div>

      {/* Filters */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput
          value={search}
          onChange={setSearch}
          placeholder="Search logs..."
          className="sm:w-60"
        />
        <select
          value={tableFilter}
          onChange={(e) => setTableFilter(e.target.value)}
          className="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        >
          <option value="all">All Tables</option>
          {tableOptions
            .filter((t) => t !== "all")
            .map((t) => (
              <option key={t} value={t}>
                {tableLabels[t] || t}
              </option>
            ))}
        </select>
        <div className="flex gap-2">
          {(
            [
              { label: "All", value: "all" },
              { label: "Created", value: "INSERT" },
              { label: "Updated", value: "UPDATE" },
              { label: "Deleted", value: "DELETE" },
            ] as const
          ).map((f) => (
            <button
              key={f.value}
              onClick={() => setActionFilter(f.value)}
              className={`rounded-lg px-3 py-1.5 text-sm font-medium transition ${
                actionFilter === f.value
                  ? "bg-indigo-600 text-white"
                  : "border border-gray-200 bg-white text-gray-600 hover:bg-gray-50"
              }`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {/* Log Entries */}
      <div className="space-y-2">
        {paged.map((log) => {
          const ActionIcon = actionIcons[log.action];
          const isExpanded = expandedId === log.id;

          return (
            <div
              key={log.id}
              className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm"
            >
              {/* Row */}
              <button
                onClick={() =>
                  setExpandedId(isExpanded ? null : log.id)
                }
                className="flex w-full items-center gap-3 px-4 py-3 text-left transition hover:bg-gray-50"
              >
                {/* Action Icon */}
                <div
                  className={`rounded-lg p-1.5 ${actionColors[log.action]}`}
                >
                  <ActionIcon className="h-4 w-4" />
                </div>

                {/* Info */}
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <span className="rounded bg-gray-100 px-2 py-0.5 text-xs font-medium text-gray-700">
                      {tableLabels[log.table_name] || log.table_name}
                    </span>
                    <span className="text-sm font-medium text-gray-900">
                      {log.action === "INSERT"
                        ? "Created"
                        : log.action === "UPDATE"
                          ? "Updated"
                          : "Deleted"}
                    </span>
                    <span className="hidden text-xs text-gray-400 sm:inline">
                      #{log.record_id}
                    </span>
                  </div>
                </div>

                {/* User */}
                <div className="hidden items-center gap-1.5 text-xs text-gray-500 md:flex">
                  <User className="h-3.5 w-3.5" />
                  {(log.user as any)?.full_name ?? "System"}
                </div>

                {/* Time */}
                <div className="flex items-center gap-1.5 text-xs text-gray-400">
                  <Calendar className="h-3.5 w-3.5" />
                  {formatDate(log.changed_at)}
                </div>

                {/* Expand */}
                {isExpanded ? (
                  <ChevronUp className="h-4 w-4 text-gray-400" />
                ) : (
                  <ChevronDown className="h-4 w-4 text-gray-400" />
                )}
              </button>

              {/* Expanded Details */}
              {isExpanded && (
                <div className="border-t border-gray-100 bg-gray-50/50 px-4 py-3">
                  <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                    {log.old_data && (
                      <div>
                        <h4 className="mb-1 text-xs font-semibold uppercase text-red-500">
                          Old Data
                        </h4>
                        <pre className="overflow-x-auto rounded-lg border border-red-100 bg-red-50/50 p-3 text-xs text-gray-700">
                          {JSON.stringify(log.old_data, null, 2)}
                        </pre>
                      </div>
                    )}
                    {log.new_data && (
                      <div>
                        <h4 className="mb-1 text-xs font-semibold uppercase text-green-500">
                          New Data
                        </h4>
                        <pre className="overflow-x-auto rounded-lg border border-green-100 bg-green-50/50 p-3 text-xs text-gray-700">
                          {JSON.stringify(log.new_data, null, 2)}
                        </pre>
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          );
        })}

        {filtered.length === 0 && (
          <div className="py-12 text-center text-sm text-gray-400">
            No audit logs found
          </div>
        )}
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <Pagination
          currentPage={page}
          totalPages={totalPages}
          onPageChange={setPage}
        />
      )}
    </div>
  );
}
