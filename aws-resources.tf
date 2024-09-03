data "aws_secretsmanager_secret" "public_keys" {
  name = "/snowflake_admin_credentials"
}

data "aws_secretsmanager_secret_version" "public_keys" {
  secret_id = data.aws_secretsmanager_secret.public_keys.id
}

data "aws_secretsmanager_secret" "private_key_1" {
  name = "/snowflake_admin_credentials/rsa_private_key_pem_1"
}

data "aws_secretsmanager_secret_version" "private_key_1" {
  secret_id = data.aws_secretsmanager_secret.private_key_1.id
}

data "aws_secretsmanager_secret" "private_key_2" {
  name = "/snowflake_admin_credentials/rsa_private_key_pem_2"
}

data "aws_secretsmanager_secret_version" "private_key_2" {
  secret_id = data.aws_secretsmanager_secret.private_key_2.id
}