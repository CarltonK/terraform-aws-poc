# Create a VPC
resource "aws_vpc" "default-network" {
  cidr_block = var.cidr_block
}
