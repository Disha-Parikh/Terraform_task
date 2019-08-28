
#AWS_INSTANCE variable

variable "ec2_count" {}
variable "amis" {
  type = "map"
}
variable "instance_type" {}
variable "az" {

  type = "list"
}
variable "instance_name" {

}
variable "instance_name_public" {}
variable "eni_name" {}
variable "region" {}
variable "private_key_path" {}
variable "public_key_path" {}
variable "key_name" {}
variable "bucket_name" {}

//variable "eip_name" {}

#ELB variable

variable "elb_name" {}

#ROUTE53 variable

variable "aws_route53_name" {}
variable "instance" {}
variable "env" {}

#VPC variable

variable "vpc_cidr" {}
variable "private_subnet_cidr" {
  type = "list"
}
variable "subnet_count" {}
variable "subnet_name" {}
variable "public_subnet_cidr" {}
variable "subnet_count_public" {}
variable "public_az" {}
