const formatters = {
    temperature: (value, unit) =>
        unit === "metric"
            ? Math.round(value)
            : Math.round((value * 9) / 5 + 32),

    wind_speed: (value, unit) =>
        unit === "metric"
            ? `${Math.round(value)} km/h`
            : `${Math.round(value / 1.60934)} mph`,

    pressure: value => `${Math.round(value)} hPa`,
};

export default formatters;