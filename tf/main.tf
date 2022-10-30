
terraform {

  backend "s3" {
    bucket = "ecomm-terraform-state-df"
    key    = "network/terraform.state"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = "eu-west-1"
}


# Network for High Availability
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"
  cidr = var.ecomm_vpc_cidr

  azs = var.azs
  #private_subnets = ["${var.ecomm_private_subnet_1}", "${var.ecomm_private_subnet_2}"]
  #public_subnets  = ["${var.ecomm_public_subnet_1}", "${var.ecomm_public_subnet_2}"]
  private_subnets = var.ecomm_private_subnets
  public_subnets  = var.ecomm_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = "development"
    Name        = "${var.prefix}-application"
  }
}

module "ec2_autoscaling_config" {
  source          = "./modules/ec2_instance"
  instance_size   = var.instance_size
  prefix          = var.prefix
  private_subnets = module.vpc.private_subnets
}

/*
module "load_balancer_config" {
  source              = "./modules/load_balancer"
  prefix              = var.prefix
  private_subnets     = module.vpc.private_subnets
  public_subnets      = module.vpc.public_subnets
  ecomm_vpc_id        = module.vpc.vpc_id
  ecomm_vpc_cidr      = module.vpc.vpc_cidr_block
  ecomm_vpc_ipv6_cidr = module.vpc.vpc_ipv6_cidr_block
}
*/
