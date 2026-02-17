"use client";

import { useEffect } from "react";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Application error:", error);
  }, [error]);

  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-slate-50 px-4">
      <div className="max-w-md text-center">
        <h1 className="mb-4 text-6xl font-bold text-indigo-600">Error</h1>
        <h2 className="mb-2 text-2xl font-semibold text-gray-800">
          Something went wrong
        </h2>
        <p className="mb-8 text-gray-600">
          An unexpected error occurred. Please try again or contact support.
        </p>
        <button
          onClick={reset}
          className="rounded-lg bg-indigo-600 px-6 py-3 font-medium text-white transition-colors hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
        >
          Try Again
        </button>
      </div>
    </div>
  );
}
