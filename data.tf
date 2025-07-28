data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "admin_public_keys" {
  name = "/snowflake_admin_credentials"
}

data "aws_secretsmanager_secret_version" "admin_public_keys" {
  secret_id = data.aws_secretsmanager_secret.admin_public_keys.id
}

data "aws_secretsmanager_secret" "admin_private_key_1" {
  name = "/snowflake_admin_credentials/rsa_private_key_pem_1"
}

data "aws_secretsmanager_secret_version" "admin_private_key_1" {
  secret_id = data.aws_secretsmanager_secret.admin_private_key_1.id
}

data "aws_secretsmanager_secret" "admin_private_key_2" {
  name = "/snowflake_admin_credentials/rsa_private_key_pem_2"
}

data "aws_secretsmanager_secret_version" "admin_private_key_2" {
  secret_id = data.aws_secretsmanager_secret.admin_private_key_2.id
}

locals {
  account_identifier = jsondecode(data.aws_secretsmanager_secret_version.admin_public_keys.secret_string)["account"]
  base_url = "https://${local.account_identifier}.snowflakecomputing.com"
  snowflake_aws_role_name       = "snowflake_glue_s3_role"
  snowflake_aws_role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.snowflake_aws_role_name}"
}