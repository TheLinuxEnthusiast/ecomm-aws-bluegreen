
variable "prefix" {}
variable "suffix" {}
variable "type" {}
variable "ecomm_vpc_id" {}
variable "ecs_cluster_id" {}
variable "task_definition_id" {}
variable "security_group_id" {}
variable "ecomm_alb_listener" {}
variable "ecomm_app_group_green" {}
variable "private_subnets" {
  type = list(string)
}