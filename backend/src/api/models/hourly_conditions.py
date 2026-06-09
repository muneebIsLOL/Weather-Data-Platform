from pydantic import BaseModel

class HourlyConditionsResponse(BaseModel):
    time: str
    temperature_2m: float
    relative_humidity_2m: float
    dew_point_2m: float
    apparent_temperature: float
    precipitation_probability: float
    weather_code: int
    surface_pressure: float
    visibility: float
    wind_speed_10m: float
    wind_direction_10m: float
    feels_like: str
    wind_direction_cardinal: str
    is_day: int