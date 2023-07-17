resource "aws_kms_key" "this" {
  count = var.kms_key_arn == "" ? 1 : 0
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.use_for_logs ? "log-delivery-write" : var.acl

  depends_on = [
    aws_s3_bucket_ownership_controls.this
  ]
}

resource "aws_s3_bucket_logging" "this" {
  count         = length(var.logging) == 0 ? 0 : 1
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn == "" ? aws_kms_key.this[0].arn : var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.use_versioning ? "Enabled": "Disabled"
  }
}
