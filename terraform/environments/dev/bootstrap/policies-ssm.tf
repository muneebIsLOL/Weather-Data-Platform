resource "aws_iam_role_policy" "terraform_ssm_policy" {
  name = "ssm-parameter-policy"
  role = data.aws_iam_session_context.current.issuer_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
        {
            Sid = "AllowTagManagement"
            Effect = "Allow"
            Action = [
                "ssm:AddTagsToResource",
                "ssm:ListTagsForResource",
                "ssm:RemoveTagsFromResource"
            ]
            Resource = "*"
        },
        {
            Sid = "AllowParameterManagement"
            Effect = "Allow"
            Action = [
                "ssm:PutParameter",
                "ssm:DeleteParameter",
                "ssm:DeleteParameters",
                "ssm:DescribeParameters",
                "ssm:GetParameters*"
            ]
            Resource = "*"
        },
    ]
  })
}