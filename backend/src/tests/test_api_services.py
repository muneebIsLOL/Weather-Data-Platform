from sqlalchemy import create_engine
import os

POSTGRES_USER = os.environ.get("POSTGRES_USER")
POSTGRES_PASSWORD = os.environ.get("POSTGRES_PASSWORD")
TEST_POSTGRES_DB = os.environ.get("TEST_POSTGRES_DB")
POSTGRES_HOST = os.environ.get("POSTGRES_HOST")


def test_hourly_weather_service():
    from src.api.services.weather_service import get_hourly

    engine = create_engine(
        f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{TEST_POSTGRES_DB}"
    )

    assert get_hourly(engine)


def test_current_weather_service():
    from src.api.services.weather_service import get_current

    engine = create_engine(
        f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{TEST_POSTGRES_DB}"
    )

    assert get_current(engine)


def test_today_weather_service():
    from src.api.services.weather_service import get_today

    engine = create_engine(
        f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{TEST_POSTGRES_DB}"
    )

    assert get_today(engine)


def test_forecast_weather_service():
    from src.api.services.weather_service import get_daily_forecast

    engine = create_engine(
        f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{TEST_POSTGRES_DB}"
    )

    assert get_daily_forecast(engine)
