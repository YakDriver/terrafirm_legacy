resource "aws_instance" "centos6" {
  ami = "ami-2b8ce651"
  instance_type = "t1.micro"
}

