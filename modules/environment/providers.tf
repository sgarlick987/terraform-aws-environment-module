provider "aws" {
  region = "${var.aws_region}"
}

provider "aws" {
  region = "${var.global_aws_region}"
  alias = "${var.global_environment}"
}
