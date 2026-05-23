from pydantic import BaseModel
from datetime import datetime

class DailyConditionsResponse(BaseModel):
    time: datetime
    temperature_2m_max: float
    temperature_2m_min: float
    sunrise: datetime
    sunset: datetime
    uv_index_max: float

