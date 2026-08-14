data "aws_ecr_image" "backend" {
  repository_name = aws_ecr_repository.backend.name
  image_tag       = "1.0.0"
}

output "backend_image" {
  value = "${data.aws_ecr_image.backend.image_uri}@${data.aws_ecr_image.backend.image_digest}"
}

data "aws_ecr_image" "frontend" {
  repository_name = aws_ecr_repository.frontend.name
  image_tag       = "1.0.0"
}

output "frontend_image" {
  value = "${data.aws_ecr_image.frontend.image_uri}@${data.aws_ecr_image.frontend.image_digest}"
}

data "aws_ecr_image" "orchestrator" {
  repository_name = aws_ecr_repository.orchestrator.name
  image_tag       = "1.0.0"
}

output "orchestrator_image" {
  value = "${data.aws_ecr_image.orchestrator.image_uri}@${data.aws_ecr_image.orchestrator.image_digest}"
}
