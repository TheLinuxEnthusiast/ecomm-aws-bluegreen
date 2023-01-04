
variable "ecomm_vpc_cidr" {}
variable "prefix" {}

variable "ecomm_public_subnets" {
  type = list(string)
}

variable "ecomm_private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "instance_size" {}
variable "ec2_key_name" {}

variable "is_green" {
  default = false
  type    = bool
}

variable "is_blue" {
  default = true
  type    = bool
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}

#variables "alb_target_groups" {
#  type = list()
#}