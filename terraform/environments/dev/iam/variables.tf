variable "account_id" {
  type        = string
  description = "The 12 digit unique AWS account id."
}

variable "current_role_arn" {
  type        = string
  description = "The ARN attribute of the current OIDC role."
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}