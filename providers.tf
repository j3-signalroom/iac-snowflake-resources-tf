provider "aws" {
    region     = var.aws_region
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
    token      = var.aws_session_token
}

provider "snowflake" {
  alias             = "security_admin"
  role              = "SECURITYADMIN"
  organization_name = local.snowflake_organization_name
  account_name      = local.snowflake_account_name
  user              = local.snowflake_admin_user
  private_key       = local.snowflake_active_private_key
  authenticator     = "SNOWFLAKE_JWT"
}

provider "snowflake" {
  role              = "SYSADMIN"
  organization_name = local.snowflake_organization_name
  account_name      = local.snowflake_account_name
  user              = local.snowflake_admin_user
  private_key       = local.snowflake_active_private_key
  authenticator     = "SNOWFLAKE_JWT"
}