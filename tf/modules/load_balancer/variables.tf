
variable "prefix" {}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "ecomm_vpc_id" {}
variable "ecomm_vpc_cidr" {}
