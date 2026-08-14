variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "image" {
  type = string
}

variable "app_db_host" {
  type = string
}

variable "app_postgres_password" {
  type = string
}

variable "app_postgres_user" {
  type = string
}

variable "app_db_name" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}