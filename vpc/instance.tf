resource "aws_instance" "vc-example-1" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"

  # VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # Security Group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # Public SSH key
  key_name = aws_key_pair.magickeypair.key_name

  # User data
  user_data = data.template_cloudinit_config.cloudinit-example.rendered

}

# creating a ebs storage volume
resource "aws_ebs_volume" "ebs-mainvpc-vol-1" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "Extra data volume"
  }
}

# attaching ebs volume to the ec2 instance
resource "aws_volume_attachment" "ebs-vol-1-attach" {
  device_name = var.INSTANCE_DEVICE_NAME
  volume_id   = aws_ebs_volume.ebs-mainvpc-vol-1.id
  instance_id = aws_instance.vc-example-1.id
}
