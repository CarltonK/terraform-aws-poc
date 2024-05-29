# VPC
resource "aws_vpc" "default-network" {
  cidr_block = var.cidr_block
}

# Subnet
resource "aws_subnet" "default_subnet" {
  vpc_id            = aws_vpc.default-network.id
  cidr_block        = var.cidr_block
  tags = {
    "name" = "${var.workspace}-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default-gateway" {
  vpc_id = aws_vpc.default-network.id

  tags = {
    Name = "${var.workspace}-net-gateway"
  }
}

# Routing table
resource "aws_route_table" "default-route" {
  vpc_id = aws_vpc.default-network.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.default-gateway.id
  }

  tags = {
    Name = "${var.workspace}-routing-table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "default-route-subnet" {
  subnet_id      = aws_subnet.default_subnet.id
  route_table_id = aws_route_table.default-route.id
}