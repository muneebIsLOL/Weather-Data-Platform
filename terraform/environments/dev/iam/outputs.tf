output "flow_log_role_arn" {
  description = "The authorization badge ARN for the VPC Flow Logs service."
  value       = aws_iam_role.flow_log_role.arn
}

output "logs_permission_policy_id" {
  description = "Inline policy for flow log role for vpc in cloudwatch."
  value       = aws_iam_role_policy.logs_permissions.id
}

output "vpc_iam_permission_policy_id" {
  description = "Vpc permission policy id."
  value = aws_iam_role_policy.this.id
}