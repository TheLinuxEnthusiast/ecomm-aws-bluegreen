
resource "aws_vpc" "ecomm_vpc" {
	cidr_block = var.ecomm_vpc
	tags = {
	   Name = "${var.prefix}-vpc"
	}
}

resource "aws_subnet" "ecomm_private_subnet_1" {
	vpc_id = aws_vpc.ecomm_vpc.id
        cidr_block = var.ecomm_private_subnet_1
	
	tags = {
		Name = "${var.prefix}-private-subnet-1"
        }
}

resource "aws_subnet" "ecomm_private_subnet_2" {
	vpc_id = aws_vpc.ecomm_vpc.id
        cidr_block = var.ecomm_private_subnet_2
	
	tags = {
		Name = "${var.prefix}-private-subnet-2"
        }
}

resource "aws_subnet" "ecomm_public_subnet_1" {
	vpc_id = aws_vpc.ecomm_vpc.id
        cidr_block = var.ecomm_public_subnet_1
	
	tags = {
		Name = "${var.prefix}-public-subnet-1"
        }
}

resource "aws_subnet" "ecomm_public_subnet_2" {
	vpc_id = aws_vpc.ecomm_vpc.id
        cidr_block = var.ecomm_public_subnet_2
	
	tags = {
		Name = "${var.prefix}-public-subnet-2"
        }
}


