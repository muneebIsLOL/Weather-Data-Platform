from unittest.mock import Mock, patch
from src.ELT.extract.data import extract_data
from src.ELT.extract.stage import stage_data
from src.ELT.transform import load_raw
import httpx, pytest, os, urllib
from sqlalchemy.engine import create_engine

POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = urllib.parse.quote_plus(os.getenv("POSTGRES_PASSWORD"))
TEST_POSTGRES_DB = os.getenv("TEST_POSTGRES_DB")
POSTGRES_HOST = os.getenv("POSTGRES_HOST")


@patch("src.ELT.extract.data.httpx.get")
def test_extract_http_request(mock_get):

    mock_get.side_effect = httpx.HTTPError("Network Error")

    with pytest.raises(httpx.HTTPError):
        extract_data()


@patch("src.ELT.extract.data.httpx.get")
def test_extract_empty_data(mock_get):
    mock_response = Mock()

    mock_response.json.side_effect = ValueError("Invalid JSON!")

    mock_get.return_value = mock_response

    with pytest.raises(ValueError):
        extract_data()


def test_empty_data_at_raw_data_stage():
    engine = create_engine(
        f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{TEST_POSTGRES_DB}"
    )

    mock_empty_data = {
        "current_conditions": {},
        "hourly_conditions": {},
        "daily_conditions": {},
        "metadata": {},
        "current_units": {},
        "hourly_units": {},
        "daily_units": {},
    }

    result = stage_data(mock_empty_data, engine)

    assert result == {
        "current_conditions": "weather_current_raw",
        "hourly_conditions": "weather_hourly_raw",
        "daily_conditions": "weather_daily_raw",
        "metadata": "weather_metadata",
        "units": "weather_units_raw",
    }


def test_with_broken_engine_at_raw_data_stage():
    from sqlalchemy import engine

    mock_engine = Mock(side_effect=engine)

    mock_data = {
        "current_conditions": {
            "time": "2026-06-25 12:00:00",
            "interval": 900,
            "apparent_temperature": 27.3,
            "temperature_2m": 25.5,
            "relative_humidity_2m": 62.5,
            "is_day": 1,
            "weather_code": 2,
            "wind_speed_10m": 12.4,
            "surface_pressure": 1013.2,
        },
        "hourly_conditions": [
            {
                "time": "2026-06-25 12:00:00",
                "temperature_2m": 25.5,
                "relative_humidity_2m": 62.5,
                "dew_point_2m": 17.1,
                "apparent_temperature": 27.3,
                "precipitation_probability": 15.0,
                "weather_code": 2,
                "surface_pressure": 1013.2,
                "visibility": 10000.0,
                "wind_speed_10m": 12.4,
                "wind_direction_10m": 180.0,
            },
            {
                "time": "2026-06-25 13:00:00",
                "temperature_2m": 26.1,
                "relative_humidity_2m": 60.0,
                "dew_point_2m": 17.3,
                "apparent_temperature": 28.0,
                "precipitation_probability": 10.0,
                "weather_code": 1,
                "surface_pressure": 1012.9,
                "visibility": 10000.0,
                "wind_speed_10m": 14.1,
                "wind_direction_10m": 185.0,
            },
        ],
        "daily_conditions": [
            {
                "time": "2026-06-25 00:00:00",
                "temperature_2m_max": 29.5,
                "temperature_2m_min": 19.0,
                "sunrise": "2026-06-25 06:12:00",
                "sunset": "2026-06-25 19:45:00",
                "uv_index_max": 6,
            },
            {
                "time": "2026-06-26 00:00:00",
                "temperature_2m_max": 30.0,
                "temperature_2m_min": 20.1,
                "sunrise": "2026-06-26 06:13:00",
                "sunset": "2026-06-26 19:45:00",
                "uv_index_max": 7,
            },
        ],
        "metadata": {
            "latitude": 24.8607,
            "longitude": 67.0011,
            "extract_time_ms": 145.23,
            "utc_offset_secs": 18000,
            "timezone": "Asia/Karachi",
            "timezone_abbr": "PKT",
            "elevation": 8.0,
        },
        "current_units": {
            "time": "iso8601",
            "interval": "seconds",
            "temperature_2m": "°C",
            "relative_humidity_2m": "%",
        },
        "hourly_units": {
            "time": "iso8601",
            "temperature_2m": "°C",
            "precipitation_probability": "%",
        },
        "daily_units": {
            "time": "iso8601",
            "temperature_2m_max": "°C",
            "sunrise": "iso8601",
        },
    }

    result = stage_data(mock_data, mock_engine)

    assert result == {
        "current_conditions": "weather_current_raw",
        "hourly_conditions": "weather_hourly_raw",
        "daily_conditions": "weather_daily_raw",
        "metadata": "weather_metadata",
        "units": "weather_units_raw",
    }


def test_load_raw_transform_with_broken_schema_ref():
    broken_schema_ref = {
        "current_conditions": "weather_hourly_raw",
        "hourly_conditions": "weather_current_raw",
        "daily_conditions": "weather_metadata",
        "metadata": "weather_daily_raw",
    }

    engine = create_engine(
        f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{TEST_POSTGRES_DB}"
    )

    result = load_raw(raw_schema_reference=broken_schema_ref, engine=engine)

    assert isinstance(result, dict)

def test_load_raw_transform_with_empty_schema_ref():
    empty_schema_ref = {
        "current_conditions": "",
        "hourly_conditions": "",
        "daily_conditions": "",
        "metadata": "",
        "units": "",
    }

    engine = create_engine(
        f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{TEST_POSTGRES_DB}"
    )

    result = load_raw(raw_schema_reference=empty_schema_ref, engine=engine)

    assert isinstance(result, dict)

def test_load_raw_transform_with_broken_engine_and_good_schema_ref():
    mock_engine = Mock()
    mock_engine.engine = ""

    schema_ref = {
        "current_conditions": "weather_current_raw",
        "hourly_conditions": "weather_hourly_raw",
        "daily_conditions": "weather_daily_raw",
        "metadata": "weather_metadata",
        "units": "weather_units_raw",
    }

    result = load_raw(raw_schema_reference=schema_ref, engine=mock_engine.engine)

    assert isinstance(result, dict)

def test_load_raw_transform_with_broken_engine_and_schema_ref():
    mock_engine = Mock()
    mock_engine.engine = ""

    broken_schema_ref = {
        "current_conditions": "weather_hourly_raw",
        "hourly_conditions": "weather_current_raw",
        "daily_conditions": "weather_metadata",
        "metadata": "weather_daily_raw",
    }

    result = load_raw(raw_schema_reference=broken_schema_ref, engine=mock_engine.engine)

    assert isinstance(result, dict)

def test_empty_raw_data_in_clean_data_input():
    from src.ELT.transform import clean_data

    empty_data = {
        "current_conditions": "",
        "hourly_conditions": "",
        "daily_conditions": "",
        "metadata": "",
        "units": "",
    }

    result = clean_data(empty_data)

    assert isinstance(result, dict)

def test_clean_data_func_with_empty_dict():
    from src.ELT.transform import clean_data

    empty_dict = {}

    result = clean_data(empty_dict)

    assert isinstance(result, dict)