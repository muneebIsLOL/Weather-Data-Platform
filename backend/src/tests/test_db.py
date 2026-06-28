def test_db_engine():
    from src.db.postgres import get_engine

    engine = get_engine()

    assert engine is not None


def test_db_tables():
    from src.db.postgres import get_engine
    import pandas as pd

    current_conditions = pd.read_sql("SELECT * FROM current_conditions", get_engine())
    hourly_conditions = pd.read_sql("SELECT * FROM hourly_conditions", get_engine())
    daily_conditions = pd.read_sql("SELECT * FROM daily_conditions", get_engine())

    assert (
        not current_conditions.empty
        and not hourly_conditions.empty
        and not daily_conditions.empty
    )
