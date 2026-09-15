output "app_db_host" {
  value = aws_db_instance.weather.address
}

output "app_db_name" {
  value = aws_db_instance.weather.db_name
}

output "app_postgres_password" {
  value = aws_db_instance.weather.password
}

output "app_postgres_user" {
  value = aws_db_instance.weather.username
}

output "airflow_db_sqlalchemy_conn_string" {
  value = "postgresql+psycopg2://${aws_db_instance.airflow.username}:${aws_db_instance.airflow.password}@${aws_db_instance.airflow.address}/${aws_db_instance.airflow.db_name}"
}