resource "aws_iam_role_policy" "this" {
  name = "vpc-permissions"
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
        Sid    = "AllowSubnetCreation"
        Effect = "Allow"

        Action = [
          "ec2:CreateSubnet*"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowInternetGatewayManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowNatGatewayManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateNatGateway",
          "ec2:AssociateNatGatewayAddress"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowRouteTableManagement"
        Effect = "Allow"

        Action = [
          "ec2:CreateRouteTable",
          "ec2:CreateRoute",
          "ec2:ReplaceRoute",
          "ec2:AssociateRouteTable"
        ]

        Resource = "*"
      },

      {
        Sid    = "AllowResourceTagging"
        Effect = "Allow"

        Action = [
          "ec2:CreateTags"
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
      }
    ]
  })
}
