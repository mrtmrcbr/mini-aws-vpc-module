module "vpc" {
  source      = "./modules/aws/vpc"
  environment = var.environment
  name        = var.vpc_name
  cidr_block  = var.vpc_cidr_block
}

module "public_subnet" {
  source      = "./modules/aws/public_subnet"
  vpc_id      = module.vpc.this_id
  vpc_name    = var.vpc_name
  name        = "public"
  environment = var.environment
  azs         = lookup(var.public_subnets["public"], "azs")
  is_public   = true
  subnets     = lookup(var.public_subnets["public"], "cidr_block")
}

module "subnet" {
  for_each = var.private_subnets

  source            = "./modules/aws/private_subnet"
  vpc_id            = module.vpc.this_id
  vpc_name          = var.vpc_name
  name              = each.key
  environment       = var.environment
  public_subnet_ids = module.public_subnet.subnet_ids
  azs               = lookup(var.private_subnets[each.key], "azs")
  subnets           = lookup(var.private_subnets[each.key], "cidr_block")
}

# resource "aws_db_subnet_group" "database" {
#   name        = format("%s-data-subnet-group", var.name)
#   description = "Database subnet group for ${var.name}"
#   subnet_ids  = aws_subnet.data.*.id

#   tags = merge(
#     {
#       Name = format("%s-data-subnet-group", var.name),
#     },
#     local.default_tags,
#     var.tags
#   )
# }