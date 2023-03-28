data "aws_route53_zone" "main" {
  name = "devopsmentor.link"
}
module "acm" {
  source = "terraform-aws-modules/acm/aws"

  domain_name         = "www.devopsmentor.link"
  zone_id             = data.aws_route53_zone.main.zone_id
  wait_for_validation = true
}

module "external_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.env_code}-external"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https to ELB"
      cidr_block  = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "any from ELB"
      cidr_block  = "0.0.0.0/0"
    }
  ]
}

module "elb" {
  source = "terraform-aws-modules/alb/aws"

  name = var.env_code

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.level1.outputs.vpc_id
  internal        = false
  subnets         = data.terraform_remote_state.level1.outputs.public_subnet
  security_groups = [module.external_sg.security_group_id]

  target_groups = [
    {
      name_prefix          = var.env_code
      backend_protocol     = "HTTP"
      backend_port         = 80
      deregistration_delay = 10

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
        matcher             = 200
      }
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      action_type        = "forward"
      target_group_index = 0
    }
  ]
}
module "dns" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_id = data.aws_route53_zone.main.zone_id
  records = [
    {
      name    = "www.${data.aws_route53_zone.main.name}"
      type    = "CNAME"
      ttl     = "3600"
      records = [module.elb.lb_dns_name]
    }
  ]

}

