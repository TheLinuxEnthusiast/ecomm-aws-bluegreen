terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "eu-west-1"
  shared_config_files      = ["/home/dfoley/.aws/config"]
  shared_credentials_files = ["/home/dfoley/.aws/credentials"]
  profile                  = "default"
}
