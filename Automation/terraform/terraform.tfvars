region = "us-west-2"
availabilityZone = "us-west-2a"
storage_type = "standard"
storage_size = "20"
prefix = "tungstentg"
instance_type = "t2.small"


instanceTenancy = "default"
dnsSupport = true
dnsHostNames = true
vpcCIDRblock = "10.0.0.0/16"
subnetCIDRblock = "10.0.1.0/24"
destinationCIDRblock = "0.0.0.0/0"
ingressCIDRblock = [ "0.0.0.0/0" ]
mapPublicIP = true
ami = "ami-058581d38548fff80"
key_name = "tungsten"
count = "3"
bucket_name = "tg-tungsten-test-buck"
