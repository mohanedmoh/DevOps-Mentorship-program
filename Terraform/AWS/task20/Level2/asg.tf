module "private_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env_code}-private"
  description = "allow port 80 and 3306 TCP inbound to ec2 ASG instances within VPC"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  computed_ingress_with_source_security_group_id = [{
    rule                     = "http-80-tcp"
    source_security_group_id = module.external_sg.security_group_id
  }]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "https to ELB"
      cidr_block  = "0.0.0.0/0"
    }
  ]
}
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.env_code

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_grace_period = 400
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.terraform_remote_state.level1.outputs.private_subnet
  target_group_arns         = module.elb.target_group_arns
  force_delete              = true

  # Launch template
  launch_template_name        = var.env_code
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id        = data.aws_ami.amazonlinux.id
  instance_type   = "t2.micro"
  security_groups = [module.private_sg.security_group_id]
  
  user_data       = data.template_cloudinit_config.config.rendered #file("userdata.sh")


  tags = {
    Environment = var.env_code
  }
}

data "template_file" "client" {
  template = file("userdata.sh")
}
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    export password="${local.db_password}"
    EOF
  }
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}


# data "template_file" "init" {
#   template = "${file("userdata.sh")}"

#   vars = {
#     password = "${local.db_password}"
#     #host     = "${module.rds.endpoint}"
#   }
# }
