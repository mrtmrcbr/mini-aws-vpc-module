locals {
  default_tags = {
    Environment = var.environment
  }
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = merge(
    {
      Name = var.name,
    },
    local.default_tags,
    var.tags
  )
}