"use client";

import { usePathname } from "next/navigation";
import { ChevronRight, Home, Search, Bell } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

const routeNames: Record<string, string> = {
  "": "Dashboard",
  users: "Users",
  authors: "Authors",
  "content-categories": "Content Categories",
  krithis: "Krithis",
  dharmas: "Dharmas",
  "guru-stories": "Guru Stories",
  "guru-photos": "Guru Photos",
  settings: "Settings",
  "audit-log": "Audit Log",
};

export default function Header() {
  const pathname = usePathname();
  const segments = pathname.split("/").filter(Boolean);
  const [searchQuery, setSearchQuery] = useState("");

  return (
    <header className="sticky top-0 z-20 border-b border-border-main bg-background/80 backdrop-blur-sm">
      <div className="flex h-16 items-center justify-between gap-4 px-6">
        {/* Breadcrumb */}
        <nav className="flex items-center gap-1.5 text-sm">
          <Link
            href="/"
            className="flex items-center gap-1 text-muted transition hover:text-foreground"
          >
            <Home className="h-4 w-4" />
          </Link>
          {segments.map((segment, i) => (
            <span key={segment} className="flex items-center gap-1.5">
              <ChevronRight className="h-3.5 w-3.5 text-muted" />
              {i === segments.length - 1 ? (
                <span className="font-medium text-foreground">
                  {routeNames[segment] ?? segment}
                </span>
              ) : (
                <Link
                  href={`/${segments.slice(0, i + 1).join("/")}`}
                  className="text-muted transition hover:text-foreground"
                >
                  {routeNames[segment] ?? segment}
                </Link>
              )}
            </span>
          ))}
          {segments.length === 0 && (
            <>
              <ChevronRight className="h-3.5 w-3.5 text-muted" />
              <span className="font-medium text-foreground">Dashboard</span>
            </>
          )}
        </nav>

        {/* Right side: search + notifications */}
        <div className="flex items-center gap-3">
          <div className="hidden md:block">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search..."
                className="w-64 rounded-lg border border-border-main bg-input-bg py-2 pl-9 pr-3 text-sm text-foreground placeholder-muted transition focus:border-indigo-400 focus:outline-none focus:ring-2 focus:ring-indigo-500/10"
              />
            </div>
          </div>
          <button className="relative rounded-lg p-2 text-muted transition hover:bg-surface-hover hover:text-foreground">
            <Bell className="h-5 w-5" />
            <span className="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-red-500" />
          </button>
        </div>
      </div>
    </header>
  );
}
