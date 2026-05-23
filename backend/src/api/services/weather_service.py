from src.db.postgres import engine
import pandas as pd
from datetime import datetime, timedelta


hourly = pd.read_sql("SELECT * FROM hourly_conditions", engine)
now = datetime.now().date()

def get_current():
    hourly_copy = hourly.copy()
    hourly_copy["time"] = pd.to_datetime(hourly_copy["time"])

    current = pd.read_sql(
        """
        SELECT time, 
        apparent_temperature, 
        temperature_2m, 
        relative_humidity_2m, 
        is_day, 
        wind_speed_10m, 
        surface_pressure, 
        feels_like 
        FROM current_conditions
        """,
        engine,
    )

    current["time"] = pd.to_datetime(current["time"]).dt.round("h")
    
    wind_direction = hourly_copy[hourly_copy["time"].isin(current["time"])]["wind_direction_cardinal"].iloc[-1]

    current["time"] = current["time"].astype(str)

    return [{
        "time": current.iloc[-1]["time"],
        "apparent_temp": current.iloc[-1]["apparent_temperature"],
        "temperature": current.iloc[-1]["temperature_2m"],
        "relative_humidity": current.iloc[-1]["relative_humidity_2m"],
        "is_day": current.iloc[-1]["is_day"],
        "wind_speed": current.iloc[-1]["wind_speed_10m"],
        "wind_direction": wind_direction,
        "surface_pressure": current.iloc[-1]["surface_pressure"],
        "feels_like": current.iloc[-1]["feels_like"]
    }]


def get_hourly():
    hourly_copy = hourly.copy()
    hourly_copy = hourly_copy.drop(columns="id")

    hourly_copy = hourly_copy[pd.to_datetime(hourly_copy["time"]).dt.date == now]
    hourly_copy["time"] = hourly_copy["time"].astype(str)
    hourly_copy = hourly_copy.to_dict(orient="records")

    return hourly_copy


daily = pd.read_sql("SELECT * FROM daily_conditions", engine)

def get_today():
    today_weather = daily[pd.to_datetime(daily["time"]).dt.date == now]
    today_weather = today_weather.drop(columns="id")

    for col in ["time", "sunrise", "sunset"]:
        today_weather[col] = today_weather[col].astype(str)

    today_weather = today_weather.to_dict(orient="records")

    return today_weather


def get_daily_forecast():
    forecast = daily[pd.to_datetime(daily["time"]).dt.date >= (now - timedelta(days=1))]
    forecast = forecast.drop(columns="id")

    for col in ["time", "sunrise", "sunset"]:
        forecast[col] = forecast[col].astype(str)

    forecast = forecast.to_dict(orient="records")

    return forecast
