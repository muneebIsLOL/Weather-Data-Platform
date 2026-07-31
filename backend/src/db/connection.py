import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError


def get_engine(cert_path: str):
    load_dotenv()

    POSTGRES_PASSWORD = os.getenv("APP_POSTGRES_PASSWORD")
    POSTGRES_USER = os.getenv("APP_POSTGRES_USER")
    DB_HOST = os.getenv("APP_DB_HOST")
    DB_NAME = os.getenv("APP_DB_NAME")
    try:
        engine = create_engine(
            f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{DB_HOST}:5432/{DB_NAME}",
            connect_args={
                "sslmode": "verify-full",
                "sslrootcert": cert_path,
                "connect_timeout": 5,
            },
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