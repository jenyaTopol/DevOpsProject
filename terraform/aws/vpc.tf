module "vpc" {
  source = "./vpc"
  vpc_cidr = "10.10.0.0/16"
  public_sn_count = 1
  private_sn_count = 2
  public_cidrs = [for i in range(2, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
  private_cidrs = [for i in range(1, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
  db_subnet_group = true
}
