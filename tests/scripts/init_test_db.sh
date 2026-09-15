#!/bin/bash

set -e 

echo "Waiting for Database..."

until
    pg_isready -h backend-db -U "$APP_POSTGRES_USER" -d postgres
do 
    echo "Waiting for backend-db container..."
    sleep 2
done

echo "Connecting to Database..."

if PGPASSWORD="$APP_POSTGRES_PASSWORD" psql -h backend-db -U "$APP_POSTGRES_USER" -d postgres -lqt | cut -d \| -f 1 | grep -qw "$APP_TEST_POSTGRES_DB"; then
    echo "Database '$APP_TEST_POSTGRES_DB' already exists."
else
    echo "Database '$APP_TEST_POSTGRES_DB' does not exist. Creating it now..."
    PGPASSWORD="$APP_POSTGRES_PASSWORD" psql -h backend-db -U "$APP_POSTGRES_USER" -d postgres -c "CREATE DATABASE \"$APP_TEST_POSTGRES_DB\";"
fi

echo "Copying schema from source database..."
PGPASSWORD="$APP_POSTGRES_PASSWORD" pg_dump --clean -h backend-db -U "$APP_POSTGRES_USER" -s -d "$APP_DB_NAME" | PGPASSWORD="$APP_POSTGRES_PASSWORD" psql -h backend-db -U "$APP_POSTGRES_USER" -d "$APP_TEST_POSTGRES_DB"

echo "Schema migration complete."

exec "$@"