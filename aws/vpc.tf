resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  tags = {
    Name = format("vpc-%s-%s", var.application_name, var.environment)
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("internet-gateway-%s-%s", var.application_name, var.environment)
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr, 8, count.index)
  availability_zone = format("%s%s", var.aws_region, var.availability_zones[count.index])
  tags = {
    Name = format("subnet-%s-%s-public-%s", var.application_name, var.environment, var.availability_zones[count.index])
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = format("%s-%s-public-route-table", var.application_name, var.environment)
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = element(aws_subnet.public_subnet, count.index).id
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr, 8, count.index + length(aws_subnet.public_subnet))
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = format("subnet-%s-%s-private-%s", var.application_name, var.environment, var.availability_zones[count.index])
  }
}

resource "aws_eip" "nat_gateway_eip" {
  count = length(var.availability_zones)
  vpc   = true

  tags = {
    Name = format("nat-gateway-eip-%s-%s-%s", var.application_name, var.environment, var.availability_zones[count.index])
  }
}

resource "aws_nat_gateway" "nat_gateways" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet, 0).id
  tags = {
    Name = format("nat-gateway-%s-%s-%s", var.application_name, var.environment, var.availability_zones[count.index])
  }
}

resource "aws_route_table" "private_route_tables" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }
  tags = {
    Name = format("private-route-table-%s-%s-%s", var.application_name, var.environment, var.availability_zones[count.index])
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet)
  route_table_id = aws_route_table.private_route_tables[count.index].id
  subnet_id      = element(aws_subnet.private_subnet, count.index).id
}
