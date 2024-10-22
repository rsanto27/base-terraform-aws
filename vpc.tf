resource "aws_vpc" "base-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-tag-vpc"
  }
}

data "aws_availability_zones" "available" {}
# output "az" {
#   value = "${data.aws_availability_zones.available}"
# }


resource "aws_subnet" "base-subnets" {
  count = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.base-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "base-igw" {
    vpc_id = aws_vpc.base-vpc.id
    tags = {
        Name = "${var.prefix}-igw"
    }
  
}

resource "aws_route_table" "base-rtb" {
  vpc_id = aws_vpc.base-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base-igw.id
  }
  tags = {
    Name = "${var.prefix}-rtb"
  }
}

resource "aws_route_table_association" "base-rtb-association" {
  count = 2
  route_table_id = aws_route_table.base-rtb.id
  subnet_id = aws_subnet.base-subnets.*.id[count.index]
}




# resource "aws_subnet" "base-subnet-1" {
#   availability_zone = "us-east-1a"
#   vpc_id = aws_vpc.base-vpc.id
#   cidr_block = "10.0.0.0/24"
#   tags = {
#     Name = "${var.prefix}-subnet-1"
#   }
# }

# resource "aws_subnet" "base-subnet-2" {
#   availability_zone = "us-east-1b"
#   vpc_id = aws_vpc.base-vpc.id
#   cidr_block = "10.0.1.0/24"
#   tags = {
#     Name = "base-subnet-2"
#   }
# }