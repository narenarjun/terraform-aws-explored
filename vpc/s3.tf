resource "aws_s3_bucket" "buckred1" {
  bucket = "mybucket-red876543"
  acl    = "private"

  tags = {
    Name = "mybucket-red876543"
  }
}

