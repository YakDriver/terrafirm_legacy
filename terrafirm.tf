resource "aws_instance" "centos6" {
  ami = "ami-bfb356d2"
  instance_type = "t1.micro"
  
  provisioner "local-exec" {
    command = "echo ${aws_instance.centos6.public_ip} > ip_address.txt"
  }
  
  provisioner "local-exec" {
    command = "cat ip_address.txt"
  }
}

