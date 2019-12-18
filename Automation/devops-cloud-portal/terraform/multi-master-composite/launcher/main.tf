
provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "tungsten_VPC" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}" 
  enable_dns_support   = "${var.dnsSupport}" 
  enable_dns_hostnames = "${var.dnsHostNames}"
tags {
    Name = "${var.prefix}-VPC"
  }
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "tungsten_VPC_GW" {
  vpc_id = "${aws_vpc.tungsten_VPC.id}"
tags {
        Name = "${var.prefix}-VPC-Internet-Gateway"
    }
} # end resource

# create the Subnet
resource "aws_subnet" "tungsten_VPC_Subnet" {
  vpc_id                  = "${aws_vpc.tungsten_VPC.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}" 
  availability_zone       = "${var.availabilityZone}"

  depends_on = ["aws_internet_gateway.tungsten_VPC_GW"]
tags = {
   Name = "${var.prefix}-VPC-Subnet"
  }
} # end resource


# Create the Route Table
resource "aws_route_table" "tungsten_VPC_route_table" {
    vpc_id = "${aws_vpc.tungsten_VPC.id}"
tags {
        Name = "${var.prefix}-VPC-Route-Table"
    }
} # end resource


# Create the Internet Access Private
resource "aws_route" "tungsten_VPC_internet_access" {
  route_table_id        = "${aws_route_table.tungsten_VPC_route_table.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.tungsten_VPC_GW.id}"
} # end resource


# Associate the Route Table with the Subnet
resource "aws_route_table_association" "tungsten_VPC_association" {
    subnet_id      = "${aws_subnet.tungsten_VPC_Subnet.id}"
    route_table_id = "${aws_route_table.tungsten_VPC_route_table.id}"
} # end resource


# Create the Security Group
resource "aws_security_group" "tungsten_VPC_Security_Group" {
  vpc_id       = "${aws_vpc.tungsten_VPC.id}"
  name         = "tungsten VPC Security Group"
  description  = "tungsten VPC Security Group"
ingress {
    cidr_blocks = "${var.ingressCIDRblock}"  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 22
    to_port    = 22
  }

ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 7
    to_port    = 7
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 7
    to_port    = 7
  }

ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 2112
    to_port    = 2112
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 2112
    to_port    = 2112
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 9100
    to_port    = 9100
    }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 9100
    to_port    = 9100
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 9104
    to_port    = 9104
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 9104
    to_port    = 9104
  }

ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 2114
    to_port    = 2114
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 2114
    to_port    = 2114
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 7800
    to_port    = 7805
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 7800
    to_port    = 7805
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 9997
    to_port    = 9997
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 9997
    to_port    = 9997
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 10000
    to_port    = 10003
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 10000
    to_port    = 10003
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 11999
    to_port    = 12000
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 11999
    to_port    = 12000
  }


    ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 13306
    to_port    = 13306
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 13306
    to_port    = 13306
  }


    ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 3306
    to_port    = 3306
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 3306
    to_port    = 3306
  }


ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 80
    to_port    = 80
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 8090
    to_port    = 8090
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 8090
    to_port    = 8090
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 443
    to_port    = 443
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 443
    to_port    = 443
  }

# allow ingress icmp port for ping operation.
  ingress {
    protocol   = "icmp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = -1
    to_port    = -1
  }


egress {
    protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr_blocks = "${var.ingressCIDRblock}"
    }

tags = {
        Name = "${var.prefix}-VPC-Security-Group"
  }
} # end resource


# create VPC Network access control list
resource "aws_network_acl" "tungsten_VPC_Security_ACL" {
  vpc_id = "${aws_vpc.tungsten_VPC.id}"
  subnet_ids = [ "${aws_subnet.tungsten_VPC_Subnet.id}" ]

# allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}" 
    from_port  = 22
    to_port    = 22
  }
# allow ingress  ports 
  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }
# allow egress  ports
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }

tags {
    Name = "${var.prefix}-VPC-ACL"
  }
} # end resource

resource "aws_instance" "tungsten" {
    ami = "${lookup(var.ami,var.region)}"  
    count = "${var.count}"
    private_ip = "${lookup(var.ips,count.index)}"
    associate_public_ip_address = "0"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${aws_security_group.tungsten_VPC_Security_Group.id}"]
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.tungsten_VPC_Subnet.id}"
    instance_type = "${var.instance_type}"


  root_block_device {
    volume_type = "${var.storage_type}"
    volume_size = "${var.storage_size}"
    iops = "${var.storage_iops}"
    delete_on_termination = true
    }
    
tags {
        Name = "${var.prefix}-node-db${count.index}"
  }
} # end resource

resource "aws_eip" "tungsten_eip" {
  vpc = true
  count = "${var.count}"
  instance                  = "${element(aws_instance.tungsten.*.id,count.index)}"
  associate_with_private_ip = "${lookup(var.ips,count.index)}"
  depends_on                = ["aws_internet_gateway.tungsten_VPC_GW"]
  depends_on =["aws_instance.tungsten"]
}

resource "aws_instance" "tungsten_connector" {
    ami = "${lookup(var.ami,var.region)}"  
    count = "2"
    private_ip = "${lookup(var.conn_ips,count.index)}"
    associate_public_ip_address = "0"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${aws_security_group.tungsten_VPC_Security_Group.id}"]
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.tungsten_VPC_Subnet.id}"
    instance_type = "t2.micro"
    
tags {
        Name = "${var.prefix}-conn-${count.index}"
  }
}


resource "aws_eip" "tungsten_connector_eip" {
  vpc = true
  count = "2"
  instance                  = "${element(aws_instance.tungsten_connector.*.id,count.index)}"
  associate_with_private_ip = "${lookup(var.conn_ips,count.index)}"
  depends_on                = ["aws_internet_gateway.tungsten_VPC_GW"]
  depends_on =["aws_instance.tungsten_connector"]
}

resource "aws_elb" "tungsten_elb" {
  name               = "${var.prefix}-terraform-elb"
  security_groups = ["${aws_security_group.tungsten_VPC_Security_Group.id}"]
  subnets = ["${aws_subnet.tungsten_VPC_Subnet.id}"]

  listener {
    instance_port     = 3306
    instance_protocol = "tcp"
    lb_port           = 3306
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "tcp:22"
    interval            = 30
  }

  instances                   = ["${aws_instance.tungsten_connector.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.prefix}-terraform-elb"
  }
} # end resource
