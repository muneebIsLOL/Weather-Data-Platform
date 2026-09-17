resource "aws_iam_role_policy" "terraform_s3_policy" {
  name = "s3-policy"
  role = data.aws_iam_session_context.current.issuer_name

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
          "s3:GetObject*",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:Get*",
          "s3:PutEncryptionConfiguration",
          "s3:PutBucket*"
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
