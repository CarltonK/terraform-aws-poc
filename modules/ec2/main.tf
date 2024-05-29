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
