resource "aws_iam_role" "ecs_task_execution_role" {
  name = "TerraformDevECSTaskExecRole"
  path = "/service-roles/"

  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/TerraformDevPermissionsBoundary"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "TerraformDevECSTaskRole"
  path = "/service-roles/"

  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/TerraformDevPermissionsBoundary"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "ecs-tasks-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDBAccess"
        Effect = "Allow"
        Action = [
          "rds:DescribeDB*",
          "rds-db:connect"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowS3Access"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::weather-data-platform-dev-*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "terraform_ecs_policy" {
  name = "ecs-policy"
  role = data.aws_iam_session_context.current.issuer_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowClusterManagement"
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:DeleteCluster",
          "ecs:DescribeCluster",
          "ecs:ListClusters",
          "ecs:UpdateCluster",
          "ecs:UpdateClusterSettings"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowTaskDefsManagement"
        Effect = "Allow"
        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:DeleteTaskDefinitions",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTaskDefinition*"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowTagManagement"
        Effect = "Allow"
        Action = [
          "ecs:TagResource",
          "ecs:UntagResource",
          "ecs:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Sid = "AllowServiceManagement"
        Effect = "Allow"
        Action = [
          "ecs:CreateService",
          "ecs:DeleteService",
          "ecs:ListServices",
          "ecs:UpdateService",
          "ecs:DescribeService*",
          "ecs:StopServiceDeployment"
        ]

        Resource = "*"
      }
    ]
  })
}
