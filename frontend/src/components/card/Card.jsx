import { useState, useEffect } from "react";
import "./App.css"
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faArrowLeft, faCloudBolt, faCloudMoon, faCloudRain, faCloudShowersHeavy, faCloudShowersWater, faCloudSun, faDroplet, faMoon, faSun, faWater, faWind } from "@fortawesome/free-solid-svg-icons"
import { faLumonDrop } from "@fortawesome/free-brands-svg-icons"
import capitalizeFirstLetter from "../../utils/text"
import useFetch from "../../hooks/fetch";
import formatters from "../../utils/formatters";
import {
    LineChart,
    Line,
    XAxis,
    YAxis,
    Tooltip,
} from "recharts";


const getFeelsLikeIcon = (feels_like, is_day) => {
    feels_like = feels_like.replace(" ", "_").toLowerCase()
    const map = {
        clear_sky: {
            0: faMoon,
            1: faSun
        },
        partly_cloudy: {
            0: faCloudMoon,
            1: faCloudSun
        },

        mainly_clear: {
            0: faCloudMoon,
            1: faCloudSun
        },

        light_drizzle: faCloudRain,
        dense_drizzle: faCloudShowersWater,
        moderate_drizzle: faCloudShowersHeavy,
        slight_rain: faDroplet,
        moderate_rain: faCloudRain,
        heavy_rain: faCloudShowersHeavy,
        thunderstorm: faCloudBolt
    }

    if (["clear_sky", "mainly_clear", "partly_cloudy"].includes(feels_like)) {
        return map?.[feels_like]?.[is_day]
    }
    return map?.[feels_like]
}

const HourlyItem = ({ unit, unit_map }) => {
    const [data, loading, error] = useFetch("hourly_weather")
    const chartData = data?.map(hour => ({
        time: hour.time,
        temp: hour.temperature
    }));
    return (
        <div className="hourly-conditions conditions-container">
            {loading && <p style={{ color: "black" }}>Loading...</p>}

            {error && <p style={{ color: "red" }}>{error}</p>}
            <div className="hourly-item">
                {!loading && !error && data.map((hour, index) => (

                    <div className="item">
                        <FontAwesomeIcon icon={getFeelsLikeIcon(hour.feels_like, hour.is_day)} className="feels-like-icon" />
                        <p className="time">{hour.time}</p>
                        <h3>{formatters.temperature(Math.round(hour.temperature_2m), unit)}°</h3>
                    </div>
                ))}
            </div>
            <div className="hourly-chart">
                <LineChart
                    data={data?.map(hour => ({
                        time: hour.time,
                        temp: hour.temperature_2m
                    }))}
                    width={data?.length * 110}
                    height={100}
                    margin={{ top: 10, right: 10, left: 10, bottom: 10 }}
                >
                    <XAxis dataKey="time" axisLine={false}
                        tick={false}
                        axisLine={false}
                        hide
                    />
                    <YAxis
                        unit="°C"
                        axisLine={false}
                        tick={false}
                        hide
                        domain={["dataMin - 2", "dataMax + 2"]} />
                    <defs>
                        <linearGradient id="tempGradient" x1="0" y1="1" x2="0" y2="0">
                            <stop offset="0%" stopColor="#ccc" />
                            <stop offset="100%" stopColor="#ffd54a" />
                        </linearGradient>
                    </defs>
                    <Line
                        type="monotone"
                        dataKey="temp"
                        stroke="url(#tempGradient)"
                    />
                </LineChart>
            </div>
        </div>
    );
}

function getWindDegrees(dir) {
    const windDirectionToDegrees = {
        N: 0,
        NNE: 22.5,
        NE: 45,
        ENE: 67.5,
        E: 90,
        ESE: 112.5,
        SE: 135,
        SSE: 157.5,
        S: 180,
        SSW: 202.5,
        SW: 225,
        WSW: 247.5,
        W: 270,
        WNW: 292.5,
        NW: 315,
        NNW: 337.5
    };
    return (windDirectionToDegrees[dir] + 270) % 360 ?? null;
}

