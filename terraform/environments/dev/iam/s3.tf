resource "aws_iam_role_policy" "s3" {
  name = "terraform-s3-permissions"
  role = var.current_role_arn

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowS3Management"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:PutObject",
          "s3:Describe*",
          "s3:ListObjects",
          "s3:GetObject*"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowS3ResourceTagging"
        Effect = "Allow"
        Action = [
          "s3:TagResource",
          "s3:UntagResource",
          "s3:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}
