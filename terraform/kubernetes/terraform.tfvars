# Variables for the Project
project_name = "vehicle"
region      = "us-east-1"

# Variables for the VPC module
vpc_cidr            = "10.0.0.0/16"
vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
enable_nat_gateway  = true
single_nat_gateway  = true
enable_dns_hostnames= true

# Variables for the EKS module
cluster_version         = "1.32"
node_group_ami_type     = "AL2_x86_64"
node_group_instance_type= "t3.small"
node_group_min_size     = 1
node_group_max_size     = 3
node_group_desired_size = 2

# Variables for the Kubernetes Application module
frontend_image = "<< Account number>>.dkr.ecr.us-east-1.amazonaws.com/vehicle-frontend:latest"
app_target_port = 80