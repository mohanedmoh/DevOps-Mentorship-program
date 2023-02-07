output "public-instance-IP" {
  description = "IP of public instance"
  value       = aws_instance.public.public_ip
}