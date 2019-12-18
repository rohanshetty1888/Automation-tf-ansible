terraform {
  required_version = ">= 0.11.7"
}

# Configure Terragrunt to automatically store tfstate files in S3

resource "aws_instance" "tungsten" {
    ami = "${var.ami}"  
    count = "${var.count}"
    private_ip = "${lookup(var.ips,count.index)}"
    associate_public_ip_address = "1"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${aws_security_group.tungsten_VPC_Security_Group.id}"]
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.tungsten_VPC_Subnet.id}"
    instance_type = "${var.instance_type}"


  root_block_device {
    volume_type = "${var.storage_type}"
    volume_size = "${var.storage_size}"
    delete_on_termination = true
    }

tags {
        Name = "${var.prefix}-node-db${count.index}"
  }
} # end resource

resource "aws_instance" "connector" {
    ami = "${var.ami}"
    count = "2"
    private_ip = "${lookup(var.conn_ips,count.index)}"
    associate_public_ip_address = "1"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${aws_security_group.tungsten_VPC_Security_Group.id}"]
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.tungsten_VPC_Subnet.id}"
    instance_type = "t2.micro"
tags {
        Name = "${var.prefix}-conn-${count.index}"
  }
} # end resource

