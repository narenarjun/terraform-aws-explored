# uploading a ssh public key the aws 

resource "aws_key_pair" "wonderkeypair" {
  key_name   = "wonderkeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  lifecycle {
    ignore_changes = [public_key]
  }
}
