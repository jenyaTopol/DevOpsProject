provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}
module "vpc" {
    source = ./vpc
    vpc_cidr = "10.10.0.0/16"
    public_sn_count = 1
    private_sn_count = 1
    public_cidr = [for i in range 2,255,2 : cidersubnet("10.10.0.0/16", 8, i)]
    private_cidr = [for i in range 1,255,2 : cidersubnet("10.10.0.0/16", 8, i)]
}