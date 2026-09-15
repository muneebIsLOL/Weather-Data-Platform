# trivy:ignore:AVD-AWS-0054
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.ecs_load_balancer.arn
  port              = "5173"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# trivy:ignore:AVD-AWS-0054
resource "aws_lb_listener" "airflow" {
  load_balancer_arn = aws_lb.ecs_load_balancer.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.airflow_tg.arn
  }
}

# trivy:ignore:AVD-AWS-0054
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.ecs_load_balancer.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}
