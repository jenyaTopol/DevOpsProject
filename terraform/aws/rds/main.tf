#######database/main.tf
resource "aws_db_instance" "default" {
  allocated_storage    = var.db_storage
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = var.engine_version
  instance_class       = var.instance_class 
  username             = var.dbuser
  password             = var.dbpassword
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_id
  identifier             = var.db_identifier
  skip_final_snapshot  = var.skip_db_snapshot
  tags = {
    Name = "my-db"
  }
}