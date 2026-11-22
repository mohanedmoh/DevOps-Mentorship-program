data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs       = data.aws_availability_zones.available.names
  nat_count = var.single_nat_gateway ? 1 : length(var.public_cidrs)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env_code}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_code}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "${var.env_code}-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_code}-igw"
  }
}

resource "aws_eip" "nat" {
  count = local.nat_count

  domain = "vpc"

  tags = {
    Name = "${var.env_code}-nat-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count = local.nat_count

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat[count.index].id

  tags = {
    Name = "${var.env_code}-nat-${count.index + 1}"
  }

  # The gateway needs the internet gateway to exist first.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.env_code}-public"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_cidrs)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[var.single_nat_gateway ? 0 : count.index].id
  }

  tags = {
    Name = "${var.env_code}-private-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
