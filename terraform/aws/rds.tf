
# resource "aws_security_group" "rds_sg" {
#   name        = "rds-security-group"
#   description = "Allow MySQL inbound traffic"
#   vpc_id      = module.vpc.vpc_id #module.vpc.vpc_id 

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] 
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# resource "aws_db_subnet_group" "rds_subnet_group" {
#   name       = "rds-subnet-group"
#   subnet_ids = module.vpc.private_subnets #module.vpc.private_subnets  

#   tags = {
#     Name = "RDS Subnet Group"
#   }
# }


# resource "aws_db_instance" "flask_mysql" {
#   identifier           = "flask-mysql-db"
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   username            = "flaskuser"
#   password            = "rootpassword" 
#   parameter_group_name = "default.mysql8.0"
#   publicly_accessible  = false
#   skip_final_snapshot  = true
#   db_subnet_group_name =  aws_db_subnet_group.rds_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
# }


# output "rds_endpoint" {
#   value = aws_db_instance.flask_mysql.endpoint
# }
