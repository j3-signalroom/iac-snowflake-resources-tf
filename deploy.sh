#!/bin/bash

#
# *** Script Syntax ***
# ./deploy.sh <create | delete> --profile=<SSO_PROFILE_NAME> \
#                               --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> \
#                               --service_account_user=<SERVICE_ACCOUNT_USER> \
#                               --day_count=<DAY_COUNT>
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
    echo "Usage:  Require all four arguments ---> `basename $0` <create | delete> --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --day_count=<DAY_COUNT> --service_account_user=<SERVICE_ACCOUNT_USER>"
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
        *"--day_count="*)
            arg_length=12
            day_count=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--service_account_user="*)
            arg_length=23
            service_account_user=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
    esac
done

# Check required --profile argument was supplied
if [ -z $AWS_PROFILE ]
then
    echo
    echo "(Error Message 002)  You did not include the proper use of the --profile=<SSO_PROFILE_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --day_count=<DAY_COUNT> --service_account_user=<SERVICE_ACCOUNT_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_warehouse argument was supplied
if [ -z $snowflake_warehouse ]
then
    echo
    echo "(Error Message 003)  You did not include the proper use of the --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --day_count=<DAY_COUNT> --service_account_user=<SERVICE_ACCOUNT_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --day_count argument was supplied
if [ -z $day_count ] && [ create_action = true ]
then
    echo
    echo "(Error Message 004)  You did not include the proper use of the --day_count=<DAY_COUNT> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --day_count=<DAY_COUNT> --service_account_user=<SERVICE_ACCOUNT_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --service_account_user argument was supplied
if [ -z $service_account_user ]
then
    echo
    echo "(Error Message 005)  You did not include the proper use of the --service_account_user=<SERVICE_ACCOUNT_USER> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --day_count=<DAY_COUNT> --service_account_user=<SERVICE_ACCOUNT_USER>"
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
if [ create_action = true ]
then
    printf "aws_account_id=\"${AWS_ACCOUNT_ID}\"\
    \naws_region=\"${AWS_REGION}\"\
    \naws_access_key_id=\"${AWS_ACCESS_KEY_ID}\"\
    \naws_secret_access_key=\"${AWS_SECRET_ACCESS_KEY}\"\
    \naws_session_token=\"${AWS_SESSION_TOKEN}\"\
    \nsnowflake_warehouse=\"${snowflake_warehouse}\"\
    \nday_count=${day_count}\
    \nservice_account_user=\"${service_account_user}\"" > terraform.tfvars
else
    printf "aws_account_id=\"${AWS_ACCOUNT_ID}\"\
    \naws_region=\"${AWS_REGION}\"\
    \naws_access_key_id=\"${AWS_ACCESS_KEY_ID}\"\
    \naws_secret_access_key=\"${AWS_SECRET_ACCESS_KEY}\"\
    \naws_session_token=\"${AWS_SESSION_TOKEN}\"\
    \nsnowflake_warehouse=\"${snowflake_warehouse}\"\
    \nservice_account_user=\"${service_account_user}\"" > terraform.tfvars
fi

terraform init

if [ "$create_action" = true ]
then
    # Create/Update the Terraform configuration
    terraform plan -var-file=terraform.tfvars
    terraform apply -var-file=terraform.tfvars
else
    # Destroy the Terraform configuration
    terraform destroy -var-file=terraform.tfvars

    # Snowflake Paths
    snowflake_root=/snowflake_resource
    snowflake_base_path=${snowflake_root}/${service_account_user}

    # Force the delete of the AWS Secrets
    aws secretsmanager delete-secret --secret-id ${snowflake_root}/rsa_private_key_1 --force-delete-without-recovery || true
    aws secretsmanager delete-secret --secret-id ${snowflake_root}/rsa_private_key_2 --force-delete-without-recovery || true
    aws secretsmanager delete-secret --secret-id ${snowflake_base_path} --force-delete-without-recovery || true
    aws secretsmanager delete-secret --secret-id ${snowflake_base_path}/rsa_private_key_pem_1 --force-delete-without-recovery || true
    aws secretsmanager delete-secret --secret-id ${snowflake_base_path}/rsa_private_key_pem_2 --force-delete-without-recovery || true
    aws secretsmanager delete-secret --secret-id ${snowflake_base_path}/rsa_private_key_1 --force-delete-without-recovery || true
    aws secretsmanager delete-secret --secret-id ${snowflake_base_path}/rsa_private_key_2 --force-delete-without-recovery || true
fi
