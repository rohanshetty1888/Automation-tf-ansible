# README #

This README.md will help understand the repository structure of terraform.
This repository is used for deploying infrastructure for continuent tungsten simple three node cluster on cloud.

### Pre-requisites ###
* Terraform v0.11.7 or latest version
* Terraform requires access to your aws account to create resources.

### Repository Structure ###

   1. The folder represents a terraform template to create AWS resource in cloud.
   2. The *.tfvars file represents configuration inputs required to create resources.
   3. Variables.tf file contains empty list of variables required to create resources.


#### Set up AWS Account ####

Terraform requires access to your aws account to create resources.

You can set the account details in ~/.aws/credentials file as shown below:

```
#Continuent
aws_secret_access_key = <your access key>
aws_access_key_id = <your secret key>

```

##### Run terraform template #####

The name of action to be performed. following actions can be performed using command: 

```
terraform "<action>"
```
1. plan
2. apply
3. refresh
4. output
5. destroy
6. show

##### About terraform template #####

Terraform template will create following resources required for simple Three node cluster.
1. VPC 
2. Subnet
3. Security Group
4. S3 data bucket
5. Route table for private subnet
6. Route table for public subnet
7. Network ACL
8. Internet Gateway
9. AWS EC2 instances
10. Elastic load balancer
