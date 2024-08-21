terraform {
    cloud {
      organization = "<TERRAFORM CLOUD ORGANIZATION NAME>"

        workspaces {
            name = "<TERRAFORM CLOUD ORGANIZATION's WORKSPACE NAME>"
        }
  }

  required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.63.0"
        }
        snowflake = {
            source  = "Snowflake-Labs/snowflake"
            version = "~> 0.94.1"
        }
    }
}

locals {
  cloud                    = "AWS"
  snowflake_secrets_prefix = "/snowflake_resource"
}
