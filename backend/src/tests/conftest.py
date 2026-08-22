from sqlalchemy import text
import pytest
from datetime import datetime, timedelta
from src.connection import get_engine


@pytest.fixture(scope="module")
def populate_db_data():
    today = datetime.today().date()

    engine = get_engine()

    with engine.connect() as connection:
        connection.execute(text(f"""
            INSERT INTO public.current_conditions (
                time,
                weather_code,
                apparent_temperature,
                temperature_2m,
                relative_humidity_2m,
                is_day,
                wind_speed_10m,
                surface_pressure,
                feels_like
            )
            VALUES (
                '{today}',
                3,
                34.2,
                32.8,
                68.0,
                1,
                14.5,
                1002.4,
                'Overcast'
            );
            INSERT INTO public.hourly_conditions (
                time,
                temperature_2m,
                relative_humidity_2m,
                dew_point_2m,
                apparent_temperature,
                precipitation_probability,
                weather_code,
                surface_pressure,
                visibility,
                wind_speed_10m,
                wind_direction_10m,
                feels_like,
                wind_direction_cardinal
            )
            VALUES
            ('{today} 00:00:00+00', 28.1, 78.0, 24.0, 29.0, 10.0, 2, 1005.2, 10000, 10.2, 330, 'Partly cloudy', 'NW'),
            ('{today} 01:00:00+00', 27.8, 79.0, 23.9, 28.7, 10.0, 2, 1005.0, 10000, 9.8, 325, 'Partly cloudy', 'NW'),
            ('{today} 02:00:00+00', 27.5, 80.0, 23.8, 28.4, 10.0, 3, 1004.8, 10000, 9.5, 320, 'Overcast', 'NW'),
            ('{today} 03:00:00+00', 27.3, 81.0, 23.7, 28.2, 15.0, 3, 1004.7, 9000, 9.2, 315, 'Overcast', 'NW'),
            ('{today} 04:00:00+00', 27.1, 82.0, 23.6, 28.0, 15.0, 3, 1004.5, 9000, 8.8, 310, 'Overcast', 'NW'),
            ('{today} 05:00:00+00', 27.0, 83.0, 23.5, 27.9, 20.0, 3, 1004.4, 9000, 8.5, 305, 'Overcast', 'NW'),
            ('{today} 06:00:00+00', 27.2, 82.0, 23.6, 28.1, 15.0, 2, 1004.6, 10000, 8.7, 300, 'Partly cloudy', 'NW'),
            ('{today} 07:00:00+00', 28.0, 79.0, 23.8, 29.0, 10.0, 2, 1005.0, 10000, 9.5, 295, 'Partly cloudy', 'NW'),
            ('{today} 08:00:00+00', 29.1, 75.0, 24.2, 30.2, 10.0, 1, 1005.4, 10000, 10.5, 290, 'Mainly clear', 'WNW'),
            ('{today} 09:00:00+00', 30.2, 71.0, 24.5, 31.5, 5.0, 1, 1005.8, 10000, 11.5, 285, 'Mainly clear', 'WNW'),
            ('{today} 10:00:00+00', 31.1, 68.0, 24.5, 32.6, 5.0, 0, 1006.0, 10000, 12.5, 280, 'Clear sky', 'W'),
            ('{today} 11:00:00+00', 32.0, 65.0, 24.4, 33.5, 5.0, 0, 1005.8, 10000, 13.5, 275, 'Clear sky', 'W'),
            ('{today} 12:00:00+00', 32.8, 63.0, 24.4, 34.2, 5.0, 0, 1005.4, 10000, 14.2, 270, 'Clear sky', 'W'),
            ('{today} 13:00:00+00', 33.4, 61.0, 24.4, 34.8, 5.0, 1, 1004.9, 10000, 15.0, 265, 'Mainly clear', 'W'),
            ('{today} 14:00:00+00', 33.7, 60.0, 24.6, 35.1, 10.0, 1, 1004.5, 10000, 15.8, 260, 'Mainly clear', 'W'),
            ('{today} 15:00:00+00', 33.5, 61.0, 24.7, 34.9, 10.0, 2, 1004.2, 10000, 16.2, 255, 'Partly cloudy', 'WSW'),
            ('{today} 16:00:00+00', 33.1, 63.0, 24.8, 34.5, 15.0, 2, 1004.0, 10000, 16.0, 250, 'Partly cloudy', 'WSW'),
            ('{today} 17:00:00+00', 32.5, 65.0, 24.7, 33.9, 15.0, 3, 1004.1, 10000, 15.2, 245, 'Overcast', 'WSW'),
            ('{today} 18:00:00+00', 31.6, 68.0, 24.8, 33.0, 20.0, 3, 1004.5, 9000, 14.0, 240, 'Overcast', 'WSW'),
            ('{today} 19:00:00+00', 30.7, 71.0, 24.7, 32.1, 20.0, 3, 1004.9, 9000, 13.0, 235, 'Overcast', 'SW'),
            ('{today} 20:00:00+00', 30.0, 73.0, 24.6, 31.4, 15.0, 2, 1005.2, 10000, 12.2, 230, 'Partly cloudy', 'SW'),
            ('{today} 21:00:00+00', 29.4, 75.0, 24.5, 30.8, 15.0, 2, 1005.4, 10000, 11.5, 225, 'Partly cloudy', 'SW'),
            ('{today} 22:00:00+00', 28.9, 76.0, 24.4, 30.3, 10.0, 1, 1005.5, 10000, 10.8, 220, 'Mainly clear', 'SW'),
            ('{today} 23:00:00+00', 28.5, 77.0, 24.2, 29.9, 10.0, 1, 1005.4, 10000, 10.5, 215, 'Mainly clear', 'SW');
            INSERT INTO public.daily_conditions (
                time,
                temperature_2m_max,
                temperature_2m_min,
                sunrise,
                sunset,
                uv_index_max
            )
            VALUES
            (
                '{today}T00:00:00Z',
                34.5,
                27.0,
                '{today}T01:45:00Z',
                '{today}T14:20:00Z',
                8.7
            ),
            (
                '{today + timedelta(days=1)}T00:00:00Z',
                35.1,
                27.4,
                '{today + timedelta(days=1)}T01:45:00Z',
                '{today + timedelta(days=1)}T14:20:00Z',
                9.1
            ),
            (
                '{today + timedelta(days=2)}T00:00:00Z',
                35.6,
                27.8,
                '{today + timedelta(days=2)}T01:44:00Z',
                '{today + timedelta(days=2)}T14:21:00Z',
                9.4
            ),
            (
                '{today + timedelta(days=3)}T00:00:00Z',
                34.8,
                27.2,
                '{today + timedelta(days=3)}T01:44:00Z',
                '{today + timedelta(days=3)}T14:21:00Z',
                8.9
            ),
            (
                '{today + timedelta(days=4)}T00:00:00Z',
                33.9,
                26.8,
                '{today + timedelta(days=4)}T01:43:00Z',
                '{today + timedelta(days=4)}T14:22:00Z',
                8.2
            ),
            (
                '{today + timedelta(days=5)}T00:00:00Z',
                34.2,
                27.1,
                '{today + timedelta(days=5)}T01:43:00Z',
                '{today + timedelta(days=5)}T14:22:00Z',
                8.5
            ),
            (
                '{today + timedelta(days=6)}T00:00:00Z',
                35.0,
                27.5,
                '{today + timedelta(days=6)}T01:42:00Z',
                '{today + timedelta(days=6)}T14:23:00Z',
                8.8
            );
        """))
        connection.commit()

    yield

    with engine.connect() as connection:
        connection.execute(text("""
                    TRUNCATE TABLE current_conditions;
                    TRUNCATE TABLE hourly_conditions;
                    TRUNCATE TABLE daily_conditions;
                """))
        connection.commit()
        connection.close()
