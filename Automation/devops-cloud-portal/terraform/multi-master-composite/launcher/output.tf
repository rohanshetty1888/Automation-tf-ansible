#output "aws_instance" {
#  value = "${module.launcher-us-east-1.tungsten.*.public_ip}"
#        }

output "public_ip" {
  value = "${aws_eip.tungsten_eip.*.public_ip}"
        }

output "public_connector_ip" {
  value = "${aws_eip.tungsten_connector_eip.*.public_ip}"
        }

output "public_connector_elb" {
  value = "${aws_elb.tungsten_elb.*.dns_name}"
        }
