# Module for VPC
module "vpc" {
    source = "./vpc"
    # Following variables are passsed from the terraform.tfvars file
    project_name          = var.project_name
    vpc_cidr              = var.vpc_cidr
    vpc_private_subnets   = var.vpc_private_subnets
    vpc_public_subnets    = var.vpc_public_subnets
    enable_nat_gateway    = var.enable_nat_gateway
    single_nat_gateway    = var.single_nat_gateway
    enable_dns_hostnames  = var.enable_dns_hostnames
}
# Module for EKS
module "eks" {
    source = "./eks"
    # Following variables are passsed from the terraform.tfvars file
    project_name            = var.project_name
    cluster_version         = var.cluster_version
    node_group_name         = var.node_group_name
    node_group_instance_type= var.node_group_instance_type
    node_group_ami_type     = var.node_group_ami_type
    node_group_min_size     = var.node_group_min_size
    node_group_max_size     = var.node_group_max_size
    node_group_desired_size = var.node_group_desired_size
    # Following variables are passed from the VPC module
    vpc_id                  = module.vpc.vpc_id
    vpc_private_subnets     = module.vpc.private_subnets
}
# # Module for Kubernetes applications
# module "kubernetes" {
#     source                = "./kube-app"
#     # Following variables are passsed from the terraform.tfvars file
#     project_name          = var.project_name
#     frontend_image        = var.frontend_image
#     app_target_port       = var.app_target_port
#     # Following variables are passed from the EKS module
#     eks_cluster_name      = module.eks.cluster_name
#     eks_cluster_endpoint  = module.eks.cluster_endpoint
#     eks_cluster_ca        = module.eks.cluster_certificate_authority
# }