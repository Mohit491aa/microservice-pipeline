# Define local variables for easy configuration across the project
locals {
  project_name = "microservice-pipeline"
  aws_region   = "us-east-1"
}

# This special "data" block fetches information from AWS.
# Here, it gets a list of all available Availability Zones in our region.
data "aws_availability_zones" "available" {
  state = "available"
}


# 1. Call the VPC Module
# This creates our entire network infrastructure.
module "vpc" {
  source = "../modules/vpc"

  project_name       = local.project_name
  aws_region         = local.aws_region
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}


# 2. Call the EKS Module
# This creates our Kubernetes cluster inside the VPC we just defined.
module "eks" {
  source = "../modules/eks"
  
  # This explicitly tells Terraform that the EKS module cannot be created
  # until the VPC module is successfully finished.
  depends_on = [module.vpc]

  project_name        = local.project_name
  cluster_name        = "${local.project_name}-cluster"
  
  # This is the most important part: we are "wiring" the modules together.
  # The output of the vpc module becomes the input for the eks module.
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
}