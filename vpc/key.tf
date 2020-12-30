# uploading a ssh public key the aws 

resource "aws_key_pair" "magickeypair" {
  key_name   = "magickeypair"
  public_key = file("keys/akey.pub")
  }