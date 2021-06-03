locals {
  default_tags = {
    Environment = var.environment
  }

  nat_gateway_count = length(var.azs)
}

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = format("%s", var.vpc_name),
    },
    local.default_tags,
    var.tags
  )
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

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.vpc_name,
        var.name,
        )
    },
    local.default_tags,
    var.tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "public_internet_gateway_ipv6" {
  route_table_id              = aws_route_table.this.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(var.subnets)

  subnet_id      = element(aws_subnet.this.*.id, count.index)
  route_table_id = aws_route_table.this.id
}