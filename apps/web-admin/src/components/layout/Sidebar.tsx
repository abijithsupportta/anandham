"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  PenTool,
  BookOpen,
  FolderTree,
  Image,
  Settings,
  LogOut,
  Shield,
  ChevronLeft,
  ChevronDown,
  Menu,
  ScrollText,
  Users,
  Layers,
} from "lucide-react";
import { useState } from "react";
import { useAuth } from "@/components/providers/auth-provider";

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
      { name: "Guru Dharmas", href: "/dharmas", icon: ScrollText },
      { name: "Guru Photos", href: "/guru-photos", icon: Image },
      { name: "Categories", href: "/categories", icon: FolderTree },
    ],
  },
  { name: "User Management", href: "/users", icon: Users },
  { name: "Authors", href: "/authors", icon: PenTool },
  { name: "Settings", href: "/settings", icon: Settings },
];

export default function Sidebar() {
  const pathname = usePathname();
  const { user, signOut } = useAuth();
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
            ? "bg-indigo-50 text-indigo-700"
            : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
        }`}
        title={collapsed ? item.name : undefined}
      >
        <item.icon
          className={`h-5 w-5 shrink-0 ${
            active ? "text-indigo-600" : "text-gray-400"
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
        className="fixed left-4 top-4 z-50 rounded-lg border border-gray-200 bg-white p-2 shadow-sm lg:hidden"
      >
        <Menu className="h-5 w-5 text-gray-600" />
      </button>

      {/* Overlay for mobile */}
      {!collapsed && (
        <div
          className="fixed inset-0 z-30 bg-black/20 lg:hidden"
          onClick={() => setCollapsed(true)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed inset-y-0 left-0 z-40 flex flex-col border-r border-gray-200 bg-white transition-all duration-300 ${
          collapsed ? "-translate-x-full lg:translate-x-0 lg:w-20" : "w-64"
        }`}
      >
        {/* Header */}
        <div className="flex h-16 items-center justify-between border-b border-gray-100 px-4">
          <div className="flex items-center gap-3">
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-indigo-600">
              <Shield className="h-5 w-5 text-white" />
            </div>
            {!collapsed && (
              <span className="text-lg font-bold text-gray-900">AMA</span>
            )}
          </div>
          <button
            onClick={() => setCollapsed(!collapsed)}
            className="hidden rounded-lg p-1.5 text-gray-400 hover:bg-gray-100 hover:text-gray-600 lg:block"
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

              // When sidebar is collapsed, just show the icon
              if (collapsed) {
                return (
                  <div key={entry.label} className="space-y-1">
                    {entry.children.map((child) => renderLink(child))}
                  </div>
                );
              }

              return (
                <div key={entry.label} className="space-y-0.5">
                  <button
                    onClick={() => toggleGroup(entry.label)}
                    className={`flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
                      groupActive
                        ? "text-indigo-700"
                        : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
                    }`}
                  >
                    <entry.icon
                      className={`h-5 w-5 shrink-0 ${
                        groupActive ? "text-indigo-600" : "text-gray-400"
                      }`}
                    />
                    <span className="flex-1 text-left">{entry.label}</span>
                    <ChevronDown
                      className={`h-4 w-4 text-gray-400 transition-transform ${
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

        {/* User / Logout */}
        <div className="border-t border-gray-100 p-3">
          {!collapsed && user && (
            <div className="mb-2 rounded-lg bg-gray-50 px-3 py-2">
              <p className="truncate text-sm font-medium text-gray-900">
                {user.email}
              </p>
              <p className="text-xs text-gray-500">Administrator</p>
            </div>
          )}
          <button
            onClick={signOut}
            className="flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-gray-600 transition-colors hover:bg-red-50 hover:text-red-700"
            title={collapsed ? "Sign out" : undefined}
          >
            <LogOut className="h-5 w-5 shrink-0 text-gray-400" />
            {!collapsed && <span>Sign out</span>}
          </button>
        </div>
      </aside>
    </>
  );
}
