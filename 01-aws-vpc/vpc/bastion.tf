# Amazon Linux 2023, resolved from the public SSM parameter.
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_key_pair" "main" {
  key_name   = "${var.env_code}-key"
  public_key = var.public_key
}

resource "aws_security_group" "bastion" {
  name        = "${var.env_code}-bastion"
  description = "SSH to the bastion from the admin address"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.env_code}-bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id
  description       = "SSH from the admin address"
  cidr_ipv4         = var.admin_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion_all" {
  security_group_id = aws_security_group.bastion.id
  description       = "Any outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "SSH to the private instance from the bastion only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.env_code}-private"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
  security_group_id            = aws_security_group.private.id
  description                  = "SSH from the bastion"
  referenced_security_group_id = aws_security_group.bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "private_all" {
  security_group_id = aws_security_group.private.id
  description       = "Any outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.env_code}-bastion"
  }
}

resource "aws_instance" "private" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.private.id]

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.env_code}-private"
  }
}
