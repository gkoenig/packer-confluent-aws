resource "aws_instance" "my-instance" {
    ami           = "${data.aws_ami.my-ami.id}"
    instance_type = "t2.medium"
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

output "ec2_global_ips" {
  value = ["${aws_instance.my-instance.*.public_ip}"]
}
