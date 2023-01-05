
# resource "aws_alb_target_group" "ecomm_app_group_blue" {
#   name        = "terraform-alb-target-blue"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.ecomm_vpc_id
#   target_type = "ip"
#   tags = {
#     Environment = "${terraform.workspace}"
#     Name        = "${var.prefix}-blue-${var.suffix}"
#   }
# }

resource "aws_ecs_service" "ecomm_service_blue" {
  name             = "ecomm-lamp-app-${var.type}"
  cluster          = var.ecs_cluster_id     #aws_ecs_cluster.ecomm_cluster.id
  task_definition  = var.task_definition_id #aws_ecs_task_definition.ecomm_app_task.id
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    security_groups = [var.security_group_id] #[aws_security_group.ecomm_sg.id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = var.ecomm_app_group_blue
    container_name   = "ecomm-lamp-app"
    container_port   = 80
  }

  depends_on = [var.ecomm_alb_listener]

}
