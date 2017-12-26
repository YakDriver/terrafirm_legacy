provider "aws" {}

resource "aws_key_pair" "terrafirm_keypair" {
  key_name   = "svc_terrafirm"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrg3XkSfEjtoViJ0cgOisTSDwZXhUQFGcjfX3heXMiRW3N6h5qjBWDXB7D1pvQDGPTvaGRNCo+4659CB36vUvzZabCpx7H/zJkot8zZEbh6i4ek8tg6Qn5ViIVhiZ2vSmgkyZylzTyKsxefhVGBVxBXYFELdkXqEnZXG36fTuka6xlkwjoklbb08LXZS7MiMpi3bP9eEAVSt03YbJHpBm50BE7+uQ+IryZN/YJkHh5PZzmZnLqdshTdDu7ZbgpbjH/mPdUuqiTiG3rUbJ7yKt9W9jH/6uUJSHWJHyqSdyCdR6RQX0BxX0ar4F9qF3FBF7Xfzf+VZAhDfXMum7+DkspC2f57F56hZ3jTl2sE9mFwPZav/GOSfYDCictlYt8suWs/mCWB4H5+ZW0opolNcXZXmVdANufbgRFb9/f096OryiTFzciW1jF/6FtDM1SEc3F5gndNLniRsUJqb+xCTBAJlmzQYe+fMegnl12Q9sidDERNwwxNI2qb57MQTDgHpPxA5w95EazTLtuIQgV8/r5De4SwMOcL1w1JVn/m4pQrD4ZrVVLl64zHA619jm2m6jos2yj66w+phxFsDgIFF+m0m5d4XqcUbU8kI7lGz/LSFjozIoS7WJ9n3M0ij1v1ABxwS4/L+VjJYsnGr038PXF00IEo5eGw63YlyochtlJ1Q== terrafirm.pem"
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
