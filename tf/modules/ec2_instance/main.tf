
# Security group for launch configuration
resource "aws_security_group" "ecomm_sg" {
  name        = "allow_tls"
  description = "Allow inbound traffic from public subnets"
  vpc_id      = var.ecomm_vpc_id

  ingress {
    description      = "Inbound access from public subnet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.public_subnets
  }

  ingress {
    description      = "Inbound SSH access from public subnet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.public_subnets
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}-allow_tls"
  }
}


data "aws_ami" "ecomm_ami" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["ecomm-app-*"]
  }
}

#launch configuration
resource "aws_launch_configuration" "ecomm_launch_config" {
	name_prefix = "${var.prefix}-lamp-"
	image_id = data.aws_ami.ecomm_ami.id
	instance_type = var.instance_size
	user_data = file("modules/ec2_instance/scripts/user-data.sh")
	key_name = var.ec2_key_name

	lifecycle {
    		create_before_destroy = true
  	}

	security_groups = [aws_security_group.ecomm_sg.id]
}

# Autoscaling group
resource "aws_autoscaling_group" "ecomm_autoscaling_group" {
  name                 = "${var.prefix}-autoscaling"
  launch_configuration = aws_launch_configuration.ecomm_launch_config.name
  vpc_zone_identifier = var.private_subnets 
  min_size             = 2
  max_size             = 3

  lifecycle {
    create_before_destroy = true
  }
}



