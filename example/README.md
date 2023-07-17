# `simple-s3-terraform` example

## Directions

* Go to `example` folder
* Create file (e.g., `simple-s3-terraform-configs.tf`) to store the configurations
* Add the following settings to the above file:

  ```tf
  provider "aws" {
    shared_config_files      = ["~/.aws/config"]
    shared_credentials_files = ["~/.aws/credentials"]
    profile                  = "<AWS Profile to Use>"
  }

  locals {
    bucket_base_name = "<name for S3 bucket>"
  }
  ```
* Run `terraform init`
* Run `terraform apply`
* Run `terraform destroy`
