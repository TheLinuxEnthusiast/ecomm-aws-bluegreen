
data "aws_ami" "ecomm_ami" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["ecomm-app-*"]
  }
}

#launch configuration
resource "aws_launch_configuration" "ecomm_launch_config" {
	name = "${var.prefix}-launch-config"
	image_id = data.aws_ami.ecomm_ami.id
	instance_type = var.instance_size

	lifecycle {
    		create_before_destroy = true
  	}
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



