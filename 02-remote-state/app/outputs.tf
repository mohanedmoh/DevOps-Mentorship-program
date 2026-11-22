output "url" {
  description = "Address of the web server."
  value       = "http://${aws_instance.web.public_ip}"
}
