output "vpc_id" {
  description = "The unique ID of the created VPC"
  value       = aws_vpc.this.id
}