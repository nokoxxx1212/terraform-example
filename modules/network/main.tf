data "aws_availability_zones" "available" {
  state = "available"
}

#----------
# vpc
#----------
# vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.system}-${var.env}-vpc"
  }
}

# flow_log
resource "aws_flow_log" "flow_log" {
  log_destination = var.flow_log_destination
  log_destination_type = "s3"
  traffic_type = "ALL"
  vpc_id = var.vpc_cidr
}

#----------
# subnet public
#----------
# subnet_public
resource "aws_subnet" "public" {
  count             = length(var.subnet_public_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.subnet_public_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.system}-${var.env}-subnet-public-${count.index + 1}"
  }
}
