resource "aws_instance" "my-instance" {
    ami           = "${data.aws_ami.my-ami.id}"
    instance_type = "t2.micro"
    key_name      = "packer-demo"
    security_groups = ["${aws_security_group.allow_ssh.name}"]
    tags = {
      Name = "Scigility-MemberDay-Demo"
    }
}

data "aws_ami" "my-ami" {
  most_recent = true
  owners      = ["134246102036"]

  filter {
    name   = "name"
    values = ["confluent-kafka*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh_europaallee"
  #vpc_id = “VPC-ID”

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags ={
    Name = "Allow SSH"
  }
}

resource "aws_key_pair" "MemberDay-temp-key" {
  key_name = "MemberDay-temp-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHpzdTKCAwCLbyuxVe0Y+4EeI1J3h8ErIOJhDxS3HoJ2G/MF3rnNQrlcslD2WPI8OtVl00SFPLDXB85vX3ZvHIRyJYa7UiCsIzKyhnRFtcpklcPMZQ5dViz5YVFn1tvOvPH7iILLhw/iAtPcx04YNi/CDCHYg/CeO6d6PY4ooLbJaJC8rHFmkhvFaqWxNxKScFiFSQy6d5WQeHLmBYwJGVvkZnSlkUl/CZjiuPVxk29uyeXZZntjR9i9m+VLy/j1/jOyK/ymrfau90U/bsm13jvuaBOe+tQpR1/t2kQOsz0Zrkd4+ttXvkqGinumMQuZudXYJDQZMoT47dEE6lEGkQzEoe4GDnPOo0OBmJDuGTlFMonOwv/wmsPnNHIceqXw2C/VsBijJ4T6ghtPn4mw1NHwzvmylVx4GZe44BOy6qxQFWOOKNwGuGzdNTK9Ve6Nm6r/ap5OSJMzPOoOZjasmr3W9q6Er9XKVYXMh9+QZeSqgJVAWmqJjmcdwTO9drv/s= gerd@zenbook"
}

output "ec2_global_ips" {
  value = ["${aws_instance.my-instance.*.public_ip}"]
}
