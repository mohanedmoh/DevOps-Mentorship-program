module "vpc" {
  source = "../Modules/vpc"

  env_code           = var.env_code
  vpc_cidr           = var.vpc_cidr
  private_cidr       = var.private_cidr
  public_cidr        = var.public_cidr
  availability_zones = var.availability_zones
}