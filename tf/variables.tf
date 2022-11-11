
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
