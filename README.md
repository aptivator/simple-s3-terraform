# `simple-s3-terraform`

## Table of Contents

* [Introduction](#introduction)
* [Prerequisites](#prerequisites)
* [Usage](#usage)
  * [Module Inputs](#module-inputs)
  * [Configuring a Provider](#configuring-a-provider)
  * [Deploying S3 Bucket Without Logging](#deploying-s3-bucket-without-logging)
  * [Deploying S3 Bucket With Logging](#deploying-s3-bucket-with-logging)
  * [Using With Multiple Providers](#using-with-multiple-providers)
* [Testing](#testing)
* [Caveats](#caveats)

## Introduction

The software was created as a part of a technical project to launch AWS S3 buckets
with the following possible features: logging, tags, versioning, and KMS encryption.
Terraform code is assembled as a module and can be referenced via a path to this
repository.  The up-to-date AWS infrastructure constructs were employing in building
`simple-s3-terraform`.

## Prerequisites

Installed `terraform` is required.  [`tfenv`](https://github.com/tfutils/tfenv) is
recommended to easily acquire and switch different versions of the tool.

## Usage

### Module Inputs

`simple-s3-terraform` accepts the following parameters:

* **bucket_name**: the name of the S3 bucket to be created (**required**)
* **acl**: one of AWS' canned access control list declarations (*default*: **"private"**)
* **kms_key_arn**: amazon resource name for a data encryption key (*default*: **""**);
  whenever a key arn is not provided, a key will be automatically created
* **logging**: a map with `target_bucket` and logs `target_prefix` properties (*default*: **{}**)
* **tags**: a map with key/value properties to get a resource (*default*: **{}**)
* **use_for_logs**: an indicator whether an S3 bucket is created to hold logs (*default*: **false**)
* **use_versioning**: a flag to turn on or off versioning feature of a bucket (*default*: **false**)

### Configuring a Provider

Terraform accepts a variety of provider settings.  Use of shared configuration
and credential files is recommended as illustrated below.

*terraform-deployment-file.tf*
```tf
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "<AWS Profile Name>"
}
``` 

### Deploying S3 Bucket Without Logging

Logging declaration would simply have to be ommitted to prevent S3 bucket logs.

*terraform-deployment-file.tf*
```tf
module "s3_bucket" {
  source         = "git::https://github.com/aptivator/simple-s3-terraform.git//module"
  bucket_name    = "a-unique-bucket-name-for-your-project"
  use_versioning = true
  
  tags = {
    environment = "dev"
  }
}
```

### Deploying S3 Bucket With Logging

An existing S3 bucket used for logs can be specified or `simple-s3-terraform` can
be employed to create a parallel bucket to store logging information.

*terraform-deployment-file.tf*
```tf
locals {
  base_name = "a-unique-bucket-name-for-your-project"
}

module "s3_bucket_logs" {
  source       = "git::https://github.com/aptivator/simple-s3-terraform.git//module"
  bucket_name  = "${local.module_base_name}-logs"
  use_for_logs = true
}

module "s3_bucket" {
  source      = "git::https://github.com/aptivator/simple-s3-terraform.git//module"
  bucket_name = local.module_base_name
  
  logging = {
    target_bucket = module.s3_bucket_logs.id
    target_prefix = "logs"
  }
}
```

`use_for_logs` parameter is more of a convenience.  It is easier to set the parameter
to `true`, then to remember to declare `acl` as `log-delivery-write`.

### Using With Multiple Providers 

The examples here use a default AWS provider.  Whenever multiple providers
are employed and aliased, a specific provider has to be directly assigned
to a module that uses `simple-s3-terraform`.

*terraform-deployment-file.tf*
```tf
provider "aws" {
  alias                    = "dev"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "<AWS Profile Name>"
}

module "s3_bucket" {
  source      = "git::https://github.com/aptivator/simple-s3-terraform.git//module"
  bucket_name = "a-unique-bucket-name-for-your-project"

  providers = {
    aws = aws.dev
  }
}
```

## Testing

`example` folder contains an S3 bucket deployment with logging.  (See [instructions](./example/README.md)
to launch the sample S3 bucket).  Automated tests are not provided at this time.  This type
of quality assurance is still an ongoing development within a terraform space and will be
addressed at a later time.

## Caveats

This is a demonstrator project and is written for educational purposes only.
