aws_region     = "eu-west-2"
environment    = "Dev"
vpc_name       = "main"
vpc_cidr_block = "10.0.0.0/16"
public_subnets = {
  public = {
    is_public  = true
    azs        = ["eu-west-2a", "eu-west-2b"]
    cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
  }
}
private_subnets = {
  app = {
    is_public  = false
    azs        = ["eu-west-2a", "eu-west-2b"]
    cidr_block = ["10.0.10.0/24", "10.0.20.0/24"]

  }

  data = {
    is_public  = false
    azs        = ["eu-west-2a", "eu-west-2b"]
    cidr_block = ["10.0.100.0/24", "10.0.200.0/24"]
  }
}