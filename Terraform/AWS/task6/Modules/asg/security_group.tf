resource "aws_security_group" "allow_ssh_private" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "http from lb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.lb_allow_http_public]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-allow_ssh-from-VPC"
  }
}