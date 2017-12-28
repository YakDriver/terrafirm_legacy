provider "aws" {}

resource "aws_key_pair" "auth" {
  key_name   = "svc_terrafirm"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8BrNrVDV1jESQF5WXvTyVaW8JT4hZgSyLOC0xqkfwFdzFaaGxHgRfbxeFf+ygrVLDcVeZ3Yd25L3ADn4yNOzJpzCpCPkiYaJPT5Ufyp3ijnlf0xSBdXz6iqaRGaL8kfj6suz0CmH20ckye884LRcbWmjYRcB+7C6FKSLWZEYPd0OrBZr8zQQv7hVssjkT7hR3xNw+ENclmNcNknGtxGzHYG2Bk6XVbTunP3WUojLcX0dTylQNOTGSzk89ooKRDfUjIZYtVTmUvJ/5ebA+rqIIXXxjnrbjeXy64aBHZFm2PNC0jsT2FA2hVezQJz4r5W2Cz1d5LM1Mfrn+Mdai1Ctc6r/A1KY8ChUK1gW7TbGp2z9Mb8V6Z4Sf/cVMAs7ukie9+sRuU+JhXSb83RWnKbQg/u65iePOUXo3rwdlQWBg1UT7y2KE2KbMi4InBs7Z/Haq6YErju0XJA1vK0y/jfksOREtXJjqgHCqp2i9MW8UBtRhs70uSBg3dd4mSaITiukEZ9TJ7Ny1iAi6WfqlGnxF2gq9hCtHf27dftcH3K1GwkgYH6NNLX9o4ChXX+QS4hySwiWNUJNLkmOY5CMOU6sWCHfnYmOTjjFeTwgfbLO5HfOYWFLkzn84VjTJjgIH3eZsnpDZXBF2gLLitpVYITxT4FFeHrGRDEeiMg3nwFO5sQ== svc_terrafirm"
}

# Create a VPC for instance
#resource "aws_vpc" "default" {
#  cidr_block = "10.0.0.0/16"
#}

# Subnet for instance
#resource "aws_subnet" "default" {
#  vpc_id                  = "${aws_vpc.default.id}"
#  cidr_block              = "10.0.1.0/24"
#  map_public_ip_on_launch = true
#}

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
  ami = "ami-658ce61f" #spel-minimal-centos-6.9-hvm-2017.12.1.x86_64-gp2
  #ami = "ami-55ef662f"  #amazon linux 2017.09.1
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.terrafirm.id}"]
  #subnet_id = "${aws_subnet.default.id}"
  user_data = <<USERDATA
#!/bin/sh
PIP_URL=https://bootstrap.pypa.io/get-pip.py
PYPI_URL=https://pypi.org/simple

# Install pip
curl "$PIP_URL" | python - --index-url="$PYPI_URL" wheel==0.29.0

# Install watchmaker
pip install --index-url="$PYPI_URL" --upgrade pip setuptools watchmaker

# Run watchmaker
watchmaker --log-level debug --log-dir=/var/log/watchmaker
USERDATA
  
  timeouts {
    create = "30m"
    delete = "30m"
  }
  
  connection {
    #type     = "ssh"
    #user     = "ec2-user"
    user     = "maintuser"
    private_key = "${var.private_key}"
    #user     = "root"
    timeout   = "30m"
  }
  
  #provisioner "remote-exec" {
  #  inline = [
  #      "echo hello bill > text_delete.txt",
  #      "date >> text_delete.txt",
  #    ]
  #}
  
  #provisioner "remote-exec" {
  #  script = "watchmaker.sh"
  #}
}
