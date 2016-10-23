variable "route53_domain" {
  description = "the domain name for route53 zones and records"
  type = "string"
}

variable "short_domain" {
  description = "a simple short name or acrynom domain for use in naming global unique resouces like s3 buckets"
  type = "string"
}

variable "environment" {
  description = "what to call this global environment"
  "type" = "string"
  default = "global"
}

variable "aws_region" {
  description = "the aws region to deploy this environmen in"
  type = "string"
}