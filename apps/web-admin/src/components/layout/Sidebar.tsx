"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  PenTool,
  BookOpen,
  FolderTree,
  Image as ImageIcon,
  Settings,
  LogOut,
  ChevronLeft,
  ChevronDown,
  Menu,
  ScrollText,
  Users,
  Layers,
  Newspaper,
  List,
  Sun,
  Moon,
  Music,
} from "lucide-react";
import { useState } from "react";
import Image from "next/image";
import { useAuth } from "@/components/providers/auth-provider";
import { useTheme } from "@/components/providers/theme-provider";

interface NavItem {
  name: string;
  href: string;
  icon: React.ComponentType<{ className?: string }>;
}

interface NavGroup {
  label: string;
  icon: React.ComponentType<{ className?: string }>;
  children: NavItem[];
}

type SidebarEntry = NavItem | NavGroup;

function isGroup(entry: SidebarEntry): entry is NavGroup {
  return "children" in entry;
}

const sidebarEntries: SidebarEntry[] = [
  { name: "Dashboard", href: "/", icon: LayoutDashboard },
  {
    label: "Content Management",
    icon: Layers,
    children: [
      { name: "Guru Krithis", href: "/krithis", icon: BookOpen },
      { name: "Guru Keerthanams", href: "/keerthanams", icon: Music },
      { name: "Guru Dharmas", href: "/dharmas", icon: ScrollText },
      { name: "Guru Photos", href: "/guru-photos", icon: ImageIcon },
      { name: "Content Categories", href: "/content-categories", icon: FolderTree },
    ],
  },
  {
    label: "Blog",
    icon: Newspaper,
    children: [
      { name: "Blog Posts", href: "/blogs", icon: List },
      { name: "Blog Categories", href: "/blogs/categories", icon: FolderTree },
    ],
  },
  { name: "User Management", href: "/users", icon: Users },
  { name: "Authors", href: "/authors", icon: PenTool },
  { name: "Project Journey", href: "/project-journey", icon: List },
  { name: "Settings", href: "/settings", icon: Settings },
];

