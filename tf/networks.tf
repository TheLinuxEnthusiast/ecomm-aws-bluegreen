
resource "aws_vpc" "ecomm_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ecomm_vpc"
  }
}

resource "aws_subnet" "ecomm_private_subnet" {
  vpc_id     = aws_vpc.ecomm_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "ecomm_private_subnet"
  }
}

resource "aws_subnet" "ecomm_public_subnet" {
  vpc_id     = aws_vpc.ecomm_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "ecomm_public_subnet"
  }
}

resource "aws_internet_gateway" "ecomm_igw" {
  vpc_id = aws_vpc.ecomm_vpc.id

  tags = {
    Name = "ecomm_igw"
  }
}

resource "aws_internet_gateway_attachment" "ecomm_igw_attach" {
  internet_gateway_id = aws_internet_gateway.ecomm_igw.id
  vpc_id              = aws_vpc.ecomm_vpc.id
}


resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "ecomm_nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.ecomm_public_subnet.id
}

#resource "aws_route_table" "ecomm_route_table_NAT" {
#    vpc_id = aws_vpc.ecomm_vpc.id
#
#    route {
#        cidr_block = "0.0.0.0/0"
#        nat_gateway_id = aws_nat_gateway.ecomm_nat_gateway.id
#    }
#
#    tags = {
#        Name = "ecomm_route_table_NAT"
#    }
#}

#resource "aws_route_table_association" "ecomm_rt_associate_NAT" {
#    subnet_id = aws_subnet.ecomm_private_subnet.id
#    route_table_id = aws_route_table.ecomm_route_table_NAT.id
#}


#resource "aws_route_table" "ecomm_route_table" {
#  vpc_id = aws_vpc.ecomm_vpc.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.ecomm_igw.id
#  }
#
#  route {
#    ipv6_cidr_block        = "::/0"
#    egress_only_gateway_id = aws_internet_gateway.ecomm_igw.id
#  }
#
#  tags = {
#    Name = "ecomm_route_table"
#  }
#}

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

resource "aws_route_table_association" "ecomm_associate_private" {
  subnet_id      = aws_subnet.ecomm_private_subnet.id
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

