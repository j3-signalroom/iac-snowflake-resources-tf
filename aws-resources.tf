# Snowflake Secrets
resource "aws_secretsmanager_secret" "snowflake" {
    name = "${local.snowflake_secrets_prefix}"
    description = "Snowflake secrets"
}

resource "aws_secretsmanager_secret_version" "snowflake" {
    secret_id     = aws_secretsmanager_secret.snowflake.id
    secret_string = jsonencode({"login_url": "${var.snowflake_login_url}",
                                "username": "${var.snowflake_username}",
                                "password": "${var.snowflake_password}"})
}
