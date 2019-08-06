variable "no_of_zk_instances" {
    default = 1
}

variable "no_of_kafka_instances" {
    default = 3
}

variable "aws_region" {
    default="eu-central-1"
}

variable "subnets" {
  type=map
  description="map of AZs to CIDR blocks within VPC"
}


variable "zk_instance_type" {
    type = string
    default = "t2.medium"
}

variable "kafka_instance_type" {
    type = string
    default = "t2.medium"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/24"
}

variable "my_ip" {
  type=string
}
