output "task_def_arn" {
  type  = string
  value = aws_ecs_task_definition.backend.arn
}

output "api_token" {
  type = string
  value = local.api_token
}