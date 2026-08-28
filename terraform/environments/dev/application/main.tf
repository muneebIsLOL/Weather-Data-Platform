module "ecs_backend_task_def" {
  source                = "../../../modules/ecs/task_definitions/backend"
  image                 = data.aws_ecr_image.backend
  project_name          = var.project_name
  environment           = var.environment
  app_db_host           = data.aws_ssm_parameter.app_db_host.value
  app_db_name           = data.aws_ssm_parameter.app_db_name.value
  app_postgres_password = data.aws_ssm_parameter.app_postgres_password.value
  app_postgres_user     = data.aws_ssm_parameter.app_postgres_user.value
  execution_role_arn    = data.aws_ssm_parameter.ecs_task_execution_role_arn.value
  task_role_arn         = data.aws_ssm_parameter.ecs_task_role_arn.value
}

module "ecs_airflow_task_def" {
  source                            = "../../../modules/ecs/task_definitions/airflow"
  image                             = data.aws_ecr_image.airflow
  project_name                      = var.project_name
  environment                       = var.environment
  app_db_host                       = data.aws_ssm_parameter.app_db_host.value
  app_db_name                       = data.aws_ssm_parameter.app_db_name.value
  app_postgres_password             = data.aws_ssm_parameter.app_postgres_password.value
  app_postgres_user                 = data.aws_ssm_parameter.app_postgres_user.value
  airflow_db_sqlalchemy_conn_string = data.aws_ssm_parameter.airflow_db_sqlalchemy_conn_string.value
  execution_role_arn                = data.aws_ssm_parameter.ecs_task_execution_role_arn.value
  task_role_arn                     = data.aws_ssm_parameter.ecs_task_role_arn.value
  bucket_name                       = data.aws_ssm_parameter.bucket.value
}

module "ecs_frontend_task_def" {
  source             = "../../../modules/ecs/task_definitions/frontend"
  image              = data.aws_ecr_image.frontend
  project_name       = var.project_name
  environment        = var.environment
  task_role_arn      = data.aws_ssm_parameter.ecs_task_role_arn.value
  execution_role_arn = data.aws_ssm_parameter.ecs_task_execution_role_arn.value
}
