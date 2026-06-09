provider "aws" {
  alias  = "sydney"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}

# Security group for Sydney - allows HTTP and SSH
resource "aws_security_group" "nginx_sg_sydney" {
  provider    = aws.sydney
  name        = "nginx-sg-sydney"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "nginx-sg-sydney"
  }
}

# Security group for Singapore - allows HTTP and SSH
resource "aws_security_group" "nginx_sg_singapore" {
  provider    = aws.singapore
  name        = "nginx-sg-singapore"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "nginx-sg-singapore"
  }
}

# EC2 in Sydney with nginx auto-installed
resource "aws_instance" "ec2_sydney" {
  provider               = aws.sydney
  ami                    = "ami-0892a9c01908fafd1"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg_sydney.id]

  user_data = <<-USERDATA
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Nginx running on Sydney - ap-southeast-2</h1>" > /usr/share/nginx/html/index.html
  USERDATA

  tags = {
    Name    = "terraform-nginx-sydney"
    Region  = "ap-southeast-2"
    Project = "terraform-task2"
  }
}

# EC2 in Singapore with nginx auto-installed
resource "aws_instance" "ec2_singapore" {
  provider               = aws.singapore
  ami                    = "ami-0df7a207adb9748c7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg_singapore.id]

  user_data = <<-USERDATA
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Nginx running on Singapore - ap-southeast-1</h1>" > /usr/share/nginx/html/index.html
  USERDATA

  tags = {
    Name    = "terraform-nginx-singapore"
    Region  = "ap-southeast-1"
    Project = "terraform-task2"
  }
}

output "sydney_public_ip" {
  value       = aws_instance.ec2_sydney.public_ip
  description = "Open this IP in browser to see Sydney nginx"
}

output "singapore_public_ip" {
  value       = aws_instance.ec2_singapore.public_ip
  description = "Open this IP in browser to see Singapore nginx"
}
