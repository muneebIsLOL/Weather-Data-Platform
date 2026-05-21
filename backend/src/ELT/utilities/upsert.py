from sqlalchemy.dialects.postgresql import insert
from sqlalchemy import MetaData, Table
import pandas as pd


def upsert_df(df: pd.DataFrame, table_name, engine, conflict_col="time"):
    metadata = MetaData()
    table = Table(table_name, metadata, autoload_with=engine)

    records = df.to_dict(orient="records")

    stmt = insert(table).values(records)

    # update_dict = {
    #     col.name: stmt.excluded[col.name]
    #     for col in table.columns
    #     if col.name != conflict_col
    # }

    upsert_stmt = stmt.on_conflict_do_update(
        index_elements=["time"],
        set_={c.name: stmt.excluded[c.name] for c in table.columns if c.name not in ["id", conflict_col]},
    )

    with engine.begin() as conn:
        conn.execute(upsert_stmt)