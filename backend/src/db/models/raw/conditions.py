from typing import Optional
import datetime
from src.db.base import Base

from sqlalchemy import BigInteger, DateTime, Identity, PrimaryKeyConstraint, REAL, SmallInteger, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column

class CurrentConditionsRaw(Base):
    __tablename__ = 'weather_current_raw'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='weather_current_raw_pkey'),
        UniqueConstraint('time', name='weather_current_raw_time_key')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    is_day: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    time: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime)
    interval: Mapped[Optional[int]] = mapped_column(SmallInteger)
    apparent_temperature: Mapped[Optional[float]] = mapped_column(REAL)
    temperature_2m: Mapped[Optional[float]] = mapped_column(REAL)
    relative_humidity_2m: Mapped[Optional[float]] = mapped_column(REAL)
    weather_code: Mapped[Optional[int]] = mapped_column(SmallInteger)
    wind_speed_10m: Mapped[Optional[float]] = mapped_column(REAL)
    surface_pressure: Mapped[Optional[float]] = mapped_column(REAL)

class DailyConditionsRaw(Base):
    __tablename__ = 'weather_daily_raw'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='weather_daily_raw_pkey'),
        UniqueConstraint('time', name='weather_daily_raw_time_key')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    temperature_2m_max: Mapped[float] = mapped_column(REAL, nullable=False)
    temperature_2m_min: Mapped[float] = mapped_column(REAL, nullable=False)
    sunrise: Mapped[datetime.datetime] = mapped_column(DateTime, nullable=False)
    sunset: Mapped[datetime.datetime] = mapped_column(DateTime, nullable=False)
    time: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime)
    uv_index_max: Mapped[Optional[int]] = mapped_column(SmallInteger)


class HourlyConditionsRaw(Base):
    __tablename__ = 'weather_hourly_raw'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='weather_hourly_raw_pkey'),
        UniqueConstraint('time', name='weather_hourly_raw_time_key')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    temperature_2m: Mapped[float] = mapped_column(REAL, nullable=False)
    relative_humidity_2m: Mapped[float] = mapped_column(REAL, nullable=False)
    dew_point_2m: Mapped[float] = mapped_column(REAL, nullable=False)
    precipitation_probability: Mapped[float] = mapped_column(REAL, nullable=False)
    weather_code: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    surface_pressure: Mapped[float] = mapped_column(REAL, nullable=False)
    visibility: Mapped[float] = mapped_column(REAL, nullable=False)
    wind_speed_10m: Mapped[float] = mapped_column(REAL, nullable=False)
    wind_direction_10m: Mapped[float] = mapped_column(REAL, nullable=False)
    time: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime)
    apparent_temperature: Mapped[Optional[float]] = mapped_column(REAL)
