output "backend_repo" {
  value = aws_ecr_repository.backend.name
}

output "frontend_repo" {
  value = aws_ecr_repository.frontend.name
}

output "airflow_repo" {
  value = aws_ecr_repository.airflow.name
}