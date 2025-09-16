module "vpc" {
  source = "./modules/vpc"
  name   = var.project_name
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"  # adjust if needed
  cluster_name    = "${var.project_name}-eks"
  cluster_version = "1.27"

  subnets = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }

  manage_aws_auth = true
}
