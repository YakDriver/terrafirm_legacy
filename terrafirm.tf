resource "aws_instance" "centos6" {
  ami = "ami-2b8ce651"
  instance_type = "t1.micro"
  
  connection {
    type     = "ssh"
    user     = "maintuser"
    password = "${var.root_password}"
  }
  
  provisioner "remote-exec" {
    script = "watchmaker.sh"
  }
}
