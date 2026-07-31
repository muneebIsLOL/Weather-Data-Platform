from typing import Optional
import datetime
from src.db.base import Base

from sqlalchemy import BigInteger, DateTime, Identity, PrimaryKeyConstraint, text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column

class UnitsRaw(Base):
    __tablename__ = 'weather_units_raw'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='weather_units_raw_pkey'),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True, start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True, autoincrement=True)
    time: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime, server_default=text('now()'))
    current_units: Mapped[Optional[dict]] = mapped_column(JSONB)
    hourly_units: Mapped[Optional[dict]] = mapped_column(JSONB)
    daily_units: Mapped[Optional[dict]] = mapped_column(JSONB)
