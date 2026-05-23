from src.api.services.weather_service import get_current
from src.api.models.current_conditions import CurrentConditionsResponse
from fastapi import APIRouter, Depends
from typing import List


router = APIRouter()

@router.get("/current_weather", response_model=List[CurrentConditionsResponse])
def current_weather():
    try:
        response = get_current()
        return response

    except Exception as e:
        print("Pydantic Model Validation Error at /current_weather")
        raise e