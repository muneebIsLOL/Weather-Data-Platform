# Backend

# Description
The backend powers the core functionality of the Weather Data Platform. It is responsible for orchestrating the ELT pipeline, managing data persistence, exposing RESTful API endpoints, and serving processed weather data to the frontend. This documentation covers the backend architecture, data flow, configuration, and development workflow.

# Core Technologies, Concepts, & Practices

## Database

This project uses a `PostgreSQL` database designed with a clean separation between raw API data and validated production data. 

### 1. Database Architecture
The schema is divided into two distinct logical layers to handle data safely:
*   **Raw Layer (`*_raw` tables):** A temporary landing area that saves exact, unfiltered data directly from the weather API. This prevents errors during data ingestion.
*   **Production Layer (`*_conditions` & `metadata` tables):** The clean, final data store. It formats timestamps correctly, runs data validations, and adds helpful calculated fields (like cardinal wind directions and "feels like" text).

---

### 2. Table Summary

#### Raw Staging Tables
*   **`weather_current_raw` / `weather_hourly_raw` / `weather_daily_raw`**: Store raw, untransformed weather readings over time.
*   **`weather_units_raw`**: Uses JSON storage to dynamically save measurement units directly from the API response.
*   **`weather_metadata`**: Logs tracking info like coordinates, timezones, and API extraction performance metrics.

#### Production Cleaned Tables
*   **`current_conditions` / `hourly_conditions` / `daily_conditions`**: Validated weather snapshots. They feature strict limits to block unrealistic numbers and include polished text metrics like `feels_like`.
*   **`metadata`**: Houses verified geographical data (latitude, longitude, elevation, and timezone shifts).
*   **`current_units` / `hourly_units` / `daily_units`**: Flat lookup tables keeping track of exactly which measurement units (e.g., °C, km/h) belong to which metrics.

---

### 3. Core Constraints & Data Integrity
To prevent corrupt data or duplicate records from breaking the application, the database enforces strict rules directly at the schema level:

*   **No Duplicates:** Every weather table enforces a `UNIQUE` constraint on the `time` field. This lets the backend safely update existing data without creating duplicate entries.
*   **Safety Check Ranges:** The production tables use database `CHECK` constraints to block bad API payloads. Examples include:
    *   **Temperatures:** Must stay between -80 and 80.
    *   **Humidity & Probability:** Restricted between 0% and 100%.
    *   **Wind Direction:** Kept strictly inside a 0 to 360-degree circle.
    *   **Coordinates:** Validates that Latitude stays within `[-90, 90]` and Longitude stays within `[-180, 180]`.

---

### 4. Database Connection & Engine Configuration
The application securely connects to the database utilizing `SQLAlchemy` and `psycopg2`. Credentials are dynamically loaded from environment files, and passwords are url-encoded to safely handle special characters.

## ELT (Extract, Load, Transform)
### Why ELT?

The Weather Data Platform follows an Extract, Load, Transform (ELT) approach instead of the traditional Extract, Transform, Load (ETL) workflow. In this architecture, raw weather data is first loaded into the database before any transformation takes place.

The platform stores both the original raw datasets and the transformed datasets, preserving the source data while providing optimized tables for API consumption.

This approach offers several advantages:

- Preserves the original dataset for auditing, debugging, and future transformations.
- Separates raw and processed data to improve maintainability.
- Enables data transformations to be rerun without re-extracting data from the source.
- Aligns with modern data engineering practices, where databases and cloud data platforms perform transformations efficiently.

### How is it Implemented
The Weather Data Platform ELT implementation is influenced by its orchestrator `apache-airflow`. It consists of the following steps:

### Extract

**API**

The pipeline retrieves weather data from the Open-Meteo API using a predefined location (Karachi, Pakistan). The JSON response is parsed into a Python dictionary and organized into separate datasets for:

- `Current Conditions`
- `Hourly Conditions`
- `Daily Conditions`
- `Measurement Units` (current_units, hourly_units, daily_units)
- `Metadata` (e.g., location, timezone, elevation)

These datasets are returned as a single dictionary for downstream ELT tasks.

**Load (Raw Data Staging)**

The extracted datasets are converted into Pandas DataFrames and staged in PostgreSQL using a sqlalchemy engine before any transformations occur. Weather conditions are stored in dedicated raw tables, measurement units are stored in a JSONB table, and metadata is stored in a separate metadata table. A reference dict is returned at the end.

