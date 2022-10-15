
# Creating Security Group for ECS 
resource "aws_security_group" "ecomm_security_group" {

  vpc_id = aws_vpc.ecomm_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecomm_security_group"
  }
}

# Creating Security Group for RDS
resource "aws_security_group" "ecomm_rds_security_group" {

  vpc_id = aws_vpc.ecomm_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.10.2.0/24"]
  }

  tags = {
    Name = "ecomm_rds_security_group"
  }
}


