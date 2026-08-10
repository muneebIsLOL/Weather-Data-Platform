resource "aws_iam_role_policy" "vpc" {
  name = "terraform-vpc-permissions"
  role = var.current_role_arn

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowVpcPermissions"
        Effect = "Allow"

        Action = [
          "ec2:CreateVpc",
          "ec2:ModifyVpc*",
          "ec2:DeleteVpc*"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowSubnetManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateSubnet*",
          "ec2:DeleteSubnet"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowInternetGatewayManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:DetachInternetGateway"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowNatGatewayManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateNatGateway",
          "ec2:DeleteNatGateway",
          "ec2:AssociateNatGatewayAddress",
          "ec2:DisassociateNatGatewayAddress"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowRouteTableManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:ReplaceRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowResourceTagsManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowEc2Describe"
        Effect = "Allow"

        Action = [
          "ec2:Describe*"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow",
        Sid    = "AllowEIPManagement"
        Action = [
          "ec2:AllocateAddress",
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress",
          "ec2:ReleaseAddress"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow"
        Sid    = "AllowFlowLogsManagement"
        Action = [
          "ec2:CreateFlowLogs",
          "ec2:DeleteFlowLogs"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Sid    = "AllowSecurityGroupManagement"
        Action = [
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:ModifySecurityGroupRules",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AssociateSecurityGroupVpc",
          "ec2:DisassociateSecurityGroupVpc",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress"
        ]
        Resource = "*"
      }
    ]
  })
}

