#!/bin/bash

# This script need below env var setup -
#   export stackuser="stacki api user name ex- admin"  
# 	export key="api key" # for key stacki server check file /root/stacki-ws.cred
#	export apiendpoint="stacki-server-api-endpoint"
# 	export seedboxhostname="stacki server host name"

# This script performs below configuration on stacki server 
#	1. loads the seedbox host file
#	2. setup the bootaction commands and host attr
# 

echo "Importing the hostfile"
python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "load hostfile file=/tmp/hostfile.csv"

echo "Run the host install action "
python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "set host installaction $seedboxhostname action=\"install sles 11.3 vga\""

echo "Run the host boot install action command"
python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "set host boot $seedboxhostname action=install"

echo "Set the host nukedisks attr for $seedboxhostname"
python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "set host attr $seedboxhostname attr=nukedisks value=true"

echo "Set the host nukecontroller attr for $seedboxhostname"
python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "set host attr $seedboxhostname attr=nukecontroller value=true"
