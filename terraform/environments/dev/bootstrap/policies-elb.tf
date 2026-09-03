resource "aws_iam_role_policy" "terraform_elb_policy" {
  name = "elb-policy"
  role = data.aws_iam_session_context.current.issuer_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowTagManagement"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:RemoveTags"
        ]

        Resource = "*"
      },
      {
        Sid    = "AllowELBManagement"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddListenerCertificates",

          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:CreateTargetGroup",

          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:DeleteTargetGroup",

          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:RegisterTargets",

          "elasticloadbalancing:DescribeListener*",
          "elasticloadbalancing:DescribeLoadBalancer*",
          "elasticloadbalancing:DescribeTargetGroup*",
          "elasticloadbalancing:DescribeTargetHealth",

          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:ModifyTargetGroup*",
          "elasticloadbalancing:ModifyLoadBalancer*",

          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets"
        ]

        Resource = "*"
      }
    ]
  })
}
