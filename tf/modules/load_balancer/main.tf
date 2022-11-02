
# Security group for load balancer
resource "aws_security_group" "lb_security_group" {
  name        = "lb_security_group"
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
  security_groups = ["${aws_security_group.lb_security_group.id}"]
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
  stickiness {
    type = "lb_cookie"
  }
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/"
    port = 80
  }
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

data "aws_instance" "get_instance_id_A" {
	filter {
    		name   = "tag:Name"
    		values = ["ecomm-instance-${var.suffix}"]
  	}
	filter {
		name = "availability-zone"
		values = ["eu-west-1a"]
	}
}

data "aws_instance" "get_instance_id_B" {
	filter {
		name = "tag:Name"
		values = ["ecomm-instance-${var.suffix}"]
	}
	filter {
                name = "availability-zone"
                values = ["eu-west-1b"]
        }
}

resource "aws_alb_target_group_attachment" "targetA" {
	target_group_arn = aws_alb_target_group.ecomm_app_group.arn
	port = 80
	target_id = data.aws_instance.get_instance_id_A.id
}

resource "aws_alb_target_group_attachment" "targetB" {
	target_group_arn = aws_alb_target_group.ecomm_app_group.arn
	port = 80
	target_id = data.aws_instance.get_instance_id_B.id
}
