#!/bin/bash
set -e

docker compose -f docker-compose.app.yml --env-file .env.production up --build

docker compose -f airflow/docker-compose.airflow.yml --env-file .env.production up --build