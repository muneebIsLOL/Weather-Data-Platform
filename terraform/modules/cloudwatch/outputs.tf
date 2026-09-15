output "log_group_arn" {
  description = "The target CloudWatch Log Group destination ARN"
  value       = aws_cloudwatch_log_group.vpc.arn
}