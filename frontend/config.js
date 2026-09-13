export const API_URL =
    window.__env__?.VITE_HOST_URL ||
    import.meta.env.VITE_HOST_URL ||
    "localhost";