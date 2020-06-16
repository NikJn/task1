resource "aws_volume_attachment" "ebs_connect" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ebs.id}"
  instance_id = "${aws_instance.web1.id}"
  force_detach = true
}
