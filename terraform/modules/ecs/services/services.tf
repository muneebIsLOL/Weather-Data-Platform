resource "aws_ecs_service" "frontend" {
  name                              = "frontend-service"
  cluster                           = var.cluster_id
  task_definition                   = var.service_attr["frontend"].task_def_arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 100

  network_configuration {
    assign_public_ip = true
    security_groups  = [var.ecs_security_group]
    subnets          = var.public_subnets
  }

  load_balancer {
    target_group_arn = var.service_attr["frontend"].target_group_arn
    container_name   = "frontend"
    container_port   = "80"
  }
}

resource "aws_ecs_service" "backend" {
  name                              = "frontend-service"
  cluster                           = var.cluster_id
  task_definition                   = var.service_attr["backend"].task_def_arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 100

  network_configuration {
    assign_public_ip = true
    security_groups  = [var.ecs_security_group]
    subnets          = var.private_subnets
  }

  load_balancer {
    target_group_arn = var.service_attr["backend"].target_group_arn
    container_name   = "backend"
    container_port   = "8000"
  }
}

resource "aws_ecs_service" "airflow" {
  name                              = "frontend-service"
  cluster                           = var.cluster_id
  task_definition                   = var.service_attr["airflow"].task_def_arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 100

  network_configuration {
    assign_public_ip = true
    security_groups  = [var.ecs_security_group]
    subnets          = var.private_subnets
  }

  load_balancer {
    target_group_arn = var.service_attr["airflow"].target_group_arn
    container_name   = "airflow"
    container_port   = "8080"
  }
}
