output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet" {
  value = module.vpc.public_subnet
}
output "private_subnet" {
  value = module.vpc.private_subnet
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}
