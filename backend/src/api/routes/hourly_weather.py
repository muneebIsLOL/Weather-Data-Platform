from services.weather_service import get_hourly
from models.hourly_conditions import HourlyConditionsResponse
from fastapi import APIRouter
from typing import List


router = APIRouter()

@router.get("/hourly_weather", response_model=List[HourlyConditionsResponse])
def current_weather():
    try:
        response = get_hourly()
        return response

    except Exception as e:
        print("Pydantic Model Validation Error at /hourly_weather")
        raise e