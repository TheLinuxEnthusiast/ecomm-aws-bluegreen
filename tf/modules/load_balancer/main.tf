
# Configure target group
resource "aws_lb_target_group" "target_group" {
  name        = "${var.prefix}-target-group"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = var.ecomm_vpc_id
}


# Security group for load balancer
resource "aws_security_group" "lb_security_group" {
  name        = "lb_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.ecomm_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.ecomm_vpc.cidr_block]
    ipv6_cidr_blocks = [var.ecomm_vpc.ipv6_cidr_block]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.ecomm_vpc.cidr_block]
    ipv6_cidr_blocks = [var.ecomm_vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}-alb-security-group"
  }
}

# Create an application load balancer
resource "aws_lb" "ecomm_load_balancer" {
  name               = "${var.prefix}_load_balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = var.aws_bucket_logs
    prefix  = "ecomm-lb"
    enabled = true
  }

  tags = {
    Environment = "development"
    Name="${var.prefix}-load-balancer"
  }
}
