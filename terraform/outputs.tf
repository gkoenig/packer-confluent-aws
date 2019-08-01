

output "zookeeper_public_ip" {
  value = aws_instance.zookeeper[*].public_ip
}
