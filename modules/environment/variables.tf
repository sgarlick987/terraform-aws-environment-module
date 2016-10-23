variable "environment" {
  description = "the name of the environment to create resources in"
  type = "string"
}

variable "global_environment" {
  description = "the name of the environment to lookup global resources in"
  type = "string"
  default = "global"
}

variable "aws_region" {
  description = "the aws region to deploy this environment in"
  type = "string"
  default = "us-east-1"
}

variable "global_aws_region" {
  description = "the aws region for global resouces such as the terraform state bucket"
  type = "string"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "the cidr for the vpc in this environment"
  type = "string"
}

variable "public_subnet_cidrs" {
  description = "list of cidr address each public subnets"
  type = "list"
}

variable "private_subnet_cidrs" {
  description = "list of cidr address each private subnets"
  type = "list"
}

variable "route53_domain" {
  description = "the domain name for route53 zones and records"
  type = "string"
}

variable "short_domain" {
  description = "a simple short name or acrynom domain for use in naming global unique resouces like s3 buckets"
  type = "string"
}