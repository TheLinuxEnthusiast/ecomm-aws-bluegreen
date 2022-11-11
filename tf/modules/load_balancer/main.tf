
# Security group for load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "${var.prefix}-alb_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.ecomm_vpc_id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}-alb-security-group-${var.suffix}"
  }
}


resource "aws_alb" "ecomm_alb" {
  name            = "${var.prefix}-alb"
  security_groups = ["${aws_security_group.alb_security_group.id}"]
  subnets         = var.public_subnets
  tags = {
    Name = "${var.prefix}-alb-${var.suffix}"
  }
}


resource "aws_alb_target_group" "ecomm_app_group" {
  name     = "terraform-example-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.ecomm_vpc_id
  target_type = "ip"
}


resource "aws_alb_listener" "ecomm_listener_http" {
  load_balancer_arn = aws_alb.ecomm_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecomm_app_group.arn
    type             = "forward"
  }
}

