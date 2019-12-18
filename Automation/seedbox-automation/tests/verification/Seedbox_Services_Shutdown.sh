#!/bin/bash
#===================================================================================
#
# FILE: Seedbox_Services_Shutdown.sh
#
# USAGE: bash Seedbox_Services_Shutdown.sh
#
# DESCRIPTION:
#  1. Seedbox_Services_Shutdown.sh is bash script which will shutdown all seedbox 
#     services
#  
#  2. Script makes sure that before shutting down seedbox, all services will be 
#     shutdown as per the standard process.
#
#===================================================================================

echo -e "\n------------------ : shutdown.sh : ------------------"
echo -e "This script will stop all running services before seedbox shutdown process\n"
sleep 4

SERVICE="craneagent"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 2

SERVICE="tdrestd"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 4

SERVICE="clienthandler"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 4

SERVICE="dsc"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 5

echo -e "==(Shutting down database repository service"
ssh -i /tmp/id_rsa root@192.168.122.77 /etc/init.d/tpa stop
echo -e "Sleeping for 15 seconds for proper shutdown of database service"
sleep 15

echo -e "==(Shutting down database repository VM"
virsh shutdown dsc_repository
echo -e "Sleeping for 10 seconds for proper shutdown of vm"
sleep 10

echo -e "==(Shutting down viewpoint service"
ssh -i /tmp/id_rsa root@192.168.122.177 /opt/teradata/viewpoint/bin/vp-control.sh stop
echo -e "Sleeping for 15 seconds for proper shutdown of viewpoint service"
sleep 15

echo -e "==(Shutting down viewpoint VM"
virsh shutdown viewpoint
echo -e "Sleeping for 10 seconds for proper shutdown of vm"
sleep 10

SERVICE="tdactivemq"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 2

SERVICE="libvirtd"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 2

SERVICE="ntp"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 2

SERVICE="bynet"
echo -e "==(Shutting down $SERVICE service"
/etc/init.d/$SERVICE stop
sleep 2
