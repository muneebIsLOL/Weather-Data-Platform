resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "dedicated"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.this.id

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = "${var.project_name}-${var.environment}-private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets
  vpc_id   = aws_vpc.this.id
  map_public_ip_on_launch = true

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = "${var.project_name}-${var.environment}-public-${each.key}"
  }
}

resource "aws_flow_log" "this" {
  iam_role_arn    = var.external_cloudwatch_log_group_arn
  log_destination = var.external_flow_log_role_arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
  depends_on = [var.external_logs_permission_policy_id]
}