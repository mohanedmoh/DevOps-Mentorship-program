module "rds" {
  source = "../Modules/rds"

  subnet_ids=data.terraform_remote_state.level1.outputs.private_subnet
  env_code = var.env_code
  db_name="mydb"
  db_username="admin"
  db_password = local.db_password
  vpc_id= data.terraform_remote_state.level1.outputs.vpc_id
  source_security_group=module.asg.security_group_id
}
