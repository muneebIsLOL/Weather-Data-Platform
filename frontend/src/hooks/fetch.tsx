import { useState, useEffect } from "react"

function useFetch<T>(endpoint: string) {
    const [data, setData] = useState<T | null>(null)
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<null | string>(null);
    const host = window.__env__?.VITE_HOST_URL;

    useEffect(() => {
        setLoading(true);
        setError(null);

        fetch(`http://${host}:8000/${endpoint}`, {
            headers: { token: "Cubecraft" }
        })
            .then(res => {
                if (!res.ok) {
                    throw new Error("Request Encountered an Error!");
                }
                return res.json();
            })
            .then(data => {
                setData(data);
                setLoading(false);
            })
            .catch(err => {
                setError(err.message);
                setLoading(false);
            });
    }, []);

    return [data, loading, error] as const
}

export default useFetch;