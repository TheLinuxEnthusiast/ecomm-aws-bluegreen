
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

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = true
  keepers = {
    rand_id = "1000"
  }
}


# Network for High Availability
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc-${random_string.suffix.result}"
  cidr = var.ecomm_vpc_cidr

  azs             = var.azs
  private_subnets = var.ecomm_private_subnets
  public_subnets  = var.ecomm_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-application-${random_string.suffix.result}"
  }
}

# Front end load balancer for ecomm site
module "load_balancer_config" {
  source               = "./modules/load_balancer"
  prefix               = var.prefix
  traffic_distribution = var.traffic_distribution
  suffix               = random_string.suffix.result
  private_subnets      = module.vpc.private_subnets
  public_subnets       = module.vpc.public_subnets
  ecomm_vpc_id         = module.vpc.vpc_id
  ecomm_vpc_cidr       = module.vpc.vpc_cidr_block
  depends_on           = [module.vpc]
}

module "ecs" {
  source                 = "./modules/ecs"
  prefix                 = var.prefix
  suffix                 = random_string.suffix.result
  ecomm_vpc_id           = module.vpc.vpc_id
  private_subnets        = module.vpc.private_subnets
  aws_security_group_alb = module.load_balancer_config.ecomm_alb_security_group_id
  alb_target_group_arn   = module.load_balancer_config.ecomm_target_group_arn_blue
  ecomm_alb_listener     = module.load_balancer_config.ecomm_alb_listener
  depends_on             = [module.load_balancer_config]
}

module "blue" {
  source               = "./modules/blue"
  count                = var.is_blue ? 1 : 0
  type                 = "blue"
  prefix               = var.prefix
  suffix               = random_string.suffix.result
  ecomm_vpc_id         = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnets
  ecomm_app_group_blue = module.load_balancer_config.ecomm_target_group_arn_blue
  ecs_cluster_id       = module.ecs.ecs_cluster_id
  task_definition_id   = module.ecs.ecs_task_definition_id
  security_group_id    = module.ecs.security_group_id
  ecomm_alb_listener   = module.load_balancer_config.ecomm_alb_listener
  depends_on           = [module.ecs]
}

module "green" {
  source                = "./modules/green"
  count                 = var.is_green ? 1 : 0
  type                  = "green"
  prefix                = var.prefix
  suffix                = random_string.suffix.result
  ecomm_vpc_id          = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  ecomm_app_group_green = module.load_balancer_config.ecomm_target_group_arn_green
  ecs_cluster_id        = module.ecs.ecs_cluster_id
  task_definition_id    = module.ecs.ecs_task_definition_id
  security_group_id     = module.ecs.security_group_id
  ecomm_alb_listener    = module.load_balancer_config.ecomm_alb_listener
  depends_on            = [module.ecs]
}