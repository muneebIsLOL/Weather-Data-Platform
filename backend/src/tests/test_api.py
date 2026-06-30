import httpx, os
from dotenv import load_dotenv

load_dotenv("../.env")
token = os.environ.get("AUTH_ACCESS_TOKEN")

api = "http://0.0.0.0:8000"

def test_docs_endpoint():
    response_code = httpx.get(f"{api}/docs", headers={"token": token}).status_code
    assert response_code == 200

def test_current_weather_endpoint():
    response_code = httpx.get(f"{api}/current_weather", headers={"token": token}).status_code
    assert response_code == 200

def test_hourly_weather_endpoint():
    response_code = httpx.get(f"{api}/hourly_weather", headers={"token": token}).status_code
    assert response_code == 200

def test_today_weather_endpoint():
    response_code = httpx.get(f"{api}/daily/today", headers={"token": token}).status_code
    assert response_code == 200

def test_forecast_weather_endpoint():
    response_code = httpx.get(f"{api}/daily/forecast", headers={"token": token}).status_code
    assert response_code == 200

def test_current_conditions_schema():
    from src.api.models.current_conditions import CurrentConditionsResponse

    current_model = {
        "time": "2026-06-19T12:53:16.399Z",
        "apparent_temp": 0,
        "temperature": 0,
        "relative_humidity": 0,
        "is_day": 0,
        "wind_speed": 0,
        "wind_direction": "string",
        "surface_pressure": 0,
        "feels_like": "string",
    }

    assert CurrentConditionsResponse.model_validate(current_model)


def test_hourly_conditions_schema():
    from src.api.models.hourly_conditions import HourlyConditionsResponse
    from typing import List
    from pydantic import TypeAdapter

    hourly_model = [
        {
            "time": "string",
            "temperature_2m": 0,
            "relative_humidity_2m": 0,
            "dew_point_2m": 0,
            "apparent_temperature": 0,
            "precipitation_probability": 0,
            "weather_code": 0,
            "surface_pressure": 0,
            "visibility": 0,
            "wind_speed_10m": 0,
            "wind_direction_10m": 0,
            "feels_like": "string",
            "wind_direction_cardinal": "string",
            "is_day": 0,
        }
    ]

    adapter = TypeAdapter(List[HourlyConditionsResponse])
    assert adapter.validate_python(hourly_model)


def test_daily_conditions_schema():
    from src.api.models.daily_conditions import DailyConditionsResponse
    from typing import List
    from pydantic import TypeAdapter

    daily_model = [
        {
            "time": "string",
            "temperature_2m_max": 0,
            "temperature_2m_min": 0,
            "sunrise": "string",
            "sunset": "string",
            "uv_index_max": 0,
        }
    ]

    adapter = TypeAdapter(List[DailyConditionsResponse])
    assert adapter.validate_python(daily_model)
