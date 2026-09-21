import httpx, os, pytest
from dotenv import load_dotenv
from unittest.mock import patch
from src.api.routes import daily_weather
from src.api.routes import hourly_weather
from src.api.routes import current_weather

load_dotenv()
token = os.getenv("APP_AUTH_ACCESS_TOKEN")

api = "http://backend-api:8000"


def test_docs_endpoint():
    response_code = httpx.get(f"{api}/docs").status_code
    assert response_code == 200


def test_current_weather_endpoint(populate_db_data):

    response_code = httpx.get(
        f"{api}/current_weather", headers={"token": token}
    ).status_code
    assert response_code == 200


def test_hourly_weather_endpoint(populate_db_data):
    response_code = httpx.get(
        f"{api}/hourly_weather", headers={"token": token}
    ).status_code
    assert response_code == 200


def test_today_weather_endpoint(populate_db_data):
    response_code = httpx.get(
        f"{api}/daily/today", headers={"token": token}
    ).status_code
    assert response_code == 200


def test_forecast_weather_endpoint(populate_db_data):
    response_code = httpx.get(
        f"{api}/daily/forecast", headers={"token": token}
    ).status_code
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


@patch.object(current_weather, "get_current")
def test_invalid_data_for_current_conditions(mock_func):
    from src.api.routes.current_weather import current_weather
    from fastapi import HTTPException

    mock_func.return_value = {
        "time": "2026-06-19T12:53:16.399Z",
        "apparent_temp": 0,
        "temperature": 0,
        "relative_humidity": 0,
        "is_day": 0,
        "wind_speed": 0,
        "wind_direction": "string",
        "surface_pressure": 0,
        "feels_like": 0,
    }

    with pytest.raises(
        HTTPException,
        match="Invalid Data Found. Please try again in next 10-15 minutes.",
    ) as excinfo:
        current_weather()

    assert excinfo.value.status_code == 500


@patch.object(hourly_weather, "get_hourly")
def test_invalid_data_for_hourly_weather_conditions(mock_func):
    from src.api.routes.hourly_weather import hourly_weather
    from fastapi import HTTPException

    mock_func.return_value = [
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
            "is_day": "invalid_type",
        }
    ]

    with pytest.raises(
        HTTPException,
        match="Invalid Data Found. Please try again in next 10-15 minutes.",
    ) as excinfo:
        hourly_weather()

    assert excinfo.value.status_code == 500


@patch.object(daily_weather, "get_today")
def test_invalid_data_for_today_weather_conditions(mock_func):
    from src.api.routes.daily_weather import today_weather
    from fastapi import HTTPException

    mock_func.return_value = [
        {
            "time": "string",
            "temperature_2m_max": 0,
            "temperature_2m_min": 0,
            "sunrise": "string",
            "sunset": "string",
            "uv_index_max": "invalid_type",
        }
    ]

    with pytest.raises(
        HTTPException,
        match="Invalid Data Found. Please try again in next 10-15 minutes.",
    ) as excinfo:
        today_weather()

    assert excinfo.value.status_code == 500


@patch.object(daily_weather, "get_daily_forecast")
def test_invalid_data_for_daily_forecast(mock_func):
    from fastapi import HTTPException
    from src.api.routes.daily_weather import daily_weather_forecast

    mock_func.return_value = [
        {
            "time": "string",
            "temperature_2m_max": 0,
            "temperature_2m_min": 0,
            "sunrise": "string",
            "sunset": "string",
            "uv_index_max": "invalid_type",
        }
    ]

    with pytest.raises(
        HTTPException,
        match="Invalid Data Found. Please try again in next 10-15 minutes.",
    ) as excinfo:
        daily_weather_forecast()

    assert excinfo.value.status_code == 500


@patch.object(current_weather, "get_current")
def test_empty_data_for_current_conditions(mock_func):
    from src.api.routes.current_weather import current_weather
    from fastapi import HTTPException

    mock_func.side_effect = ValueError(
        "Data not found. Please try again in next 10-15 minutes."
    )

    with pytest.raises(
        HTTPException, match="Data not found. Please try again in next 10-15 minutes."
    ) as excinfo:
        current_weather()

    assert excinfo.value.status_code == 404


@patch.object(hourly_weather, "get_hourly")
def test_empty_data_for_hourly_conditions(mock_func):
    from src.api.routes.hourly_weather import hourly_weather
    from fastapi import HTTPException

    mock_func.side_effect = ValueError(
        "Data not found. Please try again in next 10-15 minutes."
    )

    with pytest.raises(
        HTTPException, match="Data not found. Please try again in next 10-15 minutes."
    ) as excinfo:
        hourly_weather()

    assert excinfo.value.status_code == 404


@patch.object(daily_weather, "get_today")
def test_empty_data_for_today_conditions(mock_func):
    from src.api.routes.daily_weather import today_weather
    from fastapi import HTTPException

    mock_func.side_effect = ValueError(
        "Data not found. Please try again in next 10-15 minutes."
    )

    with pytest.raises(
        HTTPException, match="Data not found. Please try again in next 10-15 minutes."
    ) as excinfo:
        today_weather()

    assert excinfo.value.status_code == 404

@patch.object(daily_weather, "get_daily_forecast")
def test_empty_data_for_daily_forecast(mock_func):
    from src.api.routes.daily_weather import daily_weather_forecast
    from fastapi import HTTPException

    mock_func.side_effect = ValueError(
        "Data not found. Please try again in next 10-15 minutes."
    )

    with pytest.raises(
        HTTPException, match="Data not found. Please try again in next 10-15 minutes."
    ) as excinfo:
        daily_weather_forecast()

    assert excinfo.value.status_code == 404

