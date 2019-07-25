# AWS region
variable "region" {
  default = "us-west-2"
}

# EC2 VARIABLES
# ami use with ec2
variable "ami" {}

# number of Master ec2 instance
variable "master_count" {
  default = "1"
}

# number of Node ec2 instance
variable "node_count" {
  default = "0"
}

# resource instance type
variable "instance_type" {}

# aws key pair name
variable "key_name" {}

# securiy group for ec2
variable "ec2_sec_group" {}

# Associate public ip address
variable "public_ip" {
  default = "true"
}

# root volume size
variable "volume_size" {}


#Security group variables
# INGRESS
# Protocol
variable "ingress_protocol" {}
# List of CIDR blocks
variable "ingress_cidr_blocks" {}

# EGRESS
# Protocol
variable "egress_protocol" {}
# List of CIDR blocks
variable "egress_cidr_blocks" {}

# EC2 instance tags
variable "Environment" {}
variable "Service" {}

# AWS creds
variable "aws_secret_variable" {}
variable "aws_access_variable" {}

