"use client";

import { useState } from "react";
import {
  Users,
  MoreVertical,
  Eye,
  Ban,
  CheckCircle,
  Mail,
  Calendar,
  Shield,
  Trash2,
} from "lucide-react";
import { userService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";
import type { UserRole, Profile } from "@/types/database";

const roleLabels: Record<UserRole, string> = {
  super_admin: "Super Admin",
  admin: "Admin",
  author: "Author",
  customer: "Customer",
};

const roleFilters: { label: string; value: "all" | UserRole }[] = [
  { label: "All", value: "all" },
  { label: "Super Admin", value: "super_admin" },
  { label: "Admin", value: "admin" },
  { label: "Author", value: "author" },
  { label: "Customer", value: "customer" },
];

export default function UsersPage() {
  const { toast } = useToast();
  const { data: users, loading, error, refetch } = useQuery<Profile>(
    () => userService.getAll()
  );

  const [search, setSearch] = useState("");
  const [roleFilter, setRoleFilter] = useState<"all" | UserRole>("all");
  const [currentPage, setCurrentPage] = useState(1);
  const [openMenu, setOpenMenu] = useState<string | null>(null);
  const [deleteConfirm, setDeleteConfirm] = useState<{ userId: string; name: string; role: UserRole } | null>(null);
  const [deleting, setDeleting] = useState(false);
  const perPage = 10;

  async function handleToggleActive(userId: string, currentActive: boolean) {
    const result = await userService.toggleActive(userId, currentActive);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast(currentActive ? "User deactivated" : "User activated", "success");
    refetch();
    setOpenMenu(null);
  }

  async function handleDeleteUser(userId: string, role: string) {
    setDeleting(true);
    const result = await userService.deleteUser(userId, role);
    setDeleting(false);

    if (result.error) {
      toast(result.error, "error");
      setDeleteConfirm(null);
      return;
    }

    toast("User permanently deleted from database and Supabase Auth", "success");
    setDeleteConfirm(null);
    refetch();
  }

  const filtered = users.filter((u) => {
    const matchesSearch =
      u.full_name.toLowerCase().includes(search.toLowerCase()) ||
      (u.email ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesRole = roleFilter === "all" || u.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((currentPage - 1) * perPage, currentPage * perPage);

  if (loading) return <LoadingState message="Loading users..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Users"
        subtitle="Manage admin and author accounts"
        meta={
          <div className="flex items-center gap-2 text-sm text-muted">
            <Users className="h-4 w-4" />
            <span>{filtered.length} users</span>
          </div>
        }
      />

      <div className="flex flex-col gap-4 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search by name or email..." className="sm:w-80" />
        <div className="flex gap-2">
          {roleFilters.map((f) => (
            <button
              key={f.value}
              onClick={() => { setRoleFilter(f.value); setCurrentPage(1); }}
              className={`rounded-lg px-3 py-1.5 text-sm font-medium transition ${roleFilter === f.value ? "bg-indigo-600 text-white" : "bg-card text-gray-600 dark:text-gray-400 border border-border-main hover:bg-surface-hover"}`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-border-light bg-surface-hover/50">
                <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">User</th>
                <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Role</th>
                <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Status</th>
                <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Joined</th>
                <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border-light">
              {paged.map((user) => (
                <tr key={user.id} className="transition hover:bg-surface-hover/50">
                  <td className="whitespace-nowrap px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="flex h-9 w-9 items-center justify-center rounded-full bg-indigo-100 dark:bg-indigo-500/15 text-sm font-semibold text-indigo-600 dark:text-indigo-400">
                        {user.full_name.split(" ").map((n) => n[0]).join("")}
                      </div>
                      <div>
                        <p className="text-sm font-medium text-foreground">{user.full_name}</p>
                        <p className="text-xs text-muted flex items-center gap-1"><Mail className="h-3 w-3" />{user.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="whitespace-nowrap px-6 py-4">
                    <span className={`inline-flex items-center gap-1 rounded-full px-2.5 py-0.5 text-xs font-medium ${user.role === "super_admin" ? "bg-purple-100 dark:bg-purple-500/10 text-purple-700 dark:text-purple-400" : user.role === "admin" ? "bg-indigo-100 dark:bg-indigo-500/15 text-indigo-700 dark:text-indigo-400" : "bg-gray-100 dark:bg-gray-800 text-foreground"}`}>
                      <Shield className="h-3 w-3" />
                      {roleLabels[user.role]}
                    </span>
                  </td>
                  <td className="whitespace-nowrap px-6 py-4">
                    <StatusBadge status={user.is_active ? "active" : "inactive"} />
                  </td>
                  <td className="whitespace-nowrap px-6 py-4">
                    <span className="flex items-center gap-1 text-sm text-muted">
                      <Calendar className="h-3.5 w-3.5" />
                      {new Date(user.created_at).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}
                    </span>
                  </td>
                  <td className="whitespace-nowrap px-6 py-4 text-right">
                    <div className="relative inline-block">
                      <button onClick={() => setOpenMenu(openMenu === user.id ? null : user.id)} className="rounded-lg p-1.5 text-muted transition hover:bg-surface-hover hover:text-gray-600 dark:text-gray-400">
                        <MoreVertical className="h-4 w-4" />
                      </button>
                      {openMenu === user.id && (
                        <div className="absolute right-0 z-10 mt-1 w-40 rounded-lg border border-border-main bg-card py-1 shadow-lg">
                          <button className="flex w-full items-center gap-2 px-4 py-2 text-sm text-foreground hover:bg-surface-hover">
                            <Eye className="h-4 w-4" />
                            View Details
                          </button>
                          {user.is_active ? (
                            <button onClick={() => handleToggleActive(user.id, user.is_active)} className="flex w-full items-center gap-2 px-4 py-2 text-sm text-amber-600 hover:bg-amber-50 dark:hover:bg-amber-500/10">
                              <Ban className="h-4 w-4" />
                              Deactivate
                            </button>
                          ) : (
                            <button onClick={() => handleToggleActive(user.id, user.is_active)} className="flex w-full items-center gap-2 px-4 py-2 text-sm text-green-600 hover:bg-green-50 dark:hover:bg-green-500/10">
                              <CheckCircle className="h-4 w-4" />
                              Activate
                            </button>
                          )}
                          {user.role !== "super_admin" && (
                            <button onClick={() => { setDeleteConfirm({ userId: user.id, name: user.full_name, role: user.role }); setOpenMenu(null); }} className="flex w-full items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-red-500/10">
                              <Trash2 className="h-4 w-4" />
                              Delete
                            </button>
                          )}
                        </div>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
              {paged.length === 0 && <EmptyState asTableRow colSpan={5} message="No users found" />}
            </tbody>
          </table>
        </div>
      </div>

      {/* Delete confirmation modal */}
      {deleteConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="max-w-md rounded-lg bg-card p-6 shadow-lg">
            <h3 className="text-lg font-semibold text-foreground">Delete User?</h3>
            <p className="mt-2 text-sm text-muted">
              This will permanently delete <strong>{deleteConfirm.name}</strong> ({deleteConfirm.role}) from the database and Supabase Auth. This action cannot be undone.
            </p>
            <div className="mt-6 flex gap-3">
              <button
                onClick={() => {
                  handleDeleteUser(deleteConfirm.userId, deleteConfirm.role);
                }}
                disabled={deleting}
                className="flex-1 rounded-lg bg-red-600 px-3 py-2 text-sm font-medium text-white transition hover:bg-red-700 disabled:cursor-not-allowed disabled:opacity-50"
              >
                {deleting ? "Deleting..." : "Delete Permanently"}
              </button>
              <button
                onClick={() => setDeleteConfirm(null)}
                disabled={deleting}
                className="flex-1 rounded-lg border border-border-main px-3 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover disabled:cursor-not-allowed disabled:opacity-50"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
    </div>
  );
}