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

module "alb" {
  source          = "../../../modules/alb"
  project_name    = var.project_name
  environment     = var.environment
  security_groups = data.aws_ssm_paramater.alb_sg.value
  subnets         = data.aws_ssm_parameter.alb_subnets.value
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
}

module "ecs_frontend_task_def" {
  source             = "../../../modules/ecs/task_definitions/frontend"
  image              = data.aws_ecr_image.frontend
  project_name       = var.project_name
  environment        = var.environment
  task_role_arn      = data.aws_ssm_parameter.ecs_task_role_arn.value
  execution_role_arn = data.aws_ssm_parameter.ecs_task_execution_role_arn.value
  vite_host_url = module.ecs_alb.alb_dns
  depends_on = [module.ecs_alb]
}


module "ecs_services" {
  source     = "../../../modules/ecs/services"
  cluster_id = data.aws_ssm_parameter.cluster_id
  service_attr = {
    "frontend" = { task_def_arn = module.ecs_frontend_task_def.task_def_arn, target_group_arn = module.ecs_alb.frontend_tg_arn }
    "backend"  = { task_def_arn = module.ecs_backend_task_def.task_def_arn, target_group_arn = module.ecs_alb.backend_tg_arn }
    "airflow"  = { task_def_arn = module.ecs_airflow_task_def.task_def_arn, target_group_arn = module.ecs_alb.airflow_tg_arn }
  }
  ecs_security_group = data.aws_ssm_parameter.ecs_sg
  public_subnets     = data.aws_ssm_paramater.public_subnets
  private_subnets    = data.aws_ssm_paramater.private_subnets

  depends_on = [module.ecs_alb]
}