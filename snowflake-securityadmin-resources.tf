provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
}

resource "snowflake_role" "role" {
  provider = snowflake.security_admin
  name     = "example_data_lakehouse_svc_role"
}

resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_role.role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.database.name
  }
}

resource "snowflake_schema" "schema" {
  database   = snowflake_database.database.name
  name       = "example_data_lakehouse"
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_role.role.name
  on_schema {
    schema_name = "\"${snowflake_database.database.name}\".\"${snowflake_schema.schema.name}\""
  }
}

resource "snowflake_grant_privileges_to_account_role" "warehouse_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_role.role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse.name
  }
}


resource "snowflake_user" "user" {
    provider          = snowflake.security_admin
    name              = var.snowflake_user
    default_warehouse = snowflake_warehouse.warehouse.name
    default_role      = snowflake_role.role.name
    default_namespace = "${snowflake_database.database.name}.${snowflake_schema.schema.name}"
    rsa_public_key    = snowflake_user_rsa_key_pairs_rotation.rsa_public_key_1
    rsa_public_key_2  = snowflake_user_rsa_key_pairs_rotation.rsa_public_key_2
}

resource "snowflake_grant_privileges_to_account_role" "user_grant" {
  provider          = snowflake.security_admin
  privileges        = ["MONITOR"]
  account_role_name = snowflake_role.role.name  
  on_account_object {
    object_type = "USER"
    object_name = snowflake_user.user.name
  }
}

resource "snowflake_grant_account_role" "grants" {
  provider  = snowflake.security_admin
  role_name = snowflake_role.role.name
  user_name = snowflake_user.user.name
}
