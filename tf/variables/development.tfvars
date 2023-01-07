
prefix                = "ecomm"
ecomm_vpc_cidr        = "10.10.0.0/16"
ecomm_private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
ecomm_public_subnets  = ["10.10.3.0/24", "10.10.4.0/24"]
instance_size         = "t2.small"
azs                   = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
ec2_key_name          = "ec2-key-pair"
is_green              = false
is_blue               = true
traffic_distribution  = "blue"
ecr_uri               = "275562404519.dkr.ecr.eu-west-1.amazonaws.com"
frontend_name         = "ecomm-lamp-app"
backend_name          = "mariadb"
tag_version           = "latest"