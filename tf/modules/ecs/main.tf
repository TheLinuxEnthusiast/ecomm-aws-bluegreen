
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
  execution_role_arn       = data.aws_iam_role.exeution_role_arn_ecs.arn
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<EOF
   [
    {
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/ecomm-test",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "hostPort": 80,
          "protocol": "tcp",
          "containerPort": 80
        }
      ],
      "cpu": 256,
      "memoryReservation": 512,
      "image": "275562404519.dkr.ecr.eu-west-1.amazonaws.com/ecomm-lamp-app:latest",
      "essential": true,
      "name": "ecomm-lamp-app"
    },
    {
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/ecomm-test",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "hostPort": 3306,
          "protocol": "tcp",
          "containerPort": 3306
        }
      ],
      "cpu": 256,
      "memoryReservation": 512,
      "image": "275562404519.dkr.ecr.eu-west-1.amazonaws.com/mariadb:latest",
      "essential": true,
      "name": "ecomm-db"
    }
   ]
   EOF
  tags                     = local.tags
}
