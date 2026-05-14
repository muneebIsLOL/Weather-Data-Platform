CREATE TABLE IF NOT EXISTS weather_current_raw (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "time" timestamp unique,
    "interval" smallint,
    "apparent_temperature" real,
    "temperature_2m" real,
    "relative_humidity_2m" real,
    "is_day" smallint not null,
    "weather_code" smallint,
    "wind_speed_10m" real,
    "surface_pressure" real
);

CREATE TABLE IF NOT EXISTS weather_hourly_raw (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "time" timestamp unique,
    "temperature_2m" real not null,
    "relative_humidity_2m" real not null,
    "dew_point_2m" real not null,
    "apparent_temperature" real,
    "precipitation_probability" real not null,
    "weather_code" smallint not null,
    "surface_pressure" real not null,
    "visibility" real not null,
    "wind_speed_10m" real not null,
    "wind_direction_10m" real not null
);

CREATE TABLE IF NOT EXISTS weather_daily_raw (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "time" timestamp unique,
    "temperature_2m_max" real not null,
    "temperature_2m_min" real not null,
    "sunrise" timestamp not null,
    "sunset" timestamp not null,
    "uv_index_max" smallint
);

CREATE TABLE IF NOT EXISTS weather_units (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    "fetched_at" TIMESTAMP DEFAULT NOW(),

    "current_units" JSONB,
    "hourly_units" JSONB,
    "daily_units" JSONB
);

CREATE TABLE IF NOT EXISTS weather_metadata (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "fetched_at" timestamp default NOW(),
    "latitude" double precision,
    "longitude" double precision,
    "extract_time_ms" double precision,
    "utc_offset_secs" SERIAL,
    "timezone" text,
    "timezone_abbr" text,
    "elevation" real
);
