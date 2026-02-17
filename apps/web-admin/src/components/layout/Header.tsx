"use client";

import { usePathname } from "next/navigation";
import { ChevronRight, Home, Search, Bell } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

const routeNames: Record<string, string> = {
  "": "Dashboard",
  users: "Users",
  authors: "Authors",
  content: "Content",
  categories: "Categories",
  reports: "Reports",
  settings: "Settings",
};

export default function Header() {
  const pathname = usePathname();
  const segments = pathname.split("/").filter(Boolean);
  const [searchQuery, setSearchQuery] = useState("");

  return (
    <header className="sticky top-0 z-20 border-b border-gray-200 bg-white/80 backdrop-blur-sm">
      <div className="flex h-16 items-center justify-between gap-4 px-6">
        {/* Breadcrumb */}
        <nav className="flex items-center gap-1.5 text-sm">
          <Link
            href="/"
            className="flex items-center gap-1 text-gray-400 transition hover:text-gray-600"
          >
            <Home className="h-4 w-4" />
          </Link>
          {segments.map((segment, i) => (
            <span key={segment} className="flex items-center gap-1.5">
              <ChevronRight className="h-3.5 w-3.5 text-gray-300" />
              {i === segments.length - 1 ? (
                <span className="font-medium text-gray-900">
                  {routeNames[segment] ?? segment}
                </span>
              ) : (
                <Link
                  href={`/${segments.slice(0, i + 1).join("/")}`}
                  className="text-gray-400 transition hover:text-gray-600"
                >
                  {routeNames[segment] ?? segment}
                </Link>
              )}
            </span>
          ))}
          {segments.length === 0 && (
            <>
              <ChevronRight className="h-3.5 w-3.5 text-gray-300" />
              <span className="font-medium text-gray-900">Dashboard</span>
            </>
          )}
        </nav>

        {/* Right side: search + notifications */}
        <div className="flex items-center gap-3">
          <div className="hidden md:block">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search..."
                className="w-64 rounded-lg border border-gray-200 bg-gray-50 py-2 pl-9 pr-3 text-sm text-gray-900 placeholder-gray-400 transition focus:border-indigo-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500/10"
              />
            </div>
          </div>
          <button className="relative rounded-lg p-2 text-gray-400 transition hover:bg-gray-100 hover:text-gray-600">
            <Bell className="h-5 w-5" />
            <span className="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-red-500" />
          </button>
        </div>
      </div>
    </header>
  );
}
