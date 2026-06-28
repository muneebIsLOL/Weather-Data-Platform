import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from urllib.parse import quote_plus

def get_engine(env_file=None):
    load_dotenv(env_file)

    USERNAME = os.getenv("POSTGRES_USER")
    PASSWORD = os.getenv("POSTGRES_PASSWORD")
    PASSWORD = quote_plus(PASSWORD)
    HOST = os.getenv("POSTGRES_HOST", "elt-db")
    DB = os.getenv("POSTGRES_DB")
    PORT = 5432

    engine = create_engine(
        f"postgresql+psycopg2://{USERNAME}:{PASSWORD}@{HOST}:{PORT}/{DB}"
    )

    return engine