data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

# The same VPC again, this time from the community module. The version is
# pinned to a minor series, so a new major release cannot arrive unannounced.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.8"

  name = var.env_code
  cidr = var.vpc_cidr
  azs  = local.azs

  public_subnets  = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i + 100)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Owner = "platform"
  }
}
