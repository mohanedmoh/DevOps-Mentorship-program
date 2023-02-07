resource "aws_instance" "public" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private[0].id
  associate_public_ip_address = true
  availability_zone = data.aws_availability_zones.available.names[0]
  key_name = "ssh key"
  tags = {
    Name = "${var.env_code}-public"
  }
}
resource "aws_instance" "private" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private[0].id
  availability_zone = data.aws_availability_zones.available.names[0]
  key_name = "ssh key"
  tags = {
    Name = "${var.env_code}-private"
  }
}
resource "aws_security_group" "allow_ssh_public" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["90.240.135.206/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-allow_SSH-from-IP"
  }
}
resource "aws_security_group" "allow_ssh_private" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from main VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-allow_ssh-from-VPC"
  }
}
