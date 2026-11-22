output "alb_dns_name" {
  description = "DNS name of the load balancer."
  value       = aws_lb.main.dns_name
}

output "url" {
  description = "Address of the site."
  value       = "http://${aws_lb.main.dns_name}"
}

output "asg_name" {
  description = "Name of the Auto Scaling group. Use it to find the instances for Session Manager."
  value       = aws_autoscaling_group.app.name
}
