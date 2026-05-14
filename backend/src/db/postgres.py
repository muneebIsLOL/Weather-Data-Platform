import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from urllib.parse import quote_plus


load_dotenv()

USERNAME = os.getenv("USER_NAME")
PASSWORD = os.getenv("PASSWORD")
PASSWORD = quote_plus(PASSWORD)

engine = create_engine(
    f"postgresql+psycopg2://{USERNAME}:{PASSWORD}@localhost:5432/etl_db"
)