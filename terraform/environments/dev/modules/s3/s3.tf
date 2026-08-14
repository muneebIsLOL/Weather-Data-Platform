resource "aws_s3_bucket" "app" {
  bucket           = "${var.project_name}-${var.environment}-app-bucket"
  bucket_namespace = "account-regional"
}