resource "aws_ssm_parameter" "cloudwatch_role" {
  name  = "${var.project_name}/${var.environment}/iam/cloudwatch_role"
  type  = "String"
  value = aws_iam_role.cloudwatch_role.id

  depends_on = [aws_iam_role_policy.terraform_ssm_policy]
}

resource "aws_ssm_parameter" "ecs_task_execution_role_arn" {
  name  = "${var.project_name}/${var.environment}/iam/ecs_task_execution_role_arn"
  type  = "String"
  value = aws_iam_role.ecs_task_execution_role.arn
  depends_on = [aws_iam_role_policy.terraform_ssm_policy]
}

resource "aws_ssm_parameter" "ecs_task_role_arn" {
  name  = "${var.project_name}/${var.environment}/iam/ecs_task_role_arn"
  type  = "String"
  value = aws_iam_role.ecs_task_role.arn
  depends_on = [aws_iam_role_policy.terraform_ssm_policy]
}