variable "region" {
}
variable "availabilityZone" {}
variable "count" {}
variable "prefix" {}
variable "availabilityZone_west" {}
variable "region_west" {}
variable "instance_type" {}
variable "storage_size" {}
variable "storage_type" {}
variable "storage_iops" {}

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
    type = "map"
    default  = {
    us-east-1 = "ami-0f567c94ad98806df"
    us-west-2 = "ami-06b5acf8f41a6b6a3"
    eu-central-1 = "ami-ac7d4147"
    ca-central-1 = "ami-01661f18e1ae0b1c9"
    }
}

variable "key_name" {
    default = "tungsten"
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
	 default = [ "us-west-2a", "us-west-2b", "us-west-2c", "us-east-1a", "us-east-1b", "eu-central-1a", "ca-central-1a" ]
}
# end of variables.tf
