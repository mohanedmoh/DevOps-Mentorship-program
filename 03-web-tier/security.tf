resource "aws_security_group" "alb" {
  name        = "${var.env_code}-alb"
  description = "HTTP to the load balancer"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.env_code}-alb"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.env_code}-app"
  description = "HTTP from the load balancer only"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.env_code}-app"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from the allowed address"
  cidr_ipv4         = var.allowed_cidr
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  description                  = "HTTP to the web servers"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "app_http" {
  security_group_id            = aws_security_group.app.id
  description                  = "HTTP from the load balancer"
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

# The servers need to reach the internet through the NAT gateway for
# package installs and for the Systems Manager agent.
resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  description       = "Any outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
