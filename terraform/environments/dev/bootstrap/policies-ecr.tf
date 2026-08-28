resource "aws_iam_role_policy" "terraform_ecr_policy" {
  name = "ecr-policy"
  role = data.aws_iam_session_context.current.issuer_name

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
