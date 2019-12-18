#!/bin/bash
#===================================================================================
#
# FILE: Seedbox_Services_Startup.sh
#
# USAGE: bash Seedbox_Services_Startup.sh
#
# DESCRIPTION:
#  1. Seedbox_Services_Startup.sh script is a start up script. 
#     This script will check for status for different services.
#     e.g bynet, ntp, dsc services, kvm services, tdactivemq, tdrest
#
#  2. This script will first check for service status and if the service
#     is down then script attempt to start the service for 1 time.
#
#  3. If the service goes in down state even after first start attempt, then
#     script will print error message with appropriate log file path.
#
#===================================================================================
#TODO: Add log file path for kvm services. Need testing for kvm services on baremetal box.

echo -e "\n------------------ : startup.sh : ------------------"
echo -e "This script will check services status to make sure all services are up and running.\n"
sleep 4

#----------------------------------------------------------------------
# NTP service check
#----------------------------------------------------------------------
SERVICE="ntp"
/etc/init.d/$SERVICE status > /dev/null
if [ "$?" -eq 0 ]; then 
    echo -e "==(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service....."
    /etc/init.d/$SERVICE start
fi
sleep 2

#----------------------------------------------------------------------
# Bynet service check
#----------------------------------------------------------------------
SERVICE="bynet"
/etc/init.d/$SERVICE status > /dev/null
if [ "$?" -eq 0 ]; then 
    echo -e "==(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service....."
    /etc/init.d/$SERVICE start
fi
sleep 2

#----------------------------------------------------------------------
# TDActivemq service check
#----------------------------------------------------------------------
SERVICE="tdactivemq"
/etc/init.d/$SERVICE status > /dev/null
if [ "$?" -eq 0 ]; then 
    echo -e "==(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service....."
    /etc/init.d/$SERVICE start
fi
sleep 2

#----------------------------------------------------------------------
# Libvirtd service status check 
#----------------------------------------------------------------------
SERVICE="libvirtd"
/etc/init.d/$SERVICE status > /dev/null
if [ "$?" -eq 0 ]; then 
    echo -e "==(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service....."
    /etc/init.d/$SERVICE start
fi
sleep 2

#----------------------------------------------------------------------
# default network status check 
#----------------------------------------------------------------------
virsh net-list | grep 'default'
if [ "$?" -eq 0 ]; then 
    echo -e "==(STATUS OK: Default KVM network is running fine."
else
    echo -e "\n\nDefault KVM network is not running. Starting network....."
    virsh net-start default
fi
sleep 2

#----------------------------------------------------------------------
# Datbase repository VM status check
#----------------------------------------------------------------------
status_code=$(virsh list --all | grep "dsc_repository" | grep "running" | wc -l)
if [ "$status_code" -eq 1 ];
then
    echo -e "===(STATUS OK: Database VM is running fine."
else
    echo -e "\n\nDatabase VM is not running. Starting Database VM.....\n"
    virsh start dsc_repository
    echo -e "Sleeping for 15 seconds......."
    sleep 15
fi
sleep 2

#----------------------------------------------------------------------
# Datbase repository service status check
#----------------------------------------------------------------------
status_code=$(ssh -i /tmp/id_rsa root@192.168.122.77 pdestate -a | grep 'PDE state is RUN/STARTED' | wc -l)
if [ "$status_code" -eq 1 ];
then
    echo -e "===(STATUS OK: Database service is running fine."
else
    echo -e "\n\nDatabase service is not running. Starting Database service.....\n"
    ssh -i /tmp/id_rsa root@192.168.122.77 /etc/init.d/tpa start
    echo -e "Sleeping for 15 seconds......."
    sleep 15
fi
sleep 2

#----------------------------------------------------------------------
# Viewpoint VM status check
#----------------------------------------------------------------------
status_code=$(virsh list --all | grep "viewpoint" | grep "running" | wc -l)
if [ "$status_code" -eq 1 ];
then
    echo -e "===(STATUS OK: Viewpoint VM is running fine."
else
    echo -e "\nViewpoint VM is not running. Starting viewpoint VM.....\n"
    virsh start viewpoint
    echo -e "Sleeping for 15 seconds......."
    sleep 15
fi
sleep 2

#----------------------------------------------------------------------
# Viewpoint service status check
#----------------------------------------------------------------------
status_code=$(ssh -i /tmp/id_rsa root@192.168.122.177 /opt/teradata/viewpoint/bin/vp-control.sh status | grep "unused" | wc -l)
if [ "$status_code" -eq 0 ];
then
    echo -e "===(STATUS OK: Viewpoint service is running fine."
else
    echo -e "\n\nViewpoint service or dependent services are not running. Starting Viewpoint services.....\n"
    ssh -i /tmp/id_rsa root@192.168.122.77 /opt/teradata/viewpoint/bin/vp-control.sh start
    echo -e "Sleeping for 15 seconds......."
    sleep 15
fi
sleep 2

#----------------------------------------------------------------------
# DSC service check
#----------------------------------------------------------------------
SERVICE="dsc"
status_code=$(/etc/init.d/$SERVICE status | grep "not" | wc -l)
if [ "$status_code" -eq 0 ];
then
    echo -e "===(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service.....\n"
    /etc/init.d/$SERVICE start
fi
sleep 2

