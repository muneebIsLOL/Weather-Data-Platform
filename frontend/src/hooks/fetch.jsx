import { useState, useEffect } from "react"

function useFetch(endpoint) {
    const [data, setData] = useState(null)
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(false);

    useEffect(() => {
        setLoading(true);
        setError(null);

        fetch(`http://192.168.1.37:8000/${endpoint}`, {
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