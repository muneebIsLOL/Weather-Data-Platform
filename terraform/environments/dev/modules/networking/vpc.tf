resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
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

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = "${var.project_name}-${var.environment}-public-${each.key}"
  }
}