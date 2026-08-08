resource "aws_cloudwatch_log_group" "vpc" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 7
  depends_on = [var.logs_policy_id]
}
