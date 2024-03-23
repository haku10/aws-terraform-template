data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.system}-${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.system}-${var.env}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.cidr_subnet_public)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.cidr_subnet_public, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.system}-${var.env}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.cidr_subnet_private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_subnet_private, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.system}-${var.env}-private-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = length(var.cidr_subnet_private)

  vpc = true

  tags = {
    Name = "${var.system}-${var.env}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(var.cidr_subnet_private)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = "${var.system}-${var.env}-nat-gw-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.system}-${var.env}-public-rt"
  }
}
resource "aws_route_table_association" "public" {
  count          = length(var.cidr_subnet_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "${var.system}-${var.env}-private-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.cidr_subnet_private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
