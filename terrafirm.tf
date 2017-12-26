provider "aws" {}

resource "aws_key_pair" "auth" {
  key_name   = "svc_terrafirm"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGLwKGkVNM9d7otE1ZNgR6YPnJuemyGugta66bIWjd3J9HkM/ijOjzvAt/DmkccVJ/m9XucbspFxIS3z+KU6Sxs7hbFYdrQG2hAuJkcAmWTes/mfNDH1QpSrBGRWvOP0Qo5tIH3WymJixFpvboSXS4a7TmebiEDM13mpfLb+MNDFCF25GNplieTdW/MV9RaUKhy3icLXi+XJNGb0IpS+Dbrgg7jwUhRBBrJqD0DwVjBhWSncYYTG2BTEFLZaYV2xndK7Msi2eIPaYjikk7DCaEBgo8tx6YD4VfrWza/wFJjQ1npMzDbFbXOey1EqtRK6m3c3an0Ojowzqoeg1TM6TH"
}

# Create a VPC for instance
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Subnet for instance
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Security group to access the instances over SSH
resource "aws_security_group" "terrafirm" {
  name        = "terrafirm_sg"
  description = "Used in terrafirm"
  #vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "centos6" {
  #ami = "ami-2b8ce651" #spel partitioned
  ami = "ami-55ef662f"  #amazon linux 2017.09.1
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.terrafirm.id}"]
  #subnet_id = "${aws_subnet.default.id}"
  
  timeouts {
    create = "20m"
    delete = "10m"
  }
  
  connection {
    #type     = "ssh"
    #user     = "maintuser"
    private_key = "${var.private_key}"
    #user     = "root"
  }
  
  provisioner "remote-exec" {
    script = "watchmaker.sh"
  }
}
