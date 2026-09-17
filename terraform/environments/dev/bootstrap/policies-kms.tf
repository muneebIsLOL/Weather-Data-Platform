resource "aws_iam_role_policy" "terraform_kms_policy" {
  name = "kms-policy"
  role = data.aws_iam_session_context.current.issuer_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowKMSAdministration"
        Effect = "Allow"

        Action = [
          "kms:CreateKey",
          "kms:TagResource",
          "kms:DescribeKey",
          "kms:PutKeyPolicy",
          "kms:GetKeyPolicy",
          "kms:EnableKeyRotation",
          "kms:DisableKeyRotation",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:ListKeys",
          "kms:ListAliases",
          "kms:CreateAlias",
          "kms:UpdateAlias",
          "kms:DeleteAlias"
        ]

        Resource = "*"
      }
    ]
  })
}
