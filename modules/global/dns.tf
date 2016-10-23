resource "aws_route53_zone" "global" {
  name = "${var.route53_domain}"
  comment = "top level route53 zone for production cnames and ns delegation to environment spcific ns"

  tags {
    Environment = "${var.environment}"
  }
}

output "route53_zone" {
  value = "${aws_route53_zone.global.zone_id}"
}