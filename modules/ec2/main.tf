# Create a VPC
resource "aws_vpc" "default-network" {
  cidr_block = var.cidr_block
}

# Create a subnet
resource "aws_subnet" "default_subnet" {
  vpc_id            = aws_vpc.default-network.id
  cidr_block        = var.cidr_block
  availability_zone = var.region
  tags = {
    "name" = var.workspace
  }
}
