variable "vpc_cidr" {}
variable "private_subnet_cidr" {
  type = "list"
}
variable "subnet_count" {}
variable az {
  type = "list"
}
variable "subnet_name" {}
variable "public_subnet_cidr" {}
variable "subnet_count_public" {}
variable "public_az" {}
//variable "eip_public" {}