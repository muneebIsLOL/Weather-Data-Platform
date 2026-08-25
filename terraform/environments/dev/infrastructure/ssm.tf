resource "aws_ssm_parameter" "backend_repo" {
  name = "${var.project_name}/${var.environment}/ecr/backend_repo"
  type = string
  value = module.ecr.backend_image
}

resource "aws_ssm_parameter" "frontend_repo" {
  name = "${var.project_name}/${var.environment}/ecr/frontend_repo"
  type = string
  value = module.ecr.frontend_image
}

resource "aws_ssm_parameter" "backend_repo" {
  name = "${var.project_name}/${var.environment}/ecr/airflow_repo"
  type = string
  value = module.ecr.airflow_image
}

resource "aws_ssm_parameter" "app_db_host" {
  name = "${var.project_name}/${var.environment}/db/app_db_host"
  type = string
  value = module.db.app_db_host
}

resource "aws_ssm_parameter" "app_db_name" {
  name = "${var.project_name}/${var.environment}/db/app_db_name"
  type = string
  value = module.db.app_db_name
}

resource "aws_ssm_parameter" "app_postgres_user" {
  name = "${var.project_name}/${var.environment}/db/app_postgres_user"
  type = string
  value = module.db.app_postgres_user
}

resource "aws_ssm_parameter" "app_postgres_password" {
  name = "${var.project_name}/${var.environment}/db/app_postgres_password"
  type = string
  value = module.db.app_postgres_password
}

resource "aws_ssm_parameter" "airflow_db_sqlalchemy_conn_string" {
  name = "${var.project_name}/${var.environment}/db/airflow_db_sqlalchemy_conn_string"
  type = string
  value = module.db.airflow_db_sqlalchemy_conn_string
}

resource "aws_ssm_parameter" "bucket" {
  name = "${var.project_name}/${var.environment}/s3/bucket"
  type = string
  value = module.s3.bucket
}