output "flow_log_role_arn" {
  description = "The authorization badge ARN for the VPC Flow Logs service."
  value       = aws_iam_role.flow_log_role.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}