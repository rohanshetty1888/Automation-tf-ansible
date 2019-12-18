#!/bin/bash


#===================================================================================
#
# FILE: Seedbox_Verfication_TestCases.sh
#
# USAGE: bash Seedbox_Verfication_TestCases.sh SEEDBOX_IP BYNET_IP 
#
# DESCRIPTION:
# 
#  1. Seedbox_verification_test.sh script will verify status of different 
#     components of seedbox like bynet, viewpoint, network, firewall
#
#  2. While executing this script we need to pass 2 cli args
#     seedbox_ip, bynet_ip 
#
#  3. If you dont pass any arguments script will exit with proper instructions
#  
#  4. Verification script will verify following things
#     - viewpoint web access from remote server
#     - Bynet interface access from remote server 
#     - DSC rest API access
#
#===================================================================================



seedbox_ip=$1
bynet_ip=$2
total_args=$#
total_testcases=0
total_passed=0


#===  FUNCTION  ================================================================
# NAME:  check_params
# DESCRIPTION:  Check no of command line args
# PARAMETER  1:  ---
#===============================================================================

function exit_with_report()
{
  total_failed=$((total_testcases-total_passed))
  echo "$total_testcases $total_passed $total_failed" | awk 'BEGIN {printf("\n\n**Test Case execution report**\n-------------------------------\n%6s %8s %8s \n" ,"| Total |", "Passed   |", "Failed   |\n-------------------------------")} {printf("| %3d   |  %3d     |  %3d     | \n", $1, $2, $3)} {printf ("%20s","-------------------------------\n")}'
  exit 1
}

#===  FUNCTION  ================================================================
# NAME:  check_params
# DESCRIPTION:  Check no of command line args
# PARAMETER  1:  ---
#===============================================================================
function check_params()
{
  if [ "$total_args" -ne 2 ];
  then
    echo -e "\nYou have not provided required cli arguments.
Please pass exactly 2 cli arguments.
e.g bash Seedbox_Verfication_TestCases.sh SEEDBOX_IP BYNET_IP\n"
    exit 1
  fi
}

check_params

#----------------------------------------------------------------------
# Viewpoint Service Test Cases
#----------------------------------------------------------------------
echo -e "####Viewpoint Service Test Case\\n"
viewpoint_ui_port=$(curl -o - -I --silent http://"$seedbox_ip"/login.html | grep -o \
'200 OK' | wc -l)
total_testcases=$((total_testcases+1))
if [ "$viewpoint_ui_port" -ne 1 ]; then
  echo "Test Case for checking Viewpoint access been failed. 
Viewpoint service is down or port Forwarding is not enabled."
  exit_with_report
else
  echo -e "\nViewpoint access test cases is passed.\n"
  total_passed=$((total_passed+1))
fi


#----------------------------------------------------------------------
# Bynet Interface: static IP test Cases for bynet interface
#----------------------------------------------------------------------
echo -e "####Bynet Interface: static IP test Cases\\n"
byn_status=$(ping -c 1 "$bynet_ip" | wc -l)
total_testcases=$((total_testcases+1))
if [ "$byn_status" -ne 0 ]; then
  echo "Test Case for checking bynet static ip has been failed. 
Please check bynet configuration"
  exit_with_report
else
  echo -e "\nBynet static IP test cases is passed for bynet"
  total_passed=$((total_passed+1))
fi

#----------------------------------------------------------------------
# DSC Rest API Test Cases
#----------------------------------------------------------------------
echo -e "####DSC Rest Service Test Case\\n"
dsc_rest_ui=$(curl -o - -I --silent http://"$seedbox_ip:9090" | grep -o \
'200 OK' | wc -l)
total_testcases=$((total_testcases+1))
if [ "$dsc_rest_ui" -ne 1 ]; then
  echo "Test Case for checking DSC Rest API has been failed. 
DSC service is down or Firewall rules are not enabled."
  exit_with_report
else
  echo -e "\nDSC service Rest API test case is passed.\n"
  total_passed=$((total_passed+1))
fi

echo "All verification test cases for Seedbox has been successfully verified."

