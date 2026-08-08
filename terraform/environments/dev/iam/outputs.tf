output "flow_log_role_arn" {
  description = "The authorization badge ARN for the VPC Flow Logs service."
  value       = aws_iam_role.flow_log_role.arn
}
