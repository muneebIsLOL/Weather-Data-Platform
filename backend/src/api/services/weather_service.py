import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from sqlalchemy.engine.base import Engine


def get_current(engine: Engine):
    hourly = pd.read_sql("SELECT * FROM hourly_conditions", engine)

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

    if hourly.empty or current.empty:
        raise ValueError()
    
    current["time"] = pd.to_datetime(current["time"]).dt.round("h")
    hourly["time"] = pd.to_datetime(hourly["time"])

    wind_direction = hourly[hourly["time"].isin(current["time"])][
        "wind_direction_cardinal"
    ].iloc[-1]

    current = current.sort_values("time")
    current["time"] = current["time"].astype(str)

    return {
        "time": current.iloc[-1]["time"],
        "apparent_temp": current.iloc[-1]["apparent_temperature"],
        "temperature": current.iloc[-1]["temperature_2m"],
        "relative_humidity": current.iloc[-1]["relative_humidity_2m"],
        "is_day": current.iloc[-1]["is_day"],
        "wind_speed": current.iloc[-1]["wind_speed_10m"],
        "wind_direction": wind_direction,
        "surface_pressure": current.iloc[-1]["surface_pressure"],
        "feels_like": current.iloc[-1]["feels_like"],
    }


def get_hourly(engine: Engine):
    now = datetime.now().date()
    hourly = pd.read_sql("SELECT * FROM hourly_conditions", engine)
    daily = pd.read_sql("SELECT * FROM daily_conditions", engine)

    today = daily[pd.to_datetime(daily["time"]).dt.date == now]

    hourly = hourly.drop(columns="id")
    hourly = hourly[pd.to_datetime(hourly["time"]).dt.date == now]
    if hourly.empty:
        raise ValueError()
    hourly["time"] = hourly["time"].dt.strftime("%H:%M")
    sunrise = (
        pd.to_datetime(today["sunrise"])
        .dt.tz_convert("Asia/Karachi")
        .dt.strftime("%H:%M")
        .iloc[0]
    )
    sunset = (
        pd.to_datetime(today["sunset"])
        .dt.tz_convert("Asia/Karachi")
        .dt.strftime("%H:%M")
        .iloc[0]
    )
    hourly["is_day"] = np.where(
        (hourly["time"] >= sunrise) & (hourly["time"] <= sunset), 1, 0
    )
    hourly = hourly.sort_values("time")
    hourly = hourly.to_dict(orient="records")
    return hourly


def get_today(engine: Engine):
    now = datetime.now().date()
    daily = pd.read_sql("SELECT * FROM daily_conditions", engine)

    today_weather = daily[pd.to_datetime(daily["time"]).dt.date == now]
    today_weather = today_weather.drop(columns="id")
    if today_weather.empty:
        raise ValueError()

    for col in ["time", "sunrise", "sunset"]:
        today_weather[col] = pd.to_datetime(today_weather[col])
        today_weather[col] = (
            today_weather[col]
            .dt.strftime("%H:%M")
        )

    return today_weather.to_dict(orient="records")


def get_daily_forecast(engine: Engine):
    now = datetime.now().date()
    daily = pd.read_sql("SELECT * FROM daily_conditions", engine)
    forecast = daily[pd.to_datetime(daily["time"]).dt.date >= (now - timedelta(days=1))]

    if forecast.empty:
        raise ValueError()

    forecast = forecast.drop(columns="id")
    forecast["time"] = forecast["time"].dt.day_name()
    forecast.iloc[0, 0] = "Yesterday"
    forecast.iloc[1, 0] = "Today"
    for col in ["sunrise", "sunset", "time"]:
        forecast[col] = forecast[col].astype(str)

    forecast = forecast.to_dict(orient="records")

    return forecast
