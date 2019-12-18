#terraform {
#  required_version = ">= 0.11.7"
#}

#Create VPC/Subnet/Security Group/ACL/IG/Routes.

provider "aws" {
    shared_credentials_file = "~/.aws/credentials"
    region     = "${var.region}"
} # end provider

terraform {
  required_version = ">= 0.11.7"
  backend "s3" {
    region  = "us-west-2"
    bucket  = "terraform-tungsten-access-logs"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

# create the VPC
resource "aws_vpc" "tungsten_VPC" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}" 
  enable_dns_support   = "${var.dnsSupport}" 
  enable_dns_hostnames = "${var.dnsHostNames}"
tags {
    Name = "${var.prefix}-VPC"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "tungsten_VPC_Subnet" {
  vpc_id                  = "${aws_vpc.tungsten_VPC.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}" 
  availability_zone       = "${var.availabilityZone}"
tags = {
   Name = "${var.prefix}-VPC-Subnet"
  }
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
    to_port    = 10001
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 10000
    to_port    = 10001
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

resource "aws_network_acl_rule" "allow_ingress_icmp_test" {
    network_acl_id = "${aws_network_acl.tungsten_VPC_Security_ACL.id}"
    rule_number = 300
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}

resource "aws_network_acl_rule" "allow_egress_icmp_test" {
    network_acl_id = "${aws_network_acl.tungsten_VPC_Security_ACL.id}"
    rule_number = 300
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}

# Create the Internet Gateway
resource "aws_internet_gateway" "tungsten_VPC_GW" {
  vpc_id = "${aws_vpc.tungsten_VPC.id}"
tags {
        Name = "${var.prefix}-VPC-Internet-Gateway"
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


# end vpc.tf
