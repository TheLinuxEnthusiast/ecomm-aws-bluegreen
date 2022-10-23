
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

module "networking" {
	source = "./modules/networking"

	ecomm_vpc = var.ecomm_vpc
	prefix = var.prefix
	ecomm_private_subnet_1 = var.ecomm_private_subnet_1
	ecomm_private_subnet_2 = var.ecomm_private_subnet_2
	ecomm_public_subnet_1 = var.ecomm_public_subnet_1
	ecomm_public_subnet_2 = var.ecomm_public_subnet_2
}

output "ecomm_vpc_id" {
	value = module.networking.ecomm_vpc_id
}

