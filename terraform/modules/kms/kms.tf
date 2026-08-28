resource "aws_kms_key" "app" {
  description = "A symmetric encryption KMS key"

  enable_key_rotation     = true
  deletion_window_in_days = 20

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.project_name}-${var.environment}-app-key"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.current_account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.current_account_id}:role/TerraformDevRole"
        },
        Action = [
          "kms:ReplicateKey",
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        },
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:CreateGrants",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        Resource = "*"
        Condition = {
          ArnLike = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::${var.current_account_id}:role/service-roles/TerraformDevECSTask*",
              "arn:aws:iam::${var.current_account_id}:role/TerraformDevRole"
            ]
          }
        }
      }
    ]
  })

}
