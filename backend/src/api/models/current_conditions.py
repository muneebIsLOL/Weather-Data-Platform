from pydantic import BaseModel
from datetime import datetime

class CurrentConditionsResponse(BaseModel):
    time: datetime
    apparent_temp: float
    temperature: float
    relative_humidity: float
    is_day: int
    wind_speed: float
    wind_direction: str
    surface_pressure: float
    feels_like: str