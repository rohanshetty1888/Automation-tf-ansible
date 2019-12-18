
#### Pre requsite for setup #####

1. Three Ubuntu 16.04 Instances with minimum system requirement: 2 Core and 2 GB RAM
2. SSH key configuration on all Three nodes. Keep private key in ~/$USER/.ssh/ directory.


#### Steps to run the Microservices setup ####

1. Download the validate.sh script from below URL on all 3 nodes:
`wget https://s3-us-west-2.amazonaws.com/continuent-artifacts/sagarwork/validate_instance_parameter.sh`

2. Run this script with Command on all 3 nodes:
`bash sudo validate_instance_parameter.sh`

3. Above script will download the startup script and installer tar file.

4. Now run the startup script only on master ( on Instance-1) once validation script has been validated least system requiremnts. 
To run startup script:
`sudo bash startup.sh -i <Instance-1-IP-address> -p <Instance-2-IP-address> -a <Instance-3-IP-address>`

Command to run playbook manually on setup for debugging:

`ansible-playbook --vault-password-file=vault_password  -i inventory playbook.yml --extra-vars "host1=172.31.21.101 host2=172.31.21.92 host3=172.31.17.1"`
