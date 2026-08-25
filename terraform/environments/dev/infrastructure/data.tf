data "aws_ssm_parameter" "flow_log_role_arn" {
  name = "${var.project_name}/${var.environment}/iam/flow_log_role_arn"
}