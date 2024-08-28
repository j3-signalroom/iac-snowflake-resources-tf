# Retrieve metadata about the AWS Secrets Manager secret
data "aws_secretsmanager_secret" "snowflake_resource" {
  name = "/snowflake_resource"
}

# Retrieve the current version of the secret
data "aws_secretsmanager_secret_version" "snowflake_resource" {
  secret_id = data.aws_secretsmanager_secret.snowflake_resource.id
}