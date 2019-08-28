
#AWS_INSTANCE variable
ec2_count = 2
amis = {
  "us-west-1" = "ami-056ee704806822732"
}
instance_type = "t2.micro"
az = ["us-west-1a","us-west-1c"]
instance_name = "private_instance"
instance_name_public = "public_instance"
eni_name  = "network_interface"
region = "us-west-1"
//eip_name = "elastic_ip"
key_name = "aws_key"
private_key_path = "./aws_key"
public_key_path = "./aws_key.pub"
bucket_name = "terraform-remote-state-centralized-1"
#ELB variable

elb_name = "elb"

#ROUTE53 variable

aws_route53_name = "disha98.tk"
instance = "web"
env = "dev"


#VPC variable
vpc_cidr = "10.0.0.0/16"
private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
subnet_count  = 2
subnet_name = "subnet"

public_subnet_cidr = "10.0.3.0/24"
subnet_count_public = 1
public_az = "us-west-1a"
