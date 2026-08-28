data "aws_ssm_parameter" "cloudwatch_role" {
  name = "/${var.project_name}/${var.environment}/iam/cloudwatch_role"
}