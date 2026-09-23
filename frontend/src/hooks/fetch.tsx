import { useState, useEffect } from "react"

function useFetch<T>(endpoint: string) {
    const [data, setData] = useState<T | null>(null)
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<null | string>(null);
    const host = window.__env__?.VITE_HOST_URL || "localhost";
    const api_token = window.__env__?.API_TOKEN || "MySecureToken!"

    useEffect(() => {
        setLoading(true);
        setError(null);
        const url = `http://${host}:8000/${endpoint}`

        fetch(url, {
            headers: { token: api_token}
        })
            .then(res => {
                if (res.ok) {
                    return res.json();
                }
                return res.json().then(errorMessage => {
                    if (!errorMessage.detail) {
                        throw new Error(`Failed to establish a connection to the API server at ${url}`)
                    }
                    const error = new Error(errorMessage.detail);
                    throw error;
                });

            })
            .then(data => {
                setData(data);
                setLoading(false);
            })
            .catch(err => {
                const isNetworkError = err.message === "Failed to fetch" || err.message.includes("NetworkError");
                
                const finalMessage = isNetworkError 
                    ? `Failed to establish a connection to the API server at ${url}` 
                    : (err.message || `Failed to establish a connection to the API server at ${url}`);
                
                setError(finalMessage);
                setLoading(false);
            });
    }, []);

    return [data, loading, error] as const
}

export default useFetch;