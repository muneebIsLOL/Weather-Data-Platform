data "aws_ssm_parameter" "backend_repo" {
  name = "/${var.project_name}/${var.environment}/ecr/backend_repo"
}

data "aws_ssm_parameter" "airflow_repo" {
  name = "/${var.project_name}/${var.environment}/ecr/airflow_repo"
}

data "aws_ssm_parameter" "frontend_repo" {
  name = "/${var.project_name}/${var.environment}/ecr/frontend_repo"
}

data "aws_ecr_image" "backend" {
  repository_name = data.aws_ssm_parameter.backend_repo
  image_tag       = "1.0.0"
}

data "aws_ecr_image" "frontend" {
  repository_name = data.aws_ssm_parameter.frontend_repo
  image_tag       = "1.0.0"
}

data "aws_ecr_image" "airflow" {
  repository_name = data.aws_ssm_parameter.airflow_repo
  image_tag       = "1.0.0"
}

data "aws_ssm_parameter" "app_db_host" {
  name = "/${var.project_name}/${var.environment}/db/app_db_host"
}

data "aws_ssm_parameter" "app_db_name" {
  name = "/${var.project_name}/${var.environment}/db/app_db_name"
}

data "aws_ssm_parameter" "app_postgres_user" {
  name = "/${var.project_name}/${var.environment}/db/app_postgres_user"
}

data "aws_ssm_parameter" "app_postgres_password" {
  name = "/${var.project_name}/${var.environment}/db/app_postgres_password"
}

data "aws_ssm_parameter" "ecs_task_execution_role_arn" {
  name = "/${var.project_name}/${var.environment}/iam/ecs_task_execution_role_arn"
}

data "aws_ssm_parameter" "ecs_task_role_arn" {
  name = "/${var.project_name}/${var.environment}/iam/ecs_task_role_arn"
}

data "aws_ssm_parameter" "airflow_db_sqlalchemy_conn_string" {
  name = "/${var.project_name}/${var.environment}/db/airflow_db_sqlalchemy_conn_string"
}

data "aws_ssm_parameter" "bucket" {
  name = "/${var.project_name}/${var.environment}/s3/bucket"
}

data "aws_ssm_paramater" "alb_sg" {
  name = "/${var.project_name}/${var.environment}/networking/alb_sg"
}

data "aws_ssm_paramater" "ecs_sg" {
  name = "/${var.project_name}/${var.environment}/networking/ecs_services_sg"
}

data "aws_ssm_paramater" "alb_subnets" {
  name = "/${var.project_name}/${var.environment}/networking/alb_subnets"
}

data "aws_ssm_paramater" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/networking/vpc_id"
}

data "aws_ssm_parameter" "cluster_id" {
  name = "/${var.project_name}/${var.environment}/ecs/cluster_id"
}

data "aws_ssm_parameter" "public_subnets" {
  name = "/${var.project_name}/${var.environment}/networking/public_subnets"
}

data "aws_ssm_parameter" "private_subnets" {
  name = "/${var.project_name}/${var.environment}/networking/private_subnets"
}