from typing import Optional
import datetime
from src.db.base import Base

from sqlalchemy import BigInteger, CheckConstraint, DateTime, Identity, Integer, PrimaryKeyConstraint, REAL, SmallInteger, Text, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column


class CurrentConditions(Base):
    __tablename__ = 'current_conditions'
    __table_args__ = (
        CheckConstraint("apparent_temperature >= '-80'::integer::double precision AND apparent_temperature <= 80::double precision", name='current_conditions_apparent_temperature_check'),
        CheckConstraint('is_day = ANY (ARRAY[0, 1])', name='current_conditions_is_day_check'),
        CheckConstraint('relative_humidity_2m >= 0::double precision AND relative_humidity_2m <= 100::double precision', name='current_conditions_relative_humidity_2m_check'),
        CheckConstraint('surface_pressure >= 700::double precision AND surface_pressure <= 1100::double precision', name='current_conditions_surface_pressure_check'),
        CheckConstraint("temperature_2m >= '-80'::integer::double precision AND temperature_2m <= 80::double precision", name='current_conditions_temperature_2m_check'),
        CheckConstraint('wind_speed_10m >= 0::double precision AND wind_speed_10m <= 400::double precision', name='current_conditions_wind_speed_10m_check'),
        PrimaryKeyConstraint('id', name='current_conditions_pkey'),
        UniqueConstraint('time', name='current_conditions_time_key')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    time: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    weather_code: Mapped[int] = mapped_column(Integer, nullable=False)
    apparent_temperature: Mapped[Optional[float]] = mapped_column(REAL)
    temperature_2m: Mapped[Optional[float]] = mapped_column(REAL)
    relative_humidity_2m: Mapped[Optional[float]] = mapped_column(REAL)
    is_day: Mapped[Optional[int]] = mapped_column(SmallInteger)
    wind_speed_10m: Mapped[Optional[float]] = mapped_column(REAL)
    surface_pressure: Mapped[Optional[float]] = mapped_column(REAL)
    feels_like: Mapped[Optional[str]] = mapped_column(Text)

class DailyConditions(Base):
    __tablename__ = 'daily_conditions'
    __table_args__ = (
        CheckConstraint("temperature_2m_max >= '-80'::integer::double precision AND temperature_2m_max <= 80::double precision", name='daily_conditions_temperature_2m_max_check'),
        CheckConstraint("temperature_2m_min >= '-80'::integer::double precision AND temperature_2m_min <= 80::double precision", name='daily_conditions_temperature_2m_min_check'),
        CheckConstraint('uv_index_max >= 0::double precision AND uv_index_max <= 20::double precision', name='daily_conditions_uv_index_max_check'),
        PrimaryKeyConstraint('id', name='daily_conditions_pkey'),
        UniqueConstraint('time', name='daily_conditions_time_key')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    time: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    temperature_2m_max: Mapped[Optional[float]] = mapped_column(REAL)
    temperature_2m_min: Mapped[Optional[float]] = mapped_column(REAL)
    sunrise: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime(True))
    sunset: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime(True))
    uv_index_max: Mapped[Optional[float]] = mapped_column(REAL)

class HourlyConditions(Base):
    __tablename__ = 'hourly_conditions'
    __table_args__ = (
        CheckConstraint("apparent_temperature >= '-80'::integer::double precision AND apparent_temperature <= 80::double precision", name='hourly_conditions_apparent_temperature_check'),
        CheckConstraint("dew_point_2m >= '-80'::integer::double precision AND dew_point_2m <= 80::double precision", name='hourly_conditions_dew_point_2m_check'),
        CheckConstraint('precipitation_probability >= 0::double precision AND precipitation_probability <= 100::double precision', name='hourly_conditions_precipitation_probability_check'),
        CheckConstraint('relative_humidity_2m >= 0::double precision AND relative_humidity_2m <= 100::double precision', name='hourly_conditions_relative_humidity_2m_check'),
        CheckConstraint('surface_pressure >= 700::double precision AND surface_pressure <= 1100::double precision', name='hourly_conditions_surface_pressure_check'),
        CheckConstraint("temperature_2m >= '-80'::integer::double precision AND temperature_2m <= 80::double precision", name='hourly_conditions_temperature_2m_check'),
        CheckConstraint('visibility >= 0::double precision', name='hourly_conditions_visibility_check'),
        CheckConstraint('wind_direction_10m >= 0::double precision AND wind_direction_10m <= 360::double precision', name='hourly_conditions_wind_direction_10m_check'),
        CheckConstraint('wind_speed_10m >= 0::double precision AND wind_speed_10m <= 400::double precision', name='hourly_conditions_wind_speed_10m_check'),
        PrimaryKeyConstraint('id', name='hourly_conditions_pkey'),
        UniqueConstraint('time', name='hourly_conditions_time_key')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    time: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    temperature_2m: Mapped[Optional[float]] = mapped_column(REAL)
    relative_humidity_2m: Mapped[Optional[float]] = mapped_column(REAL)
    dew_point_2m: Mapped[Optional[float]] = mapped_column(REAL)
    apparent_temperature: Mapped[Optional[float]] = mapped_column(REAL)
    precipitation_probability: Mapped[Optional[float]] = mapped_column(REAL)
    weather_code: Mapped[Optional[int]] = mapped_column(Integer)
    surface_pressure: Mapped[Optional[float]] = mapped_column(REAL)
    visibility: Mapped[Optional[float]] = mapped_column(REAL)
    wind_speed_10m: Mapped[Optional[float]] = mapped_column(REAL)
    wind_direction_10m: Mapped[Optional[float]] = mapped_column(REAL)
    feels_like: Mapped[Optional[str]] = mapped_column(Text)
    wind_direction_cardinal: Mapped[Optional[str]] = mapped_column(Text)
