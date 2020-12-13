resource "aws_kms_key" "kms-key" {
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = format("log-bucket-%s-%s", var.application_name, var.environment)
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = format("web-bucket-%s-%s", var.application_name, var.environment)
  acl    = "private"

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
