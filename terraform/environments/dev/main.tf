data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

module "iam" {
  source           = "./iam"
  current_role_arn = data.aws_iam_session_context.current.issuer_name
  account_id       = data.aws_caller_identity.current.id
  project_name     = var.project_name
  environment      = var.environment
}

module "cloudwatch" {
  source     = "./modules/cloudwatch"
  depends_on = [module.iam]
}

module "vpc" {
  source       = "./modules/networking"
  project_name = var.project_name
  environment  = var.environment
  cidr_block   = "10.0.0.0/16"

  private_subnets = {
    "subnet-1" = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
    }
    "subnet-2" = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
    }
  }

  public_subnets = {
    "subnet-1" = {
      cidr_block = "10.0.3.0/24"
      az         = "ap-south-1a"
    }
    "subnet-2" = {
      cidr_block = "10.0.4.0/24"
      az         = "ap-south-1b"
    }
  }

  external_cloudwatch_log_group_arn = module.iam.flow_log_role_arn
  external_flow_log_role_arn        = module.cloudwatch.log_group_arn
  depends_on                        = [module.cloudwatch]
}

module "db" {
  source       = "./modules/databases"
  project_name = var.project_name
  environment  = var.environment
  subnet_ids   = module.vpc.subnet_ids
  sg_ids       = [module.vpc.postgres_sg_id]
  depends_on   = [module.vpc]
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  environment  = var.environment

  depends_on = [module.iam]
}

module "ecs_cluster" {
  source       = "./modules/ecs/cluster"
  project_name = var.project_name
  environment  = var.environment

  depends_on = [module.iam]
}

module "ecs_backend_task_def" {
  source                = "./modules/ecs/task_definitions/backend"
  image                 = module.ecr.backend_image
  project_name          = var.project_name
  environment           = var.environment
  app_db_host           = module.db.app_db_host
  app_db_name           = module.db.app_db_name
  app_postgres_password = module.db.app_postgres_password
  app_postgres_user     = module.db.app_postgres_user
  execution_role_arn    = module.iam.ecs_task_execution_role_arn
  task_role_arn         = module.iam.ecs_task_role_arn

  depends_on = [module.ecs_cluster]
}

module "ecs_orchestrator_task_def" {
  source                            = "./modules/ecs/task_definitions/orchestrator"
  image                             = module.ecr.orchestrator_image
  project_name                      = var.project_name
  environment                       = var.environment
  app_db_host                       = module.db.app_db_host
  app_db_name                       = module.db.app_db_name
  app_postgres_password             = module.db.app_postgres_password
  app_postgres_user                 = module.db.app_postgres_user
  airflow_db_sqlalchemy_conn_string = module.db.airflow_db_sqlalchemy_conn_string
  execution_role_arn                = module.iam.ecs_task_execution_role_arn
  task_role_arn                     = module.iam.ecs_task_role_arn
  bucket_name                       = module.s3.bucket

  depends_on = [module.ecs_cluster]
}

module "ecs_frontend_task_def" {
  source             = "./modules/ecs/task_definitions/frontend"
  project_name       = var.project_name
  environment        = var.environment
  image              = module.ecr.frontend_image
  task_role_arn      = module.iam.ecs_task_role_arn
  execution_role_arn = module.iam.ecs_task_execution_role_arn

  depends_on = [module.ecs_cluster]
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
  kms_key_arn  = module.kms.app_key_arn

  depends_on = [module.iam]
}

module "kms" {
  source             = "./modules/kms"
  current_account_id = data.aws_caller_identity.current.id
  project_name       = var.project_name
  environment        = var.environment
}