# Output instance public IP
output "instance_public_ip" {
  value = aws_instance.default-instance.public_ip
}
