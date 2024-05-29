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
    cidr_block = "0.0.0.0/0"
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

# Security Group
resource "aws_security_group" "default-security-group" {
  vpc_id = aws_vpc.default-network.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.workspace}-security-group"
  }
}

# EC2 instance
resource "aws_instance" "default-instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI for us-west-2
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.default_subnet.id
  vpc_security_group_ids      = [aws_security_group.default-security-group.id]

  tags = {
    Name = "${var.workspace}-Instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}