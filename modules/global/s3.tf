resource "aws_s3_bucket" "terraform_global_state" {
  bucket = "${var.short_domain}-${var.environment}-terraform-state-${var.aws_region}"
  acl = "private"

  tags {
    Name = "${var.short_domain}-${var.environment}-terraform-state-${var.aws_region}"
    Environment = "${var.environment}"
    Application = "terraform"
  }
}