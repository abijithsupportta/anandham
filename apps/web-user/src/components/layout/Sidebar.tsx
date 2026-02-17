"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

interface SidebarProps {
  isOpen?: boolean;
  onClose?: () => void;
}

export default function Sidebar({ isOpen = true, onClose }: SidebarProps) {
  const pathname = usePathname();

  const menuItems = [
    { href: "/", label: "Home", icon: "🏠" },
    { href: "/library", label: "My Library", icon: "📚" },
    { href: "/favorites", label: "Favorites", icon: "❤️" },
    { href: "/history", label: "History", icon: "🕐" },
    { href: "/settings", label: "Settings", icon: "⚙️" },
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
          fixed left-0 top-16 z-40 h-[calc(100vh-4rem)] w-64 transform border-r
          border-orange-100 bg-white transition-transform duration-200 ease-in-out
          ${isOpen ? "translate-x-0" : "-translate-x-full"}
          md:translate-x-0
        `}
      >
        <nav className="flex flex-col gap-1 p-4">
          {menuItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                onClick={onClose}
                className={`
                  flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium
                  transition-colors
                  ${
                    isActive
                      ? "bg-orange-100 text-orange-700"
                      : "text-gray-600 hover:bg-orange-50 hover:text-orange-600"
                  }
                `}
              >
                <span>{item.icon}</span>
                <span>{item.label}</span>
              </Link>
            );
          })}
        </nav>
      </aside>
    </>
  );
}
