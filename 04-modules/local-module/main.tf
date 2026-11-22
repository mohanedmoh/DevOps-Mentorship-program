# The VPC from task 3, now behind a module. The root only says what it
# wants. The module decides how to build it.
module "vpc" {
  source = "../modules/vpc"

  name     = var.env_code
  cidr     = "10.0.0.0/16"
  az_count = 2

  tags = {
    Owner = "platform"
  }
}
