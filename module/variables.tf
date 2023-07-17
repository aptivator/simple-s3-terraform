variable "acl" {
  type    = string
  default = "private"
}

variable "bucket_name" {
  type = string
}

variable "kms_key_arn" {
  type    = string
  default = ""
}

variable "logging" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "use_for_logs" {
  type    = bool
  default = false
}

variable "use_versioning" {
  type    = bool
  default = false
}
