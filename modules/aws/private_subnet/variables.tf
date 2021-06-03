variable "vpc_id" {
  type = string
}

variable "vpc_name" {
    type = string
}
variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {

  }
}

variable "is_public" {
  type = bool
  default = false
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}