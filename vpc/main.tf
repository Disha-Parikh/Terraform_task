resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_classiclink = false
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = false
}

resource "aws_subnet" "private_subnet" {
  count = var.subnet_count
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.az, count.index)
  tags = {
    Name = "${var.subnet_name}-${count.index}-private"
  }
}
resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidr
  availability_zone = var.public_az
  tags = {
    Name = "${var.subnet_name}-public"
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}
resource "aws_route_table_association" "public_route_table_association" {
  count = var.subnet_count_public
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}
resource "aws_security_group" "allow-http-tcp" {
  vpc_id = aws_vpc.vpc.id
  name = "allow-all"
  description = "security group that allows ssh & http and all egress traffic"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security Group"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnet.id
}
resource "aws_eip" "eip" {
  vpc = true
//  network_interface = aws_network_interface.eni[count.index].id
  tags = {
    Name = "aws_eip_nat_gateway"
  }
}