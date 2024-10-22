module "base-vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}

module "base-eks" {
  source = "./modules/eks"
  prefix = var.prefix
  vpc_id = module.base-vpc.vpc_id
  cluster_name = var.cluster_name
  retention_days = var.retention_days
  subnet_ids = module.base-vpc.subnet_ids
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
}

