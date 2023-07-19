resource "aws_key_pair" "provisioner" {
  key_name   = "provisioner"
  public_key = file("C:\\Users\\user\\provisioner.pub")
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-tls"
  description = "Allow all ports"
  vpc_id      = "vpc-0e8b8f8294711f53c" #default vpc id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "staticweb" {
    ami = "ami-012b9156f755804f5"
    
    instance_type = "t3.micro"
    key_name = aws_key_pair.provisioner.key_name
    security_groups = [aws_security_group.allow_tls.name]

    # where you are running terraform command
    provisioner "local-exec" {
        command = "echo The server's IP address is ${self.public_ip} > public_ip.txt"
    }
}