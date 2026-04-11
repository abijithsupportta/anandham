"use client";

import { useEffect } from "react";
import { themeConfig } from "@/config/theme.config";

export function ThemeScript() {
  useEffect(() => {
    // Prevent FOUC (Flash of Unstyled Content)
    const storedTheme = localStorage.getItem(themeConfig.storageKey);
    
    let effectiveTheme: "light" | "dark";
    
    if (storedTheme === "light") {
      effectiveTheme = "light";
    } else if (storedTheme === "dark") {
      effectiveTheme = "dark";
    } else {
      // Use default theme (light)
      effectiveTheme = "light";
    }
    
    document.documentElement.classList.remove("light", "dark");
    document.documentElement.classList.add(effectiveTheme);
  }, []);

  return null;
}
