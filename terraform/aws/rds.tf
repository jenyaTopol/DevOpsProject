resource "aws_security_group" "rds_sg" {
  name        = "my-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = module.vpc.vpc_id

  # Ingress rule to allow SQL traffic, replace with your IP/CIDR
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_cidrs  # Replace with your IP/CIDR
  }

  # Egress rule - allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}


module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name           = "test-aurora-db-mysql"
  engine         = "aurora-mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  instances = {
    test = {}
  }

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.db_security_group
  storage_encrypted   = true
  apply_immediately   = true

  enabled_cloudwatch_logs_exports = ["error"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}