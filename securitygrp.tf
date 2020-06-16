resource "aws_security_group" "tasksgroup" {
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