export default function Sidebar() {
  const pathname = usePathname();
  const { user, signOut } = useAuth();
  const { theme, toggleTheme } = useTheme();
  const [collapsed, setCollapsed] = useState(false);
  const [openGroups, setOpenGroups] = useState<Record<string, boolean>>({
    "Content Management": true,
  });

  const isActive = (href: string) => {
    if (href === "/") return pathname === "/";
    return pathname.startsWith(href);
  };

  const isGroupActive = (group: NavGroup) =>
    group.children.some((child) => isActive(child.href));

  function toggleGroup(label: string) {
    setOpenGroups((prev) => ({ ...prev, [label]: !prev[label] }));
  }

  function renderLink(item: NavItem, indent = false) {
    const active = isActive(item.href);
    return (
      <Link
        key={item.name}
        href={item.href}
        onClick={() => {
          if (window.innerWidth < 1024) setCollapsed(true);
        }}
        className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
          indent && !collapsed ? "ml-4" : ""
        } ${
          active
            ? "bg-accent-subtle text-indigo-400 dark:text-indigo-300"
            : "text-gray-600 hover:bg-surface-hover hover:text-foreground dark:text-gray-400 dark:hover:text-gray-200"
        }`}
        title={collapsed ? item.name : undefined}
      >
        <item.icon
          className={`h-5 w-5 shrink-0 ${
            active ? "text-indigo-500 dark:text-indigo-400" : "text-gray-400 dark:text-gray-500"
          }`}
        />
        {!collapsed && <span>{item.name}</span>}
      </Link>
    );
  }

  return (
    <>
      {/* Mobile toggle */}
      <button
        onClick={() => setCollapsed(!collapsed)}
        className="fixed left-4 top-4 z-50 rounded-lg border border-border-main bg-surface p-2 shadow-sm lg:hidden"
      >
        <Menu className="h-5 w-5 text-foreground" />
      </button>

      {/* Overlay for mobile */}
      {!collapsed && (
        <div
          className="fixed inset-0 z-30 bg-black/40 lg:hidden"
          onClick={() => setCollapsed(true)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed inset-y-0 left-0 z-40 flex flex-col border-r border-border-main bg-sidebar transition-all duration-300 ${
          collapsed ? "-translate-x-full lg:translate-x-0 lg:w-20" : "w-64"
        }`}
      >
        {/* Header */}
        <div className="flex h-16 items-center justify-between border-b border-border-light px-4">
          <div className="flex items-center gap-3">
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-indigo-600 overflow-hidden">
              <Image src="/web-logo.png" alt="Anandham" width={36} height={36} className="h-full w-full object-cover" priority />
            </div>
            {!collapsed && (
              <span className="text-lg font-bold text-foreground">Anandham</span>
            )}
          </div>
          <button
            onClick={() => setCollapsed(!collapsed)}
            className="hidden rounded-lg p-1.5 text-muted hover:bg-surface-hover hover:text-foreground lg:block"
          >
            <ChevronLeft
              className={`h-4 w-4 transition-transform ${
                collapsed ? "rotate-180" : ""
              }`}
            />
          </button>
        </div>

        {/* Navigation */}
        <nav className="flex-1 space-y-1 overflow-y-auto px-3 py-4">
          {sidebarEntries.map((entry) => {
            if (isGroup(entry)) {
              const groupActive = isGroupActive(entry);
              const groupOpen = openGroups[entry.label] ?? false;

              if (collapsed) {
                // In collapsed mode show just the group icon linking to its first child
                const firstChild = entry.children[0];
                return (
                  <Link
                    key={entry.label}
                    href={firstChild.href}
                    className={`flex items-center justify-center rounded-lg p-2 transition-colors ${
                      groupActive
                        ? "bg-accent-subtle text-indigo-400 dark:text-indigo-300"
                        : "text-gray-600 hover:bg-surface-hover hover:text-foreground dark:text-gray-400 dark:hover:text-gray-200"
                    }`}
                    title={entry.label}
                  >
                    <entry.icon
                      className={`h-5 w-5 shrink-0 ${
                        groupActive ? "text-indigo-500 dark:text-indigo-400" : "text-gray-400 dark:text-gray-500"
                      }`}
                    />
                  </Link>
                );
              }

              return (
                <div key={entry.label} className="space-y-0.5">
                  <button
                    onClick={() => toggleGroup(entry.label)}
                    className={`flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
                      groupActive
                        ? "text-indigo-400 dark:text-indigo-300"
                        : "text-gray-600 hover:bg-surface-hover hover:text-foreground dark:text-gray-400 dark:hover:text-gray-200"
                    }`}
                  >
                    <entry.icon
                      className={`h-5 w-5 shrink-0 ${
                        groupActive ? "text-indigo-500 dark:text-indigo-400" : "text-gray-400 dark:text-gray-500"
                      }`}
                    />
                    <span className="flex-1 text-left">{entry.label}</span>
                    <ChevronDown
                      className={`h-4 w-4 text-muted transition-transform ${
                        groupOpen ? "rotate-180" : ""
                      }`}
                    />
                  </button>
                  {groupOpen && (
                    <div className="space-y-0.5">
                      {entry.children.map((child) => renderLink(child, true))}
                    </div>
                  )}
                </div>
              );
            }

            return renderLink(entry);
          })}
        </nav>

        {/* Theme Toggle + User / Logout */}
        <div className="border-t border-border-light p-3">
          {/* Theme toggle */}
          <button
            onClick={toggleTheme}
            className="mb-2 flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted transition-colors hover:bg-surface-hover hover:text-foreground"
            title={collapsed ? (theme === "dark" ? "Light mode" : "Dark mode") : undefined}
          >
            {theme === "dark" ? (
              <Sun className="h-5 w-5 shrink-0 text-amber-400" />
            ) : (
              <Moon className="h-5 w-5 shrink-0 text-gray-400" />
            )}
            {!collapsed && <span>{theme === "dark" ? "Light Mode" : "Dark Mode"}</span>}
          </button>

          {!collapsed && user && (
            <div className="mb-2 rounded-lg bg-surface-hover px-3 py-2">
              <p className="truncate text-sm font-medium text-foreground">
                {user.email}
              </p>
              <p className="text-xs text-muted">Administrator</p>
            </div>
          )}
          <button
            onClick={signOut}
            className="flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-muted transition-colors hover:bg-red-500/10 hover:text-red-400"
            title={collapsed ? "Sign out" : undefined}
          >
            <LogOut className="h-5 w-5 shrink-0 text-gray-400 dark:text-gray-500" />
            {!collapsed && <span>Sign out</span>}
          </button>
        </div>
      </aside>
    </>
  );
}
