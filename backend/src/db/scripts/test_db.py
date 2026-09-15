import sys, time
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os


def verify_connection():
    load_dotenv()
    POSTGRES_USER = os.getenv("APP_POSTGRES_USER")
    POSTGRES_PASSWORD = os.getenv("APP_POSTGRES_PASSWORD")
    DB_HOST = os.getenv("APP_DB_HOST")
    DB_NAME = os.getenv("APP_DB_NAME")
    CERT_PATH = os.getenv("APP_DB_CERT_PATH")

    print("Checking Database Connection...")

    for attempt in range(1, 6):
        try:
            connect_args = {}

            if CERT_PATH:
                connect_args = {
                    "sslmode": "verify-full",
                    "sslrootcert": CERT_PATH,
                    "connect_timeout": 5,
                }
            engine = create_engine(
                f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{DB_HOST}:5432/{DB_NAME}",
                connect_args=connect_args,
            )
            with engine.connect() as conn:
                print("Database connection verified successfully.")
                sys.exit(0)
        except Exception as e:
            print(f"Attempt {attempt}/5 failed: Database not ready yet. {e}")
            time.sleep(3)
    print("Error: Could not connect to the database after 5 attempts.")
    sys.exit(1)


if __name__ == "__main__":
    verify_connection()
