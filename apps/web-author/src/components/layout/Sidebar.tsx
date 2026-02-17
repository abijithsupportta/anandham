"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

interface SidebarProps {
  isOpen?: boolean;
  onClose?: () => void;
}

export default function Sidebar({ isOpen = true, onClose }: SidebarProps) {
  const pathname = usePathname();

  const menuSections = [
    {
      title: "Content",
      items: [
        { href: "/", label: "Dashboard", icon: "📊" },
        { href: "/content", label: "My Content", icon: "📝" },
        { href: "/drafts", label: "Drafts", icon: "📄" },
        { href: "/published", label: "Published", icon: "✅" },
      ],
    },
    {
      title: "Tools",
      items: [
        { href: "/editor", label: "Editor", icon: "✏️" },
        { href: "/media", label: "Media Library", icon: "🖼️" },
        { href: "/analytics", label: "Analytics", icon: "📈" },
      ],
    },
    {
      title: "Account",
      items: [
        { href: "/profile", label: "Profile", icon: "👤" },
        { href: "/settings", label: "Settings", icon: "⚙️" },
      ],
    },
  ];

  return (
    <>
      {/* Overlay for mobile */}
      {isOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/50 md:hidden"
          onClick={onClose}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`
          fixed left-0 top-16 z-40 h-[calc(100vh-4rem)] w-64 transform
          overflow-y-auto border-r border-slate-200 bg-white transition-transform
          duration-200 ease-in-out
          ${isOpen ? "translate-x-0" : "-translate-x-full"}
          md:translate-x-0
        `}
      >
        <div className="flex flex-col gap-6 p-4">
          {menuSections.map((section) => (
            <div key={section.title}>
              <h3 className="mb-2 px-3 text-xs font-semibold uppercase tracking-wider text-slate-400">
                {section.title}
              </h3>
              <nav className="flex flex-col gap-1">
                {section.items.map((item) => {
                  const isActive = pathname === item.href;
                  return (
                    <Link
                      key={item.href}
                      href={item.href}
                      onClick={onClose}
                      className={`
                        flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium
                        transition-colors
                        ${
                          isActive
                            ? "bg-indigo-50 text-indigo-700"
                            : "text-slate-600 hover:bg-slate-50 hover:text-indigo-600"
                        }
                      `}
                    >
                      <span>{item.icon}</span>
                      <span>{item.label}</span>
                    </Link>
                  );
                })}
              </nav>
            </div>
          ))}
        </div>
      </aside>
    </>
  );
}
