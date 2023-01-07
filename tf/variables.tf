
variable "ecomm_vpc_cidr" {
  type = string
}

variable "prefix" {
  type = string
}

variable "ecomm_public_subnets" {
  type = list(string)
}

variable "ecomm_private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "instance_size" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

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

variable "ecr_uri" {
  type = string
}

variable "frontend_name" {
  type = string
}

variable "backend_name" {
  type = string
}

variable "tag_version" {
  type = string
}