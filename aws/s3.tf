resource "aws_s3_bucket" "log_bucket" {
  bucket = format("log-bucket-%s-%s", var.application_name, var.environment)
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = format("web-bucket-%s-%s", var.application_name, var.environment)
  acl    = "private"
}
