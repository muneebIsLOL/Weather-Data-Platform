import { useState, useEffect } from "react"

function useFetch(endpoint) {
    const [data, setData] = useState(null)
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(false);
    const host = import.meta.env.VITE_HOST_URL;

    useEffect(() => {
        setLoading(true);
        setError(null);

        fetch(`http://${host}:8000/${endpoint}`, {
            headers: { token: "Cubecraft" }
        })
            .then(res => {
                if (!res.ok) {
                    throw new Error("API limit reached or request failed");
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

    return [data, loading, error]
}

export default useFetch;