data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

module "iam" {
  source           = "./iam"
  current_role_arn = data.aws_iam_session_context.current.issuer_name
  account_id       = data.aws_caller_identity.current.id
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  logs_policy_id = module.iam.logs_permission_policy_id
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

  external_cloudwatch_log_group_arn  = module.iam.flow_log_role_arn
  external_flow_log_role_arn         = module.cloudwatch.log_group_arn
  external_logs_permission_policy_id = module.iam.logs_permission_policy_id

}
