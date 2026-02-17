"use client";

import {
  BookOpen,
  ScrollText,
  Image,
  PenTool,
  FolderTree,
  TrendingUp,
  ClipboardList,
  FileText,
  Clock,
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

// Mock data — replace with Supabase queries
const stats = [
  {
    title: "Guru Krithis",
    value: "48",
    change: "32 published",
    changeType: "positive" as const,
    icon: BookOpen,
    iconColor: "text-purple-600",
    iconBg: "bg-purple-50",
  },
  {
    title: "Guru Dharmas",
    value: "24",
    change: "18 published",
    changeType: "positive" as const,
    icon: ScrollText,
    iconColor: "text-amber-600",
    iconBg: "bg-amber-50",
  },
  {
    title: "Guru Photos",
    value: "156",
    change: "142 published",
    changeType: "positive" as const,
    icon: Image,
    iconColor: "text-blue-600",
    iconBg: "bg-blue-50",
  },
  {
    title: "Authors",
    value: "12",
    change: "10 verified",
    changeType: "neutral" as const,
    icon: PenTool,
    iconColor: "text-green-600",
    iconBg: "bg-green-50",
  },
  {
    title: "Categories",
    value: "18",
    change: "All active",
    changeType: "neutral" as const,
    icon: FolderTree,
    iconColor: "text-indigo-600",
    iconBg: "bg-indigo-50",
  },
  {
    title: "Total Slokas",
    value: "1,247",
    change: "Across all krithis",
    changeType: "neutral" as const,
    icon: FileText,
    iconColor: "text-rose-600",
    iconBg: "bg-rose-50",
  },
];

const contentOverTime = [
  { month: "Sep", krithis: 12, dharmas: 6 },
  { month: "Oct", krithis: 18, dharmas: 10 },
  { month: "Nov", krithis: 25, dharmas: 14 },
  { month: "Dec", krithis: 32, dharmas: 17 },
  { month: "Jan", krithis: 40, dharmas: 20 },
  { month: "Feb", krithis: 48, dharmas: 24 },
];

const topCategories = [
  { name: "Devotional", count: 145 },
  { name: "Philosophical", count: 98 },
  { name: "Spiritual", count: 87 },
  { name: "Daily Practice", count: 65 },
  { name: "Kids", count: 42 },
];

const recentActivity = [
  {
    type: "krithi",
    action: "published",
    message: 'Krithi "காலை வெயில்" published',
    user: "Super Admin",
    time: "15 min ago",
  },
  {
    type: "dharma",
    action: "created",
    message: 'New dharma "நித்ய கர்மா" created',
    user: "Super Admin",
    time: "1 hour ago",
  },
  {
    type: "photo",
    action: "uploaded",
    message: "3 new guru photos uploaded",
    user: "Super Admin",
    time: "2 hours ago",
  },
  {
    type: "krithi",
    action: "updated",
    message: 'Added 12 slokas to "அன்பின் வழி"',
    user: "Super Admin",
    time: "3 hours ago",
  },
  {
    type: "author",
    action: "created",
    message: 'New author "கவிதா" added',
    user: "Super Admin",
    time: "5 hours ago",
  },
];

const draftContent = [
  { title: "மழை நாள்", type: "krithi", slokas: 8, updated: "2 hours ago" },
  { title: "நித்ய கர்மா", type: "dharma", items: 5, updated: "1 day ago" },
  { title: "நிலா ராத்திரி", type: "krithi", slokas: 0, updated: "3 days ago" },
];

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      {/* Page Title */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-500">
          Overview of Anandham content management
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {stats.map((stat) => (
          <StatCard key={stat.title} {...stat} />
        ))}
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Content Growth Chart */}
        <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <TrendingUp className="h-5 w-5 text-indigo-600" />
            <h2 className="text-lg font-semibold text-gray-900">
              Content Growth
            </h2>
          </div>
          <ResponsiveContainer width="100%" height={280}>
            <AreaChart data={contentOverTime}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" />
              <XAxis dataKey="month" stroke="#9ca3af" fontSize={12} />
              <YAxis stroke="#9ca3af" fontSize={12} />
              <Tooltip
                contentStyle={{
                  borderRadius: "8px",
                  border: "1px solid #e5e7eb",
                  boxShadow: "0 1px 3px rgba(0,0,0,0.1)",
                }}
              />
              <Area
                type="monotone"
                dataKey="krithis"
                stroke="#8b5cf6"
                fill="#ede9fe"
                strokeWidth={2}
                name="Krithis"
              />
              <Area
                type="monotone"
                dataKey="dharmas"
                stroke="#f59e0b"
                fill="#fef3c7"
                strokeWidth={2}
                name="Dharmas"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Top Categories Chart */}
        <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <FolderTree className="h-5 w-5 text-amber-600" />
            <h2 className="text-lg font-semibold text-gray-900">
              Top Categories
            </h2>
          </div>
          <ResponsiveContainer width="100%" height={280}>
            <BarChart data={topCategories} layout="vertical">
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" horizontal={false} />
              <XAxis type="number" stroke="#9ca3af" fontSize={12} />
              <YAxis
                type="category"
                dataKey="name"
                stroke="#9ca3af"
                fontSize={12}
                width={100}
              />
              <Tooltip
                contentStyle={{
                  borderRadius: "8px",
                  border: "1px solid #e5e7eb",
                  boxShadow: "0 1px 3px rgba(0,0,0,0.1)",
                }}
              />
              <Bar dataKey="count" fill="#818cf8" radius={[0, 4, 4, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Bottom Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Recent Activity */}
        <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <ClipboardList className="h-5 w-5 text-indigo-600" />
            <h2 className="text-lg font-semibold text-gray-900">
              Recent Activity
            </h2>
          </div>
          <div className="space-y-4">
            {recentActivity.map((item, i) => (
              <div key={i} className="flex items-start gap-3">
                <div
                  className={`mt-0.5 rounded-lg p-1.5 ${
                    item.type === "krithi"
                      ? "bg-purple-50"
                      : item.type === "dharma"
                        ? "bg-amber-50"
                        : item.type === "photo"
                          ? "bg-blue-50"
                          : "bg-green-50"
                  }`}
                >
                  {item.type === "krithi" ? (
                    <BookOpen className="h-3.5 w-3.5 text-purple-600" />
                  ) : item.type === "dharma" ? (
                    <ScrollText className="h-3.5 w-3.5 text-amber-600" />
                  ) : item.type === "photo" ? (
                    <Image className="h-3.5 w-3.5 text-blue-600" />
                  ) : (
                    <PenTool className="h-3.5 w-3.5 text-green-600" />
                  )}
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-700">{item.message}</p>
                  <p className="text-xs text-gray-400">
                    {item.user} · {item.time}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Draft Content */}
        <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
          <div className="mb-4 flex items-center gap-2">
            <Clock className="h-5 w-5 text-amber-600" />
            <h2 className="text-lg font-semibold text-gray-900">
              Draft Content
            </h2>
          </div>
          <div className="space-y-3">
            {draftContent.map((item) => (
              <div
                key={item.title}
                className="flex items-center justify-between rounded-lg border border-gray-100 p-3"
              >
                <div className="flex items-center gap-3">
                  <div
                    className={`rounded-lg p-1.5 ${
                      item.type === "krithi" ? "bg-purple-50" : "bg-amber-50"
                    }`}
                  >
                    {item.type === "krithi" ? (
                      <BookOpen className="h-4 w-4 text-purple-600" />
                    ) : (
                      <ScrollText className="h-4 w-4 text-amber-600" />
                    )}
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-900">
                      {item.title}
                    </p>
                    <p className="text-xs text-gray-500">
                      {"slokas" in item
                        ? `${item.slokas} slokas`
                        : `${item.items} items`}{" "}
                      · Updated {item.updated}
                    </p>
                  </div>
                </div>
                <StatusBadge status="draft" />
              </div>
            ))}
          </div>
          <button className="mt-4 w-full rounded-lg border border-gray-200 py-2 text-center text-sm font-medium text-indigo-600 transition hover:bg-indigo-50">
            View all drafts →
          </button>
        </div>
      </div>
    </div>
  );
}