### Transform

Using referenced dict for postgresql tables, raw data is loaded for further transformations. Following are the key points:

**Key Points**
- Cleans the extracted data by handling missing, invalid, and duplicate values.
- Transforms the dataset by creating, modifying, and removing columns where required.
- Normalizes the data, applies appropriate data types, and optimizes it for storage and API consumption.
- Because of `apache-airflow`, data is saved into `ELT/temp/`, which is useful for backup and in case data is corrupted upstream.
- All the transformation functions are orchestrated inside one function. A reference table is returned for upstream tasks so they can gather data from `ELT/temp/`

### Validation
The validation logic in ELT involves the verification of business logic, and schema after the data is transformed. 

#### Key Validations

**Business**

Validation functions enclosed in class, primary validation tables are:

- `current_conditions`
- `daily_conditions`
- `hourly_conditions`

Since they make 90% of the usable data, they are validated business logic bugs and throw `ValidationError` exception if are invalid.

**Schema**

Schema validation involves verifying the structure, integrity, and basic logic of the data using `pandera`. It includes:

- Complete validation of each table and each of their columns.
- Include Dtype validations.
- Basic business logic validation.

**Validation Order**

The Weather-ELT-Platform validation follows subsequent order: 

- `schema`
- `business`

### Load (Save)
The Load & Storage module is the final stage of the ELT pipeline. It securely commits your fully processed and transformed data to the target database. This guarantees data integrity and ensures the pipeline is ready for downstream analytics and reporting.

## API
Weather-ELT-Platform API focusses on serving data, primarily for frontend over the internet. It uses `FastAPI` python library and serves data from a database using a `sqlalchemy` engine (connection).

### Services
#### Weather Service
It makes the data ready to be served over the API. It creates, removes, and modify data. These are the functions for seperate endpoints:

- `get_current`: Serves current weather data.
- `get_hourly`: Returns hourly data.
- `get_today`: Shows today overall conditions and variables.
- `get_daily_forecast`: 7 Day future forecast.

#### Models
Response models, validating structure, integrity, and schema data served on endpoints. Uses `Pydantic` as the validator.

**Key Models**
- `CurrentConditionsResponse`
- `HourlyConditionsResponse`
- `DailyConditionsResponse`

#### Dependencies & Config
Dependencies and configurations that enhances API, such as:

- `Metadata`: Related to each endpoint, explain the purpose and the type of response.
- `Authenctication`: Login header for each endpoint except /docs. Requires configuration of `AUTH_ACCESS_TOKEN` in .env file. 
- `Rate-Limiter`: Limit the amount of requests such as 10 requests per second.

#### Routers
Following are the routers used to serve different types of data:

- `/current_weather`
- `/hourly_weather`
- `/daily`
  -  `/forecast`
  -  `/today`

#### Relationship (Models, Endpoints, Services)
- `get_current`-`CurrentConditionsResponse`-`/current_weather`
- `get_hourly`-`HourlyConditionsResponse`-`/hourly_weather`
- `get_today`-`List[DailyConditionsResponse]`-`/daily/today`
- `get_daily_forecast`-`List[DailyConditionsResponse]`-`/daily/forecast`

## Docker
The primary purpose of this project is to represent containerziation with `Dockerfile` and `docker-compose`. In backend there is a `Dockerfile` that completely packs backend stuff such as api, excluding ELT, db.

### Key Points
- With Python-3.14
- Requirements are copied and installed with base.txt being essential and api.txt.
- API folder is copied.
- With `uvicorn`, API is then deployed on host `0.0.0.0` and port `8000`

These instructions are put inside the folder's `Dockerfile` and then serve as an image or service for the project's `docker-compose`.

---

## Tests
Software testing is an industry-standard best practice that is essential for the success of any software project. Some initial tests are being written inside the folder which would be increased overtime as the project becomes bigger, complex, and more sophisticated. Some of the tests written, are mentioned below:

### Key Tests:
- `test_api_services`: Includes standard API service testing with each endpoint service function wrapped separately.
- `test_api`: Tests and validates API after its deployed. Includes separate testing for endpoints, and response models.
- `test_db`: Typical Database testing such as engine, and tables.

*Note: These tests are all done locally and are not designed for docker and containerization.*

