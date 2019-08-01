
###############################
# ASG
###############################
resource "aws_autoscaling_group" "kafka" {
    count= var.no_of_kafka_instances
    desired_capacity= "1"
    min_size        = "1"
    max_size        = var.no_of_kafka_instances
    health_check_grace_period = 60
    health_check_type = "EC2"
    launch_configuration = aws_launch_configuration.kafka.name
    vpc_zone_identifier = [ aws_subnet.demosubnet[count.index].id ]
    name = "cfdemo-kafka-${format("%02d", count.index + 1)}"

    lifecycle {
        create_before_destroy = true
    }
    
    tag {
            key         = "Name"
            value       = "cfdemo-kafka-${format("%02d", count.index + 1)}"
            propagate_at_launch = true
        }
    tag {
            key                 = "ID"
            value               = "${count.index + 1}"
            propagate_at_launch = true
        }
    tag {
            key="Project"
            value = "Intern Eval."
            propagate_at_launch = true
        }
    tag {
            key="Customer"
            value = "Scigility"
            propagate_at_launch = true
        }
    tag {
            key="Requestor"
            value = "GeKo"
            propagate_at_launch = true
        }
}

resource "aws_launch_configuration" "kafka" {
    #associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.tf_demo_profile.arn
    image_id             = "${data.aws_ami.my-ami.id}"
    key_name             = "packer-demo"
    security_groups      = ["${aws_security_group.tf_demo.id}"]
    user_data            = data.template_file.kafka.rendered
    instance_type        = var.zk_instance_type
    name_prefix          = "cfdemo-kafka-"
    
    lifecycle {
        create_before_destroy = true
    }
    
}

data "template_file" "kafka" {
    template = file("./templates/cloudinit_kafka.tpl")
    vars = {
        clustername = "confluentdemo"
        zookeeper_count = var.no_of_zk_instances
    }
}

