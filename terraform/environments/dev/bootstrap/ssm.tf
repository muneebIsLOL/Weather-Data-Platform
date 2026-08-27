resource "aws_ssm_parameter" "cloudwatch_role" {
  name  = "${var.project_name}/${var.environment}/iam/cloudwatch_role"
  type  = "String"
  value = aws_iam_role.cloudwatch_role.id
}

resource "aws_ssm_parameter" "ecs_task_execution_role_arn" {
  name  = "${var.project_name}/${var.environment}/iam/ecs_task_execution_role_arn"
  type  = "String"
  value = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ssm_parameter" "ecs_task_role_arn" {
  name  = "${var.project_name}/${var.environment}/iam/ecs_task_role_arn"
  type  = "String"
  value = aws_iam_role.ecs_task_role.arn
}