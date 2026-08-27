data "aws_caller_identity" "current" {}

module "cloudwatch" {
  source = "../../../modules/cloudwatch"
}

module "vpc" {
  source       = "../../../modules/networking"
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

  external_cloudwatch_log_group_arn = data.aws_ssm_parameter.cloudwatch_role.arn
  external_flow_log_role_arn        = module.cloudwatch.log_group_arn
  depends_on                        = [module.cloudwatch]
}

module "db" {
  source       = "../../../modules/databases"
  project_name = var.project_name
  environment  = var.environment
  subnet_ids   = module.vpc.subnet_ids
  sg_ids       = [module.vpc.postgres_sg_id]
  depends_on   = [module.vpc]
}

module "ecr" {
  source       = "../../../modules/ecr"
  project_name = var.project_name
  environment  = var.environment
}

module "ecs_cluster" {
  source       = "../../../modules/ecs/cluster"
  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source       = "../../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
  kms_key_arn  = module.kms.app_key_arn
}

module "kms" {
  source             = "../../../modules/kms"
  current_account_id = data.aws_caller_identity.current.id
  project_name       = var.project_name
  environment        = var.environment
}