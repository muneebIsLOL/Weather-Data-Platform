from services.weather_service import get_today, get_daily_forecast
from models.daily_conditions import DailyConditionsResponse
from typing import List
from fastapi import APIRouter


router = APIRouter(prefix="/daily")

@router.get("/today", response_model=List[DailyConditionsResponse])
def today_weather():
    try:
        response = get_today()
        return response

    except Exception as e:
        print("Pydantic Model Validation Error at /daily_weather")
        raise e

@router.get("/forecast", response_model=List[DailyConditionsResponse])
def daily_weather_forecast():
    try:
        response = get_daily_forecast()
        return response

    except Exception as e:
        print("Pydantic Model Validation Error at /daily_weather")
        raise e