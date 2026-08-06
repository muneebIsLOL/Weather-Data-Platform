variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "private_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "subnet-1" = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
    }
    "subnet-2" = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
    }
  }
}

variable "public_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "subnet-1" = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
    }
    "subnet-2" = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
    }
  }
}