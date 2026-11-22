resource "aws_security_group" "alb" {
  name        = "${var.env_code}-wp-alb"
  description = "HTTP and HTTPS to the load balancer"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.env_code}-wp-alb"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.env_code}-wp-app"
  description = "HTTP from the load balancer only"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.env_code}-wp-app"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.env_code}-wp-db"
  description = "MySQL from the WordPress server only"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.env_code}-wp-db"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP, redirected to HTTPS"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTPS"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  description                  = "HTTP to the WordPress server"
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

resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  description       = "Any outbound traffic, for the image pull, the secret and the database"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "db_mysql" {
  security_group_id            = aws_security_group.db.id
  description                  = "MySQL from the WordPress server"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}
