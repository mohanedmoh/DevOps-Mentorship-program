module "asg" {
  source = "../Modules/asg"

  env_code             = var.env_code
  private_subnet       = data.terraform_remote_state.level1.outputs.private_subnet
  vpc_id               = data.terraform_remote_state.level1.outputs.vpc_id
  lb_allow_http_public = module.lb.lb_allow_http_public
  target_group_arn     = module.lb.target_group_arn
  ami                  = data.aws_ami.amazonlinux.id
}
