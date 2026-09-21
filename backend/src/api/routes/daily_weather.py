from src.api.services.weather_service import get_today, get_daily_forecast
from src.api.models.daily_conditions import DailyConditionsResponse
from typing import List
from fastapi import APIRouter
from pydantic import ValidationError, TypeAdapter
from src.db.connection import get_engine
from fastapi.exceptions import HTTPException

router = APIRouter(prefix="/daily")


@router.get("/today", tags=["today"])
def today_weather():
    try:
        engine = get_engine()
        response = get_today(engine)
        return TypeAdapter(List[DailyConditionsResponse]).validate_python(response)


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


@router.get("/forecast", tags=["forecast"])
def daily_weather_forecast():
    try:
        engine = get_engine()
        response = get_daily_forecast(engine)
        return TypeAdapter(List[DailyConditionsResponse]).validate_python(response)

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
