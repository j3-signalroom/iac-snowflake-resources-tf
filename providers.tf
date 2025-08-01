provider "aws" {
    region     = var.aws_region
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
    token      = var.aws_session_token
}

provider "snowflake" {
  alias             = "security_admin"
  role              = "SECURITYADMIN"

  # The most recently version of Snowflake Terraform Provider requires the 
  # `organization_name` and `account_name` to be set, whereas the previous 
  # versions did not require this.  That is why we are setting these values
  # here.  Plus, `account` as been deprecated in favor of `account_name`.
  organization_name = "${split("-", jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["account"])[0]}"
  account_name      = "${split("-", jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["account"])[1]}"

  user              = jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["admin_user"]
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["active_rsa_public_key_number"] == 1 ? data.aws_secretsmanager_secret_version.admin_private_key_1.secret_string : data.aws_secretsmanager_secret_version.admin_private_key_2.secret_string

  preview_features_enabled = [
    "snowflake_user_programmatic_access_token_resource",
  ]
}

provider "snowflake" {
  role              = "SYSADMIN"

  # The most recently version of Snowflake Terraform Provider requires the 
  # `organization_name` and `account_name` to be set, whereas the previous 
  # versions did not require this.  That is why we are setting these values
  # here.  Plus, `account` as been deprecated in favor of `account_name`.
  organization_name = "${split("-", jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["account"])[0]}"
  account_name      = "${split("-", jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["account"])[1]}"

  user              = jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["admin_user"]
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["active_rsa_public_key_number"] == 1 ? data.aws_secretsmanager_secret_version.admin_private_key_1.secret_string : data.aws_secretsmanager_secret_version.admin_private_key_2.secret_string

  preview_features_enabled = [
    "snowflake_user_programmatic_access_token_resource",
  ]
}