const CurrentItem = ({ data, unit }) => {
    const dataCopy = { ...data }

    const icons = {
        relative_humidity: <FontAwesomeIcon icon={faDroplet} />,
        wind_speed: <FontAwesomeIcon icon={faWind} />,
        wind_direction: <FontAwesomeIcon icon={faArrowLeft} style={{ rotate: `${getWindDegrees(data && data.wind_direction)}deg` }} />,
        surface_pressure: <FontAwesomeIcon icon={faWater} />
    };

    const formatters_modified = {
        relative_humidity: value => `${value}%`,
        wind_speed: (value, unit = undefined) => formatters.wind_speed(value, unit),
        wind_direction: value => value,
        surface_pressure: value => formatters.pressure(value)
    }

    delete dataCopy?.["apparent_temp"]
    delete dataCopy?.["temperature"]
    delete dataCopy?.["is_day"]
    delete dataCopy?.["temperature"]
    delete dataCopy?.["time"]
    delete dataCopy?.["feels_like"]

    return (
        <>
            <div className="today-conditions conditions-container">
                {
                    !dataCopy ? (
                        <p>Loading...</p>
                    ) : (
                        Object.entries(dataCopy).map(([key, value]) => (
                            <div key={key} className={key.replaceAll("_", "-").toLowerCase()}>
                                <h4 className="variable-header">
                                    {icons[key]}
                                    {capitalizeFirstLetter(key.replaceAll("_", " "))}
                                </h4>
                                <h1>{formatters_modified[key]?.(value, unit) ?? value}</h1>
                            </div>
                        ))
                    )
                }
            </div>
        </>
    )
}

const DailyItem = ({ unit }) => {
    const [data, loading, error] = useFetch("daily/forecast")
    return (
        <div className="daily-conditions conditions-container">
            {/* <h3 style={{ textAlign: "center" }}>Daily</h3> */}
            {loading && <p style={{ color: "black" }}>Loading...</p>}

            {error && <p style={{ color: "red" }}>{error}</p>}

            {!loading && !error && data.map((day, index) => (
                <div className="daily-item">
                    <p className="forecast-time">{day.time}</p>
                    <p className="min-max-temp">
                        <span>{formatters.temperature(Math.round(day.temperature_2m_max), unit)}°</span>
                        <span>{formatters.temperature(Math.round(day.temperature_2m_min), unit)}°</span>
                    </p>
                </div>
            ))}
        </div>
    )
}

const DayNightTime = () => {
    const [data, loading, error] = useFetch("daily/today")

    return (
        <div className="day-night-time-container conditions-container">
            {loading && <p style={{ color: "black" }}>Loading...</p>}

            {error && <p style={{ color: "red" }}>{error}</p>}
            {
                !loading && !error &&
                <div className="timings">
                    <div>
                        <p>Sunrise</p>
                        <h1>{data[0]["sunrise"]}</h1>
                    </div>
                    <div>
                        <p>Sunset</p>
                        <h1>{data[0]["sunset"]}</h1>
                    </div>
                </div>
            }
        </div>
    )
}

const Card = ({ data, unit }) => {
    const [open, setOpenStatus] = useState(false)
    return (
        <div className={`card-layout ${open ? "grow" : "collapse"}`}>
            <section className="card-wrapper">
                <div className="card">
                    <div className="card-toggle" onClick={() => setOpenStatus(!open)}></div>
                    {/* <h3>Hourly</h3> */}
                    <HourlyItem unit={unit} />
                    <DailyItem unit={unit} />
                    {/* <h3>Current Conditions</h3> */}
                    <CurrentItem data={data} unit={unit} />
                    <DayNightTime />
                </div>
            </section>
        </div>
    )
}

export default Card;