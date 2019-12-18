variable "region" {}
variable "availabilityZone" {}
variable "instanceTenancy" {}
variable "dnsSupport" {}
variable "dnsHostNames" {}
variable "vpcCIDRblock" {}
variable "subnetCIDRblock" {}
variable "destinationCIDRblock" {}
variable "ingressCIDRblock" {
         type = "list"
}
variable "mapPublicIP" {}
variable "ami" {}
variable "key_name" {}
variable "instance_type" {}
variable "storage_type" {}
variable "storage_size" {}
variable "bucket_name" {}
variable "prefix" {}

variable "count" {}
variable "ips" {
	 default = {
        "0" = "10.0.1.5"
        "1" = "10.0.1.6"
        "2" = "10.0.1.7"
        "3" = "10.0.1.8"
        "4" = "10.0.1.9"
        "5" = "10.0.1.10"
        }
}
variable "availabilityZones" {
	 type = "list"
	 default = [ "us-west-2a", "us-west-2b", "us-west-2c" ]
}
#variable "instance_ip" {}
# end of variables.tf