terraform {
    cloud {
      organization = "signalroom"

        workspaces {
            name = "snowflake-resources-workspace-007"
        }
  }

  required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.65.0"
        }
        snowflake = {
            source  = "Snowflake-Labs/snowflake"
            version = "~> 0.94.1"
        }
    }
}

# Create the Snowflake user RSA keys pairs
module "snowflake_user_rsa_key_pairs_rotation" {   
    source  = "github.com/j3-signalroom/iac-snowflake-user-rsa_key_pairs_rotation-tf_module"

    # Required Input(s)
    aws_region           = var.aws_region
    aws_account_id       = var.aws_account_id
    snowflake_account    = jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["account"]
    service_account_user = var.service_account_user

    # Optional Input(s)
    day_count                 = var.day_count
    aws_lambda_memory_size    = var.aws_lambda_memory_size
    aws_lambda_timeout        = var.aws_lambda_timeout
    aws_log_retention_in_days = var.aws_log_retention_in_days
}