terraform {
  required_version = ">= 0.11.7"
}

# Add instances with aws elastic load balancer.
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
