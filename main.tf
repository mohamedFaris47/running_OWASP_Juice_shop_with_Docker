# owasp project
# --------------

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_access_key
}

# Create security group to allow port 22,80,3000
resource "aws_security_group" "allow_web" {
  name        = "owasp_sg"
  description = "Allow traffic for owasp website"
  vpc_id      = var.vpc_id


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# Create ubuntu server
resource "aws_instance" "owasp-server-instance" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  availability_zone      = var.ec2_region
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name               = var.ec2_key_pair_name

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install docker.io -y
                sudo systemctl start docker
                sudo docker pull bkimminich/juice-shop
                sudo docker volume create owasp
                sudo docker run --restart always -p 80:3000 -v owasp:/juice-shop --name owasp-container bkimminich/juice-shop
                EOF
  tags = {
    "Name" = "owasp-server"
  }

}
