output "vpc_id" {
  description = "The unique ID of the created VPC"
  value       = aws_vpc.this.id
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_sg.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}