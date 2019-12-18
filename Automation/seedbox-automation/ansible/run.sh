#!/bin/bash

function main
{
    ACTION=""
    check_action=""
    is_action=0
    is_env=0
    INVENTORY=""
    ENV=""
    VARS=""

    while getopts a:e:v: opt
    do
        case "$opt" in
          e)
            ENV=$OPTARG
            is_env=1
 	  ;;
          a)
            check_action=$OPTARG
            is_action=1
	  ;;
          v)
            VARS=$OPTARG
            echo $VARS
          ;;
        esac
    done

    # Checking for no params
    if [ "$#" -eq 0 ]; then
      echo -e "\nAnsible Job execution failed. Please check configuration in jenkins job"
      exit 1
    fi 

    #Checking which env 
    if [ $is_env -eq 1 ]; then 
      if [ $ENV == "prod" ]; then
        INVENTORY="inventory_prod.ini"
      elif [ $ENV == "qa" ]; then
        INVENTORY="inventory.ini"
      elif [ $ENV == "dbvm" ]; then
        INVENTORY="inventory_dbvm.ini"
      else
        echo -e "\nAnsible Job execution failed. Please check configuration in jenkins job"
        exit 1
      fi
    fi

    #Checking which action to be taken
    if [ $is_action -eq 1 ]; then 
      if [ $check_action == "install" ]; then
        ACTION="dsa_setup.yml"
      elif [ $check_action == "cleanup" ]; then
	ACTION="uninstall.yml"
      elif [ $check_action == "install_dbvm" ]; then
	ACTION="dsa_setup_on_dbvm.yml"
      else
        echo -e "\nAnsible Job execution failed. Please check configuration in jenkins job"
        exit 1
      fi
    else
      echo -e "\nAnsible Job execution failed. Please check configuration in jenkins job"
      exit 1
    fi

    if [ -z "$VARS" ]; then 
      ansible-playbook -i $INVENTORY $ACTION --vault-password-file vault_pass.txt
    else
      VARS="$VARS"
      ansible-playbook -i $INVENTORY $ACTION --extra-vars "$VARS" --vault-password-file vault_pass.txt
    fi 
}

main "$@"
