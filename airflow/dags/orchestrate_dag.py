import sys
from pathlib import Path

backend_dir = Path("/opt/airflow/src")
if str(backend_dir) not in sys.path:
    sys.path.insert(0, str(backend_dir))

from airflow.sdk import dag, task
import pendulum, datetime
from ELT.extract.data import extract_data
from ELT.extract.stage import stage_data
from ELT.transform import transform_data
from ELT.load import load_data
from ELT.validation.business import BusinessValidation
from ELT.validation.schema import schema_validate
from db.postgres import engine


@dag(
    dag_id="ELT_Orchestration",
    schedule=datetime.timedelta(minutes=15),
    start_date=pendulum.datetime(2026, 5, 18, tz="UTC"),
    catchup=False,
    tags=["ELT", "Pipeline", "Orchestrate"]
)
def orchestrate():
    @task
    def extract():
        data = extract_data()
        raw_schema_reference = stage_data(data, engine)

        return raw_schema_reference
    
    @task()
    def transform(raw_schema_reference):
        data, transformed_schema_reference = transform_data(raw_schema_reference, engine)
        data = schema_validate(data)
        BusinessValidation(data).run()
        return transformed_schema_reference

    @task
    def load(transformed_schema_reference: dict):
        return load_data(engine, transformed_schema_reference)        
    
    schema_reference = extract()
    schema_reference = transform(schema_reference)
    load(schema_reference)

pipeline = orchestrate()