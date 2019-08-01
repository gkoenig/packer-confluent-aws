resource "aws_instance" "bastion" {
    subnet_id = aws_subnet.demosubnet[0].id
    iam_instance_profile = aws_iam_instance_profile.tf_demo_profile.name
    ami             = "${data.aws_ami.my-ami.id}"
    key_name             = "packer-demo"
    vpc_security_group_ids      = [ aws_security_group.sg_bastion.id ]
    instance_type        = var.zk_instance_type
   
    tags = {
            Name        = "bastion"
            propagate_at_launch = true
        }
}




resource "aws_security_group" "sg_bastion" {
  name = "allow_ssh"
  vpc_id = aws_vpc.the_vpc.id
  tags = {
      Name = "Kafka-Automation-Demo"
      Project = "Intern Eval."
      Customer = "Scigility"
      Requestor = "GeKo"
    }
}

resource "aws_security_group_rule" "bastion_tcp_22_cidr" {
  security_group_id = "${aws_security_group.sg_bastion.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "${var.my_ip}/32" ]
  type              = "ingress"
}
resource "aws_security_group_rule" "bastion_out" {
  security_group_id = "${aws_security_group.sg_bastion.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [ "0.0.0.0/0" ]
  type              = "egress"
}