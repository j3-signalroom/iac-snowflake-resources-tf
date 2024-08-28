#!/bin/bash

#
# *** Script Syntax ***
# scripts/run-terraform-locally.sh --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account_locator=<snowflake_account_locator> --snowflake_username=<SNOWFLAKE_USERNAME>
#
#

# Check if arguments were supplied; otherwise exit script
if [ ! -n "$1" ]
then
    echo
    echo "(Error Message 001)  You did not include all four arguments in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account_locator=<snowflake_account_locator> --snowflake_username=<SNOWFLAKE_USERNAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Get the arguments passed
arg_count=0
action_argument_supplied=false
for arg in "$@" # $@ sees arguments as separate words
do
    case $arg in
        *"--profile="*)
            AWS_PROFILE=$arg;;
        *"--environment="*)
            arg_length=14
            environment_name=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--action=create"*)
            action_argument_supplied=true
            create_action=true;;
        *"--action=destroy"*)
            action_argument_supplied=true
            create_action=false;;
        *"--snowflake_account_locator="*)
            arg_length=26
            snowflake_account_locator=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_username="*)
            arg_length=21
            snowflake_username=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
    esac
    let "arg_count+=1"
done

# Check required --environment argument was supplied
if [ -z $environment_name ]
then
    echo
    echo "(Error Message 002)  You did not include the proper use of the --environment=<ENVIRONMENT_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account_locator=<snowflake_account_locator> --snowflake_username=<SNOWFLAKE_USERNAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --profile argument was supplied
if [ -z $AWS_PROFILE ]
then
    echo
    echo "(Error Message 003)  You did not include the proper use of the --profile=<AWS_SSO_SSO_PROFILE_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account_locator=<snowflake_account_locator> --snowflake_username=<SNOWFLAKE_USERNAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --action argument was supplied
if [ "$action_argument_supplied" = false ]
then
    echo
    echo "(Error Message 004)  You did not include the proper use of the --action=<create | destroy> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account_locator=<snowflake_account_locator> --snowflake_username=<SNOWFLAKE_USERNAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_account_locator argument was supplied
if [ -z $snowflake_account_locator ]
then
    echo
    echo "(Error Message 005)  You did not include the proper use of the --snowflake_account_locator=<snowflake_account_locator> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account_locator=<snowflake_account_locator> --snowflake_username=<SNOWFLAKE_USERNAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_username argument was supplied
if [ -z $snowflake_username ]
then
    echo
    echo "(Error Message 006)  You did not include the proper use of the --snowflake_username=<SNOWFLAKE_USERNAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account_locator=<snowflake_account_locator> --snowflake_username=<SNOWFLAKE_USERNAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Get the SSO AWS_ACCESS_KEY_ID, AWS_ACCESS_SECRET_KEY, AWS_SESSION_TOKEN, and AWS_REGION, and
# set them as environmental variables
aws sso login $AWS_PROFILE
eval $(aws2-wrap $AWS_PROFILE --export)
export AWS_REGION=$(aws configure get sso_region $AWS_PROFILE)
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Export Terraform authentication information via environment variables so Terraform can authenticate
# the Snowflake user
export SNOWFLAKE_USER="${snowflake_username}"
export SNOWFLAKE_AUTHENTICATOR=JWT
export SNOWFLAKE_PRIVATE_KEY=`cat ${key_path}/snowflake_${snowflake_username}_key.p8`
export SNOWFLAKE_ACCOUNT="${snowflake_account_locator}"

# Create terraform.tfvars file
printf "aws_account_id=\"${AWS_ACCOUNT_ID}\"\
\naws_profile=\"${environment_name}\"\
\naws_region=\"${AWS_REGION}\"\
\naws_access_key_id=\"${AWS_ACCESS_KEY_ID}\"\
\naws_secret_access_key=\"${AWS_SECRET_ACCESS_KEY}\"\
\naws_session_token=\"${AWS_SESSION_TOKEN}\"\
\nsnowflake_account_locator=\"${snowflake_account_locator}\"\
\nsnowflake_authenticator=\"JWT\"\
\nsnowflake_username=\"${snowflake_username}\"" > terraform.tfvars

terraform init

if [ "$create_action" = true ]
then
    # Create/Update/Destroy the Terraform configuration
    terraform plan -var-file=terraform.tfvars
    terraform apply -var-file=terraform.tfvars
else
    # Destroy the Terraform configuration
    terraform destroy -var-file=terraform.tfvars
fi
