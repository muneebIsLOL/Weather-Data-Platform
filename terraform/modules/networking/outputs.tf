output "vpc_id" {
  description = "The unique ID of the created VPC"
  value       = aws_vpc.this.id
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_sg.id
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg" {
  value = aws_security_group.ecs_services_sg.id
}