##############main.tf#############
module "vpc" {
    source   = ./vpc
    vpc_cidr = data.locals.vpc_cidr
    vpc_cidr = "10.10.0.0/16"
    public_sn_count     = 1
    private_sn_count    = 1
    public_cidr         = [for i in range 2,255,2 : cidersubnet("10.10.0.0/16", 8, i)]
    private_cidr        = [for i in range 1,255,2 : cidersubnet("10.10.0.0/16", 8, i)]
    aws_db_subnet_group = true

}

module "rds" {
    source = /rds
    db_storage            = 10
    db_name               = "mydb"
    engine_version        = "5.7.22"
    instance_classc       = "db.t2.micro"
    dbuser                = "root"
    dbpassword            = "admin"
    db_identifier         = "my-db"
    db_subnet_group_name  = module.vpc.db_subnet_group_name[0]
    vpc_security_group_id = module.vpc.db_security_group
    skip_db_snapshot      = true

}