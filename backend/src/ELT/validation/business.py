from src.ELT.utilities.errors import ValidationError

class BusinessValidation:
    def __init__(self, data: dict):
        self.data = data
        self.current_conditions = data["current_conditions"]
        self.hourly_conditions = data["hourly_conditions"]
        self.daily_conditions = data["daily_conditions"]
        
    def validate_temp_consistency(self):
        for conditions in [self.current_conditions, self.hourly_conditions]:
            diff = conditions["apparent_temperature"] - conditions["temperature_2m"]
            mask = diff.abs() > 20
            if mask.any():
                invalid_values = conditions[mask]
                raise ValidationError(
                    "Temperature inconsistency detected: apparent_temperature deviates significantly from temperature_2m beyond expected physical range, indicating a possible anomaly.",
                    rule="temperature_physics_consistency",
                    bad_rows=invalid_values
                )
        
        minmax_temp_range = self.daily_conditions["temperature_2m_max"] - self.daily_conditions["temperature_2m_min"]
        mask = minmax_temp_range <= 2

        if mask.any():
            invalid_values = self.daily_conditions[mask]
            raise ValidationError(
                "Temperature range anomaly detected: daily temperature variation (max - min) is unusually low, indicating possible data aggregation issue or missing environmental variability.",
                rule="temperature_daily_variation_low_anomaly",
                df_name="daily_conditions",
                bad_rows=invalid_values
            )
    
    def validate_time_consistency(self):
        mask = self.daily_conditions["sunrise"] > self.daily_conditions["sunset"]
        if mask.any():
            invalid_values = self.daily_conditions[mask]
            raise ValidationError(
                "Temporal consistency validation failed: sunrise time occurs after sunset time, violating expected daily solar sequence.",
                rule="sunrise_sunset_temporal_consistency",
                df_name="daily_conditions",
                bad_rows=invalid_values
            )
        
    def run(self):
        self.validate_temp_consistency()
        self.validate_time_consistency()
