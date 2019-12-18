variable "region" {}
variable "availabilityZone" {}
variable "storage_size" {}
variable "count" {}
variable "prefix" {}
variable "instance_type" {}

variable "instanceTenancy" {
     default     = "default"
}

variable "dnsSupport" {
     default     = true
}

variable "dnsHostNames" {
    default = true
}

variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}

variable "subnetCIDRblock" {
    default = "10.0.1.0/24"
}

variable "subnetCIDRinternal" {
    type = "list"
    default = [ "10.0.1.0/24" ]
}

variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
         type = "list"
         default = [ "0.0.0.0/0" ]
}

variable "mapPublicIP" {
    default = true
}

variable "ami" {
    default  = "ami-058581d38548fff80"
}

variable "key_name" {
    default = "tungsten"
}

variable "storage_type" {
    default = "standard"
}

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


variable "conn_ips" {
         default = {
        "0" = "10.0.1.20"
        "1" = "10.0.1.21"
        "2" = "10.0.1.22"
        "3" = "10.0.1.23"
        "4" = "10.0.1.24"
        "5" = "10.0.1.25"
        }
}

variable "availabilityZones" {
	 type = "list"
	 default = [ "us-west-2a", "us-west-2b", "us-west-2c" ]
}
# end of variables.tf
