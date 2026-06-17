from services.weather_service import get_current
from models.current_conditions import CurrentConditionsResponse
from fastapi import APIRouter


router = APIRouter()

@router.get("/current_weather", response_model=CurrentConditionsResponse)
def current_weather():
    try:
        response = get_current()
        return response

    except Exception as e:
        print("Pydantic Model Validation Error at /current_weather")
        raise e
    