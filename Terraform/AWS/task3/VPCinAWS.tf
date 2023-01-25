resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.env_code}-VPC_Main"
  }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.env_code}-public1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.env_code}-public2"
  }
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "${var.env_code}-private1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "${var.env_code}-private2"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_code}-IGW"
  }
}
resource "aws_nat_gateway" "natgw1" {
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.eip1.id
  tags = {
    Name = "${var.env_code}-natgw1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_nat_gateway" "natgw2" {
  subnet_id     = aws_subnet.public2.id
  allocation_id = aws_eip.eip2.id
  tags = {
    Name = "${var.env_code}-natgw2"
  }
}
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_code}-public RT1"
  }
}
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw1.id
  }

  tags = {
    Name = "${var.env_code}-private RT1"
  }
}
resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw2.id
  }

  tags = {
    Name = "${var.env_code}-private RT2"
  }
}
resource "aws_eip" "eip1" {
  tags = {
    Name = "${var.env_code}-eip1"
  }
  vpc = true
}
resource "aws_eip" "eip2" {
  vpc = true
  tags = {
    Name = "${var.env_code}-eip2"
  }
}
resource "aws_route_table_association" "public_association1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public1.id
}
resource "aws_route_table_association" "public_association2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public1.id
}


resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}
resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}