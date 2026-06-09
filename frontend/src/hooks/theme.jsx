import { useEffect, useState } from "react";

export function useTheme() {
  const [themeMode, setThemeMode] = useState(() => {
    return localStorage.getItem("theme-mode") || "system";
  });

  const [activeTheme, setActiveTheme] = useState("dark");

  useEffect(() => {
    const root = document.documentElement;

    const determineActiveTheme = (mode) => {
      if (mode === "system") {
        return window.matchMedia("(prefers-color-scheme: light)").matches ? "light" : "dark";
      }
      return mode;
    };

    const currentTheme = determineActiveTheme(themeMode);
    setActiveTheme(currentTheme);

    if (currentTheme === "light") {
      root.setAttribute("theme", "light");
    } else {
      root.removeAttribute("theme"); 
    }

    localStorage.setItem("theme-mode", themeMode);
  }, [themeMode]);

  useEffect(() => {
    if (themeMode !== "system") return;

    const mediaQuery = window.matchMedia("(prefers-color-scheme: light)");
    
    const handleSystemChange = (e) => {
      const root = document.documentElement;
      const newTheme = e.matches ? "light" : "dark";
      setActiveTheme(newTheme);
      
      if (newTheme === "light") {
        root.setAttribute("theme", "light");
      } else {
        root.removeAttribute("theme");
      }
    };

    mediaQuery.addEventListener("change", handleSystemChange);
    return () => mediaQuery.removeEventListener("change", handleSystemChange);
  }, [themeMode]);

  return { themeMode, setThemeMode, activeTheme };
}
