variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "private_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "subnet-1" = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
    }
    "subnet-2" = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
    }
  }
}

variable "public_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "subnet-1" = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
    }
    "subnet-2" = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
    }
  }
}

variable "external_flow_log_role_arn" {
  type        = string
  description = "IAM Role ARN coming from the iam module directory"
}

variable "external_cloudwatch_log_group_arn" {
  type        = string
  description = "CloudWatch log group ARN coming from the cloudwatch module directory"
}

variable "external_logs_permission_policy_id" {
  type        = string
  description = "ID for logs permission policy in cloudwatch for flow logs"
}

variable "external_vpc_iam_permission_policy_id" {
  type        = string
  description = "ID for vpc permission policy"
}