# Apache-Airflow (Orchestration)

# Description
Apache Airflow is an open-source platform used to programmatically create, schedule, and monitor workflows. It is widely used in data engineering to manage complex data pipelines (ETL/ELT jobs) and machine learning models.

# Components & Implementation Details
In this project, Apache-Airflow is used to orchestrate the ELT pipeline from the backend, using both docker and locally.

## Why Apache-Airflow
`Apache-Airflow` is one of the most commonly used in production orchestrators. Not only its easier to implement, but its available in the mainstream interpreter `Python` for data pipelines. In `Weather-ELT-Platform`, this is the primary choice as in future versions, other `apache` services would be implemented. This would make this project more synchronized and reliable.

## Dags
### ELT_Orchestration
This DAG (Directed Acyclic Graph) is used to orchestrate the ELT (Extract, Load, Transform) from the backend. Following are the points:

**Key Points**
- It was created on `2026/5/18`.
- It runs every 15 minutes.
- Each task retries 3 times if fails.
- Extracting raw data and staging, both are put inside one `extract` task.
- Similarly transformations and validation are combined in one `transform` task.
- Lastly, the data is loaded.

## Tests
Software testing is included in this section of the project to improve and speed up the development continiously. These tests range from `dag` tests to complete `ELT` tests using `pytest` module in `python`. Following are the tests written:

- test_dag
- test_ELT

## Docker
Docker is primary to this project. In this section of the project, it serves one of the most important purpose, orchestrating the airflow services, and the dags. It consist of two files:

- `Dockerfile`
- `docker-compose.airflow.yml`

**Dockerfile**
This is used to install `apache-airflow` and requirements such as `base` and `airflow`. Its placed as the primary and initial image in the compose file.

**docker-compose.airflow.yml**
This file is used to install dependencies and complete `apache-airflow` tool. It includes `airflow-scheduler`, `airflow-apiserver`, `redis` and `postgreSQL` for `dag` storage. It uses an external network to connect with the application's `ELT` db.
