
# AWS region
region = "us-west-2"

# EC2 VARIABLES

# ami use with ec2
ami = "ami-052e2f145c4002e3e"

# number of Master ec2 instance
master_count = "1"

# number of Node ec2 instance
node_count = "1"

# resource instance type
instance_type = "t2.large"

# aws key pair name
key_name = "okd-cluster"

# securiy group for ec2
ec2_sec_group = "saleshero-okd-sg"

# root volume size
volume_size = "10"

# Associate public ip address (true/false)
public_ip = "true"


#Security group variables
# INGRESS

# Protocol
ingress_protocol = "tcp"

# List of CIDR blocks
ingress_cidr_blocks = "0.0.0.0/0"

# EGRESS

# Protocol
egress_protocol = "-1"

# List of CIDR blocks
egress_cidr_blocks = "0.0.0.0/0"

# EC2 instance tags
Environment = "Testing"
Service = "SalesHero"
 
