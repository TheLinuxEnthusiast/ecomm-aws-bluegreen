
variable "ecomm_vpc_id" {}
variable "aws_security_group_alb" {}
variable "prefix" {}
variable "suffix" {}
variable "private_subnets" {
  type = list(string)
}
variable "alb_target_group_arn" {}
variable "ecomm_alb_listener" {}

