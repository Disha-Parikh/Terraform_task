provider "aws" {
  region =var.region
}
terraform {
  backend "s3" {
    bucket = "terraform-remote-state-centralized-1"
    region = "us-west-1"
    dynamodb_table= "terraform-state-lock-dynamo"
    encrypt= "true"
    key= "./terraform.tfstate"

  }
}
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"

  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "S3 bucket"
  }
}
module "ec2" {
  source = "./ec2"
  amis = var.amis
  az = var.az
  ec2_count = var.ec2_count
  eni_name = var.eni_name
  instance_name = var.instance_name
  instance_type = var.instance_type
  region = var.region
  subnet_id = module.vpc.subnet_id
  sg = module.vpc.sg
  private_key_path = var.private_key_path
  public_key_path = var.public_key_path
  subnet_id_public = module.vpc.subnet_id_public
  key_name = var.key_name
  instance_name_public = var.instance_name_public
//  bucket_name = var.bucket_name
  //  eip_name = var.eip_name
}

module "elb" {
  source = "./elb"
  az = var.az
  elb_name = var.elb_name
}

module "route53" {
  source = "./route53"
  aws_route53_name = var.aws_route53_name
//  eip = module.ec2.eip
  env = var.env
  instance = var.instance
  region = var.region
  ec2_count = var.ec2_count
  eip = module.vpc.eip
}
module "vpc" {
  source = "./vpc"
  az = var.az
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  subnet_count = var.subnet_count
  vpc_cidr = var.vpc_cidr
  subnet_name = var.subnet_name
  subnet_count_public = var.subnet_count_public
  public_az = var.public_az

//  eip_public = module.ec2.eip_public
}


