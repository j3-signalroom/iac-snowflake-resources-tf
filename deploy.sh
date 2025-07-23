#!/bin/bash

#
# *** Script Syntax ***
# ./deploy.sh <create | delete> --profile=<SSO_PROFILE_NAME> \
#                               --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> \
#                               --snowflake_user=<SNOWFLAKE_USER> \
#                               --secrets_path=<SECRETS_PATH> \
#                               --lambda_function_name=<LAMBDA_FUNCTION_NAME>
#
#

# Check required command (create or delete) was supplied
case $1 in
  create)
    create_action=true;;
  delete)
    create_action=false;;
  *)
    echo
    echo "(Error Message 001)  You did not specify one of the commands: create | delete."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` <create | delete> --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --snowflake_user=<SNOWFLAKE_USER> --secrets_path=<SECRETS_PATH> --lambda_function_name=<LAMBDA_FUNCTION_NAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
    ;;
esac

# Get the arguments passed by shift to remove the first word
# then iterate over the rest of the arguments
shift
for arg in "$@" # $@ sees arguments as separate words
do
    case $arg in
        *"--profile="*)
            AWS_PROFILE=$arg;;
        *"--snowflake_warehouse="*)
            arg_length=22
            snowflake_warehouse=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_user="*)
            arg_length=17
            snowflake_user=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--secrets_path="*)
            arg_length=15
            secrets_path=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--lambda_function_name="*)
            arg_length=23
            lambda_function_name=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
    esac
done

# Check required --profile argument was supplied
if [ -z $AWS_PROFILE ]
then
    echo
    echo "(Error Message 002)  You did not include the proper use of the --profile=<SSO_PROFILE_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --snowflake_user=<SNOWFLAKE_USER> --secrets_path=<SECRETS_PATH> --lambda_function_name=<LAMBDA_FUNCTION_NAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_warehouse argument was supplied
if [ -z $snowflake_warehouse ]
then
    echo
    echo "(Error Message 003)  You did not include the proper use of the --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --snowflake_user=<SNOWFLAKE_USER> --secrets_path=<SECRETS_PATH> --lambda_function_name=<LAMBDA_FUNCTION_NAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_user argument was supplied
if [ -z $snowflake_user ]
then
    echo
    echo "(Error Message 004)  You did not include the proper use of the --snowflake_user=<SNOWFLAKE_USER> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --snowflake_user=<SNOWFLAKE_USER> --secrets_path=<SECRETS_PATH> --lambda_function_name=<LAMBDA_FUNCTION_NAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --secrets_path argument was supplied
if [ -z $secrets_path ]
then
    echo
    echo "(Error Message 005)  You did not include the proper use of the --secrets_path=<SECRETS_PATH> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --snowflake_user=<SNOWFLAKE_USER> --secrets_path=<SECRETS_PATH> --lambda_function_name=<LAMBDA_FUNCTION_NAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --lambda_function_name argument was supplied
if [ -z $lambda_function_name ]
then
    echo
    echo "(Error Message 006)  You did not include the proper use of the --lambda_function_name=<LAMBDA_FUNCTION_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --snowflake_user=<SNOWFLAKE_USER> --secrets_path=<SECRETS_PATH> --lambda_function_name=<LAMBDA_FUNCTION_NAME>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Set the AWS environment credential variables that are used
# by the AWS CLI commands to authenicate
aws sso login $AWS_PROFILE
eval $(aws2-wrap $AWS_PROFILE --export)
export AWS_REGION=$(aws configure get sso_region $AWS_PROFILE)
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Create terraform.tfvars file
printf "aws_account_id=\"${AWS_ACCOUNT_ID}\"\
\naws_region=\"${AWS_REGION}\"\
\naws_access_key_id=\"${AWS_ACCESS_KEY_ID}\"\
\naws_secret_access_key=\"${AWS_SECRET_ACCESS_KEY}\"\
\naws_session_token=\"${AWS_SESSION_TOKEN}\"\
\nsnowflake_warehouse=\"${snowflake_warehouse}\"\
\nsnowflake_user=\"${snowflake_user}\"\
\nsecrets_path=\"${secrets_path}\"\
\nlambda_function_name=\"${lambda_function_name}\"" > terraform.tfvars

terraform init

if [ "$create_action" = true ]
then
    # Create/Update the Terraform configuration
    terraform plan -var-file=terraform.tfvars
    terraform apply -var-file=terraform.tfvars
else
    # Destroy the Terraform configuration
    terraform destroy -var-file=terraform.tfvars

    # Snowflake Secrets Path
    snowflake_secrets_path=$(echo $secrets_path | tr '[:upper:]' '[:lower:]')
    
    # Force the delete of the AWS Secrets
    aws secretsmanager delete-secret --secret-id ${snowflake_secrets_path} --force-delete-without-recovery || true
fi
