from src.api.services.weather_service import get_hourly
from src.api.models.hourly_conditions import HourlyConditionsResponse
from fastapi import APIRouter
from typing import List
from src.db.connection import get_engine
from pydantic import ValidationError, TypeAdapter
from fastapi.exceptions import HTTPException

router = APIRouter()


@router.get(
    "/hourly_weather",
    tags=["hourly_weather"],
)
def hourly_weather():
    try:
        engine = get_engine()
        response = get_hourly(engine)
        return TypeAdapter(List[HourlyConditionsResponse]).validate_python(response)
    
    except ValidationError as e:
        raise HTTPException(
            status_code=500,
            detail="Invalid Data Found. Please try again in next 10-15 minutes.",
        )
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail="An unexpected error occurred on our servers. Please try your request again later.",
        )
