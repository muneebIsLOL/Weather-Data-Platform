resource "aws_lb" "ecs_load_balancer" {
  name               = "${var.project_name}-${var.environment}-ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false
}
