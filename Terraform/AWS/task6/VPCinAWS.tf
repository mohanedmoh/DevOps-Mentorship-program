resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.env_code}-VPC_Main"
  }
}
resource "aws_subnet" "public" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.env_code}-public-${(count.index) + 1}"
  }
}
resource "aws_subnet" "private" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.env_code}-private-${(count.index) + 1}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_code}-IGW"
  }
}
resource "aws_nat_gateway" "natgw" {
  count = length(var.public_cidr)

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.eip[count.index].id
  tags = {
    Name = "${var.env_code}-natgw-${(count.index) + 1}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_code}-public RT"
  }
}
resource "aws_route_table" "private" {
  count  = length(var.private_cidr)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw[count.index].id
  }

  tags = {
    Name = "${var.env_code}-private RT-${(count.index) + 1}"
  }
}
resource "aws_eip" "eip" {
  count = length(var.public_cidr)
  vpc   = true

  tags = {
    Name = "${var.env_code}-eip-${(count.index) + 1}"
  }
}
resource "aws_route_table_association" "public_association" {
  count = length(var.public_cidr)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public1.id
}
resource "aws_route_table_association" "private_association" {
  count = length(var.private_cidr)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
