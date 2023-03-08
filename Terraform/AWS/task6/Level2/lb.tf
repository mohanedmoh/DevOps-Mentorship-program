module "lb" {
  source = "../Modules/lb"

  env_code      = var.env_code
  public_subnet = data.terraform_remote_state.level1.outputs.public_subnet
  vpc_id        = data.terraform_remote_state.level1.outputs.vpc_id
}
