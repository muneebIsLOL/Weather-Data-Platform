import pytest
from src.connection import get_engine

def test_hourly_weather_service():
    from src.api.services.weather_service import get_hourly

    engine = get_engine()
    with pytest.raises(ValueError):
        get_hourly(engine)


def test_current_weather_service():
    from src.api.services.weather_service import get_current

    engine = get_engine()
    with pytest.raises(ValueError):
        get_current(engine)


def test_today_weather_service():
    from src.api.services.weather_service import get_today

    engine = get_engine()
    with pytest.raises(ValueError):
        get_today(engine)


def test_forecast_weather_service():
    from src.api.services.weather_service import get_daily_forecast

    engine = get_engine()
    with pytest.raises(ValueError):
        get_daily_forecast(engine)
