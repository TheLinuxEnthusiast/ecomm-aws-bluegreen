
prefix="ecomm"
ecomm_vpc_cidr="10.10.0.0/16"
#ecomm_private_subnet_1="10.10.1.0/24"
#ecomm_private_subnet_2="10.10.2.0/24"
#ecomm_public_subnet_1="10.10.3.0/24"
#ecomm_public_subnet_2="10.10.4.0/24"
ecomm_private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
ecomm_public_subnets = ["10.10.3.0/24", "10.10.4.0/24"]
instance_size="t2.micro"
azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
