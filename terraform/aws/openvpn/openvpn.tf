resource "aws_instance" "openvpn_server" {
  ami           = "ami-0abcd1234abcd1234" # change ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "your-key-pair" # Change to your key pair

  # Security group for OpenVPN server
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  tags = {
    Name = "OpenVPNServer"
  }
}

resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn-sg"
  description = "Security group for OpenVPN server"
  vpc_id      = aws_vpc.my_vpc.id

  # Add rules for OpenVPN server

  
}
