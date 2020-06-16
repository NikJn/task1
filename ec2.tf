resource "aws_instance" "web1" {

  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name = "tasks1"
  security_groups = [ "tasksgroup" ]

  tags = {
     Name = "ebsos"
  }

}
