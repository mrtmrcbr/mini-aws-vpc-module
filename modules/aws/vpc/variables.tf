variable "name" {
  type = string
}

variable "cidr_block" {
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