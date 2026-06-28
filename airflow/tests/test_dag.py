def test_orchestrate_dag():
    from dags.orchestrate_dag import pipeline
    from airflow.sdk import DAG
    
    assert pipeline is not None
    assert isinstance(pipeline, DAG)
    assert "extract" in pipeline.task_dict
    assert "transform" in pipeline.task_dict
    assert "load" in pipeline.task_dict

def test_orchestrate_dag_props():
    from dags.orchestrate_dag import pipeline
    import datetime
    
    dag_tags = pipeline.tags
    assert "ELT" in dag_tags
    assert "Pipeline" in dag_tags
    assert "Orchestrate" in dag_tags
    assert pipeline.schedule == datetime.timedelta(minutes=15)
