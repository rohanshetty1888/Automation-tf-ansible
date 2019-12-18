#!/bin/bash

export JDK7_64_HOME=/opt/teradata/jvm64/jdk7
export JRE7_64_HOME=/opt/teradata/jvm64/jre7

cd {{ dsc_package_path.stdout }}
/usr/bin/expect <<EOD
set timeout 8
spawn ./dscinstall.sh -r {{ dsc_rpm.stdout }}
expect "*?lease enter ActiveMQ Broker URL"
send "{{ dsc_activemq_url }}\n"
sleep 1
expect "*?lease enter ActiveMQ Broker Port"
send "{{ dsc_activemq_port }}\n"
sleep 1
expect "*?lease enter type of ActiveMQ connection"
send "{{ dsc_activemq_conn }}\n"
sleep 1
expect "*?lease enter the dbs host name where the DSC repository" 
send "{{ dsc_dbs_hostname }}\n" 
sleep 1
expect "*?lease enter the ip address of the dbs system" 
send "{{ dsc_dbs_ipaddress }}\n" 
sleep 1
expect "*?lease enter the dbs superuser's username"
send "{{ dsc_dbs_superuser }}\n"
sleep 1
expect "*?lease enter the dbs superuser's password"
send "{{ tddb.tddbpassword }}\n"
sleep 1
expect {
"*?lease enter the desired size in GB" { send "{{ dsc_dbs_user_size }}\n"; exp_continue }
}
sleep 1
expect "*?lease enter the admin dbs username"
send "{{ dsc_dbs_admin }}\n"
sleep 1
expect "*?lease enter the admin dbs password"
send "{{ dsc_dbs_admin_password }}\n"
sleep 1
expect "*?lease enter the password used by BAR dbs user"
send "{{ dsc_bardbs_password }}\n"
sleep 1
expect "*?lease enter the password used by BARBACKUP dbs user"
send "{{ dsc_backupdbs_password }}\n"
sleep 1
expect "*?lease enter unique dsc name"
send "{{ dsc_unique_name }}\n"
sleep 1
expect "*?lease enter the Viewpoint URL for Viewpoint"
send "{{ dsc_viewpoint_url }}\n"
sleep 1
expect "*?lease enter the Viewpoint port for Viewpoint"
send "{{ dsc_viewpoint_port }}\n"
sleep 1
expect "*?lease enter the Viewpoint type for Viewpoint"
send "{{ dsc_viewpoint_type }}\n"
sleep 1
expect "*?Is CAM environment clustere"
send "{{ dsc_cam_env_clustered }}\n"
sleep 1
expect "*?lease enter the primary URL for CAM"
send "{{ dsc_cam_url }}\n"
sleep 1
expect "*?lease enter the port for CAM"
send "{{ dsc_cam_port }}\n"
sleep 1
expect "*?lease enter the port for the DSARest"
send "{{ dsa_rest_port }}\n"
sleep 1
expect "*?lease enter the username to set up a account"
send "{{ dsc_run_user }}\n"
sleep 1
expect "*?lease enter the userid of the dscuser"
send "{{ dsc_userid }}\n"
sleep 60
interact
EOD
