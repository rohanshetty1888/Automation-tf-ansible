#output "instance_id" {
#  description = "List of IDs of instances"
#  value       = ["${aws_instance.tungsten.*.id}"]
#}

output "address" {
  value = "${aws_elb.tungsten_elb.dns_name}"
	}

output "public_ip" {
  value = "${aws_instance.tungsten.*.public_ip}"
        }
