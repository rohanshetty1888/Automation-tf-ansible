provider "aws" {
    shared_credentials_file = "~/.aws/credentials"
    #region     = "us-west-2"
} # end provider

terraform {
  required_version = ">= 0.11.7"
  backend "s3" { 
  }
}

module "launcher-us-east-1" {
  source = "./launcher"
  region = "${var.region}"
  availabilityZone = "${var.availabilityZone}"
  count = "${var.count}"
  prefix = "${var.prefix}"
  instance_type = "${var.instance_type}"
  storage_size = "${var.storage_size}"
  storage_type = "${var.storage_type}"
  storage_iops = "${var.storage_iops}"
  }

module "launcher-eu-central-1" {
  source = "./launcher"
  region = "${var.region_west}"
  availabilityZone = "${var.availabilityZone_west}"
  count = "${var.count}"
  prefix = "${var.prefix}"
  instance_type = "${var.instance_type}"
  storage_size = "${var.storage_size}"
  storage_type = "${var.storage_type}"
  storage_iops = "${var.storage_iops}"
  }

output "public_ip" {
  value =  "${module.launcher-us-east-1.public_ip}"
        }

output "public_ips" {
  value =  "${module.launcher-eu-central-1.public_ip}"
        }

output "public_connector_ip" {
  value =  "${module.launcher-us-east-1.public_connector_ip}"
        }

output "public_connector_ips" {
  value =  "${module.launcher-eu-central-1.public_connector_ip}"
        }

output "public_connector_elb_east" {
  value =  "${module.launcher-us-east-1.public_connector_elb}"
        }

output "public_connector_elb_west" {
  value =  "${module.launcher-eu-central-1.public_connector_elb}"
        }