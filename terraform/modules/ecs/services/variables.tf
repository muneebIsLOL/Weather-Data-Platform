variable "cluster_id" {
  type = string
}

variable "service_attr" {
  type = map(object({
    task_def_arn     = string
    target_group_arn = string
  }))
}

variable "ecs_security_group" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
