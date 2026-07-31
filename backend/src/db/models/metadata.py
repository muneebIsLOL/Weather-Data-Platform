from typing import Optional
import datetime
from src.db.base import Base

from sqlalchemy import BigInteger, CheckConstraint, DateTime, Double, Identity, Integer, PrimaryKeyConstraint, REAL, Text, UniqueConstraint, text
from sqlalchemy.orm import Mapped, mapped_column


class MetadataRaw(Base):
    __tablename__ = 'metadata'
    __table_args__ = (
        CheckConstraint("elevation >= '-500'::integer::double precision AND elevation <= 9000::double precision", name='metadata_elevation_check'),
        CheckConstraint('extract_time_ms >= 0::double precision', name='metadata_extract_time_ms_check'),
        CheckConstraint("latitude >= '-90'::integer::double precision AND latitude <= 90::double precision", name='metadata_latitude_check'),
        CheckConstraint("longitude >= '-180'::integer::double precision AND longitude <= 180::double precision", name='metadata_longitude_check'),
        PrimaryKeyConstraint('id', name='metadata_pkey'),
        UniqueConstraint('time', name='metadata_time_key')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    time: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    timezone: Mapped[str] = mapped_column(Text, nullable=False)
    timezone_abbr: Mapped[str] = mapped_column(Text, nullable=False)
    latitude: Mapped[Optional[float]] = mapped_column(REAL)
    longitude: Mapped[Optional[float]] = mapped_column(REAL)
    extract_time_ms: Mapped[Optional[float]] = mapped_column(REAL)
    utc_offset_secs: Mapped[Optional[float]] = mapped_column(REAL)
    elevation: Mapped[Optional[float]] = mapped_column(REAL)

class Metadata(Base):
    __tablename__ = 'weather_metadata'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='weather_metadata_pkey'),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    utc_offset_secs: Mapped[int] = mapped_column(Integer, nullable=False)
    time: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime, server_default=text('now()'))
    latitude: Mapped[Optional[float]] = mapped_column(Double(53))
    longitude: Mapped[Optional[float]] = mapped_column(Double(53))
    extract_time_ms: Mapped[Optional[float]] = mapped_column(Double(53))
    timezone: Mapped[Optional[str]] = mapped_column(Text)
    timezone_abbr: Mapped[Optional[str]] = mapped_column(Text)
    elevation: Mapped[Optional[float]] = mapped_column(REAL)
