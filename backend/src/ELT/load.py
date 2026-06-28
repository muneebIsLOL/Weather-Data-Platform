import pandas as pd
from src.ELT.utilities.upsert import upsert_df

def load_data(engine, transformed_schema_reference: dict):
    data = {}
    try:
        for key, value in transformed_schema_reference.items():
            path = f"./src/ELT/temp/{key}.parquet"
            data[key] = pd.read_parquet(path)

            if "units" in key:
                data[key].to_sql(
                    value,
                    engine,
                    if_exists="append",
                    index=False
                )
            
            else:
                upsert_df(data[key], value, engine)
    
    except Exception as e:
        print("Data Loading Error:")
        raise e