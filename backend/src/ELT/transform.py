from src.db.postgres import engine
import pandas as pd
import datetime
import numpy as np


def load_raw(schema_reference: dict, engine):
    data = {}
    for key, value in schema_reference.items():
        data[key] = pd.read_sql(f"SELECT * FROM {value}", engine)

    return data


schema_ref = {
    "current_conditions": "weather_current_raw",
    "hourly_conditions": "weather_hourly_raw",
    "daily_conditions": "weather_daily_raw",
    "metadata": "weather_metadata",
    "units": "weather_units",
}

data = load_raw(schema_ref, engine)

def clean_data(data: dict):
    for value in data.values():
        if isinstance(value, pd.DataFrame):
            value["id"] = value["id"].ffill()
            if "time" in value.columns:
                value["time"] = value["time"].fillna(datetime.datetime.now())
                value["time"] = pd.to_datetime(value["time"])

    current_conditions = data["current_conditions"]
    hourly_conditions = data["hourly_conditions"]
    daily_conditions = data["daily_conditions"]
    metadata = data["metadata"]
    units = data["units"]
    current_units = pd.json_normalize(units["current_units"])
    hourly_units = pd.json_normalize(units["hourly_units"])
    daily_units = pd.json_normalize(units["daily_units"])

    for units in [current_units, hourly_units, daily_units]:
        units = units.ffill()

    hourly_conditions["apparent_temperature"] = hourly_conditions[
        "apparent_temperature"
    ].fillna(hourly_conditions["temperature_2m"])

    current_conditions["interval"] = current_conditions["interval"].ffill()

    cols = [
        "apparent_temperature",
        "temperature_2m",
        "relative_humidity_2m",
        "weather_code",
        "surface_pressure",
    ]

    merged = current_conditions.merge(
        hourly_conditions[["time"] + cols],
        on="time",
        how="left",
        suffixes=("", "_hourly"),
    )

    for col in cols:
        merged[col] = merged[col].fillna(merged[f"{col}_hourly"])
        merged.drop(columns=f"{col}_hourly", inplace=True)

    current_conditions = merged

    daily_conditions["uv_index_max"] = daily_conditions["uv_index_max"].ffill()

    for col in ["latitude", "longitude", "timezone", "timezone_abbr"]:
        metadata[col] = metadata[col].ffill()

    for col in ["extract_time_ms", "elevation"]:
        metadata[col] = metadata[col].fillna(metadata[col].mean())

    metadata["utc_offset_secs"] = metadata["utc_offset_secs"].ffill()

    del data["units"]

    data["current_units"] = current_units
    data["hourly_units"] = hourly_units
    data["daily_units"] = daily_units

    return data


print(clean_data(data))


def column_mapping(data: dict):
    current_conditions = data["current_conditions"]
    hourly_conditions = data["hourly_conditions"]

    WEATHER_CODES = {
        0: "Clear sky",
        1: "Mainly clear",
        2: "Partly cloudy",
        3: "Overcast",
        45: "Fog",
        48: "Depositing rime fog",
        51: "Light drizzle",
        53: "Moderate drizzle",
        55: "Dense drizzle",
        56: "Light freezing drizzle",
        57: "Dense freezing drizzle",
        61: "Slight rain",
        63: "Moderate rain",
        65: "Heavy rain",
        66: "Light freezing rain",
        67: "Heavy freezing rain",
        71: "Slight snow fall",
        73: "Moderate snow fall",
        75: "Heavy snow fall",
        77: "Snow grains",
        80: "Slight rain showers",
        81: "Moderate rain showers",
        82: "Violent rain showers",
        85: "Slight snow showers",
        86: "Heavy snow showers",
        95: "Thunderstorm",
        96: "Thunderstorm with slight hail",
        99: "Thunderstorm with heavy hail",
    }

    cardinal_directions = [
        "N",
        "NNE",
        "NE",
        "ENE",
        "E",
        "ESE",
        "SE",
        "SSE",
        "S",
        "SSW",
        "SW",
        "WSW",
        "W",
        "WNW",
        "NW",
        "NNW",
    ]

    for conditions in [current_conditions, hourly_conditions]:
        conditions["feels_like"] = (
            conditions["weather_code"]
            .map(WEATHER_CODES)
            .fillna("UNKNOWN_CODE")
            .astype("category")
        )
    idx = (((hourly_conditions["wind_direction_10m"] + 11.25) // 22.5) % 16).astype(int)
    hourly_conditions["wind_direction_cardinal"] = idx.apply(
        lambda x: cardinal_directions[x]
    ).astype("category").fillna("UNKNOWN")

    return data


def normalize(data: dict):
    for value in [
        data["current_conditions"],
        data["hourly_conditions"],
        data["daily_conditions"],
    ]:
        value["id"] = value["id"].astype("int8")

        if "time" in value.columns:
            value["time"] = pd.to_datetime(value["time"])

        elif "fetched_at" in value.columns:
            value["fetched_at"] = pd.to_datetime(value["fetched_at"])

        for col in value.loc[:, value.columns.str.contains("temperature")].columns:
            value[col] = value[col].astype(float)

    current_conditions = data["current_conditions"]
    hourly_conditions = data["hourly_conditions"]

    for value in [current_conditions, hourly_conditions]:
        value["relative_humidity_2m"] = value["relative_humidity_2m"].astype(np.float16)
        value["weather_code"] = value["weather_code"].astype(int)
        value["wind_speed_10m"] = value["wind_speed_10m"].astype(np.float16)        

    return data