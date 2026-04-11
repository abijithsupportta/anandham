"use client";

import { useTheme } from "@/hooks/useTheme";
import { useState, useEffect } from "react";

export function Header() {
  const { theme, toggleTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <header className="w-full no-select" style={{ height: '56px', backgroundColor: 'var(--color-bg)', borderBottom: '1px solid rgba(201, 168, 76, 0.2)', flexShrink: 0 }}>
      <div className="h-full flex items-center justify-between px-4">
        {/* Left: Logo + Site Name */}
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-full overflow-hidden">
            <img
              src="https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png"
              alt="Gurusmruthi"
              className="w-full h-full object-cover"
            />
          </div>
          <h1 className="font-heading font-semibold" style={{ fontSize: '14px', color: 'var(--color-text)' }}>
            Gurusmruthi
          </h1>
        </div>

        {/* Right: Theme Toggle */}
        <button
          onClick={toggleTheme}
          className="w-9 h-9 flex items-center justify-center rounded-lg active:scale-92 transition-transform duration-100"
          style={{ backgroundColor: 'var(--color-card-bg)' }}
          aria-label="Toggle theme"
        >
          {!mounted ? (
            <div className="w-5 h-5" />
          ) : theme === 'dark' ? (
            <svg className="w-5 h-5" style={{ color: 'var(--color-text)' }} fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
          ) : (
            <svg className="w-5 h-5" style={{ color: 'var(--color-text)' }} fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
            </svg>
          )}
        </button>
      </div>
    </header>
  );
}
