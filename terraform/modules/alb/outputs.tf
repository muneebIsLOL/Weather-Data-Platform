output "frontend_tg_arn" {
  type  = string
  value = aws_lb_target_group.frontend_tg.arn
}

output "airflow_tg_arn" {
  type  = string
  value = aws_lb_target_group.airflow_tg.arn
}

output "backend_tg_arn" {
  type  = string
  value = aws_lb_target_group.backend_tg.arn
}

output "alb_dns" {
  type  = string
  value = aws_lb.ecs_load_balancer.dns_name
}