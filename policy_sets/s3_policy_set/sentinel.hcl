policy "logging" {
  source            = "../../sentinel/s3_logging.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "versioning" {
  source            = "../../sentinel/s3_versioning.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "encryption" {
  source            = "../../sentinel/s3_encryption.sentinel"
  enforcement_level = "soft-mandatory"
}
