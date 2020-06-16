resource "aws_s3_bucket_object" "task1" {

  bucket = "sjnik"
  key    = "images"
  source = "/git/images.jpg"
  acl = "public-read"
  content_type = "image/jpg"
}
