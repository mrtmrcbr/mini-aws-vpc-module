variable "aws_region" { }

variable "environment" { }

variable "vpc_name" { }

variable "vpc_cidr_block" { }

variable "public_subnets" { }

variable "private_subnets" { }

variable "tags" {
  type = map(any)
  default = {

  }
}