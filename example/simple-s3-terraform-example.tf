module "s3_bucket_logs" {
  source       = "git::https://github.com/aptivator/simple-s3-terraform.git//module"
  bucket_name  = "${local.bucket_base_name}-logs"
  use_for_logs = true
}

module "s3_bucket" {
  source      = "git::https://github.com/aptivator/simple-s3-terraform.git//module"
  bucket_name = local.bucket_base_name
  
  logging = {
    target_bucket = module.s3_bucket_logs.id
    target_prefix = "logs"
  }
}
