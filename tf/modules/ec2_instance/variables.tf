
variable "instance_size" {}
variable "prefix" {}
variable "public_subnets" {
	type = list(string)
}
variable "private_subnets" {
	type = list(string)
}
variable "ecomm_vpc_id" {}
variable "ec2_key_name" {}
variable "suffix" {}
