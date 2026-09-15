import "./index.css"
import "./App.css"
import Navbar from "./components/navbar/Navbar"
import Card from "./components/card/Card"
import Settings from "./components/settings/Settings"
import { useEffect, useState } from "react"
import useFetch from "./hooks/fetch"
import formatters from "./utils/formatters"
import type { Weather, Unit, CurrentWeather } from "./types"

interface Diurnal {
  day: Weather
  night: Weather
}

interface Background {
  desktop: Diurnal
  mobile: Diurnal
}

const backgrounds: Background = {
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

interface CurrentTempProps {
  data: CurrentWeather | null
  error: string | null
  loading: boolean
  unit: Unit
}

const CurrentTemp = ({ data, error, loading, unit }: CurrentTempProps) => {
  return (
    <>
      {loading && <p>Loading...</p>}

      {error && <p>{error}</p>}

      {!loading && !error && data && (
        <h1 className="temperature">
          {formatters.temperature(Math.round(data?.temperature), unit)}°
        </h1>
      )}
    </>
  );
}

const App = () => {
  const [openStatus, setOpenStatus] = useState<boolean>(false)
  const [unit, setUnits] = useState<Unit>("metric");
  const [data, loading, error] = useFetch<CurrentWeather>("current_weather")

  useEffect(() => {
    const updateBackground = () => {
      if (!data?.feels_like) return;
      const isDay = data.is_day;
      const weatherType = data.feels_like.replaceAll(" ", "_").toLowerCase() as keyof Weather;

      const device =
        window.innerWidth <= 768
          ? "mobile"
          : "desktop";

      const time =
        isDay
          ? "day"
          : "night";

      const background =
        backgrounds?.[device][time][weatherType];

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
      {
        !loading && !error && data && (
          <>
            <main className="main-weather">
              <Navbar onClick={() => setOpenStatus(!openStatus)} icon={openStatus} />
              <section className="current-conditions">
                <div className="basic-metrics">
                  <CurrentTemp data={data} error={error} loading={loading} unit={unit} />
                  <div className="feels-wrapper">
                    <h3 className="feels-like">{!loading && !error && data && data.feels_like}</h3>
                  </div>
                </div>
              </section>
              <Card data={data} unit={unit} />
            </main>
            <Settings className={openStatus ? "" : "hide"} unit={unit} setUnits={setUnits} />
          </>
        )}
    </>
  )
}

export default App;