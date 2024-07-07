#############vpc-outputs.tf##############
output "vpc_id" {
    value = aws_vpc.devops_vpc.id
}
output "db_subnet_group_name" {
    value = aws_db_subnet_group.my_rds_subnetgroup.*.name
}

output "db_security_group" {
    value = aws_security_group.mysql_sg.id
}

output "public_subnet" {
    value = aws_subnet.public_subnet.*.id
}

output "private_subnet" {
    value = aws_subnet.private_subnet.*.id
}
output "private_cidrs" {
   value = [for i in range(1, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
}