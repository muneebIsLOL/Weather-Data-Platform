import pandera.pandas as pa
from pandera.typing.pandas import Series
from ELT.config.constants import WEATHER_CODES, cardinal_directions
import datetime


class CurrentConditions(pa.DataFrameModel):
    time: Series[datetime.datetime] = pa.Field(unique=True)
    apparent_temperature: Series[float] = pa.Field(gt=-80, lt=80)
    temperature_2m: Series[float] = pa.Field(ge=-80, le=80)
    relative_humidity_2m: Series[pa.Float16] = pa.Field(ge=0, le=100)
    is_day: Series[pa.Category] = pa.Field(isin=[0, 1])
    weather_code: Series[int] = pa.Field(isin=list(WEATHER_CODES.keys()))
    wind_speed_10m: Series[pa.Float16] = pa.Field(ge=0, le=400)
    surface_pressure: Series[float] = pa.Field(ge=700, le=1100)
    feels_like: Series[pa.Category] = pa.Field(
        isin=list(WEATHER_CODES.values()), raise_warning=True
    )


class HourlyConditions(pa.DataFrameModel):
    time: Series[datetime.datetime] = pa.Field(unique=True)

    temperature_2m: Series[float] = pa.Field(ge=-80, le=80)
    relative_humidity_2m: Series[pa.Float16] = pa.Field(ge=0, le=100)
    dew_point_2m: Series[float] = pa.Field(ge=-80, le=80)

    apparent_temperature: Series[float] = pa.Field(ge=-80, le=80)
    precipitation_probability: Series[float] = pa.Field(ge=0, le=100)

    weather_code: Series[int] = pa.Field(isin=list(WEATHER_CODES.keys()))

    surface_pressure: Series[float] = pa.Field(ge=700, le=1100)
    visibility: Series[float] = pa.Field(ge=0)

    wind_speed_10m: Series[pa.Float16] = pa.Field(ge=0, le=400)
    wind_direction_10m: Series[float] = pa.Field(ge=0, le=360)

    feels_like: Series[pa.Category] = pa.Field(
        isin=list(WEATHER_CODES.values()), nullable=True
    )

    wind_direction_cardinal: Series[pa.Category] = pa.Field(isin=cardinal_directions)


class DailyConditions(pa.DataFrameModel):
    time: Series[datetime.datetime] = pa.Field(unique=True)

    temperature_2m_max: Series[float] = pa.Field(ge=-80, le=80)
    temperature_2m_min: Series[float] = pa.Field(ge=-80, le=80)

    sunrise: Series[datetime.datetime]
    sunset: Series[datetime.datetime]

    uv_index_max: Series[float] = pa.Field(ge=0, le=20)


class Metadata(pa.DataFrameModel):
    time: Series[datetime.datetime] = pa.Field(unique=True)

    latitude: Series[float] = pa.Field(ge=-90, le=90)
    longitude: Series[float] = pa.Field(ge=-180, le=180)

    extract_time_ms: Series[float] = pa.Field(ge=0)

    utc_offset_secs: Series[int] = pa.Field(nullable=True)

    timezone: Series[str]
    timezone_abbr: Series[str]

    elevation: Series[float] = pa.Field(ge=-500, le=9000)


class CurrentUnits(pa.DataFrameModel):
    time: Series[str]

    is_day: Series[str]
    interval: Series[str]

    weather_code: Series[str]

    temperature_2m: Series[str]
    wind_speed_10m: Series[str]
    surface_pressure: Series[str]

    apparent_temperature: Series[str]


class HourlyUnits(pa.DataFrameModel):
    time: Series[str]
    visibility: Series[str]
    dew_point_2m: Series[str]

    weather_code: Series[str]

    temperature_2m: Series[str]
    wind_speed_10m: Series[str]
    surface_pressure: Series[str]

    wind_direction_10m: Series[str]

    apparent_temperature: Series[str]
    relative_humidity_2m: Series[str]
    precipitation_probability: Series[str]


class DailyUnits(pa.DataFrameModel):
    time: Series[str]

    sunrise: Series[str]
    sunset: Series[str]

    uv_index_max: Series[str]

    temperature_2m_max: Series[str]
    temperature_2m_min: Series[str]


def schema_validate(data: dict):
    try:
        validators = {
            "metadata": Metadata,
            "current_conditions": CurrentConditions,
            "hourly_conditions": HourlyConditions,
            "daily_conditions": DailyConditions,
            "current_units": CurrentUnits,
            "hourly_units": HourlyUnits,
            "daily_units": DailyUnits,
        }

        for key, value in data.items():
            data[key] = validators[key](value)
        return data
    except Exception as e:
        print("Schema Validation Error:")
        raise e
