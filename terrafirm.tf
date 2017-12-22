resource "aws_instance" "centos6" {
  ami = "ami-bfb356d2"
  instance_type = "t1.micro"
}

