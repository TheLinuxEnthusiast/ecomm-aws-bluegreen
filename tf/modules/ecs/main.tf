
locals {
  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-${var.suffix}"
  }
}

resource "aws_security_group" "ecomm_sg" {
  name   = "${var.prefix}-security-group-${var.suffix}"
  vpc_id = var.ecomm_vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [var.aws_security_group_alb]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_ecs_cluster" "ecomm_cluster" {
  name = "${var.prefix}-cluster-${var.suffix}"
}


data "aws_iam_role" "exeution_role_arn_ecs" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "ecomm_app_task" {
  family                   = "ecomm-lamp-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = data.aws_iam_role.exeution_role_arn_ecs.arn 
  cpu = 512
  memory = 1024
  container_definitions    = <<EOF
	[
    	{
      	"name"      : "ecomm-lamp-app",
      	"image"     : "275562404519.dkr.ecr.eu-west-1.amazonaws.com/ecomm-lamp-app:latest",
      	"cpu"       : 512,
      	"memory"    : 1024,
      	"essential" : true,
	"networkMode": "awsvpc",
      	"portMappings" : [
        	{
          	"containerPort" : 80,
          	"hostPort"      : 80
        	}
      		]
    		}
  	]
	EOF
  tags                     = local.tags
}


resource "aws_ecs_service" "ecomm_service" {
  name             = "ecomm-lamp-app" 
  cluster          = aws_ecs_cluster.ecomm_cluster.id
  task_definition  = aws_ecs_task_definition.ecomm_app_task.id
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    security_groups = [aws_security_group.ecomm_sg.id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "ecomm-lamp-app"
    container_port = 80
  }

  depends_on = [var.ecomm_alb_listener]

}

