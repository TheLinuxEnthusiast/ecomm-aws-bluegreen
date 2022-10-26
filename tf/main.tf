
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
  cidr = var.ecomm_vpc

  azs             = var.azs
  private_subnets = ["${var.ecomm_private_subnet_1}", "${var.ecomm_private_subnet_2}"]
  public_subnets  = ["${var.ecomm_public_subnet_1}", "${var.ecomm_public_subnet_2}"]

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
