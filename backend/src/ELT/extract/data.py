import httpx
from urllib.error import HTTPError

def extract_data():
    try:
        r = httpx.get(
            "https://api.open-meteo.com/v1/forecast?"
            "latitude=24.8608&"
            "longitude=67.0104&"
            "daily=temperature_2m_max,"
            "temperature_2m_min,"
            "sunrise,"
            "sunset,"
            "uv_index_max&"
            "hourly=temperature_2m,"
            "relative_humidity_2m,"
            "dew_point_2m,"
            "apparent_temperature,"
            "precipitation_probability,"
            "weather_code,"
            "surface_pressure,"
            "visibility,"
            "wind_speed_10m,"
            "wind_direction_10m&"
            "current=apparent_temperature,"
            "temperature_2m,"
            "relative_humidity_2m,"
            "is_day,"
            "weather_code,"
            "wind_speed_10m,"
            "surface_pressure&"
            "timezone=auto"
        )

        data = r.json()

        current_conditions = data.get("current")
        hourly_conditions = data.get("hourly")
        daily_conditions = data.get("daily")

        current_units = data.get("current_units")
        hourly_units = data.get("hourly_units")
        daily_units = data.get("daily_units")

        weather_metadata = {
            "latitude": data.get("latitude"),
            "longitude": data.get("longitude"),
            "extract_time_ms": data.get("generationtime_ms"),
            "utc_offset_secs": data.get("utc_offset_seconds"),
            "timezone": data.get("timezone"),
            "timezone_abbr": data.get("timezone_abbreviation"),
            "elevation": data.get("elevation"),
        }

        if any(
            x is None for x in [current_conditions, hourly_conditions, daily_conditions]
        ):
            raise ValueError("Missing Critical Fields.")

        return {
            "current_conditions": current_conditions,
            "hourly_conditions": hourly_conditions,
            "daily_conditions": daily_conditions,
            "current_units": current_units,
            "hourly_units": hourly_units,
            "daily_units": daily_units,
            "metadata": weather_metadata
        }

    except (Exception, HTTPError) as e:
        print("Error!!")
        raise e