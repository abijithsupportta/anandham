"use client";

import { useEffect } from "react";

export function ThemeInitializer() {
  useEffect(() => {
    // Prevent FOUC (Flash of Unstyled Content)
    const storedTheme = localStorage.getItem("gurusmruthi-theme");
    
    let effectiveTheme: "light" | "dark";
    
    if (storedTheme === "light") {
      effectiveTheme = "light";
    } else if (storedTheme === "dark") {
      effectiveTheme = "dark";
    } else {
      // Default to light
      effectiveTheme = "light";
    }
    
    document.documentElement.classList.remove("light", "dark");
    document.documentElement.classList.add(effectiveTheme);
  }, []);

  return null;
}