#----------------------------------------------------------------------
# Clienthandler service check
#----------------------------------------------------------------------
SERVICE="clienthandler"
status_code=$(/etc/init.d/$SERVICE status | grep "not" | wc -l)
if [ "$status_code" -eq 0 ];
then
    echo -e "==(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service.....\n"
    /etc/init.d/$SERVICE start
fi
sleep 2

#----------------------------------------------------------------------
# TDrestd service check
#----------------------------------------------------------------------
SERVICE="tdrestd"
status_code=$(/etc/init.d/$SERVICE status | grep "running" | wc -l)
if [ "$status_code" -eq 1 ];
then
    echo -e "==(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service.....\n"
    /etc/init.d/$SERVICE start
fi
sleep 2

#----------------------------------------------------------------------
# Craneagent service check
#----------------------------------------------------------------------
SERVICE="craneagent"
/etc/init.d/$SERVICE status > /dev/null
if [ "$?" -eq 0 ]; then 
    echo -e "==(STATUS OK: $SERVICE service is running fine."
else
    echo -e "\n\n$SERVICE is not running. Starting $SERVICE service....."
    /etc/init.d/$SERVICE start > /dev/null 2>&1
fi
sleep 2


echo -e "\n\nNow Checking status of services again. If It is still down, then please check appropriate log files.\n"
sleep 4
##Following code snippet will check services status and it will display the path of logs file to debug.
SERVICE="ntp"
/etc/init.d/$SERVICE status > /dev/null
if [ "$?" -ne 0 ]; then
    echo -e "\nCRITICAL: $SERVICE service is still down even after starting service. Please check logs at /var/log/ntp\n"
    sleep 2
fi

SERVICE="bynet"
/etc/init.d/$SERVICE status > /dev/null
if [ "$?" -ne 0 ]; then
    echo -e "\nCRITICAL: Bynet service is still down even after starting service. Please check logs at /var/log/messages\n"
    sleep 2
fi

SERVICE="tdactivemq"
/etc/init.d/$SERVICE status > /dev/null 
if [ "$?" -ne 0 ]; then
    echo -e "\nCRITICAL: TDActivemq service is still down even after starting service. Please check logs at /var/opt/teradata/tdactivemq/logs/activemq.log\n"
    sleep 2
fi

SERVICE="libvirtd"
/etc/init.d/$SERVICE status > /dev/null 
if [ "$?" -ne 0 ]; then
    echo -e "\nCRITICAL: Libvirtd service is still down even after starting service. Please check logs at /var/log/libvirt/libvirtd.log\n"
    sleep 2
fi

virsh net-list | grep 'default'
if [ "$?" -ne 0 ]; then
    echo -e "\nCRITICAL: KVM default network is still down even after starting network. Please check logs at /var/log/libvirt/libvirtd.log\n"
    sleep 2
fi

status_code=$(virsh list --all | grep "dsc_repository" | grep "running" | wc -l)
if [ "$status_code" -ne 1 ]; then
    echo -e "\nCRITICAL: Database VM is still down even after starting service. Please check logs at /var/log/libvirt/libvirtd.log\n"
    sleep 2
fi

status_code=$(ssh -i /tmp/id_rsa root@192.168.122.77 pdestate -a | grep 'PDE state is RUN/STARTED' | wc -l)
if [ "$status_code" -ne 1 ];
then
    echo -e "\nCRITICAL: Database service is still down even after starting service. Please login to database VM and check logs."
    echo -e "Run this command to Login database VM from seedbox: ssh -i /tmp/id_rsa root@192.168.122.77\n"
fi

status_code=$(virsh list --all | grep "viewpoint" | grep "running" | wc -l)
if [ "$status_code" -ne 1 ]; then
    echo -e "\nCRITICAL: viewpoint VM is still down even after starting service. Please check logs at /var/log/libvirt/libvirtd.log\n"
    sleep 2
fi

status_code=$(ssh -i /tmp/id_rsa root@192.168.122.177 /opt/teradata/viewpoint/bin/vp-control.sh status | grep "unused" | wc -l)
if [ "$status_code" -ne 0 ];
then
    echo -e "CRITICAL: Viewpoint service is still down even after starting service. Please login to viewpoint VM and check logs.\n"
    echo -e "Run this command to Login viewpoint VM from seedbox: ssh -i /tmp/id_rsa root@192.168.122.177\n"
fi

status_code=$(/etc/init.d/dsc status | grep "not" | wc -l)
if [ "$status_code" -ne 0 ]; then
    echo -e "\nCRITICAL: DSC service is still down even after starting service. Please check logs at /var/opt/teradata/dss/dsc.console.log\n"
    sleep 2
fi

status_code=$(/etc/init.d/clienthandler status | grep "not" | wc -l)
if [ "$status_code" -ne 0 ]; then
    echo -e "\nCRITICAL: Clienthandler service is still down even after starting service. Please check logs at /var/opt/teradata/dsa/logs/clienthandler.log\n"
    sleep 2
fi

status_code=$(/etc/init.d/tdrestd status | grep "running" | wc -l)
if [ "$status_code" -eq 0 ];
then
    echo -e "\nCRITICAL: Tdrestd service is still down even after starting service. Please check logs at /var/opt/teradata/rest/daemon/logs/tdrestd.log\n"
    sleep 2
fi

SERVICE="craneagent"
/etc/init.d/$SERVICE status > /dev/null 
if [ "$?" -ne 0 ]; then
    echo -e "\nCRITICAL: Craneagent service is still down even after starting service. Please check logs at /var/opt/teradata/dss/agent.log\n"
    sleep 2
fi
