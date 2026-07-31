#!/bin/bash

set -e

echo "==> Running pre-flight database checks..."

python -m src.db.scripts.test_db

echo "==> Running Alembic migrations..."
python -m alembic -c /app/src/db/alembic.ini upgrade head

echo "==> Database migrations successful."
