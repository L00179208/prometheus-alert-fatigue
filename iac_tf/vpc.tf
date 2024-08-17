# Define the VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Define Subnet in AZ1
resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
}

# Define Subnet in AZ2
resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
}
