module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  
  name                  = "${var.project_name}-vpc"
  cidr                  = var.vpc_cidr
  private_subnets       = var.vpc_private_subnets
  public_subnets        = var.vpc_public_subnets
  enable_nat_gateway    = var.enable_nat_gateway
  single_nat_gateway    = var.single_nat_gateway
  enable_dns_hostnames  = var.enable_dns_hostnames
  azs                   = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}