resource "aws_iam_role_policy" "ecr" {
  name = "terraform-ecr-policy"
  role = var.current_role_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowECRManagement"
        Action = [
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:PutImage*",
          "ecr:BatchGetImage",
          "ecr:BatchDeleteImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:Describe*",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
