"use client";

import { useTheme } from "@/hooks/useTheme";

export function Header() {
  const { theme, toggleTheme } = useTheme();

  return (
    <header className="sticky top-0 z-50 w-full" style={{ backgroundColor: 'var(--color-bg)' }}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div className="flex items-center justify-between">
          {/* Left: Logo + Site Name */}
          <div className="flex items-center gap-3">
            <img
              src="https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png"
              alt="Gurusmruthi"
              className="w-10 h-10 sm:w-12 sm:h-12 rounded-full object-contain"
            />
            <h1 className="font-heading text-xl sm:text-2xl font-bold" style={{ color: 'var(--color-text)' }}>
              Gurusmruthi
            </h1>
          </div>

          {/* Center: Malayalam subtitle */}
          <div className="hidden md:block">
            <p className="font-malayalam text-sm" style={{ color: 'var(--color-text)', opacity: 0.7 }}>
              ശ്രീ നാരായണ ഗുരുദേവകൃതികൾ
            </p>
          </div>

          {/* Right: Theme Toggle */}
          <button
            onClick={toggleTheme}
            className="p-2 rounded-full transition-colors"
            style={{ backgroundColor: 'var(--color-card-bg)' }}
            aria-label="Toggle theme"
          >
            {theme === 'dark' ? (
              <svg className="w-6 h-6" style={{ color: 'var(--color-text)' }} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            ) : (
              <svg className="w-6 h-6" style={{ color: 'var(--color-text)' }} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
              </svg>
            )}
          </button>
        </div>

        {/* Bottom border with gold accent */}
        <div className="mt-4 h-px" style={{ backgroundColor: 'var(--color-gold)', opacity: 0.3 }} />
      </div>
    </header>
  );
}
