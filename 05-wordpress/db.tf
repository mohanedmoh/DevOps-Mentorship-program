resource "aws_db_subnet_group" "main" {
  name       = "${var.env_code}-wp"
  subnet_ids = local.private_subnet_ids
}

resource "aws_db_instance" "main" {
  identifier     = "${var.env_code}-wordpress"
  engine         = "mysql"
  engine_version = "8.4"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "wordpress"
  username = "wpadmin"

  # RDS creates the master password and keeps it in Secrets Manager.
  # It never appears in the code, in a variable or in the state file.
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 7

  # Practice settings. For real data set a final snapshot and deletion protection.
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true
}
