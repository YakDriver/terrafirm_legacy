resource "aws_instance" "centos6" {
  #ami = "ami-2b8ce651" #spel partitioned
  ami = "ami-55ef662f"  #amazon linux 2017.09.1
  instance_type = "t1.micro"
  
  timeouts {
    create = "20m"
    delete = "10m"
  }
  
  connection {
    type     = "ssh"
    #user     = "maintuser"
    #secret_key = "${var.ssh_key}"
    user     = "root"
  }
  
  provisioner "remote-exec" {
    script = "watchmaker.sh"
  }
}
