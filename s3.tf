resource "aws_s3_bucket" "sjnik" {
  bucket = "sjnik"
  acl    = "public-read"
  region = "ap-south-1"

  tags = {
    Name = "sjnik"
  }


provisioner "local-exec" {
       command= "ansible-playbook git1.yml"
  }

provisioner "local-exec" {
       when = destroy
       command= "ansible-playbook remove1.yml"
  }

}
