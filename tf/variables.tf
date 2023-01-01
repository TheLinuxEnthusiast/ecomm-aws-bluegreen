
variable "ecomm_vpc_cidr" {}
variable "prefix" {}
#variable "ecomm_private_subnet_1" {}
#variable "ecomm_private_subnet_2" {}
#variable "ecomm_public_subnet_1" {}
#variable "ecomm_public_subnet_2" {}

variable "ecomm_public_subnets" {
  type = list(string)
}

variable "ecomm_private_subnets" {
  type = list(string)
}

#variable "instance_size" {}
variable "azs" {
  type = list(string)
}
#variable "ec2_key_name" {}

variable "instance_size" {}
variable "ec2_key_name" {}

variable "is_green" {
  default = false
  type = bool
}

variable "is_blue" {
  default = true
  type = bool
}

locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}