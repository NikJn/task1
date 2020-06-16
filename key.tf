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
