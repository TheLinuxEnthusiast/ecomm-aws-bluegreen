
variable "ecomm_vpc" {}
variable "prefix" {}
variable "ecomm_private_subnet_1" {}
variable "ecomm_private_subnet_2" {}
variable "ecomm_public_subnet_1" {}
variable "ecomm_public_subnet_2" {}
variable "instance_size" {}
variable "azs" {
  type = list(string)
}
