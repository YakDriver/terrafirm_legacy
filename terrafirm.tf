resource "aws_instance" "centos6" {
  ami = "ami-2b8ce651"
  instance_type = "t1.micro"
  
  timeouts {
    create = "20m"
    delete = "10m"
  }
  
  #connection {
  #  type     = "ssh"
  #  user     = "maintuser"
  #}
  
  #provisioner "remote-exec" {
  #  script = "watchmaker.sh"
  #}
}
