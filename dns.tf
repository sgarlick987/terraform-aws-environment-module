data "terraform_remote_state" "global" {
  backend = "s3"
  config {
    bucket = "${var.short_domain}-${var.global_environment}-terraform-state-${var.global_aws_region}"
    key = "${var.global_environment}/${var.global_aws_region}.tfstate"
    region = "${var.global_aws_region}"
  }
}

resource "aws_route53_zone" "delegated_zone" {
  name = "${var.environment}.${var.route53_domain}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_route53_record" "ns" {
  provider = "aws.${var.global_environment}"
  zone_id = "${data.terraform_remote_state.global.route53_zone}"
  name = "${var.environment}.${var.route53_domain}"
  type = "NS"
  ttl = "30"
  records = [
    "${aws_route53_zone.delegated_zone.name_servers.0}",
    "${aws_route53_zone.delegated_zone.name_servers.1}",
    "${aws_route53_zone.delegated_zone.name_servers.2}",
    "${aws_route53_zone.delegated_zone.name_servers.3}"
  ]
}

output "route53_env_zone" {
  value = "${aws_route53_zone.delegated_zone.zone_id}"
}

output "route53_global_zone" {
  value = "${data.terraform_remote_state.global.route53_zone}"
}