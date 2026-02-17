"use client";

import { useEffect, useState, useRef, useCallback } from "react";
import { usePathname, useSearchParams } from "next/navigation";

/**
 * Slim top progress bar — appears during route transitions.
 * Pure CSS animation, zero dependencies.
 */
export default function NavigationProgress() {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [progress, setProgress] = useState(0);
  const [visible, setVisible] = useState(false);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const prevPath = useRef(pathname + searchParams.toString());

  const start = useCallback(() => {
    setVisible(true);
    setProgress(15);

    // Simulate incremental progress
    let p = 15;
    timerRef.current = setInterval(() => {
      p += Math.random() * 12;
      if (p > 90) p = 90;
      setProgress(p);
    }, 200);
  }, []);

  const done = useCallback(() => {
    if (timerRef.current) clearInterval(timerRef.current);
    setProgress(100);
    setTimeout(() => {
      setVisible(false);
      setProgress(0);
    }, 300);
  }, []);

  useEffect(() => {
    const currentPath = pathname + searchParams.toString();
    if (prevPath.current !== currentPath) {
      // Route changed — complete the bar
      done();
      prevPath.current = currentPath;
    }
  }, [pathname, searchParams, done]);

  // Listen for link clicks to start the bar
  useEffect(() => {
    function handleClick(e: MouseEvent) {
      const anchor = (e.target as HTMLElement).closest("a");
      if (!anchor) return;

      const href = anchor.getAttribute("href");
      if (!href) return;

      // Skip external links, hash links, new tab
      if (
        href.startsWith("http") ||
        href.startsWith("#") ||
        anchor.target === "_blank" ||
        e.ctrlKey ||
        e.metaKey ||
        e.shiftKey
      )
        return;

      const currentPath = pathname + searchParams.toString();
      // Only start if navigating to a different path
      if (href !== currentPath && href !== pathname) {
        start();
      }
    }

    document.addEventListener("click", handleClick, true);
    return () => document.removeEventListener("click", handleClick, true);
  }, [pathname, searchParams, start]);

  if (!visible) return null;

  return (
    <div className="fixed inset-x-0 top-0 z-[9999] h-[3px]">
      <div
        className="h-full bg-indigo-500 shadow-[0_0_10px_rgba(99,102,241,0.7)] transition-all duration-200 ease-out"
        style={{ width: `${progress}%` }}
      />
    </div>
  );
}
