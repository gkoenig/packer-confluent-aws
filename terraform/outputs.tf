output "zookeeper_priv_ip" {
  value = aws_instance.zookeeper[*].private_ip
}

output "zookeeper_public_ip" {
  value = aws_instance.zookeeper[*].public_ip
}


