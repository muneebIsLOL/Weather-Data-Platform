import "./index.css"
import "./App.css"
import Navbar from "./components/navbar/Navbar"
import Card from "./components/card/Card"
import Settings from "./components/settings/Settings"
import { useEffect, useState } from "react"
import useFetch from "./hooks/fetch"
import formatters from "./utils/formatters"

const backgrounds = {
    desktop: {
        day: {
            clear_sky: "/backgrounds/desktop/day/clear-sky.jpg",
            cloudy: "/backgrounds/desktop/day/cloudy.jpeg",
            thunderstorm: "/backgrounds/shared/day/thunderstorm.jpg"
        },

        night: {
            clear_sky: "/backgrounds/desktop/night/clear-sky.png"
        }
    },

    mobile: {
        day: {
            clear_sky: "/backgrounds/mobile/day/clear-sky.jpg",
            cloudy: "/backgrounds/mobile/day/cloudy.jpeg",
            thunderstorm: "/backgrounds/shared/day/thunderstorm.jpg"
        },

        night: {
            clear_sky: "/backgrounds/mobile/night/clear-sky.jpg"
        }
    }
}

const CurrentTemp = ({ data, error, loading, unit }) => {
    const temp = data?.temperature
    return (
        <>
            {loading && <p>Loading...</p>}

            {error && <p>{error}</p>}

            {!loading && !error && data && (
                <h1 className="temperature">
                    {formatters.temperature(Math.round(temp), unit)}°
                </h1>
            )}
        </>
    );
}

const App = () => {
    const [openStatus, setOpenStatus] = useState(false)
    const [unit, setUnits] = useState("metric");
    const [data, loading, error] = useFetch("current_weather")


    useEffect(() => {
        const updateBackground = () => {
            const isDay = data?.is_day;
            const weatherType = data?.feels_like?.replaceAll(" ", "_")?.toLowerCase();

            const device =
                window.innerWidth <= 768
                    ? "mobile"
                    : "desktop";

            const time =
                isDay
                    ? "day"
                    : "night";

            const background =
                backgrounds?.[device]?.[time]?.[weatherType];

            if (background) {
                document.body.style.backgroundImage =
                    `url(${background})`;
            }
        };

        updateBackground();

        window.addEventListener("resize", updateBackground);

        return () => {
            window.removeEventListener(
                "resize",
                updateBackground
            );
        };
    }, [data]);

    return (
        <>
            <main className="main-weather">
                <Navbar onClick={() => setOpenStatus(!openStatus)} icon={openStatus} />
                <section className="current-conditions">
                    <div className="basic-metrics">
                        <CurrentTemp data={data} error={error} loading={loading} unit={unit} />
                        <div className="feels-wrapper">
                            <h3 className="feels-like">{data?.feels_like}</h3>
                        </div>
                    </div>
                </section>
                <Card data={data} unit={unit} formatters={formatters} />
            </main>
            <Settings className={openStatus ? "" : "hide"} unit={unit} setUnits={setUnits} />
        </>
    )
}

export default App;