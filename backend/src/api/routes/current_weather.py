from src.api.services.weather_service import get_current
from src.api.models.current_conditions import CurrentConditionsResponse
from fastapi import APIRouter
from src.db.connection import get_engine
from pydantic import ValidationError
from fastapi.exceptions import HTTPException

router = APIRouter()


@router.get(
    "/current_weather",
    tags=["current_weather"],
)
def current_weather():
    try:
        engine = get_engine()
        response = get_current(engine)
        return CurrentConditionsResponse(
            **response if isinstance(response, dict) else response.__dict__
        )

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
