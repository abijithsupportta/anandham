"use client";

import { krithiService } from "@/services";
import type { Krithi } from "@/types/database";
import Link from "next/link";
import { useState, useEffect } from "react";

export default function KrithisPage() {
  const [krithis, setKrithis] = useState<Krithi[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [searchExpanded, setSearchExpanded] = useState(false);

  useEffect(() => {
    async function loadKrithis() {
      const result = await krithiService.getAll();
      console.log("Krithis service result:", result);
      if (result.data) {
        const publishedKrithis = result.data.filter((k) => k.status === "published");
        console.log("Published krithis count:", publishedKrithis.length);
        console.log("Published krithis:", publishedKrithis);
        console.log("Krithis with slugs:", publishedKrithis.map(k => ({ 
          id: k.id, 
          title: k.title, 
          slug: k.slug, 
          slug_encoded: encodeURIComponent(k.slug),
          description: k.description?.substring(0, 50) + "..." 
        })));
        setKrithis(publishedKrithis);
      }
      setLoading(false);
    }
    loadKrithis();
  }, []);

  const filteredKrithis = krithis.filter((krithi) =>
    krithi.title.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const groupedKrithis = filteredKrithis.reduce((acc, krithi) => {
    const categoryName = krithi.category?.name || "Uncategorized";
    if (!acc[categoryName]) {
      acc[categoryName] = [];
    }
    acc[categoryName].push(krithi);
    return acc;
  }, {} as Record<string, Krithi[]>);

  return (
    <div className="no-select">
      {/* Sticky Sub-Header */}
      <div className="sticky top-0 z-50" style={{ height: '52px', backgroundColor: 'var(--color-bg)', borderBottom: '1px solid rgba(201, 168, 76, 0.15)' }}>
        <div className="h-full flex items-center justify-between px-4">
          {/* Back Button */}
          <Link
            href="/"
            className="w-11 h-11 flex items-center justify-center active:scale-92 transition-transform duration-100"
            style={{ color: 'var(--color-text)' }}
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </Link>

          {/* Center Title */}
          <div className="flex-1 text-center">
            <div className="font-malayalam font-semibold" style={{ fontSize: '16px', color: 'var(--color-text)' }}>
              ഗുരുദേവകൃതികൾ
            </div>
            {!loading && filteredKrithis.length > 0 && (
              <div className="text-xs" style={{ color: 'var(--color-text)', opacity: 0.6 }}>
                {filteredKrithis.length}
              </div>
            )}
          </div>

          {/* Search Button */}
          <button
            onClick={() => setSearchExpanded(!searchExpanded)}
            className="w-11 h-11 flex items-center justify-center active:scale-92 transition-transform duration-100"
            style={{ color: 'var(--color-text)' }}
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </button>
        </div>
      </div>

      {/* Search Bar */}
      <div
        className="overflow-hidden transition-all duration-200 ease"
        style={{ maxHeight: searchExpanded ? '52px' : '0px' }}
      >
        <input
          type="text"
          placeholder="തിരയുക..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full px-4 py-3 font-malayalam outline-none"
          style={{
            fontSize: '16px',
            backgroundColor: 'transparent',
            borderBottom: '1px solid rgba(201, 168, 76, 0.3)',
            color: 'var(--color-text)'
          }}
        />
      </div>

      {/* Loading State */}
      {loading && (
        <div className="space-y-0">
          {[...Array(8)].map((_, i) => (
            <div
              key={i}
              className="flex items-center"
              style={{ height: '56px', padding: '0 16px', borderBottom: '1px solid rgba(201, 168, 76, 0.12)' }}
            >
              <div className="min-w-[28px] text-xs font-malayalam" style={{ opacity: 0.4, color: 'var(--color-text)' }}>
                {(i + 1).toString().padStart(2, '0')}
              </div>
              <div
                className="h-4 rounded animate-pulse"
                style={{
                  width: `${40 + Math.random() * 35}%`,
                  backgroundColor: 'rgba(201, 168, 76, 0.1)'
                }}
              />
            </div>
          ))}
        </div>
      )}

      {/* Empty State */}
      {!loading && filteredKrithis.length === 0 && (
        <div className="text-center py-12">
          <div className="font-malayalam text-lg" style={{ color: 'var(--color-text)', opacity: 0.6 }}>
            ഒന്നും കണ്ടെത്തിയില്ല
          </div>
        </div>
      )}

      {/* Krithi List */}
      {!loading && filteredKrithis.length > 0 && (
        <div style={{ paddingBottom: 'max(80px, env(safe-area-inset-bottom))' }}>
          {Object.entries(groupedKrithis).map(([categoryName, categoryKrithis]) => (
            <div key={categoryName}>
              {categoryName !== "Uncategorized" && (
                <div
                  className="font-malayalam uppercase"
                  style={{
                    fontSize: '11px',
                    letterSpacing: '2px',
                    color: '#C9A84C',
                    padding: '20px 16px 6px',
                    backgroundColor: 'rgba(201, 168, 76, 0.03)'
                  }}
                >
                  {categoryName}
                </div>
              )}
              {categoryKrithis.map((krithi, index) => (
                <Link
                  key={krithi.id}
                  href={`/krithis/${krithi.id}`}
                  className="flex items-center active:bg-[rgba(201,168,76,0.06)] transition-colors duration-100"
                  style={{
                    height: '56px',
                    padding: '0 16px',
                    borderBottom: '1px solid rgba(201, 168, 76, 0.12)'
                  }}
                >
                  <div className="min-w-[28px] text-xs font-malayalam" style={{ opacity: 0.4, color: 'var(--color-text)' }}>
                    {(index + 1).toString().padStart(2, '0')}
                  </div>
                  <div className="flex-1 font-malayalam" style={{ fontSize: '16px', fontWeight: 500, color: 'var(--color-text)' }}>
                    {krithi.title}
                  </div>
                  <svg
                    className="w-4 h-4"
                    style={{ color: '#C9A84C', opacity: 0.4 }}
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                  </svg>
                </Link>
              ))}
            </div>
          ))}
        </div>
      )}

      {/* Developed by */}
      <div className="text-center py-8">
        <a
          href="https://abijithcb.com"
          target="_blank"
          rel="noopener noreferrer"
          className="inline-block px-4 py-2 rounded-lg transition-colors"
          style={{
            backgroundColor: 'var(--color-card-bg)',
            border: '1px solid var(--color-border)',
            color: 'var(--color-text)',
            fontSize: '12px'
          }}
        >
          Developed by abijithcb.com
        </a>
      </div>
    </div>
  );
}
