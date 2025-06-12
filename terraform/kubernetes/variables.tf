variable "project_name" {
    description = "Project name"
    type        = string
    default     = "srp"
}

variable "region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}

# Varibles for the VPC module
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
    description = "Private Subnets for the VPC"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
    description = "Public Subnets for the VPC"
    type        = list(string)
    default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "enable_nat_gateway" {
    description = "Enable NAT Gateway"
    type        = bool
    default     = true
}
variable "single_nat_gateway" {
    description = "Use a single NAT Gateway"
    type        = bool
    default     = true
}
variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames"
    type        = bool
    default     = true
}

# Variables for the EKS module

variable "cluster_version" {
    description = "EKS Cluster version"
    type        = string
    default     = "1.29"
}

variable "node_group_ami_type" {
    description = "AMI type for the node group"
    type        = string
    default     = "AL2_x86_64"
}

variable "node_group_name" {
    description = "Name of the node group"
    type        = string
    default     = "sr-node-group"
}
variable "node_group_instance_type" {
    description = "Instance type for the node group"
    type        = string
    default     = "t3.small"
}
variable "node_group_min_size" {
    description = "Minimum size of the node group"
    type        = number
    default     = 1
}
variable "node_group_max_size" {
    description = "Maximum size of the node group"
    type        = number
    default     = 3
}
variable "node_group_desired_size" {
    description = "Desired size of the node group"
    type        = number
    default     = 2
}

# Variables for the Kubernetes Applications module
variable "frontend_image" {
  type        = string
  description = "The Frontend Docker Container to Deploy."
}

variable "app_target_port" {
  type        = number
  description = "The target port for the application."
  default     = 80
}