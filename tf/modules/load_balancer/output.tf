
output "ecomm_alb_id" {
  value = aws_alb.ecomm_alb.id
}

output "ecomm_alb_dns" {
  value = aws_alb.ecomm_alb.dns_name
}
