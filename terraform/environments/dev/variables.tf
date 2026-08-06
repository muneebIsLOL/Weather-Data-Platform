variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

variable "project_name" {
  description = "Project name used for naming AWS resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}
