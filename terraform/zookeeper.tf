
###############################
# EC2 instances for Zookeeper
###############################
resource "aws_instance" "zookeeper" {
    count= var.no_of_zk_instances
    subnet_id = aws_subnet.demosubnet[count.index].id
    iam_instance_profile = aws_iam_instance_profile.tf_demo_profile.name
    ami             = "${data.aws_ami.my-ami.id}"
    key_name             = "packer-demo"
    vpc_security_group_ids      = [ aws_security_group.tf_demo.id ]
    user_data            = data.template_file.zookeeper.rendered
    instance_type        = var.zk_instance_type
   
    tags = {
            Name        = "cfdemo-zk-${format("%02d", count.index + 1)}"
            ID          ="${count.index + 1}"
            propagate_at_launch = true
        }
}

data "template_file" "zookeeper" {
    template = file("./templates/cloudinit_zookeeper.tpl")
    vars = {
        clustername = "confluentdemo"
        zookeeper_count = var.no_of_zk_instances
    }
}

