from src.api.services.weather_service import get_hourly
from src.api.models.hourly_conditions import HourlyConditionsResponse
from fastapi import APIRouter
from typing import List
from src.db.postgres import get_engine
from pydantic import ValidationError

router = APIRouter()


@router.get(
    "/hourly_weather",
    response_model=List[HourlyConditionsResponse],
    tags=["hourly_weather"],
)
def hourly_weather():
    try:
        engine = get_engine()
        response = get_hourly(engine)
        return response

    except ValidationError as e:
        print("Pydantic Model Validation Error at /hourly_weather")
        raise e

    except ValueError as e:
        return []
