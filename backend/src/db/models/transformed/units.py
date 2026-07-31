from sqlalchemy import Column, Table, Text, Integer
from src.db.base import Base

t_current_units = Table(
    'current_units', Base.metadata,
    Column("id", Integer, primary_key=True),
    Column('time', Text),
    Column('is_day', Text),
    Column('interval', Text),
    Column('relative_humidity_2m', Text),
    Column('weather_code', Text),
    Column('temperature_2m', Text),
    Column('wind_speed_10m', Text),
    Column('surface_pressure', Text),
    Column('apparent_temperature', Text)
)

t_daily_units = Table(
    'daily_units', Base.metadata,
    Column("id", Integer, primary_key=True),
    Column('time', Text),
    Column('sunrise', Text),
    Column('sunset', Text),
    Column('uv_index_max', Text),
    Column('temperature_2m_max', Text),
    Column('temperature_2m_min', Text)
)

t_hourly_units = Table(
    'hourly_units', Base.metadata,
    Column("id", Integer, primary_key=True),
    Column('time', Text),
    Column('visibility', Text),
    Column('dew_point_2m', Text),
    Column('weather_code', Text),
    Column('temperature_2m', Text),
    Column('wind_speed_10m', Text),
    Column('surface_pressure', Text),
    Column('wind_direction_10m', Text),
    Column('apparent_temperature', Text),
    Column('relative_humidity_2m', Text),
    Column('precipitation_probability', Text)
)