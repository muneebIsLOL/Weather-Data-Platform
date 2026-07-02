# Weather Data Platform

## Overview
A production-style, containerized data engineering platform built with Apache Airflow, FastAPI, PostgreSQL, and Docker. The platform automates weather data ingestion, transformation, validation, and storage through ELT pipelines, while exposing processed data through Fastapi APIs and an interactive frontend dashboard.

## Features
- Automatically extracts weather from the `Open-Meteo` api.
- Orchestrates an end-to-end ELT pipeline using an orchestrator library.
- Separates raw and processed weather datasets.
- Validates weather data before loading it into the database.
- Stores weather information in a structured PostgreSQL database.
- Exposes processed weather data through RESTful API endpoints.
- Displays weather information in a responsive dashboard.
- Supports current, hourly, and daily weather forecasts.
- Maintains local backups of extracted datasets.
- Runs as a fully containerized application for consistent deployment.

## Core Stack & Tools
### Frontend
- React
- Vue
- Vanilla CSS

### Backend
- FastAPI
- Pydantic

### Database
- PostgreSQL
- SQLAlchemy

### Data Engineering
- Apache Airflow
- ELT Pipeline

### Data Source
- Open-Meteo API

### Containerization
- Docker
- Docker Compose

### Testing
- Pytest

### CI/CD
- GitHub Actions

## Step-by-Step Setup

### Prerequisites
- Docker
- Docker Compose
- Git

### Clone the Repository
```git clone github.com/muneebIsLOL/Weather-Data-Platform```

### Configure the Environment Files & Variables
- After cloning the repo, grab the variables from `.env.example`.
- Make an environment file and name it `.env.production`.
- Paste the variables from `.env.example` and tailor it according to your needs.

### Configure the Docker
- Run the following cmd:
- `docker compose -f docker-compose.app.yml --env_file .env.production up --build`
- Similarly run the airflow compose:
- `docker compose -f airflow/docker-compose.airflow.yml --env_file .env.production up --build`

### Access the application (Frontend)
- Open up your browser and type:
- `localhost:5173` 

If the application loads successfully, the Weather Data Platform has been deployed correctly and is ready to use.

For component-specific information, refer to:

backend/README.md
frontend/README.md