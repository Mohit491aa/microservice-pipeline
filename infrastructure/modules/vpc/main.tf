# 1. Define the main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# 2. Create Public Subnets
resource "aws_subnet" "public" {
  for_each          = { for i, cidr in var.public_subnet_cidr_blocks : i => cidr }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${each.key + 1}"
  }
}

# 3. Create Private Subnets
resource "aws_subnet" "private" {
  for_each          = { for i, cidr in var.private_subnet_cidr_blocks : i => cidr }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]
  tags = {
    Name = "${var.project_name}-private-subnet-${each.key + 1}"
  }
}

# 4. Create an Internet Gateway for public traffic
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# 5. Create a Public Route Table to route traffic to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# 6. Associate the Public Route Table with the Public Subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# 7. Create an Elastic IP and a NAT Gateway for private subnets to access the internet
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id # Place NAT in the first public subnet
  tags = {
    Name = "${var.project_name}-nat-gw"
  }
  depends_on = [aws_internet_gateway.main]
}

# 8. Create a Private Route Table to route traffic to the NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# 9. Associate the Private Route Table with the Private Subnets
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}