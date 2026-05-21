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

CREATE TABLE IF NOT EXISTS weather_units_raw (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    "time" TIMESTAMP DEFAULT NOW(),

    "current_units" JSONB,
    "hourly_units" JSONB,
    "daily_units" JSONB
);

CREATE TABLE IF NOT EXISTS weather_metadata (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "time" timestamp default NOW(),
    "latitude" double precision,
    "longitude" double precision,
    "extract_time_ms" double precision,
    "utc_offset_secs" SERIAL,
    "timezone" text,
    "timezone_abbr" text,
    "elevation" real
);

CREATE TABLE IF NOT EXISTS current_conditions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    time TIMESTAMPTZ UNIQUE NOT NULL,

    apparent_temperature REAL CHECK (apparent_temperature BETWEEN -80 AND 80),
    temperature_2m REAL CHECK (temperature_2m BETWEEN -80 AND 80),

    relative_humidity_2m REAL CHECK (relative_humidity_2m BETWEEN 0 AND 100),

    is_day SMALLINT CHECK (is_day IN (0, 1)),

    weather_code INT NOT NULL,

    wind_speed_10m REAL CHECK (wind_speed_10m >= 0 AND wind_speed_10m <= 400),

    surface_pressure REAL CHECK (surface_pressure BETWEEN 700 AND 1100),

    feels_like TEXT
);

CREATE TABLE IF NOT EXISTS hourly_conditions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    time TIMESTAMPTZ UNIQUE NOT NULL,

    temperature_2m REAL CHECK (temperature_2m BETWEEN -80 AND 80),
    relative_humidity_2m REAL CHECK (relative_humidity_2m BETWEEN 0 AND 100),
    dew_point_2m REAL CHECK (dew_point_2m BETWEEN -80 AND 80),

    apparent_temperature REAL CHECK (apparent_temperature BETWEEN -80 AND 80),

    precipitation_probability REAL CHECK (precipitation_probability BETWEEN 0 AND 100),

    weather_code INT,

    surface_pressure REAL CHECK (surface_pressure BETWEEN 700 AND 1100),

    visibility REAL CHECK (visibility >= 0),

    wind_speed_10m REAL CHECK (wind_speed_10m >= 0 AND wind_speed_10m <= 400),
    wind_direction_10m REAL CHECK (wind_direction_10m BETWEEN 0 AND 360),

    feels_like TEXT,

    wind_direction_cardinal TEXT
);

CREATE TABLE IF NOT EXISTS daily_conditions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    time TIMESTAMPTZ UNIQUE NOT NULL,

    temperature_2m_max REAL CHECK (temperature_2m_max BETWEEN -80 AND 80),
    temperature_2m_min REAL CHECK (temperature_2m_min BETWEEN -80 AND 80),

    sunrise TIMESTAMPTZ,
    sunset TIMESTAMPTZ,

    uv_index_max REAL CHECK (uv_index_max BETWEEN 0 AND 20)
);

CREATE TABLE IF NOT EXISTS metadata (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    time TIMESTAMPTZ UNIQUE NOT NULL,

    latitude REAL CHECK (latitude BETWEEN -90 AND 90),
    longitude REAL CHECK (longitude BETWEEN -180 AND 180),

    extract_time_ms REAL CHECK (extract_time_ms >= 0),

    utc_offset_secs REAL,

    timezone TEXT NOT NULL,
    timezone_abbr TEXT NOT NULL,

    elevation REAL CHECK (elevation BETWEEN -500 AND 9000)
);

CREATE TABLE IF NOT EXISTS current_units (
    time TEXT,

    is_day TEXT,
    interval TEXT,
    relative_humidity_2m TEXT,

    weather_code TEXT,

    temperature_2m TEXT,
    wind_speed_10m TEXT,
    surface_pressure TEXT,

    apparent_temperature TEXT
);

CREATE TABLE IF NOT EXISTS hourly_units (
    time TEXT,

    visibility TEXT,
    dew_point_2m TEXT,

    weather_code TEXT,

    temperature_2m TEXT,
    wind_speed_10m TEXT,
    surface_pressure TEXT,

    wind_direction_10m TEXT,

    apparent_temperature TEXT,
    relative_humidity_2m TEXT,

    precipitation_probability TEXT
);

CREATE TABLE IF NOT EXISTS daily_units (
    time TEXT,

    sunrise TEXT,
    sunset TEXT,

    uv_index_max TEXT,

    temperature_2m_max TEXT,
    temperature_2m_min TEXT
);