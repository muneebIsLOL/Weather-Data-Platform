import pendulum, datetime
from src.ELT.extract.data import extract_data
from src.ELT.extract.stage import stage_data
from src.ELT.transform import transform_data
from src.ELT.load import load_data
from src.ELT.validation.business import BusinessValidation
from src.ELT.validation.schema import schema_validate
from src.db.postgres import get_engine
from airflow.sdk import dag, task


@dag(
    dag_id="ELT_Orchestration",
    schedule=datetime.timedelta(minutes=15),
    start_date=pendulum.datetime(2026, 5, 18, tz="UTC"),
    catchup=False,
    tags=["ELT", "Pipeline", "Orchestrate"]
)
def orchestrate():
    @task(default_args={"retries": 3})
    def extract():
        data = extract_data()
        raw_schema_reference = stage_data(data, get_engine())

        return raw_schema_reference
    
    @task(default_args={"retries": 3})
    def transform(raw_schema_reference):
        data, transformed_schema_reference = transform_data(raw_schema_reference, get_engine())
        data = schema_validate(data)
        BusinessValidation(data).run()
        return transformed_schema_reference

    @task(default_args={"retries": 3})
    def load(transformed_schema_reference: dict):
        return load_data(get_engine(), transformed_schema_reference)        
    
    schema_reference = extract()
    schema_reference = transform(schema_reference)
    load(schema_reference)

pipeline = orchestrate()