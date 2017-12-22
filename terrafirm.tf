resource "aws_instance" "centos6" {
  ami = "ami-55ef662f"
  instance_type = "t1.micro"
}

