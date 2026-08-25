module "ecs_backend_task_def" {
  source                = "../../../modules/ecs/task_definitions/backend"
  image                 = data.aws_ecr_image.backend
  project_name          = var.project_name
  environment           = var.environment
  app_db_host           = data.aws_ssm_parameter.app_db_host
  app_db_name           = data.aws_ssm_parameter.app_db_name
  app_postgres_password = data.aws_ssm_parameter.app_postgres_password
  app_postgres_user     = data.aws_ssm_parameter.app_postgres_user
  execution_role_arn    = data.aws_ssm_parameter.ecs_task_execution_role_arn
  task_role_arn         = data.aws_ssm_parameter.ecs_task_role_arn
}

module "ecs_airflow_task_def" {
  source                            = "../../../modules/ecs/task_definitions/airflow"
  image                             = data.aws_ecr_image.airflow
  project_name                      = var.project_name
  environment                       = var.environment
  app_db_host                       = data.aws_ssm_parameter.app_db_host
  app_db_name                       = data.aws_ssm_parameter.app_db_name
  app_postgres_password             = data.aws_ssm_parameter.app_postgres_password
  app_postgres_user                 = data.aws_ssm_parameter.app_postgres_user
  airflow_db_sqlalchemy_conn_string = data.aws_ssm_parameter.airflow_db_sqlalchemy_conn_string
  execution_role_arn                = data.aws_ssm_parameter.ecs_task_execution_role_arn
  task_role_arn                     = data.aws_ssm_parameter.ecs_task_role_arn
  bucket_name                       = data.aws_ssm_parameter.bucket
}

module "ecs_frontend_task_def" {
  source             = "../../../modules/ecs/task_definitions/frontend"
  image              = data.aws_ecr_image.frontend
  project_name       = var.project_name
  environment        = var.environment
  task_role_arn      = data.aws_ssm_parameter.ecs_task_role_arn
  execution_role_arn = data.aws_ssm_parameter.ecs_task_execution_role_arn
}
