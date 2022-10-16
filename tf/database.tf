
resource "random_password" "db_master_pass" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "random_id" "id" {
  byte_length = 8
}

resource "aws_secretsmanager_secret" "db-pass" {
  name = "db-pass-${random_id.id.hex}"
}

# initial value
resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id = aws_secretsmanager_secret.db-pass.id
  secret_string = jsonencode(
    {
      username = aws_db_instance.ecomm_mysql_db.username
      password = aws_db_instance.ecomm_mysql_db.password
      engine   = "mysql"
      host     = aws_db_instance.ecomm_mysql_db.endpoint
    }
  )
}

resource "aws_db_subnet_group" "ecomm_subnet_group" {
  name        = "ecomm_rds_subnet_group"
  description = "DB Subnet group for Ecomm RDS instance"
  subnet_ids  = [aws_subnet.ecomm_private_subnet1.id, aws_subnet.ecomm_private_subnet2.id]
  tags = {
    Name = "ecomm_subnet_group"
  }
}


resource "aws_db_instance" "ecomm_mysql_db" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  port                 = var.db_port
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = random_password.db_master_pass.result
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  db_subnet_group_name   = aws_db_subnet_group.ecomm_subnet_group.id
  vpc_security_group_ids = [aws_security_group.ecomm_rds_security_group.id]

  tags = {
    Name = "ecomm_mysql_db"
  }
}

/*
resource "null_resource" "db_bootstrap" {
  triggers = {
    file = filesha1("sql/bootstrap.sql")
  }
  provisioner "local-exec" {

    command = <<-EOF
			while read line; do
				echo "$line"
				aws rds-data execute-statement --resource-arn "$DB_ARN" --database  "$DB_NAME" --secret-arn "$SECRET_ARN" --sql "$line"
			done  < <(awk 'BEGIN{RS=";\n"}{gsub(/\n/,""); if(NF>0) {print $0";"}}' sql/bootstrap.sql)	
		EOF
    environment = {
      DB_ARN     = aws_db_instance.ecomm_mysql_db.arn
      DB_NAME    = aws_db_instance.ecomm_mysql_db.address
      SECRET_ARN = aws_secretsmanager_secret.db-pass.arn
    }
    interpreter = ["bash", "-c"]
  }
  depends_on = [
    aws_db_instance.ecomm_mysql_db
  ]
}
*/
