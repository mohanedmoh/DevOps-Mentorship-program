output "instance_id" {
  description = "ID of the instance."
  value       = aws_instance.app.id
}

output "private_ip" {
  description = "Private IP address of the instance."
  value       = aws_instance.app.private_ip
}
