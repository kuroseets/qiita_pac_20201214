variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "ap-northeast-1"
}

variable application_name {
  default = "qiita-20201214"
}

variable environment {
  default = "test"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = [
    "a",
    "c",
    "d"
  ]
}
