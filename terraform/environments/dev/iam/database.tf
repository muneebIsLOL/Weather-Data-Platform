resource "aws_iam_role_policy" "rds_db_policy" {
  name = "terraform-database-permissions"
  role = var.current_role_arn

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
