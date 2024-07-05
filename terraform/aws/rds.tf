resource "aws_security_group" "rds_sg" {
  name        = "my-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = module.vpc.vpc_id

  # Ingress rule to allow SQL traffic, replace with your IP/CIDR
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.1/32"]  # Replace with your IP/CIDR
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

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "mysql-test-instance"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name     = "test-db"
  username    = "admin"
  password    = "password"
  port        = "3306"


  subnet_ids             = ["subnet-12345678", "subnet-87654321"] ###need to insert private-subnet-id

  create_db_option_group = false
  create_db_parameter_group = false
  create_db_subnet_group = true

  deletion_protection = false
  multi_az            = false
  storage_encrypted   = true
  publicly_accessible = false
}

output "db_instance_endpoint" {
  value = module.db.db_instance_endpoint
}
