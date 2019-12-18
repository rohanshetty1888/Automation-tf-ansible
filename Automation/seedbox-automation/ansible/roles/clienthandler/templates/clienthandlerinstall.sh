#!/bin/bash

cd {{ clienthandler_pkg_path.stdout }}
/usr/bin/expect <<EOD
set timeout 60
spawn ./clienthandler_install.sh -r {{ clienthandler_rpm.stdout }}
expect "*?lease enter the directory to use as the base directory" 
send "{{ clienthandler_base_dir }}\n" 
sleep 1
expect "*?lease enter ActiveMQ Broker" 
send "{{ clienthandler_activemq_url }}:{{ clienthandler_activemq_port }}\n"
sleep 1
expect "*?lease enter next ActiveMQ Broker" 
send "\n"
sleep 1
expect "*?lease enter type of ActiveMQ connection"
send "{{ clienthandler_activemq_conn }}\n"
sleep 1
expect "*?lease enter Server ID"
send "{{ clienthandler_hostname.stdout }}\n"
sleep 1
expect "*?s this system the master"
send "{{ clienthandler_master_choice }}\n"
sleep 1
expect "*?lease enter the CBB"
send "{{ clienthandler_cbb_path }}\n"
sleep 1
expect "*?lease enter the username to set up a account"
send "{{ clienthandler_username }}\n"
sleep 1
expect "*?lease enter the userid of the"
send "{{ clienthandler_uid }}\n"
sleep 30
interact
EOD

