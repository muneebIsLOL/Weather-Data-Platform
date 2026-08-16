import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from urllib.parse import quote_plus


def get_engine():
    load_dotenv()

    POSTGRES_PASSWORD = quote_plus(os.getenv("APP_POSTGRES_PASSWORD"))
    POSTGRES_USER = os.getenv("APP_POSTGRES_USER")
    DB_HOST = os.getenv("APP_DB_HOST")
    DB_NAME = os.getenv("APP_DB_NAME")
    CERT_PATH = os.getenv("APP_DB_CERT_PATH")

    try:
        connect_args = {}

        if CERT_PATH:
            connect_args = {
                "sslmode": "verify-full",
                "sslrootcert": CERT_PATH,
                "connect_timeout": 5,
            }

        engine = create_engine(
            f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}"
            f"@{DB_HOST}:5432/{DB_NAME}",
            connect_args=connect_args,
            pool_pre_ping=True,
        )

        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))

        return engine

    except SQLAlchemyError as e:
        print(f"Database error: {e}")
        raise e

    except Exception as e:
        print(f"Error {e}")
        raise e
