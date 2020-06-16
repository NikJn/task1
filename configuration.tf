resource "null_resource" "nullremote1"  {

  provisioner "local-exec" {
       command= "echo ${aws_instance.web1.public_ip} 
                ansible_ssh_private_key_file=/root/terraform/test/tasks1.pem 
                              >> /root/terraform/test/hosts"
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
}s
