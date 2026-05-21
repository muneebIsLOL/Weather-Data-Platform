import pandas as pd


class ValidationError(Exception):
    def __init__(
        self,
        message: str,
        *,
        rule: str = None,
        df_name: str = None,
        bad_rows: pd.DataFrame,
    ):
        super().__init__(message)
        self.rule = rule
        self.df_name = df_name
        self.bad_rows = bad_rows