resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "SnapUrlVPC"
  }
}

resource "aws_subnet" "public" {
  count             = 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "SnapUrlPublicSubnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate the Route Table with a Public Subnet
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public[0].id # Reference your public subnet with an index
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # Reference your VPC

  tags = {
    Name = "Main Internet Gateway"
  }
}

# Output definitions
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public[0].id
}
