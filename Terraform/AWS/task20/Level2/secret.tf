data "aws_secretsmanager_secret" "rds_password" {
  name = "rds/password"
}
data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}
locals {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string)["rds_password"]
}
