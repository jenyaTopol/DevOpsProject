





############vpc.tf#####

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list"{
  input = data.aws_availability_zones.available.names
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyDevOpsVPC-${random_integer.random.id}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = var.public_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_route_table_assocation" "public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  count                   = var.private_sn_count  
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index] 

  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_route_table_assocation" "private_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_route_table.id
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "MyNATGateway"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = data.private_cidr
  gateway_id             = aws_internet_gateway.nat_gw.id

}

resource "aws_security_group" "public_sg" {
  name        = public_sg
  description = "Security group for public subnets"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_block = var.public_cidr
  }
  egress {
    from_prot  = 0 
    to_port    = 0
    protocol   = "-1"
    cidr_block = [0.0.0.0/0]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Security group for private subnets"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = var.private_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = var.private_cidr
  }
}

resource "aws_db_subnet_group" "my_rds_subnetgroup" {
  count var.aws_db_subnet_group == true ? 1 : 0
  name       = "my_rds_subnetgroup"
  subnet_ids = aws_subnet.private_subnet.*.id
  tags = {
    Name = "my_rds_subnetgroup"
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port     = 3306
    to_port       = 3306
    protocol      = "tcp"
    cidr_blocks   = var.private_cidr
  }
}









