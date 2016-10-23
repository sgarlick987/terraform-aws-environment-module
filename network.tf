module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"

  name = "${var.environment}"

  cidr = "${var.vpc_cidr}"
  private_subnets = "${var.private_subnet_cidrs}"
  public_subnets = "${var.public_subnet_cidrs}"

  enable_nat_gateway = "true"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  azs = [
    "${data.aws_availability_zones.available.names[0]}",
    "${data.aws_availability_zones.available.names[1]}",
    "${data.aws_availability_zones.available.names[2]}"]
}

resource "aws_db_subnet_group" "private" {
  name = "main"
  subnet_ids = ["${module.vpc.private_subnets}"]
  tags {
    Name = "${var.environment}-private-subnets"
    Environment = "${var.environment}"

  }
}

resource "aws_key_pair" "bootstrap_key_pair" {
  key_name = "${var.environment}"
  public_key = "${file("../files/ssh_key_pair.pub")}"
}
