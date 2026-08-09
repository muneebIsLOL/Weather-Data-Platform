resource "aws_iam_role" "flow_log_role" {
  name = "vpc-flow-log-cloudwatch-role"
  path = "/service-roles/"

  permissions_boundary = "arn:aws:iam::${var.account_id}:policy/TerraformDevPermissionsBoundary"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowVpcFlowLogs"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "vpc_logs_permissions" {
  name = "logs-permissions"
  role = aws_iam_role.flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "terraform_cloudwatch_policy" {
  name = "terraform-cloudwatch-permissions"
  role = var.current_role_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLogGroupManagement"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:TagLogGroup",
          "logs:UntagLogGroup",
          "logs:TagResource",
          "logs:UntagResource",
          "logs:ListTagsForResource",
          "logs:ListTagsLogGroup"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowLogDescribeActions"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}
