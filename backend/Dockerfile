FROM python:3.14-slim

WORKDIR /app

COPY ./requirements/ ./requirements

RUN pip install --upgrade pip
RUN pip install -r ./requirements/base.txt -r ./requirements/api.txt

COPY backend/src/api/ ./src/api
COPY backend/src/db/ ./src/db

RUN chmod +x ./src/db/scripts/migrations.sh

CMD ["python", "-m", "uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000"]