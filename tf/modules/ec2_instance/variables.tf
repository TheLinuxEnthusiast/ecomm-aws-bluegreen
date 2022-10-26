
variable "instance_size" {}
variable "prefix" {}
variable "private_subnets" {
	type = list(string)
}
