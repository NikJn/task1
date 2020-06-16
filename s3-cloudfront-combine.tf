/*provider "aws" {
  region = "ap-south-1"
  profile = "nikhil"
}*/


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

resource "aws_s3_bucket_object" "task1" {
depends_on = [
     aws_s3_bucket.sjnik,
  ]

  bucket = "sjnik"
  key    = "images"
  source = "/git/images.jpg"
  acl = "public-read"
  content_type = "image/jpg"
}



resource "aws_cloudfront_distribution" "task" {
depends_on = [
     aws_s3_bucket_object.task1,
  ]

  origin {
    domain_name = "${aws_s3_bucket.sjnik.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.sjnik.id}"

    custom_origin_config {
      http_port = 80
      https_port =80
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = ["TLSv1" , "TLSv1.1" , "TLSv1.2"]
    }
  }

  enabled = true 

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.sjnik.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
geo_restriction {
restriction_type = "none"
}
}
}
