variable "access_key" {}
variable "secret_key" {}
variable "management_cidr_block" {}
variable "key_name" {
  default = "terraform"
}

variable "aws_region" {
  default = "us-west-2"
}
