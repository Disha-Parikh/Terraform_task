variable "ec2_count" {}
variable "amis" {
  type = "map"
}
variable "instance_type" {}
variable "subnet_id" {
  type = "list"
}
variable "az" {
  type = "list"
}
variable "instance_name" {}
variable "instance_name_public" {}
variable "eni_name" {}
variable "region" {}
variable "sg" {}
variable "private_key_path" {
  default = "aws_key"
}
variable "public_key_path" {
  default = "aws_key.pub"
}
variable "subnet_id_public" {}
variable "key_name" {}
//variable "eip_name" {}