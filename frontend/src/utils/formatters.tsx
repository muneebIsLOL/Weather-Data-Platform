import type { Unit } from "../types";

type Formatters = "temperature" | "wind_speed" | "pressure"

const formatters: Record<Formatters, (value: number, unit?: Unit) => string | number> = {
    temperature: (value, unit) =>
        unit === "metric"
            ? Math.round(value)
            : Math.round((value * 9) / 5 + 32),

    wind_speed: (value, unit) =>
        unit === "metric"
            ? `${Math.round(value)} km/h`
            : `${Math.round(value / 1.60934)} mph`,

    pressure: (value): string => `${Math.round(value)} hPa`,
};

export default formatters;