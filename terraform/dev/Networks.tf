
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["AndVPC"]
  }
}

data "aws_route_table" "rt" {
  filter {
    name   = "tag:Name"
    values = ["AndMainRT"]
  }
}


resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy
  enable_dns_hostnames = var.enable_dns_support
  enable_dns_support = var.enable_dns_hostnames
  tags = {
    Name = var.vpc_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

#Adding subnet for each host
resource "aws_subnet" "public" {
  count = var.instance_count
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  vpc_id = data.aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  tags = {
    Name = cidrsubnet(var.vpc_cidr, 8, count.index)
  }
}

resource "aws_route_table_association" "public" {
  count = var.instance_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = data.aws_route_table.rt.id
}
