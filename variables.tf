variable "aws_region" {
    description = "The AWS Region."
    type        = string
}

variable "aws_account_id" {
    description = "The AWS Account ID."
    type        = string
}

variable "aws_access_key_id" {
    description = "The AWS Access Key ID."
    type        = string
}

variable "aws_secret_access_key" {
    description = "The AWS Secret Access Key."
    type        = string
}

variable "aws_session_token" {
    description = "The AWS Session Token."
    type        = string
}

variable "snowflake_warehouse" {
    description = "The Snowflake warehouse."
    type        = string
}

variable "service_account_user" {
    description = "The Snowflake service account user who is to be assigned the RSA key pairs for its authentication."
    type        = string
}

variable "day_count" {
    description = "How many day(s) should the RSA key pair be rotated for."
    type = number
    default = 30
    
    validation {
        condition = var.day_count >= 1
        error_message = "Rolling day count, `day_count`, must be greater than or equal to 1."
    }
}
