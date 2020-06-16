provider "aws" {
  region = "ap-south-1"
  profile = "nikhil"
}
resource "tls_private_key" "tlskey1" {
  algorithm   = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key1" {
  depends_on=[
	tls_private_key.tlskey1
  ]
  key_name   = "tasks1"
  public_key = "${tls_private_key.tlskey1.public_key_openssh}"
}

resource "local_file" "private-file1" {
  depends_on = [
     aws_key_pair.generated_key1
  ]

  content  = "${tls_private_key.tlskey1.private_key_pem}"
  filename = "tasks1.pem"

  provisioner "local-exec" {
       command= "chmod 400 tasks1.pem"
  }

}
resource "aws_security_group" "tasksgroup" {
  depends_on = [
    local_file.private-file1
  ]

  name = "tasksgroup"
  description = "Allow TLS inbound traffic"
  vpc_id = "vpc-80c2dfe8"
  ingress {
 	description = "SSH"
 	from_port = 22
 	to_port = 22
 	protocol = "tcp"
 	cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
 	description = "HTTP"
 	from_port = 80
 	to_port = 80
 	protocol = "tcp"
 	cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
 	from_port = 0
 	to_port = 0
 	protocol = "-1"
 	cidr_blocks = ["0.0.0.0/0"]
  } 	
  tags = {
  	Name = "tasksgroup"
  }
}


resource "aws_instance" "web1" {

depends_on = [
     aws_security_group.tasksgroup,
  ]

  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name = "tasks1"
  security_groups = [ "tasksgroup" ]

  tags = {
     Name = "ebsos"
  }

}

resource "aws_ebs_volume" "ebs" {
depends_on = [
     aws_instance.web1,
  ]

  availability_zone = aws_instance.web1.availability_zone
  size              = 3
  tags = {
    Name = "nikebs"
  }
}


resource "aws_volume_attachment" "ebs_connect" {
depends_on = [
     aws_ebs_volume.ebs,
  ]


  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ebs.id}"
  instance_id = "${aws_instance.web1.id}"
  force_detach = true
}

resource "null_resource" "nullremote1"  {

  depends_on = [
     aws_volume_attachment.ebs_connect,
  ]

  provisioner "local-exec" {
       command= "echo ${aws_instance.web1.public_ip} ansible_ssh_private_key_file=/root/terraform/test/tasks1.pem >> /root/terraform/test/hosts"
  }
  provisioner "local-exec" {
       command= "ansible-playbook software.yml"
  }

  provisioner "local-exec" {
       command= "ansible-playbook partition.yml"
  }
  provisioner "local-exec" {
       command= "ansible-playbook remove.yml"
  }

  provisioner "local-exec" {
       command= "ansible-playbook git.yml"
  }
/*  provisioner "local-exec" {
      command= "firefox  ${aws_instance.web1.public_ip}"
  }*/
}

output "myos_ip" {
  value = aws_instance.web1.public_ip
}

