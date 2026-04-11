"use client";

import { useState } from "react";

const PLAY_STORE_URL = "https://play.google.com/store/apps/details?id=com.anandham.anandham_user&pcampaignid=web_share";

export default function AppDownloadButton() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      {/* Floating Download Button */}
      <button
        onClick={() => setIsOpen(true)}
        className="fixed bottom-6 right-6 z-50 flex items-center gap-2 px-4 py-3 rounded-full shadow-lg transition-all duration-300 hover:scale-105 active:scale-95"
        style={{
          backgroundColor: "#C9A84C",
          color: "#2C1810",
          fontFamily: "var(--font-malayalam)",
        }}
      >
        <svg
          className="w-5 h-5"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
          strokeWidth={2}
        >
          <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
        </svg>
        <span className="font-medium text-sm">Download App</span>
      </button>

      {/* Modal/Popup */}
      {isOpen && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4"
          style={{ backgroundColor: "rgba(0, 0, 0, 0.5)" }}
          onClick={() => setIsOpen(false)}
        >
          <div
            className="max-w-sm w-full p-6 rounded-2xl shadow-2xl"
            style={{
              backgroundColor: "var(--color-bg)",
              border: "1px solid var(--color-border)",
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="text-center">
              <div
                className="w-16 h-16 mx-auto mb-4 rounded-full flex items-center justify-center"
                style={{ backgroundColor: "#C9A84C" }}
              >
                <svg
                  className="w-8 h-8"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                  strokeWidth={2}
                  style={{ color: "#2C1810" }}
                >
                  <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                </svg>
              </div>
              <h3
                className="text-xl font-bold mb-2"
                style={{ color: "var(--color-text)" }}
              >
                Download Anandham App
              </h3>
              <p
                className="text-sm mb-6"
                style={{ color: "var(--color-text-muted)" }}
              >
                Digital research center for Sree Narayana Guru studies
              </p>
              <a
                href={PLAY_STORE_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center justify-center gap-2 w-full px-6 py-3 rounded-full font-medium transition-all duration-300 hover:scale-105 active:scale-95"
                style={{
                  backgroundColor: "#C9A84C",
                  color: "#2C1810",
                }}
              >
                <svg
                  className="w-5 h-5"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.5,12.92 20.16,13.19L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z" />
                </svg>
                Get it on Google Play
              </a>
              <button
                onClick={() => setIsOpen(false)}
                className="mt-4 text-sm transition-colors hover:opacity-70"
                style={{ color: "var(--color-text-muted)" }}
              >
                Maybe later
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
