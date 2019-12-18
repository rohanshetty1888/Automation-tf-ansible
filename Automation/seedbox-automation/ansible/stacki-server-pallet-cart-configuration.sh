#!/bin/bash

# This script need below env var setup 
#	1.export palleturi="stacki pallet uri"
#	2.export palletname="stacki pallet name"
#	3.export carturi="stacki cart uri"
#	4.export cartname="stacki cart name"
#	5.export stackuser="stacki server api user name"
#	6.export apiendpoint="stacki server api endpoint"

# This script perform below action on stacki server
#	1. download the pallet/cart from given url
#	2. add the pallet/cart
# 	3. enable the pallet/cart

result=$(python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "list pallet $palletname")
if [[ $result == *"CommandError: error - unknown pallet"* ]]; then
  echo "$palletname pallet is not there. Setting it!!"
elif [[ $result == *"\"name\":"* ]];then
  echo "$palletname pallet is already there. overwriting the pallet"
  python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "remove pallet $palletname"
fi

result=$(python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "list cart $cartname")
if [[ $result == *"{}"* ]]; then
  echo "$cartname cart is not there. Setting it!!"
elif [[ $result == *"\"name\":"* ]];then
  echo "$cartname cart is already there. overwriting the cart"
  python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "remove pallet $palletname"
fi

# run the ansible playbook to download the carts/pallets
ansible-playbook -i inventory.ini deploy-stacki-carts-pallets.yml --extra-vars "pallet_url=$palleturi,pallet_name=$palletname,carts_url=$carturi cart_name=$cartname"

# enable the cart and pallet 
python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "enable pallet $palletname box=$boxname"
python stacki_rest/stacki_server_config.py -u $stackuser -k $key -a $apiendpoint -c "enable cart $cartname box=$boxname"
