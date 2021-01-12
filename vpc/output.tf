output "instance" {
  value = aws_instance.vc-example-1.public_ip
}

output "rds" {
  value = aws_db_instance.mariadb.endpoint
}
