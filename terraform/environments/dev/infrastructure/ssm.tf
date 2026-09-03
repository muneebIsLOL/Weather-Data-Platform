resource "aws_ssm_parameter" "backend_repo" {
  name  = "/${var.project_name}/${var.environment}/ecr/backend_repo"
  type  = "String"
  value = module.ecr.backend_repo
}

resource "aws_ssm_parameter" "frontend_repo" {
  name  = "/${var.project_name}/${var.environment}/ecr/frontend_repo"
  type  = "String"
  value = module.ecr.frontend_repo
}

resource "aws_ssm_parameter" "airflow_repo" {
  name  = "/${var.project_name}/${var.environment}/ecr/airflow_repo"
  type  = "String"
  value = module.ecr.airflow_repo
}

resource "aws_ssm_parameter" "app_db_host" {
  name  = "/${var.project_name}/${var.environment}/db/app_db_host"
  type  = "String"
  value = module.db.app_db_host
}

resource "aws_ssm_parameter" "app_db_name" {
  name  = "/${var.project_name}/${var.environment}/db/app_db_name"
  type  = "String"
  value = module.db.app_db_name
}

resource "aws_ssm_parameter" "app_postgres_user" {
  name  = "/${var.project_name}/${var.environment}/db/app_postgres_user"
  type  = "String"
  value = module.db.app_postgres_user
}

resource "aws_ssm_parameter" "app_postgres_password" {
  name  = "/${var.project_name}/${var.environment}/db/app_postgres_password"
  type  = "String"
  value = module.db.app_postgres_password
}

resource "aws_ssm_parameter" "airflow_db_sqlalchemy_conn_string" {
  name  = "/${var.project_name}/${var.environment}/db/airflow_db_sqlalchemy_conn_string"
  type  = "String"
  value = module.db.airflow_db_sqlalchemy_conn_string
}

resource "aws_ssm_parameter" "bucket" {
  name  = "/${var.project_name}/${var.environment}/s3/bucket"
  type  = "String"
  value = module.s3.bucket
}

resource "aws_ssm_parameter" "alb_sg" {
  name  = "/${var.project_name}/${var.environment}/networking/alb_sg"
  type  = "String"
  value = module.vpc.alb_sg
}

resource "aws_ssm_parameter" "ecs_sg" {
  name  = "/${var.project_name}/${var.environment}/networking/ecs_services_sg"
  type  = "String"
  value = module.vpc.ecs_sg
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/networking/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "cluster_id" {
  name  = "/${var.project_name}/${var.environment}/ecs/cluster_id"
  type  = "String"
  value = module.ecs_cluster.cluster_id
}

resource "aws_ssm_parameter" "public_subnets" {
  name  = "/${var.project_name}/${var.environment}/networking/public_subnets"
  type  = "StringList"
  value = join(",", module.vpc.public_subnets)
}

resource "aws_ssm_parameter" "private_subnets" {
  name  = "/${var.project_name}/${var.environment}/networking/private_subnets"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)
}