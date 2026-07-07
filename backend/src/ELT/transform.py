import pandas as pd
import datetime
import numpy as np
from src.ELT.config.constants import WEATHER_CODES, cardinal_directions
from pathlib import Path

def load_raw(raw_schema_reference: dict, engine):
    data = {}
    for key, value in raw_schema_reference.items():
        data[key] = pd.read_sql(f"SELECT * FROM {value}", engine)
    return data

def clean_data(data: dict):
    for key, value in data.items():
        data[key] = value.drop(columns="id")
        if isinstance(value, pd.DataFrame):
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

    for key, df in data.items():
        if isinstance(df, pd.DataFrame) and "time" in df.columns:

            df["time"] = pd.to_datetime(df["time"])

            df = (
                df.sort_values("time")
                    .drop_duplicates(subset=["time"], keep="last")
                    .reset_index(drop=True)
            )

            df["time"] = (
                pd.to_datetime(df["time"], utc=True)
                .dt.floor("min")
            )

            data[key] = df

    hourly_conditions["apparent_temperature"] = hourly_conditions[
        "apparent_temperature"
    ].fillna(hourly_conditions["temperature_2m"])

    current_conditions = current_conditions.drop(columns="interval")

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

    data["current_conditions"] = current_conditions
    data["hourly_conditions"] = hourly_conditions
    data["daily_conditions"] = daily_conditions
    data["metadata"] = metadata
    data["current_units"] = current_units
    data["hourly_units"] = hourly_units
    data["daily_units"] = daily_units

    return data

def column_mapping(data: dict):
    current_conditions = data["current_conditions"]
    hourly_conditions = data["hourly_conditions"]
    metadata = data["metadata"]

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
    ).fillna("UNKNOWN").astype("category")

    data["current_conditions"] = current_conditions
    data["hourly_conditions"] = hourly_conditions
    data["metadata"] = metadata

    return data


def normalize(data: dict):
    for value in [
        data["current_conditions"],
        data["hourly_conditions"],
        data["daily_conditions"],
    ]:
        if "time" in value.columns:
            value["time"] = pd.to_datetime(value["time"])

        elif "fetched_at" in value.columns:
            value["fetched_at"] = pd.to_datetime(value["fetched_at"])

        for col in value.loc[:, value.columns.str.contains("temperature")].columns:
            value[col] = value[col].astype(float)

    current_conditions = data["current_conditions"]
    hourly_conditions = data["hourly_conditions"]
    daily_conditions = data["daily_conditions"]

    current_conditions["is_day"] = current_conditions["is_day"].astype("category")

    daily_conditions["uv_index_max"] = daily_conditions["uv_index_max"].astype(float)

    for value in [current_conditions, hourly_conditions]:
        value["relative_humidity_2m"] = value["relative_humidity_2m"].astype(np.float16)
        value["weather_code"] = value["weather_code"].astype(int)
        value["wind_speed_10m"] = value["wind_speed_10m"].astype(np.float16)        

    data["current_conditions"] = current_conditions
    data["hourly_conditions"] = hourly_conditions
    data["daily_conditions"] = daily_conditions

    return data

def save_data(data: dict):
    Path("./src/ELT/temp").mkdir(parents=True, exist_ok=True)
    for key, value in data.items():
       value.to_parquet(
           f"./src/ELT/temp/{key}.parquet",
            index=False
       ) 

def transform_data(raw_schema_reference: dict, engine):
    try:
        data = load_raw(raw_schema_reference, engine)
        
        cleaned_data = clean_data(data)

        transformed_data = column_mapping(cleaned_data)

        normalized_data = normalize(transformed_data)

        save_data(normalized_data)

        transformed_schema_reference = {
            "current_conditions": "current_conditions",
            "hourly_conditions": "hourly_conditions",
            "daily_conditions": "daily_conditions",
            "metadata": "metadata",
            "current_units": "current_units",
            "hourly_units": "hourly_units",
            "daily_units": "daily_units"
        }

        return normalized_data, transformed_schema_reference

    except Exception as e:
        print("Data Transformation Error:")
        raise e