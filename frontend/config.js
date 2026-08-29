export const API_URL = 
  (typeof window !== 'undefined' && window.__env__?.VITE_API_URL) || 
  import.meta.env.VITE_API_URL || 
  'localhost';