provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::701759196663:role/codebuild-terrafirm-service-role"
  }
}

resource "aws_instance" "centos6" {
  #ami = "ami-2b8ce651" #spel partitioned
  ami = "ami-55ef662f"  #amazon linux 2017.09.1
  instance_type = "t2.micro"
  
  timeouts {
    create = "20m"
    delete = "10m"
  }
  
  connection {
    type     = "ssh"
    #user     = "maintuser"
    #private_key = "${var.private_key}"
    user     = "root"
  }
  
  provisioner "remote-exec" {
    script = "watchmaker.sh"
  }
}
