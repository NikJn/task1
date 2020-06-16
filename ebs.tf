resource "aws_ebs_volume" "ebs" {

  availability_zone = aws_instance.web1.availability_zone
  size              = 3
  tags = {
    Name = "nikebs"
  }
}
