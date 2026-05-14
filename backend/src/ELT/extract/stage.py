from src.db.postgres import engine
import pandas as pd
from sqlalchemy.dialects.postgresql import JSONB


def stage_data(data: dict):
    current_conditions = pd.DataFrame([data["current_conditions"]])
    hourly_conditions = pd.DataFrame(data["hourly_conditions"])
    daily_conditions = pd.DataFrame(data["daily_conditions"])
    metadata = pd.DataFrame([data["metadata"]])

    units = pd.DataFrame(
        {
            "current_units": [data["current_units"]],
            "hourly_units": [data["hourly_units"]],
            "daily_units": [data["daily_units"]],
        }
    )

    units.to_sql(
        "weather_units",
        engine,
        if_exists="append",
        index=False,
        dtype={"current_units": JSONB, "hourly_units": JSONB, "daily_units": JSONB},
    )


    current_conditions.to_sql(
        "weather_current_raw", engine, if_exists="append", index=False
    )

    hourly_conditions.to_sql(
        "weather_hourly_raw", engine, if_exists="append", index=False
    )

    daily_conditions.to_sql(
        "weather_daily_raw", engine, if_exists="append", index=False
    )

    metadata.to_sql("weather_metadata", engine, if_exists="append", index=False)

    return {
        "current_conditions": "weather_current_raw",
        "hourly_conditions": "weather_hourly_raw",
        "daily_conditions": "weather_daily_raws",
        "metadata": "weather_metadata",
        "units": "weather_units"
    }
