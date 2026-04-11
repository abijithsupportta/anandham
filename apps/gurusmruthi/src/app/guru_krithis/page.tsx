"use client";

import { krithiService } from "@/services";
import type { Krithi } from "@/types/database";
import Link from "next/link";
import { useState, useEffect } from "react";

export default function KrithisPage() {
  const [krithis, setKrithis] = useState<Krithi[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadKrithis() {
      const result = await krithiService.getAll();
      if (result.data) {
        setKrithis(result.data.filter((k) => k.status === "published"));
      }
      setLoading(false);
    }
    loadKrithis();
  }, []);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-12">
      <h1 className="text-2xl sm:text-3xl font-bold text-black dark:text-white mb-6 sm:mb-8">
        ശ്രീ നാരായണ ഗുരുദേവകൃതികൾ
      </h1>
      <p className="text-sm sm:text-base text-gray-700 dark:text-gray-300 mb-8">
        Sacred musical compositions and verses by Sree Narayana Guru
      </p>

      {loading ? (
        <div className="text-center py-12">
          <div className="text-black dark:text-white">Loading krithis...</div>
        </div>
      ) : krithis.length === 0 ? (
        <div className="text-center py-12">
          <div className="text-gray-700 dark:text-gray-300">No krithis found</div>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {krithis.map((krithi) => (
            <Link
              key={krithi.id}
              href={`/guru_krithis/${krithi.slug}`}
              className="group"
            >
              <div className="relative overflow-hidden rounded-2xl p-4 sm:p-6 transition-all duration-300 hover:scale-105 hover:shadow-xl cursor-pointer bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 hover:border-blue-600 dark:hover:border-amber-200">
                <div className="text-4xl sm:text-5xl mb-3 sm:mb-4 group-hover:scale-110 transition-transform">
                  📜
                </div>
                <h3 className="text-lg sm:text-xl font-bold text-black dark:text-white mb-2">
                  {krithi.title}
                </h3>
                <p className="text-xs sm:text-sm text-gray-700 dark:text-gray-300 line-clamp-2 mb-3">
                  {krithi.description}
                </p>
                {krithi.category && (
                  <span className="inline-block px-2 py-1 text-xs bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-200 rounded-full">
                    {krithi.category.name}
                  </span>
                )}
                <div className="absolute bottom-3 sm:bottom-4 right-3 sm:right-4 opacity-0 group-hover:opacity-100 transition-opacity">
                  <svg className="w-5 h-5 sm:w-6 sm:h-6 text-blue-600 dark:text-amber-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                  </svg>
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
