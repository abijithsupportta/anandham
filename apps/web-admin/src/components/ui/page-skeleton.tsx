/**
 * Professional skeleton loading UI for dashboard pages.
 * Shows a layout-aware shimmer effect while content loads.
 */

function Shimmer({ className = "" }: { className?: string }) {
  return (
    <div
      className={`animate-pulse rounded-lg bg-surface-hover dark:bg-[#333] ${className}`}
    />
  );
}

/** Stat card skeleton */
function StatCardSkeleton() {
  return (
    <div className="rounded-xl border border-border-main bg-card p-6">
      <div className="flex items-center justify-between">
        <div className="space-y-3">
          <Shimmer className="h-4 w-24" />
          <Shimmer className="h-8 w-16" />
          <Shimmer className="h-5 w-32 rounded-full" />
        </div>
        <Shimmer className="h-12 w-12 rounded-xl" />
      </div>
    </div>
  );
}

/** Table/list page skeleton */
export function ListPageSkeleton({ rows = 6 }: { rows?: number }) {
  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="space-y-2">
          <Shimmer className="h-7 w-48" />
          <Shimmer className="h-4 w-64" />
        </div>
        <Shimmer className="h-10 w-36 rounded-lg" />
      </div>

      {/* Filters */}
      <div className="flex gap-3">
        <Shimmer className="h-10 w-64 rounded-lg" />
        <Shimmer className="h-10 w-32 rounded-lg" />
      </div>

      {/* Table rows */}
      <div className="rounded-xl border border-border-main bg-card overflow-hidden">
        {/* Header row */}
        <div className="border-b border-border-light px-6 py-4 flex gap-6">
          <Shimmer className="h-4 w-1/4" />
          <Shimmer className="h-4 w-1/6" />
          <Shimmer className="h-4 w-1/6" />
          <Shimmer className="h-4 w-1/6" />
        </div>
        {/* Data rows */}
        {Array.from({ length: rows }).map((_, i) => (
          <div
            key={i}
            className="border-b border-border-light px-6 py-4 flex items-center gap-6 last:border-0"
          >
            <Shimmer className="h-4 w-1/3" />
            <Shimmer className="h-4 w-1/6" />
            <Shimmer className="h-6 w-20 rounded-full" />
            <Shimmer className="h-4 w-1/6" />
          </div>
        ))}
      </div>
    </div>
  );
}

/** Form/detail page skeleton */
export function FormPageSkeleton() {
  return (
    <div className="space-y-6">
      {/* Back + title */}
      <div className="flex items-center gap-3">
        <Shimmer className="h-9 w-9 rounded-lg" />
        <div className="space-y-2">
          <Shimmer className="h-7 w-56" />
          <Shimmer className="h-4 w-80" />
        </div>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        {/* Main form */}
        <div className="lg:col-span-2 space-y-4">
          <div className="rounded-xl border border-border-main bg-card p-6 space-y-5">
            <div className="space-y-2">
              <Shimmer className="h-4 w-16" />
              <Shimmer className="h-10 w-full rounded-lg" />
            </div>
            <div className="space-y-2">
              <Shimmer className="h-4 w-20" />
              <Shimmer className="h-40 w-full rounded-lg" />
            </div>
          </div>
        </div>

        {/* Sidebar panel */}
        <div className="space-y-4">
          <div className="rounded-xl border border-border-main bg-card p-6 space-y-4">
            <Shimmer className="h-5 w-24" />
            <Shimmer className="h-10 w-full rounded-lg" />
            <Shimmer className="h-10 w-full rounded-lg" />
            <Shimmer className="h-10 w-full rounded-lg" />
          </div>
        </div>
      </div>
    </div>
  );
}

/** Dashboard skeleton */
export function DashboardSkeleton() {
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <Shimmer className="h-7 w-36" />
        <Shimmer className="h-4 w-72" />
      </div>

      {/* Stat cards */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {Array.from({ length: 7 }).map((_, i) => (
          <StatCardSkeleton key={i} />
        ))}
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <div className="rounded-xl border border-border-main bg-card p-6">
          <Shimmer className="mb-4 h-6 w-48" />
          <Shimmer className="h-[280px] w-full rounded-lg" />
        </div>
        <div className="rounded-xl border border-border-main bg-card p-6">
          <Shimmer className="mb-4 h-6 w-44" />
          <Shimmer className="h-[280px] w-full rounded-lg" />
        </div>
      </div>

      {/* Bottom row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <div className="rounded-xl border border-border-main bg-card p-6 space-y-4">
          <Shimmer className="h-6 w-36" />
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="flex items-center gap-3">
              <Shimmer className="h-8 w-8 rounded-lg" />
              <div className="flex-1 space-y-1.5">
                <Shimmer className="h-4 w-3/4" />
                <Shimmer className="h-3 w-1/3" />
              </div>
            </div>
          ))}
        </div>
        <div className="rounded-xl border border-border-main bg-card p-6 space-y-3">
          <Shimmer className="h-6 w-32" />
          {Array.from({ length: 3 }).map((_, i) => (
            <div
              key={i}
              className="rounded-lg border border-border-light p-3 flex items-center justify-between"
            >
              <div className="flex items-center gap-3">
                <Shimmer className="h-8 w-8 rounded-lg" />
                <div className="space-y-1.5">
                  <Shimmer className="h-4 w-40" />
                  <Shimmer className="h-3 w-28" />
                </div>
              </div>
              <Shimmer className="h-6 w-14 rounded-full" />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
