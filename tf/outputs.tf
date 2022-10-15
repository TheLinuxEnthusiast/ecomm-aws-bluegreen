
output "rds_hostname" {
  value       = aws_db_instance.ecomm_mysql_db.address
  description = "Hostname of Created RDS instance"
  sensitive   = false
}
