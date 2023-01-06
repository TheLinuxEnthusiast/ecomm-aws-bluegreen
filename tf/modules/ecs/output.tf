
output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecomm_cluster.id
}

output "ecs_task_definition_id" {
  value = aws_ecs_task_definition.ecomm_app_task.id
}

output "security_group_id" {
  value = aws_security_group.ecomm_sg.id
}