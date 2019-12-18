#!/bin/bash

export JDK7_64_HOME=/opt/teradata/jvm64/jdk7
export JRE7_64_HOME=/opt/teradata/jvm64/jre7

cd {{ barcmdcline_pkg_path.stdout }}
/usr/bin/expect <<EOD
set timeout 60
spawn ./dscinstall.sh -r {{ barcmdcline_rpm.stdout }}
expect "*?lease enter the directory to use as the base directory"
send "{{ barcmd_base_dir }}\n"
sleep 1
expect "*?lease enter ActiveMQ Broker URL"
send "{{ barcmd_activemq_url }}\n"
sleep 1
expect "*?lease enter ActiveMQ Broker Port"
send "{{ barcmd_activemq_port }}\n"
sleep 1
expect "*?lease enter type of ActiveMQ connection"
send "{{ barcmd_activemq_conn }}\n"
sleep 1
expect "*?lease specify the name of dsc to connect to"
send "{{ barcmd_dsc_unique_name }}\n"
sleep 30
interact
EOD

