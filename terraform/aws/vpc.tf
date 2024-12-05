module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"

  enable_nat_gateway  = true
  single_nat_gateway  = true
  reuse_nat_ips       = true  

  }
}

output "vpc_id" {
  value = module.vpc.id
}

output "private_subnets" {
  value = module.vpc.private.*.id
}

output "private_cidr_blocks" {
  value = module.vpc.private.*.cidr_block
}

output "db_subnet_group" {
  value = module.vpc.my_db_subnet_group.name
}