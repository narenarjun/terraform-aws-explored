resource "aws_instance" "vc-example-1" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"

  # VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # Security Group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # Public SSH key
  key_name = aws_key_pair.magickeypair.key_name

}
