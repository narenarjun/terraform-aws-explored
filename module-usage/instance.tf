resource "aws_instance" "name" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"

  # the  VPC subnet
  subnet_id = var.ENV == "prod" ? module.vpc-prod.public_subnets[0] : module.vpc-dev.public_subnets[0]

  # the security group
  vpc_security_group_ids = [var.ENV == "prod" ? aws_security_group.allow-ssh-prod.id : aws_security_group.allow-ssh-dev.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}
