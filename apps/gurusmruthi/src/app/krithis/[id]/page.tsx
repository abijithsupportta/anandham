"use client";

import { krithiService } from "@/services";
import type { Krithi } from "@/types/database";
import Link from "next/link";
import { useState, useEffect } from "react";
import { useParams } from "next/navigation";
import KrithiSchema from "@/components/seo/KrithiSchema";

export default function KrithiDetailPage() {
  const params = useParams();
  const id = params.id as string;
  const [krithi, setKrithi] = useState<Krithi | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showToast, setShowToast] = useState(false);

  useEffect(() => {
    async function loadKrithi() {
      try {
        const result = await krithiService.getById(id);
        
        if (result.error) {
          setError(result.error);
          setLoading(false);
          return;
        }
        
        if (result.data) {
          setKrithi(result.data);
        } else {
          setError("Krithi not found");
        }
      } catch (err) {
        setError("Failed to load krithi");
      }
      setLoading(false);
    }
    loadKrithi();
  }, [id]);

  // Split description into verses
  const verses = krithi?.description
    ? krithi.description.split("\n\n").filter((verse) => verse.trim() !== "")
    : [];

  const handleCopy = () => {
    if (!krithi) return;
    
    let text = `${krithi.title}\n${krithi.category?.name || ''}\n\n`;
    verses.forEach((verse, index) => {
      text += `ശ്ലോകം ${index + 1}\n${verse}\n\n`;
    });
    
    navigator.clipboard.writeText(text);
    setShowToast(true);
    setTimeout(() => setShowToast(false), 2000);
  };

  return (
    <div className="no-select">
      {krithi && <KrithiSchema krithi={krithi} />}
      {/* Sticky Sub-Header */}
      <div className="sticky top-0 z-50" style={{ height: '52px', backgroundColor: 'var(--color-bg)', borderBottom: '1px solid rgba(201, 168, 76, 0.15)' }}>
        <div className="h-full flex items-center justify-between px-4">
          {/* Back Button */}
          <Link
            href="/guru_krithis"
            className="w-11 h-11 flex items-center justify-center active:scale-92 transition-transform duration-100"
            style={{ color: 'var(--color-text)' }}
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </Link>

          {/* Center Title */}
          <div className="flex-1 overflow-hidden px-4">
            <h1 className="font-malayalam font-medium truncate" style={{ fontSize: '15px', color: 'var(--color-text)' }}>
              {krithi?.title || "Loading..."}
            </h1>
          </div>

          {/* Copy Button */}
          <button
            onClick={handleCopy}
            className="w-11 h-11 flex items-center justify-center active:scale-92 transition-transform duration-100"
            style={{ color: '#C9A84C' }}
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2" />
            </svg>
          </button>
        </div>
      </div>

      {loading ? (
        <div className="text-center py-12">
          <div style={{ color: 'var(--color-text)' }}>Loading...</div>
        </div>
      ) : error ? (
        <div className="text-center py-12">
          <div className="text-red-600 dark:text-red-400 mb-4">{error}</div>
        </div>
      ) : !krithi ? (
        <div className="text-center py-12">
          <div style={{ color: 'var(--color-text)', opacity: 0.6 }}>Krithi not found</div>
        </div>
      ) : (
        <div style={{ paddingBottom: 'max(80px, env(safe-area-inset-bottom))' }}>
          {/* Slokas Section */}
          {verses.length > 0 && (
            <div>
              {verses.map((verse, index) => (
                <div key={index}>
                  {index > 0 && (
                    <div style={{ borderTop: '1px solid rgba(201, 168, 76, 0.12)', margin: '0 16px' }} />
                  )}
                  <div style={{ padding: '16px 16px' }}>
                    <div className="font-malayalam select-text" style={{ fontSize: '11px', color: '#C9A84C', letterSpacing: '1px', marginBottom: '10px' }}>
                      ശ്ലോകം {index + 1}
                    </div>
                    <p
                      className="font-malayalam select-text whitespace-pre-line"
                      style={{
                        color: 'var(--color-text)',
                        fontSize: '17px',
                        lineHeight: 2.2
                      }}
                    >
                      {verse}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          )}

          {verses.length === 0 && (
            <div className="text-center py-12 px-5">
              <div className="font-malayalam text-lg" style={{ color: 'var(--color-text)', opacity: 0.6 }}>
                ശ്ലോകങ്ങളൊന്നുമില്ല
              </div>
            </div>
          )}

          {/* YouTube Section */}
          {krithi.youtube_url && (
            <div style={{ borderTop: '1px solid rgba(201, 168, 76, 0.15)', padding: '20px 16px' }}>
              <a
                href={krithi.youtube_url}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2"
                style={{ color: 'var(--color-text)' }}
              >
                <svg className="w-5 h-5" style={{ color: '#FF0000' }} viewBox="0 0 24 24" fill="currentColor">
                  <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                </svg>
                <span className="font-malayalam text-sm">YouTube-ൽ കേൾക്കുക</span>
              </a>
            </div>
          )}
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

      {/* Toast Notification */}
      {showToast && (
        <div
          className="fixed left-1/2 transform -translate-x-1/2 rounded-full"
          style={{
            bottom: '24px',
            backgroundColor: '#C9A84C',
            color: '#000',
            padding: '10px 24px',
            fontSize: '14px',
            animation: 'fadeInOut 2s ease-in-out forwards'
          }}
        >
          പകർത്തി
        </div>
      )}

      <style jsx>{`
        @keyframes fadeInOut {
          0% { opacity: 0; transform: translate(-50%, 10px); }
          10% { opacity: 1; transform: translate(-50%, 0); }
          90% { opacity: 1; transform: translate(-50%, 0); }
          100% { opacity: 0; transform: translate(-50%, -10px); }
        }
      `}</style>
    </div>
  );
}
