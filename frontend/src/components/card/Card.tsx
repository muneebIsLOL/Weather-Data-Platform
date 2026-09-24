import { useState } from "react";
import "./App.css"
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faArrowLeft, faCloudBolt, faCloudMoon, faCloudRain, faCloudShowersHeavy, faCloudShowersWater, faCloudSun, faDroplet, faMoon, faSun, faWater, faWind } from "@fortawesome/free-solid-svg-icons"
import capitalizeFirstLetter from "../../utils/text"
import useFetch from "../../hooks/fetch";
import formatters from "../../utils/formatters";
import {
    LineChart,
    Line,
    XAxis,
    YAxis
} from "recharts";
import type { CurrentWeather, Unit, Weather } from "../../types";


const getFeelsLikeIcon = (feels_like: string, is_day: 0 | 1) => {
    feels_like = feels_like.replace(" ", "_").toLowerCase()
    const map: Record<string, any> = {
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

    const result = map[feels_like]

    if (result && typeof result === "object" && is_day) {
        return result[is_day]
    }

    return result || faSun
}

type CardinalDirection =
    | "N"
    | "NNE"
    | "NE"
    | "ENE"
    | "E"
    | "ESE"
    | "SE"
    | "SSE"
    | "S"
    | "SSW"
    | "SW"
    | "WSW"
    | "W"
    | "WNW"
    | "NW"
    | "NNW";

interface HourlyWeather {
    time: string;
    temperature_2m: number;
    relative_humidity_2m: number;
    dew_point_2m: number;
    apparent_temperature: number;
    precipitation_probability: number;
    weather_code: number;
    surface_pressure: number;
    visibility: number;
    wind_speed_10m: number;
    wind_direction_10m: number;
    feels_like: keyof Weather;
    wind_direction_cardinal: CardinalDirection;
    is_day: 0 | 1;
}

const HourlyItem = ({ unit }: { unit: Unit }) => {
    const [data, loading, error] = useFetch<HourlyWeather[]>("hourly_weather")
    return (
        <>
            {loading && <p> Loading...</p>}
            {error && <p style={{ color: "red" }} >{error}</p>}
            {
                !loading && !error && Array.isArray(data) &&
                (
                    <div className="hourly-conditions conditions-container">

                        <div className="hourly-item">
                            {data.map((hour) => (
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
                                width={(data as HourlyWeather[])?.length * 110}
                                height={100}
                                margin={{ top: 10, right: 10, left: 10, bottom: 10 }}
                            >
                                <XAxis dataKey="time"
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
                )
            }
        </>
    )
}

function getWindDegrees(dir: CardinalDirection): number {
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
    return (windDirectionToDegrees[dir] + 270) % 360
}

const CurrentItem = ({ data, unit, error, loading }: CardProps) => {
    if (loading) {
        return <p>Loading....</p>
    }
    
    if (error) {
        return <p style={{color: "red"}}>{error}</p>
    }

    type WeatherVariable =
        | "relative_humidity"
        | "wind_speed"
        | "wind_direction"
        | "surface_pressure";


    const { relative_humidity, wind_speed, wind_direction, surface_pressure } = data as CurrentWeather;
    const modifiedData: Record<WeatherVariable, number | string> = {
        relative_humidity,
        wind_speed,
        wind_direction,
        surface_pressure
    };

    const icons: Record<WeatherVariable, React.ReactNode> = {
        relative_humidity: <FontAwesomeIcon icon={faDroplet} />,
        wind_speed: <FontAwesomeIcon icon={faWind} />,
        wind_direction: <FontAwesomeIcon icon={faArrowLeft} style={{ rotate: `${getWindDegrees(wind_direction as CardinalDirection)}deg` }} />,
        surface_pressure: <FontAwesomeIcon icon={faWater} />
    };

    const formatters_modified: Record<WeatherVariable, (value: any, unit?: Unit) => string> = {
        relative_humidity: (value) => `${value}%`,
        wind_speed: (value, unit = "metric") => formatters.wind_speed(value, unit) as string,
        wind_direction: (value) => value as CardinalDirection,
        surface_pressure: (value) => formatters.pressure(value) as string
    };

    return (
        <div className="today-conditions conditions-container">
            {Object.entries(modifiedData).map(([key, value]) => {
                const variableKey = key as WeatherVariable;
                return (
                    <div key={variableKey} className={variableKey.replaceAll("_", "-").toLowerCase()}>
                        <h4 className="variable-header">
                            {icons[variableKey]}
                            {capitalizeFirstLetter(variableKey.replaceAll("_", " "))}
                        </h4>
                        <h1>
                            {typeof value === "string"
                                ? formatters_modified[variableKey](value)
                                : formatters_modified[variableKey](value, unit)}
                        </h1>
                    </div>
                );
            })}
        </div>
    );
};

interface DailyWeather {
    time: string;
    temperature_2m_max: number;
    temperature_2m_min: number;
    sunrise: string;
    sunset: string;
    uv_index_max: number;
}

const DailyItem = ({ unit }: { unit: Unit }) => {
    const [data, loading, error] = useFetch<DailyWeather[]>("daily/forecast")

    return (
        <div className="daily-conditions conditions-container">
            {error && (
                <p style={{ color: "red" }}>{error}</p>
            )}

            {!loading && !error && Array.isArray(data) && data.map((day) => (
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
    const [data, loading, error] = useFetch<DailyWeather[]>("daily/today")

    return (
        <div className="day-night-time-container conditions-container">
            {loading && <p style={{ color: "black" }}>Loading...</p>}

            {error && <p style={{ color: "red" }}>{error}</p>}
            {
                !loading && !error && Array.isArray(data) &&
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

interface CardProps {
    data: CurrentWeather | null
    error: string | null
    loading: boolean
    unit: Unit
}

const Card = ({ data, unit, error, loading }: CardProps) => {
    const [open, setOpenStatus] = useState(false)
    return (
        <div className={`card-layout ${open ? "grow" : "collapse"}`}>
            <section className="card-wrapper">
                <div className="card">
                    <div className="card-toggle" onClick={() => setOpenStatus(!open)}></div>
                    <HourlyItem unit={unit} />
                    <DailyItem unit={unit} />
                    <CurrentItem data={data} unit={unit} error={error} loading={loading} />
                    <DayNightTime />
                </div>
            </section>
        </div>
    )
}

export default Card;