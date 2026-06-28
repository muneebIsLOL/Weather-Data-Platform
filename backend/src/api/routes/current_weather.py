from src.api.services.weather_service import get_current
from src.api.models.current_conditions import CurrentConditionsResponse
from fastapi import APIRouter
from src.db.postgres import get_engine
from pydantic import ValidationError

router = APIRouter()


@router.get(
    "/current_weather",
    response_model=CurrentConditionsResponse,
    tags=["current_weather"],
)
def current_weather():
    try:
        engine = get_engine()
        response = get_current(engine)
        return response

    except ValidationError as e:
        print("Pydantic Model Validation Error at /current_weather")
        raise e

    except ValueError as e:
        return {}