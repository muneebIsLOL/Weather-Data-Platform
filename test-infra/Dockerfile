FROM python:3.14

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./requirements ./requirements

RUN pip install --upgrade pip && pip install -r ./requirements/base.txt -r ./requirements/api.txt

COPY ./backend/src/tests ./tests

COPY ./backend/src/api ./src/api

COPY ./backend/src/db/connection.py ./src/connection.py

COPY ./test-infra/test_db_init.sh ./test_db_init.sh

RUN chmod +x ./test_db_init.sh

ENTRYPOINT ["./test_db_init.sh"]

CMD ["python", "-m", "pytest"]