resource "aws_ssm_parameter" "flow_log_role_arn" {
  name = "${var.project_name}/${var.environment}/iam/flow_log_role_arn"
  type = "String" 
  value = aws_iam_role.flow_log_role.arn
}

resource "aws_ssm_parameter" "ecs_task_execution_role_arn" {
  name = "${var.project_name}/${var.environment}/iam/ecs_task_execution_role_arn"
  type = "String" 
  value = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ssm_parameter" "ecs_task_role_arn" {
  name = "${var.project_name}/${var.environment}/iam/ecs_task_role_arn"
  type = "String" 
  value = aws_iam_role.ecs_task_role.arn
}