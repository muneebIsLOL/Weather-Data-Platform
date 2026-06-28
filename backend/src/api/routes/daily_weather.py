from src.api.services.weather_service import get_today, get_daily_forecast
from src.api.models.daily_conditions import DailyConditionsResponse
from typing import List
from fastapi import APIRouter
from pydantic import ValidationError
from src.db.postgres import get_engine

router = APIRouter(prefix="/daily", tags=["daily"])


@router.get("/today", response_model=List[DailyConditionsResponse], tags=["today"])
def today_weather():
    try:
        engine = get_engine()
        response = get_today(engine)
        return response

    except ValidationError as e:
        print("Pydantic Model Validation Error at /daily_weather")
        raise e

    except ValueError as e:
        return []


@router.get(
    "/forecast", response_model=List[DailyConditionsResponse], tags=["forecast"]
)
def daily_weather_forecast():
    try:
        engine = get_engine()
        response = get_daily_forecast(engine)
        return response

    except ValidationError as e:
        print("Pydantic Model Validation Error at /daily_weather")
        raise e

    except ValueError as e:
        return []