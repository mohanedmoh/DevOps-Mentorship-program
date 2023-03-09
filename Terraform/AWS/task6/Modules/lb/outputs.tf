output "lb_allow_http_public" {
  value = aws_security_group.lb_allow_http_public.id
}
output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}
output "lb_arn" {
  value = aws_lb.main.arn
}
