variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

variable "region" {
  type = string
}