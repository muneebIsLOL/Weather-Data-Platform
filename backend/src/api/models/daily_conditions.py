from pydantic import BaseModel

class DailyConditionsResponse(BaseModel):
    time: str
    temperature_2m_max: float
    temperature_2m_min: float
    sunrise: str
    sunset: str
    uv_index_max: float

