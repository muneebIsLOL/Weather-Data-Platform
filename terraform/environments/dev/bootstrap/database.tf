resource "aws_iam_role_policy" "rds_db_policy" {
  name = "terraform-database-permissions"
  role = data.aws_iam_session_context.current.issuer_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowRdsDBAccess"
        Effect = "Allow"
        Action = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:DescribeDB*"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowsRdsDBTagging"
        Effect = "Allow"
        Action = [
          "rds:ListTagsForResource",
          "rds:RemoveTagsFromResource",
          "rds:AddTagsToResource"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowSubnetManagement"
        Effect = "Allow"
        Action = [
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:ModifyDBSubnetGroup"
        ]
        Resource = "*"
      }
    ]
  })
}
