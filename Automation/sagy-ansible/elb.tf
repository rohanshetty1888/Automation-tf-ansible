terraform {
  required_version = ">= 0.11.7"
}

# Create s3 bucket to store ELB logs
resource "aws_s3_bucket" "s3_data_bucket" {
    bucket = "${var.prefix}-tungsteng-elb-log"
    force_destroy = true

# Policy fot bucket to enable PUT object
    policy =<<EOF
{
"Id": "Policy1509573454872",
"Version": "2012-10-17",
"Statement": [
    {
    "Sid": "Stmt1509573447773",
    "Action": "s3:PutObject",
    "Effect": "Allow",
    "Resource": "arn:aws:s3:::${var.prefix}-tungsteng-elb-log/*",
    "Principal": {
        "AWS": ["797873946194"]
    }
    }
]
}
EOF
} # End of resource


# Add instances with aws elastic load balancer.
resource "aws_elb" "tungsten_elb" {
  name               = "${var.prefix}-terraform-elb"  
  security_groups = ["${aws_security_group.tungsten_VPC_Security_Group.id}"]
  subnets = ["${aws_subnet.tungsten_VPC_Subnet.id}"]


  access_logs {
    bucket = "${var.prefix}-tungsteng-elb-log"
    bucket_prefix = "elb"
    interval = 5
}


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

  instances                   = ["${aws_instance.connector.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.prefix}-terraform-elb"
  }
} # end resource
# end of elb.tf
