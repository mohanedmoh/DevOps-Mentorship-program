output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet" {
  value = aws_subnet.public[0].id
}
output "private_subnet" {
  value = aws_subnet.private[0].id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}