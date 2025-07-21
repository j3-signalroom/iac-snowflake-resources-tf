terraform {
    cloud {
      organization = "signalroom"

        workspaces {
            name = "iac-snowflake-resources-workspace"
        }
  }

  required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.4.0"
        }
        snowflake = {
            source  = "snowflakedb/snowflake"
            version = "2.3.0"
        }
    }
}

# Create the Snowflake user RSA keys pairs
module "snowflake_user_rsa_key_pairs_rotation" {   
    source  = "github.com/j3-signalroom/iac-snowflake-user-rsa_key_pairs_rotation-tf_module"

    # Required Input(s)
    aws_region           = var.aws_region
    account_identifier   = jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["account"]
    service_account_user = var.service_account_user

    # Optional Input(s)
    secret_insert             = lower(var.service_account_user)
    day_count                 = var.day_count
    aws_lambda_memory_size    = var.aws_lambda_memory_size
    aws_lambda_timeout        = var.aws_lambda_timeout
    aws_log_retention_in_days = var.aws_log_retention_in_days
}

resource "snowflake_account_role" "role" {
  provider = snowflake.security_admin
  name     = upper("${var.service_account_user}_ROLE")
}

resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.example.name
  }
}

resource "snowflake_schema" "schema" {
  database   = snowflake_database.example.name
  name       = upper("${var.service_account_user}_SCHEMA")
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_schema {
    schema_name = "\"${snowflake_database.example.name}\".\"${snowflake_schema.schema.name}\""
  }
}

resource "snowflake_grant_privileges_to_account_role" "warehouse_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.example.name
  }
}

resource "snowflake_user" "user" {
  provider          = snowflake.security_admin
  name              = upper("${var.service_account_user}_USER")
  default_warehouse = snowflake_warehouse.example.name
  default_role      = snowflake_account_role.role.name
  default_namespace = "${snowflake_database.example.name}.${snowflake_schema.schema.name}"

  # Setting the attributes to `null`, effectively unsets the attribute
  # Refer to this link `https://docs.snowflake.com/en/user-guide/key-pair-auth#configuring-key-pair-rotation`
  # for more information
  rsa_public_key    = module.snowflake_user_rsa_key_pairs_rotation.active_rsa_public_key_number == 1 ? module.snowflake_user_rsa_key_pairs_rotation.rsa_public_key_pem_1 : null
  rsa_public_key_2  = module.snowflake_user_rsa_key_pairs_rotation.active_rsa_public_key_number == 2 ? module.snowflake_user_rsa_key_pairs_rotation.rsa_public_key_pem_2 : null
}

resource "snowflake_grant_privileges_to_account_role" "user_grant" {
  provider          = snowflake.security_admin
  privileges        = ["MONITOR"]
  account_role_name = snowflake_account_role.role.name  
  on_account_object {
    object_type = "USER"
    object_name = snowflake_user.user.name
  }
}

resource "snowflake_grant_account_role" "grants" {
  provider  = snowflake.security_admin
  role_name = snowflake_account_role.role.name
  user_name = snowflake_user.user.name
}

resource "snowflake_database" "example" {
  name = upper("${var.service_account_user}_DATABASE")
}

resource "snowflake_warehouse" "example" {
  name           = upper("${var.service_account_user}_WAREHOUSE")
  warehouse_size = "xsmall"
  auto_suspend   = 60
}