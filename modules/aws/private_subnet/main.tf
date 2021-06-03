locals {
  default_tags = {
    Environment = var.environment
  }

  nat_gateway_count = length(var.azs)
}

resource "aws_subnet" "this" {
  count = length(var.subnets)

  vpc_id            = var.vpc_id
  cidr_block        = element(concat(var.subnets, [""]), count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      Name = format(
        "%s-%s-%s",
        var.vpc_name,
        var.name,
      substr(split("-", element(var.azs, count.index))[2], 1, 2)),
    },
    local.default_tags,
    var.tags
  )
}

resource "aws_eip" "nat_ip" {
  count = local.nat_gateway_count

  vpc = true

  tags = merge(
    {
      "Name" = format(
        "%s-%s-%s-nat-ip",
        var.vpc_name,
        var.name,
        substr(split("-", element(var.azs, count.index))[2], 1, 2)
      )
    },
    local.default_tags,
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = element(aws_eip.nat_ip.*.id, count.index)
  subnet_id     = element(var.public_subnet_ids, count.index)

  tags = merge(
    {
      "Name" = format(
        "%s-%s-%s",
        var.vpc_name,
        var.name,
        substr(split("-", element(var.azs, count.index))[2], 1, 2)
      )
    },
    local.default_tags,
    var.tags
  )
}

resource "aws_route_table" "this" {
  count = local.nat_gateway_count

  vpc_id = var.vpc_id

  tags = merge(
    {
      "Name" = format(
        "%s-%s-%s",
        var.vpc_name,
        var.name,
        substr(split("-", element(var.azs, count.index))[2], 1, 2)
      )
    },
    local.default_tags,
    var.tags
  )
}

resource "aws_route" "nat_gateway" {
  count = local.nat_gateway_count

  route_table_id         = element(aws_route_table.this.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)
}

resource "aws_route_table_association" "this" {
  count = length(var.subnets)

  subnet_id      = element(aws_subnet.this.*.id, count.index)
  route_table_id = element(aws_route_table.this.*.id, count.index)
}