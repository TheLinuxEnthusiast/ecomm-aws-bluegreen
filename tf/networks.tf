
resource "aws_vpc" "ecomm_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ecomm_vpc"
  }
}

resource "aws_subnet" "ecomm_private_subnet1" {
  vpc_id     = aws_vpc.ecomm_vpc.id
  cidr_block = var.private_subnet_cidr1

  tags = {
    Name = "ecomm_private_subnet1"
  }
  depends_on = [
    aws_vpc.ecomm_vpc
  ]
}

resource "aws_subnet" "ecomm_private_subnet2" {
  vpc_id     = aws_vpc.ecomm_vpc.id
  cidr_block = var.private_subnet_cidr2

  tags = {
    Name = "ecomm_private_subnet2"
  }
  depends_on = [
    aws_vpc.ecomm_vpc
  ]
}
resource "aws_subnet" "ecomm_public_subnet" {
  vpc_id     = aws_vpc.ecomm_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "ecomm_public_subnet"
  }
  depends_on = [
    aws_vpc.ecomm_vpc
  ]
}

resource "aws_internet_gateway" "ecomm_igw" {
  vpc_id = aws_vpc.ecomm_vpc.id

  tags = {
    Name = "ecomm_igw"
  }
  depends_on = [
    aws_vpc.ecomm_vpc
  ]
}


resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "ecomm_nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.ecomm_public_subnet.id
  depends_on = [
    aws_eip.eip,
    aws_subnet.ecomm_public_subnet
  ]
}


resource "aws_route_table" "ecomm_private_route_table" {
  vpc_id = aws_vpc.ecomm_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecomm_nat_gateway.id
  }

  tags = {
    Name = "ecomm_private_route_table"
  }
}

resource "aws_route_table_association" "ecomm_associate_private1" {
  subnet_id      = aws_subnet.ecomm_private_subnet1.id
  route_table_id = aws_route_table.ecomm_private_route_table.id
}

resource "aws_route_table_association" "ecomm_associate_private2" {
  subnet_id      = aws_subnet.ecomm_private_subnet2.id
  route_table_id = aws_route_table.ecomm_private_route_table.id
}

resource "aws_route_table" "ecomm_public_route_table" {
  vpc_id = aws_vpc.ecomm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm_igw.id
  }

  tags = {
    Name = "ecomm_public_route_table"
  }
}

resource "aws_route_table_association" "ecomm_associate_public" {
  subnet_id      = aws_subnet.ecomm_public_subnet.id
  route_table_id = aws_route_table.ecomm_public_route_table.id
}

