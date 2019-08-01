
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

#######################
# base networking 
#######################
resource "aws_vpc" "the_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  
  tags = {
    Name = "cf-demo-vpc"
  }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.the_vpc.id}"
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.the_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags= {
    Name = "Public Subnet RT"
  }
}

resource "aws_route_table_association" "public-rt" {
  count     = length(var.subnets)
  subnet_id = aws_subnet.demosubnet[count.index].id
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_subnet" "demosubnet" {
  count                   = length(var.subnets)
  vpc_id                  = "${aws_vpc.the_vpc.id}"
  cidr_block              = "${element(values(var.subnets), count.index)}"
  availability_zone       = "${element(keys(var.subnets), count.index)}"
  map_public_ip_on_launch = true

  tags = {
      Name = "demosubnet-${count.index+1}"
      Project = "Intern Eval."
      Customer = "Scigility"
      Requestor = "GeKo"
    }
}

resource "aws_security_group" "tf_demo" {
  name = "tf_demo_sg"
  vpc_id = aws_vpc.the_vpc.id
  tags = {
      Name = "Kafka-Automation-Demo"
      Project = "Intern Eval."
      Customer = "Scigility"
      Requestor = "GeKo"
    }
}

// Allow any internal network flow.
resource "aws_security_group_rule" "zk_ingress_any_any_self" {
  security_group_id = "${aws_security_group.tf_demo.id}"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  self              = true
  type              = "ingress"
}
resource "aws_security_group_rule" "zk_egress_allow_all_internal" {
  security_group_id = "${aws_security_group.tf_demo.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}
resource "aws_security_group_rule" "zk_ingress_tcp_22_cidr" {
  security_group_id = "${aws_security_group.tf_demo.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "${var.my_ip}/32" ]
  type              = "ingress"
}



###############################
# IAM
###############################
resource "aws_iam_instance_profile" "tf_demo_profile" {
    name = "demo-profile"
    role = aws_iam_role.demo_role.id
}
resource "aws_iam_role" "demo_role" {
    name            = "demo-role"
    assume_role_policy = data.aws_iam_policy_document.roledoc.json
}
data "aws_iam_policy_document" "roledoc" {
    statement {
        actions = [
            "sts:AssumeRole",
        ]
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_policy" "tf_demo_policy" {
  name        = "confluentdemo-policy"
  description = "Allow EC2 and cloudwatch"
  policy      = data.aws_iam_policy_document.policydoc.json
}
data "aws_iam_policy_document" "policydoc" {
    statement {
        actions = [
            "ec2:*",
            "cloudwatch:*",
        ]
        resources = [ "*" ]
    }
}

resource "aws_iam_policy_attachment" "demo_policyattachment" {
    name       = "confluentdemo-policyattachment"
    roles       = [ aws_iam_role.demo_role.name ]
    policy_arn = aws_iam_policy.tf_demo_policy.arn
}
