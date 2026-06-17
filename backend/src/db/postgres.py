import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from urllib.parse import quote_plus


load_dotenv()

USERNAME = os.getenv("POSTGRES_USER")
PASSWORD = os.getenv("POSTGRES_PASSWORD")
PASSWORD = quote_plus(PASSWORD)
HOST = os.getenv("POSTGRES_HOST", "elt-db")
PORT = 5432

engine = create_engine(
    f"postgresql+psycopg2://{USERNAME}:{PASSWORD}@{HOST}:5432/elt_db"
)