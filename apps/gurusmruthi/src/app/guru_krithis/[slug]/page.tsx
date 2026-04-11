"use client";

import { krithiService } from "@/services";
import type { Krithi, Sloka } from "@/types/database";
import Link from "next/link";
import { useState, useEffect } from "react";
import { useParams } from "next/navigation";

export default function KrithiDetailPage() {
  const params = useParams();
  const slug = params.slug as string;
  const [krithi, setKrithi] = useState<Krithi | null>(null);
  const [slokas, setSlokas] = useState<Sloka[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadKrithi() {
      try {
        console.log("Loading krithi with slug:", slug);
        
        const result = await krithiService.getBySlug(slug);
        console.log("Krithi service result:", result);
        
        if (result.error) {
          console.error("Error loading krithi:", result.error);
          setError(`Service error: ${result.error}`);
          setLoading(false);
          return;
        }
        
        if (result.data) {
          console.log("Krithi data found:", result.data);
          // Validate krithi data structure
          if (!result.data.id) {
            setError("Invalid krithi data: missing id");
            setLoading(false);
            return;
          }
          
          setKrithi(result.data);
          
          // Load slokas for this krithi
          try {
            const slokasResult = await krithiService.getSlokas(result.data.id);
            console.log("Slokas result:", slokasResult);
            
            if (slokasResult.error) {
              console.error("Error loading slokas:", slokasResult.error);
              // Don't fail the whole page if slokas fail to load
            }
            
            if (slokasResult.data) {
              setSlokas(slokasResult.data);
            }
          } catch (slokaErr) {
            console.error("Unexpected error loading slokas:", slokaErr);
            // Don't fail the whole page if slokas fail to load
          }
        } else {
          setError("Krithi not found");
        }
      } catch (err) {
        console.error("Unexpected error:", err);
        setError(`Unexpected error: ${err instanceof Error ? err.message : 'Unknown error'}`);
      }
      setLoading(false);
    }
    loadKrithi();
  }, [slug]);

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-12">
      {/* Back Button */}
      <Link
        href="/guru_krithis"
        className="inline-flex items-center gap-2 text-sm text-blue-600 dark:text-blue-400 hover:underline mb-6"
      >
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
        </svg>
        Back to Krithis
      </Link>

      {loading ? (
        <div className="text-center py-12">
          <div className="text-black dark:text-white">Loading krithi...</div>
        </div>
      ) : error ? (
        <div className="text-center py-12">
          <div className="text-red-600 dark:text-red-400 mb-4">{error}</div>
          <div className="text-gray-700 dark:text-gray-300 text-sm mb-2">Slug: {slug}</div>
          <div className="text-gray-600 dark:text-gray-400 text-xs">
            Check browser console for detailed error logs
          </div>
        </div>
      ) : !krithi ? (
        <div className="text-center py-12">
          <div className="text-gray-700 dark:text-gray-300">Krithi not found</div>
        </div>
      ) : (
        <div className="space-y-8">
          {/* Krithi Header */}
          <div className="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-2xl p-6 sm:p-8">
            <div className="flex items-start justify-between mb-4">
              <div className="text-5xl sm:text-6xl mb-4">📜</div>
              {krithi.category && (
                <span className="inline-block px-3 py-1 text-xs sm:text-sm bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-200 rounded-full">
                  {krithi.category.name}
                </span>
              )}
            </div>
            <h1 className="text-2xl sm:text-4xl font-bold text-black dark:text-white mb-4">
              {krithi.title}
            </h1>
            <p className="text-sm sm:text-base text-gray-700 dark:text-gray-300 mb-4">
              {krithi.description}
            </p>
            {krithi.author && (
              <div className="flex items-center gap-2 text-xs sm:text-sm text-gray-600 dark:text-gray-400">
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
                <span>By {krithi.author.name}</span>
              </div>
            )}
            {krithi.youtube_url && (
              <a
                href={krithi.youtube_url}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 mt-4 px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors"
              >
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                </svg>
                <span className="text-sm font-medium">Watch on YouTube</span>
              </a>
            )}
          </div>

          {/* Slokas Section */}
          {slokas.length > 0 && (
            <div className="space-y-4">
              <h2 className="text-xl sm:text-2xl font-bold text-black dark:text-white mb-4">
                Slokas ({slokas.length})
              </h2>
              {slokas.map((sloka) => (
                <div
                  key={sloka.id}
                  className="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl p-4 sm:p-6 hover:border-blue-600 dark:hover:border-amber-200 transition-colors"
                >
                  <div className="flex items-start gap-3 mb-4">
                    <div className="flex-shrink-0 w-8 h-8 sm:w-10 sm:h-10 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-200 font-bold text-sm sm:text-base">
                      {sloka.sloka_number}
                    </div>
                    <div className="flex-1">
                      <h3 className="text-base sm:text-lg font-semibold text-black dark:text-white mb-2">
                        Sloka {sloka.sloka_number}
                      </h3>
                    </div>
                  </div>

                  {/* Original Text */}
                  <div className="mb-4">
                    <div className="flex items-center justify-between mb-2">
                      <h4 className="text-xs sm:text-sm font-semibold text-gray-700 dark:text-gray-300">
                        Original Text
                      </h4>
                      <button
                        onClick={() => copyToClipboard(sloka.original_text)}
                        className="p-1.5 rounded-md bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                        title="Copy text"
                      >
                        <svg className="w-4 h-4 text-gray-700 dark:text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                        </svg>
                      </button>
                    </div>
                    <p className="text-sm sm:text-base text-gray-900 dark:text-gray-100 leading-relaxed font-medium whitespace-pre-line">
                      {sloka.original_text}
                    </p>
                  </div>

                  {/* Transliteration */}
                  {sloka.transliteration && (
                    <div className="mb-4">
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="text-xs sm:text-sm font-semibold text-gray-700 dark:text-gray-300">
                          Transliteration
                        </h4>
                        <button
                          onClick={() => copyToClipboard(sloka.transliteration)}
                          className="p-1.5 rounded-md bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                          title="Copy transliteration"
                        >
                          <svg className="w-4 h-4 text-gray-700 dark:text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                          </svg>
                        </button>
                      </div>
                      <p className="text-sm sm:text-base text-gray-900 dark:text-gray-100 leading-relaxed italic whitespace-pre-line">
                        {sloka.transliteration}
                      </p>
                    </div>
                  )}

                  {/* Translation */}
                  {sloka.translation && (
                    <div className="mb-4">
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="text-xs sm:text-sm font-semibold text-gray-700 dark:text-gray-300">
                          Translation
                        </h4>
                        <button
                          onClick={() => copyToClipboard(sloka.translation)}
                          className="p-1.5 rounded-md bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                          title="Copy translation"
                        >
                          <svg className="w-4 h-4 text-gray-700 dark:text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                          </svg>
                        </button>
                      </div>
                      <p className="text-sm sm:text-base text-gray-900 dark:text-gray-100 leading-relaxed whitespace-pre-line">
                        {sloka.translation}
                      </p>
                    </div>
                  )}

                  {/* Explanation */}
                  {sloka.explanation && (
                    <div>
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="text-xs sm:text-sm font-semibold text-gray-700 dark:text-gray-300">
                          Explanation
                        </h4>
                        <button
                          onClick={() => copyToClipboard(sloka.explanation)}
                          className="p-1.5 rounded-md bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                          title="Copy explanation"
                        >
                          <svg className="w-4 h-4 text-gray-700 dark:text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                          </svg>
                        </button>
                      </div>
                      <p className="text-sm sm:text-base text-gray-900 dark:text-gray-100 leading-relaxed whitespace-pre-line">
                        {sloka.explanation}
                      </p>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}

          {slokas.length === 0 && (
            <div className="text-center py-12 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl">
              <div className="text-gray-700 dark:text-gray-300">No slokas available for this krithi</div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
