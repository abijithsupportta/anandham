"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import {
  BookOpen,
  ScrollText,
  Image,
  PenTool,
  FolderTree,
  TrendingUp,
  ClipboardList,
  Clock,
  Music,
  FileText,
  Loader2,
} from "lucide-react";
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
} from "recharts";
import StatCard from "@/components/ui/stat-card";
import StatusBadge from "@/components/ui/status-badge";
import {
  dashboardService,
  type ContentStats,
  type DraftItem,
  type CategoryCount,
  type MonthlyGrowth,
} from "@/services/dashboard.service";
import type { AuditLog } from "@/types/database";

// ── Helpers ────────────────────────────────────────────────

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "Just now";
  if (mins < 60) return `${mins} min ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  const days = Math.floor(hrs / 24);
  if (days < 30) return `${days}d ago`;
  return new Date(dateStr).toLocaleDateString();
}

function tableLabelAndIcon(tableName: string) {
  switch (tableName) {
    case "guru_krithis":
      return { label: "Krithi", icon: BookOpen, color: "text-purple-600 dark:text-purple-400", bg: "bg-purple-50 dark:bg-purple-500/10" };
    case "guru_dharmas":
      return { label: "Dharma", icon: ScrollText, color: "text-amber-600 dark:text-amber-400", bg: "bg-amber-50 dark:bg-amber-500/10" };
    case "guru_photos":
      return { label: "Guru Photo", icon: Image, color: "text-blue-600 dark:text-blue-400", bg: "bg-blue-50 dark:bg-blue-500/10" };
    case "guru_keerthanams":
      return { label: "Keerthanam", icon: Music, color: "text-yellow-600 dark:text-yellow-400", bg: "bg-yellow-50 dark:bg-yellow-500/10" };
    case "blogs":
      return { label: "Blog", icon: FileText, color: "text-rose-600 dark:text-rose-400", bg: "bg-rose-50 dark:bg-rose-500/10" };
    case "authors":
      return { label: "Author", icon: PenTool, color: "text-green-600 dark:text-green-400", bg: "bg-green-50 dark:bg-green-500/10" };
    case "content_categories":
      return { label: "Category", icon: FolderTree, color: "text-indigo-600 dark:text-indigo-400", bg: "bg-indigo-50 dark:bg-indigo-500/10" };
    default:
      return { label: tableName, icon: FileText, color: "text-gray-600 dark:text-gray-400", bg: "bg-gray-50 dark:bg-gray-500/10" };
  }
}

function draftTypeConfig(type: DraftItem["type"]) {
  switch (type) {
    case "krithi":
      return { label: "Krithi", icon: BookOpen, color: "text-purple-600", bg: "bg-purple-50 dark:bg-purple-500/10", href: "/krithis" };
    case "dharma":
      return { label: "Dharma", icon: ScrollText, color: "text-amber-600", bg: "bg-amber-50 dark:bg-amber-500/10", href: "/dharmas" };
    case "blog":
      return { label: "Blog", icon: FileText, color: "text-rose-600", bg: "bg-rose-50 dark:bg-rose-500/10", href: "/blogs" };
    case "keerthanam":
      return { label: "Keerthanam", icon: Music, color: "text-yellow-600", bg: "bg-yellow-50 dark:bg-yellow-500/10", href: "/keerthanams" };
    case "guru_photo":
      return { label: "Guru Photo", icon: Image, color: "text-blue-600", bg: "bg-blue-50 dark:bg-blue-500/10", href: "/guru-photos" };
  }
}

const actionLabels: Record<string, string> = {
  INSERT: "created",
  UPDATE: "updated",
  DELETE: "deleted",
};

// ── Chart tooltip styling for dark mode ────────────────────

const chartTooltipStyle = {
  borderRadius: "8px",
  border: "1px solid var(--border-main)",
  backgroundColor: "var(--card)",
  color: "var(--foreground)",
  boxShadow: "0 1px 3px rgba(0,0,0,0.1)",
};

// ── Component ──────────────────────────────────────────────

export default function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState<ContentStats | null>(null);
  const [activity, setActivity] = useState<AuditLog[]>([]);
  const [drafts, setDrafts] = useState<DraftItem[]>([]);
  const [topCats, setTopCats] = useState<CategoryCount[]>([]);
  const [growth, setGrowth] = useState<MonthlyGrowth[]>([]);

  useEffect(() => {
    async function load() {
      const [s, a, d, c, g] = await Promise.all([
        dashboardService.getStats(),
        dashboardService.getRecentActivity(8),
        dashboardService.getDrafts(8),
        dashboardService.getTopCategories(6),
        dashboardService.getMonthlyGrowth(),
      ]);
      if (s.data) setStats(s.data);
      if (a.data) setActivity(a.data);
      if (d.data) setDrafts(d.data);
      if (c.data) setTopCats(c.data);
      if (g.data) setGrowth(g.data);
      setLoading(false);
    }
    load();
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-32">
        <Loader2 className="h-8 w-8 animate-spin text-indigo-500" />
      </div>
    );
  }

  // ── Build stat cards from real data ──────────────────────

  const statCards = stats
    ? [
        {
          title: "Guru Krithis",
          value: stats.krithis.total,
          change: `${stats.krithis.published} published · ${stats.krithis.draft} draft`,
          changeType: stats.krithis.published > 0 ? ("positive" as const) : ("neutral" as const),
          icon: BookOpen,
          iconColor: "text-purple-600 dark:text-purple-400",
          iconBg: "bg-purple-50 dark:bg-purple-500/10",
        },
        {
          title: "Guru Dharmas",
          value: stats.dharmas.total,
          change: `${stats.dharmas.published} published · ${stats.dharmas.draft} draft`,
          changeType: stats.dharmas.published > 0 ? ("positive" as const) : ("neutral" as const),
          icon: ScrollText,
          iconColor: "text-amber-600 dark:text-amber-400",
          iconBg: "bg-amber-50 dark:bg-amber-500/10",
        },
        {
          title: "Guru Photos",
          value: stats.guruPhotos.total,
          change: `${stats.guruPhotos.published} published · ${stats.guruPhotos.draft} draft`,
          changeType: stats.guruPhotos.published > 0 ? ("positive" as const) : ("neutral" as const),
          icon: Image,
          iconColor: "text-blue-600 dark:text-blue-400",
          iconBg: "bg-blue-50 dark:bg-blue-500/10",
        },
        {
          title: "Guru Keerthanams",
          value: stats.keerthanams.total,
          change: `${stats.keerthanams.published} published · ${stats.keerthanams.draft} draft`,
          changeType: stats.keerthanams.published > 0 ? ("positive" as const) : ("neutral" as const),
          icon: Music,
          iconColor: "text-yellow-600 dark:text-yellow-400",
          iconBg: "bg-yellow-50 dark:bg-yellow-500/10",
        },
        {
          title: "Blog Posts",
          value: stats.blogs.total,
          change: `${stats.blogs.published} published · ${stats.blogs.draft} draft`,
          changeType: stats.blogs.published > 0 ? ("positive" as const) : ("neutral" as const),
          icon: FileText,
          iconColor: "text-rose-600 dark:text-rose-400",
          iconBg: "bg-rose-50 dark:bg-rose-500/10",
        },
        {
          title: "Authors",
          value: stats.authors.total,
          change: `${stats.authors.verified} verified`,
          changeType: "neutral" as const,
          icon: PenTool,
          iconColor: "text-green-600 dark:text-green-400",
          iconBg: "bg-green-50 dark:bg-green-500/10",
        },
        {
          title: "Content Categories",
          value: stats.categories.total,
          change: `${stats.categories.active} active`,
          changeType: "neutral" as const,
          icon: FolderTree,
          iconColor: "text-indigo-600 dark:text-indigo-400",
          iconBg: "bg-indigo-50 dark:bg-indigo-500/10",
        },
      ]
    : [];

  return (
    <div className="space-y-6">
      {/* Page Title */}
      <div>
        <h1 className="text-2xl font-bold text-foreground">Dashboard</h1>
        <p className="mt-1 text-sm text-muted">
          Overview of Anandham content management
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {statCards.map((stat) => (
          <StatCard key={stat.title} {...stat} />
        ))}
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Content Growth Chart */}
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <TrendingUp className="h-5 w-5 text-indigo-600 dark:text-indigo-400" />
            <h2 className="text-lg font-semibold text-foreground">
              Content Growth (Last 6 Months)
            </h2>
          </div>
          {growth.length > 0 ? (
            <ResponsiveContainer width="100%" height={280}>
              <AreaChart data={growth}>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border-light, #374151)" />
                <XAxis dataKey="month" stroke="var(--muted, #9ca3af)" fontSize={12} />
                <YAxis stroke="var(--muted, #9ca3af)" fontSize={12} allowDecimals={false} />
                <Tooltip contentStyle={chartTooltipStyle} />
                <Area type="monotone" dataKey="krithis" stroke="#8b5cf6" fill="#8b5cf680" strokeWidth={2} name="Krithis" />
                <Area type="monotone" dataKey="dharmas" stroke="#f59e0b" fill="#f59e0b80" strokeWidth={2} name="Dharmas" />
                <Area type="monotone" dataKey="blogs" stroke="#f43f5e" fill="#f43f5e80" strokeWidth={2} name="Blogs" />
                <Area type="monotone" dataKey="keerthanams" stroke="#eab308" fill="#eab30880" strokeWidth={2} name="Keerthanams" />
              </AreaChart>
            </ResponsiveContainer>
          ) : (
            <div className="flex h-[280px] items-center justify-center text-sm text-muted">
              No data yet — start creating content!
            </div>
          )}
        </div>

        {/* Top Content Categories Chart */}
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <FolderTree className="h-5 w-5 text-amber-600 dark:text-amber-400" />
            <h2 className="text-lg font-semibold text-foreground">
              Top Content Categories
            </h2>
          </div>
          {topCats.length > 0 ? (
            <ResponsiveContainer width="100%" height={280}>
              <BarChart data={topCats} layout="vertical">
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border-light, #374151)" horizontal={false} />
                <XAxis type="number" stroke="var(--muted, #9ca3af)" fontSize={12} allowDecimals={false} />
                <YAxis type="category" dataKey="name" stroke="var(--muted, #9ca3af)" fontSize={12} width={120} />
                <Tooltip contentStyle={chartTooltipStyle} />
                <Bar dataKey="count" fill="#818cf8" radius={[0, 4, 4, 0]} />
              </BarChart>
            </ResponsiveContainer>
          ) : (
            <div className="flex h-[280px] items-center justify-center text-sm text-muted">
              No category data yet
            </div>
          )}
        </div>
      </div>

      {/* Bottom Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Recent Activity */}
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <ClipboardList className="h-5 w-5 text-indigo-600 dark:text-indigo-400" />
            <h2 className="text-lg font-semibold text-foreground">
              Recent Activity
            </h2>
          </div>
          {activity.length > 0 ? (
            <div className="space-y-4">
              {activity.map((log) => {
                const info = tableLabelAndIcon(log.table_name);
                const Icon = info.icon;
                const title =
                  (log.new_data as Record<string, unknown>)?.title ??
                  (log.old_data as Record<string, unknown>)?.title ??
                  log.record_id.slice(0, 8);
                const userName =
                  (log.user as unknown as { full_name: string })?.full_name ?? "System";

                return (
                  <div key={log.id} className="flex items-start gap-3">
                    <div className={`mt-0.5 rounded-lg p-1.5 ${info.bg}`}>
                      <Icon className={`h-3.5 w-3.5 ${info.color}`} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm text-foreground truncate">
                        {info.label}{" "}
                        <span className="font-medium">&ldquo;{String(title)}&rdquo;</span>{" "}
                        {actionLabels[log.action] ?? log.action.toLowerCase()}
                      </p>
                      <p className="text-xs text-muted">
                        {userName} · {timeAgo(log.changed_at)}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <p className="py-8 text-center text-sm text-muted">
              No recent activity
            </p>
          )}
          <Link
            href="/audit-log"
            className="mt-4 block w-full rounded-lg border border-border-main py-2 text-center text-sm font-medium text-indigo-500 transition hover:bg-accent-subtle"
          >
            View full audit log →
          </Link>
        </div>

        {/* Draft Content */}
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <Clock className="h-5 w-5 text-amber-600 dark:text-amber-400" />
            <h2 className="text-lg font-semibold text-foreground">
              Draft Content
            </h2>
          </div>
          {drafts.length > 0 ? (
            <div className="space-y-3">
              {drafts.map((item) => {
                const cfg = draftTypeConfig(item.type);
                const Icon = cfg.icon;

                return (
                  <Link
                    key={`${item.type}-${item.id}`}
                    href={`${cfg.href}/${item.id}`}
                    className="flex items-center justify-between rounded-lg border border-border-light p-3 transition hover:bg-accent-subtle"
                  >
                    <div className="flex items-center gap-3 min-w-0">
                      <div className={`shrink-0 rounded-lg p-1.5 ${cfg.bg}`}>
                        <Icon className={`h-4 w-4 ${cfg.color}`} />
                      </div>
                      <div className="min-w-0">
                        <p className="text-sm font-medium text-foreground truncate">
                          {item.title}
                        </p>
                        <p className="text-xs text-muted">
                          {cfg.label} · Updated {timeAgo(item.updated_at)}
                        </p>
                      </div>
                    </div>
                    <StatusBadge status="draft" />
                  </Link>
                );
              })}
            </div>
          ) : (
            <p className="py-8 text-center text-sm text-muted">
              No drafts — all content is published!
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
