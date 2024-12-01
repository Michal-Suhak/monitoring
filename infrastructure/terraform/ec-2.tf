resource "aws_security_group" "ssh-security-group" {
  name = "ssh security group"
  description = "Allow SSH into host"
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  tags = {
    Name        = "ssh security group"
    CreatedBy   = "terraform"
  }
}

resource "aws_instance" "app-instance" {
  ami                   = "ami-0084a47cc718c111a"
  instance_type         = "t2.micro"
  key_name              = var.key_pair_name
  security_groups       = [aws_security_group.ssh-security-group.name]
  user_data = file("app-bootstrap-script.sh")

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }

  tags = {
    Name                = "app"
  }
}
