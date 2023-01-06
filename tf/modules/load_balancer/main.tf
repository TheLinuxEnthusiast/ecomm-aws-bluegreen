

# Security group for load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "${var.prefix}-alb_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.ecomm_vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-${var.suffix}"
  }
}


resource "aws_alb" "ecomm_alb" {
  name            = "${var.prefix}-alb"
  security_groups = ["${aws_security_group.alb_security_group.id}"]
  subnets         = var.public_subnets

  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-${var.suffix}"
  }
}

resource "aws_alb_target_group" "ecomm_app_group_green" {
  name        = "terraform-alb-target-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.ecomm_vpc_id
  target_type = "ip"

  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-green-${var.suffix}"
  }
}

resource "aws_alb_target_group" "ecomm_app_group_blue" {
  name        = "terraform-alb-target-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.ecomm_vpc_id
  target_type = "ip"
  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-blue-${var.suffix}"
  }
}



resource "aws_alb_listener" "ecomm_listener_http" {
  load_balancer_arn = aws_alb.ecomm_alb.arn
  port              = "80"
  protocol          = "HTTP"

  #default_action {
  #  type             = "forward"
  #  target_group_arn = aws_lb_target_group.blue.arn
  #}
  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_alb_target_group.ecomm_app_group_blue.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
      }

      target_group {
        arn    = aws_alb_target_group.ecomm_app_group_green.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }

  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-${var.suffix}"
  }
}
