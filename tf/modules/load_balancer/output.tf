
output "ecomm_alb_id" {
  value = aws_alb.ecomm_alb.id
}

output "ecomm_alb_dns" {
  value = aws_alb.ecomm_alb.dns_name
}

output "ecomm_target_group_arn_blue" {
  value = aws_alb_target_group.ecomm_app_group_blue.arn
}

output "ecomm_target_group_arn_green" {
  value = aws_alb_target_group.ecomm_app_group_green.arn
}

output "ecomm_alb_listener" {
  value = aws_alb_listener.ecomm_listener_http.arn
}

output "ecomm_alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}
