output "url" {
  description = "Address of the site."
  value       = "https://${var.site_hostname}"
}

output "db_endpoint" {
  description = "Address of the MySQL database."
  value       = aws_db_instance.main.address
}

output "db_secret_arn" {
  description = "ARN of the secret that holds the database password. The value is not shown here."
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}
