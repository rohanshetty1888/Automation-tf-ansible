#!/bin/bash

RED="\x1b[31m"
GREEN="\x1b[32m"
COLOR_RESET="\x1b[0m"
stateFileName=""
terraform_args=""

# update this when new component gets added
# update this when new folder gets added
# first comma separated strings represent components for customerlobby
# second comma separated string represent names of folders corresponding to above components respectively.


echo_with_color() {
  echo -e "$2$1$COLOR_RESET"
}

function main 
{
  initScript "$@"  
  get_state_name
  echo_with_color "Target terraform module is at ./$module_directory/*.tf" $GREEN
  #cd $module_directory
  tf_init
  
  case "$ACTION" in
    apply)      tf_apply
                ;;
    plan)       tf_plan
                ;;
    destroy)    tf_destroy
                ;;
    show)       terraform show 
                ;;                
    output)     tf_output                
                ;;
    refresh)    tf_refresh
                ;;
    *)          echo "The action $ACTION is not valid terraform action."
                exit 1
                ;;
  esac      
}
function usage
{
    cat <<EOF

    Usage:
        -e Environment:  The name of environment such as staging, POC, Production. Currently only staging is available.
	       select the type of cluster name:
		- simple-cluster
		- multinode-cluster
		- composite-cluster
        -a Action: The name of action to be performed. It can take values like apply|plan|show|output|destroy|refresh
            This can accept following values-
              plan
              apply
              refresh
              output
              destroy
              show
        -r Region: us-west-2
        -s Customkey: Custom Name of state file. This is recommended when you dont want to touch existing infrastructure.
        
    Examples:
        ./run_terraform.sh -e simple-cluster -a plan|apply|destroy|show|output|refresh  -r us-east-1 -s <prefix>
        ./run_terraform.sh -e simple-cluster -a plan|apply|destroy|show|output|refresh  -r us-east-1 -s <prefix>

EOF
}

function initScript
{
    ENVIRONMENT=""
    ACTION="plan" 
    REGION="us-west-2"
    CUSTOMKEY=""   
    while getopts h:e:a:r:s: opt
        do
           case "$opt" in
              h) usage "";exit 1;;
              e) ENVIRONMENT=$OPTARG;; 
              a) ACTION=$OPTARG;; 
              r) REGION=$OPTARG;;  
              s) CUSTOMKEY=$OPTARG;;                   
              \?) usage "";exit 1;;
           esac
        done
    if [ -z $ENVIRONMENT ] || [ -z $ACTION ] || [ -z $CUSTOMKEY ];
        then
            echo "$(date) Make sure you provide -e environment and -s CUSTOMKEY and -a ACTION"
            exit 1;            
    fi        

}



function tf_output
{
  eval "terraform output -json"
}

function tf_apply
{
  eval "terraform apply -var prefix=$CUSTOMKEY -auto-approve=true $terraform_args"
  eval "echo 'JSON OUTPUT STARTS HERE ::'"
  eval "terraform output -json"
}

function tf_plan
{
  eval "terraform plan -var prefix=$CUSTOMKEY $terraform_args"    
}

function tf_destroy
{
  eval "terraform destroy -var prefix=$CUSTOMKEY -force $terraform_args"
}

function tf_refresh
{
  eval "terraform refresh -var prefix=$CUSTOMKEY $terraform_args"
}

function release_local_state
{
  echo "cleaning up..."
  #rm -rf ./$module_directory/.terraform
  rm -rf ./*tfstate
  rm -rf ./terraform.tfstate.backup
}

function get_state_name
{
    if [ -z "$CUSTOMKEY" ];
      then
        stateFileName="$ENVIRONMENT""/""$COMPONENT""_state.tfstate"
      else
        stateFileName="$ENVIRONMENT""/""$CUSTOMKEY""/terraform.tfstate"
    fi
    echo_with_color "state file name = $stateFileName" $GREEN
}

function tf_init
{
  terraform get -update=true
  terraform init -backend-config="bucket=tungsten-state-$ENVIRONMENT" -backend-config="key=$stateFileName" -backend-config="region=$REGION" -reconfigure
}

main "$@"

#bash run_terraform.sh -e simple-cluster -a plan -r us-west-2 -s sagy
