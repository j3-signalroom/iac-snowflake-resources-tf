terraform {
    cloud {
      organization = "signalroom"

        workspaces {
            name = "snowflake-resources-workspace"
        }
  }

  required_providers {
        snowflake = {
            source  = "Snowflake-Labs/snowflake"
            version = "~> 0.94.1"
        }
    }
}

# Create the Snowflake user RSA key pairs
module "snowflake_user_rsa_key_pairs_rotation" {  
    source  = "github.com/j3-signalroom/iac-snowflake-user-rsa_key_pairs_rotation-tf_module"

    # Required Input(s)
    aws_region     = var.aws_region
    aws_account_id = var.aws_account_id
    account        = var.snowflake_account
    user           = var.snowflake_user

    # Optional Input(s)
    day_count = var.day_count
}